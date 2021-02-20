package provide de1_device_scale 1.0

package require de1_de1 1.1
package require de1_event 1.0
package require de1_logging 1.0
package require de1_gui 1.2


namespace eval ::device::scale::event::listener {

	proc on_connect_add {args} {

		::event::listener::_generic_add ::device::scale::event::listener::_on_connect_lists {*}$args
	}

	proc on_disconnect_add {args} {

		::event::listener::_generic_add ::device::scale::event::listener::_on_disconnect_lists {*}$args
	}

	proc on_update_available_add {args} {

		::event::listener::_generic_add ::device::scale::event::listener::_on_update_available_lists {*}$args
	}

	foreach callback_list [list \
				       ::device::scale::event::listener::_on_connect_lists \
				       ::device::scale::event::listener::_on_disconnect_lists \
				       ::device::scale::event::listener::_on_update_available_lists \
				      ] {
		::event::listener::_init_callback_list $callback_list
	}
}

namespace eval ::device::scale::event::apply {

	proc on_connect_callbacks {args} {

		::event::apply::_generic ::device::scale::event::listener::_on_connect_lists {*}$args
	}

	proc on_disconnect_callbacks {args} {

		::event::apply::_generic ::device::scale::event::listener::_on_disconnect_lists {*}$args
	}

	proc on_update_available_callbacks {args} {

		::event::apply::_generic ::device::scale::event::listener::_on_update_available_lists {*}$args
	}
}


namespace eval ::device::scale {

	# NB: ::scale is the identifier for a Tk proc
	#     as well as used by math::linearalgebra (see NAMING CONFLICT its man page)

	variable autotare_states [list "Espresso" "HotWater"]

	# Holdoff for tare requests in ms
	# 200 ms should be enough, but
	# See commit a8a61e1 Jan-18-2020:
	#     slightly more delay (500ms) with tare on espresso start,
	#     to make sure we don't have a ble command splat with decent scale

	variable _tare_holdoff_initial	200
	variable _tare_holdoff_repeat	200

	# Level in g over which will auto-tare before flow

	variable autotare_threshold 0.1

	# Consider scale "lost" if no weight update within (seconds)

	variable warn_if_no_updates_within 1.0

	variable run_timer False

	variable _initial_tare_after_id ""

	variable _last_weight_update_time 0

	# Watchdogs for seeing scale updates

	variable _watchdog_timeout  1000
	variable _watchdog_entry_id ""
	variable _watchdog_leave_id ""

	variable _watchdog_updates_seen False
	variable _watchdog_update_tries 10

	variable _tare_last_requested 0

	# If a tare is requested and "0" is seen within this limit
	# will call ::device::scale::on_tare_seen

	variable _tare_awaiting_zero_ms 1000
	variable _tare_awaiting_zero False

	variable _delayed_tare_id ""

	# Show "normal" messages around waiting for updates in the GUI?

	variable show_update_watchdog_notifications False



	# See also on_connect callbacks for initialization

	proc init {} {
		period::init
		history::init
	}


	proc is_connected {} {
		expr { [info exists ::de1(scale_device_handle)] == 1  &&  $::de1(scale_device_handle) != 0 }
	}

	proc bluetooth_address {}  {
		expr { $::settings(scale_bluetooth_address) }
	}

	# Boolean to determine if should be a "problem" that the scale isn't connected and reporting

	proc expecting_present {} {
		expr { [::device::scale::bluetooth_address] != "" }
	}

	proc type {}  {
		expr { $::settings(scale_type) }
	}

	proc sensor_lag {{scale_type ""}} {

		# From https://www.youtube.com/watch?v=SIzFhnZ32Y0 (James Hoffmann) at 4:51
		#
		# Hiroia    0.20
		# Skale     0.33
		# Felicita  0.45
		# Acaia     0.64
		#
		# then add 1/2 average period (50 ms) for BLE delay

		if { $scale_type == "" } { set scale_type [::device::scale::type] }

		return [ switch -exact $scale_type {

			hiroiajimmy { expr { 0.25 } }
			atomaxskale { expr { 0.38 } }
			decentscale { expr { 0.38 } }
			felicita    { expr { 0.50 } }
			acaiascale  { expr { 0.69 } }
			default     { expr { 0.38 } }

		}]
	}

	proc is_autotare_state {{state_text "None"}} {

		if { $state_text == "None" } { set state_text [::de1::state::current_state] }

		expr { $state_text in $::device::scale::autotare_states }
	}


	proc process_weight_update {sensorweight {event_time 0}} {

		if { $event_time == 0 } {set event_time [expr { [clock milliseconds] / 1000.0 }]}

		::device::scale::watchdog_tickle ::device::scale::_watchdog_entry_id entry

		if { $sensorweight == 0 \
			     && $::device::scale::_tare_awaiting_zero  \
			     && [expr {[clock milliseconds] - $::device::scale::_tare_last_requested}] \
					<  $::device::scale::_tare_awaiting_zero_ms } {

			set ::device::scale::_tare_awaiting_zero False
			::device::scale::on_tare_seen

			msg -DEBUG [format "Tare delay: %i ms" \
					    [expr {[clock milliseconds] - $::device::scale::_tare_last_requested}]]
		}

		::device::scale::period::estimate_update $event_time
		::device::scale::history::push_mass $sensorweight $event_time

		set ::device::scale::_last_weight_update_time $event_time

		# Support use case for two cups, only one on the scale

		set cups [expr { $::settings(scale_stop_at_half_shot) == 1 ? 2 : 1 }]

		set thisrawweight [expr { $sensorweight * $cups }]
		set thisweight [expr { [::device::scale::history::weight_estimate] * $cups }]

		set ::de1(scale_sensor_weight) [round_to_two_digits $thisrawweight]
		set ::de1(scale_weight) [round_to_two_digits $thisweight]


		set flow_raw [expr { [::device::scale::history::flow_estimate_raw] * $cups }]
		set flow [expr { [::device::scale::history::flow_estimate] * $cups }]

		set ::de1(scale_weight_rate_raw) [round_to_two_digits $flow_raw]
		set ::de1(scale_weight_rate) [round_to_two_digits $flow]

		# Scheduled tare as per existing logic
		# Note that it previously was never "reset" other than by skale_tare

		if {$sensorweight < 0 && [::de1::state::current_state] == "Idle"} {

			if {$::settings(tare_only_on_espresso_start) != 1} {

				# one second after the negative weights have stopped, automatically do a tare

				after cancel $::device::scale::_delayed_tare_id
				set ::device::scale::_delayed_tare_id [after 1000 ::device::scale::tare]
			}
		}

		#
		# During espresso or hot-water flow
		#

		# NB: "is_recording" is required for SAW to work right now

		if { ( [::device::scale::history::is_recording] ) } {

			::device::scale::history::capture_espresso_clock_reference

			# Check if SAW is needed, but only when there is flow (adding a cup shouldn't trigger SAW)

			if { [::de1::state::is_flow_during_state] } {

				::device::scale::saw::check_for_saw
			}

			# is_recording is true until the post-flow period expires

			if { ! [::de1::state::is_flow_before_state] } {

				::device::scale::history::update_drink_weights
			}
		}

		#
		# Preparing for espresso or hot-water flow
		#

		if { [::de1::state::is_flow_before_state] } {

			# Was a cup was added during the warmup stage?

			if { abs($::de1(scale_sensor_weight)) > $::device::scale::autotare_threshold  \
				     && $::device::scale::_initial_tare_after_id == "" \
				     && [::device::scale::is_autotare_state] } {

				::device::scale::tare
			}
		}

		set event_dict [ dict create \
					 event_time		[expr {[clock milliseconds] / 1000.0}] \
					 reported_weight	$sensorweight \
					 report_time		$event_time \
					 weight_raw		$thisrawweight \
					 weight_filtered	$thisweight \
					 flow_raw		$flow_raw \
					 flow_filtered		$flow \
					]

		::device::scale::event::apply::on_update_available_callbacks $event_dict

		::device::scale::watchdog_tickle ::device::scale::_watchdog_leave_id leave
	}


	proc tare {args} {

		set since_last_tare [expr {[clock milliseconds] - $::device::scale::_tare_last_requested}]

		if { $since_last_tare < $::device::scale::_tare_holdoff_repeat } {

			if { "-force" in $args } {
				msg -NOTICE [format "tare request -force after %d ms (%.3f)" \
						     $since_last_tare \
						     [ expr { $::device::scale::_tare_last_requested / 1000.0 } ] ]

			} else {
				msg -NOTICE [format "tare request declined as after %d ms (%.3f)" \
						     $since_last_tare \
						     [ expr { $::device::scale::_tare_last_requested / 1000.0 } ] ]
				return
			}

		} else {
			msg -INFO "tare request"
		}

		switch -exact $::settings(scale_type) {

			atomaxskale { skale_tare }

			decentscale { decentscale_tare }

			acaiascale { acaia_tare }

			felicita { felicita_tare }

			hiroiajimmy { hiroia_tare }
		}

		set ::device::scale::_tare_last_requested [clock milliseconds]

		set ::device::scale::_tare_awaiting_zero True

		# See process_weight_update for this feature related to auto-tare on Idle

		after cancel $::device::scale::_delayed_tare_id
		set ::device::scale::_delayed_tare_id ""
	}


	# Median time from tare request to zero weight ~330 ms on Skale 2 and can be over 500 ms
	# Reset at least history-based estimates due to "external" change

	proc on_tare_seen {args} {

		::device::scale::history::on_tare_seen {*}$args
	}

	#
	# HACK: Keep requesting scale updates until they start arriving
	#	every $::device::scale::_watchdog_timeout
	#       up to $::device::scale::_watchdog_update_tries times
	#

	proc watchdog_first {args} {

		if { ! [::device::scale::is_connected] } {
			msg -DEBUG "Scale watchdog first skipping start, scale not connected"
			return
		}

		if { $::device::scale::_watchdog_entry_id  == "" } {
			msg -DEBUG "Scale watchdog first starting with handle $::de1(scale_device_handle)"
		} else {
			after cancel $::device::scale::_watchdog_entry_id
		}
		set ::device::scale::_watchdog_entry_id \
			[ after $::device::scale::_watchdog_timeout \
				  [list ::device::scale::_watchdog_first_fire 1] ]

	}

	proc _watchdog_first_fire {tries} {

		if { $tries >=  ${::device::scale::_watchdog_update_tries} } {
			msg -ERROR "Scale updates not seen, $tries of ${::device::scale::_watchdog_update_tries}, ABANDONING"
			::gui::notify::scale_event abandoning_updates
			return
		} else {
			msg -WARNING "Scale updates not seen, $tries of ${::device::scale::_watchdog_update_tries}"
			if { $::device::scale::show_update_watchdog_notifications } {
				::gui::notify::scale_event retrying_updates $tries
			}
			scale_enable_weight_notifications
			set ::device::scale::_watchdog_entry_id \
				[ after $::device::scale::_watchdog_timeout \
					  [list ::device::scale::_watchdog_first_fire [incr tries]] ]
		}
	}

	proc watchdog_tickle {id name} {

		if { [set $id]  == "" } {
			msg -DEBUG "Scale watchdog $name starting with handle $::de1(scale_device_handle)"
		} else {
			after cancel [set $id]
		}
		set $id [ after $::device::scale::_watchdog_timeout \
				  [list ::device::scale::_watchdog_fire $id $name] ]
		set ::device::scale::_watchdog_updates_seen true

	}

	proc _watchdog_fire {id name} {

		msg -WARNING "Scale watchdog $name TIMEOUT"
		::gui::notify::scale_event timeout_updates $name
		set $id ""
	}

	proc _watchdog_cancel {id name} {

		if {[info exists id]} {
			after cancel [set $id]
			msg -INFO "Scale watchdog $name cancelled"
		} else {
			msg -INFO "Scale watchdog $name - no ID to cancel"
		}
	}

	proc last_weight_update_time {} {

		expr { $::device::scale::_last_weight_update_time }
	}


	# Format scale-related data for .shot file

	proc format_for_history {data_name} {
		upvar $data_name shotfile_list
		history::format_for_history shotfile_list
	}


} ;# ::device::scale


namespace eval ::device::scale::period {

	variable _estimate_state

	array set _estimate_state {
		last_arrival 		0.0
		new_value_weight	0.0001
		moving_average		0.100
		threshold		0.350
	}

	# The Skale 2 seems to clock out weight updates on a ~150 ms clock
	# There can be two updates sent in the same time slot, and a slot
	# can be skipped. This behavior leads to 300 ms being "expected"
	# See https://3.basecamp.com/3671212/buckets/7351439/messages/3331033233
	# for a plot of inter-sample times

	# A new_value_weight of 0.0001 is a tau of ~10,000 samples, ~17 minutes.
	# The high variance of Skale 2 inter-arrival times requires long tau
	# to increase the accuracy of the estimate. Setting the period
	# for a new scale to 100 ms mitigates "cold start" issues.

	variable _scale_period_name None

	proc init {args} {

		variable _estimate_state
		variable _scale_period_name
		variable _scale_period_update_weight_name

		if { ! [::device::scale::is_connected] } {
			msg -DEBUG "No scale to init [join $args {, }]"
			return
		}

		set btaddr [::device::scale::bluetooth_address]

		set _scale_period_name "scale_period_${btaddr}"
		set _scale_period_update_weight_name "scale_period_update_weight_${btaddr}"

		if { [info exists ::settings($_scale_period_name)] \
			     && [string is double -strict $::settings($_scale_period_name)] } {
			set _estimate_state(moving_average) $::settings($_scale_period_name)
		}
		if { [info exists ::settings($_scale_period_update_weight_name)] \
			     && [string is double -strict $::settings($_scale_period_update_weight_name)] } {
			set _estimate_state(new_value_weight) $::settings($_scale_period_update_weight_name)
		}
	}


	proc estimate {} {

		variable _estimate_state

		expr { $_estimate_state(moving_average) }
	}


	proc estimate_update { arrival_time } {

		variable _estimate_state
		variable _scale_period_name
		variable _scale_period_update_weight_name

		set delta [expr { $arrival_time - $_estimate_state(last_arrival) }]
		if { $delta < $_estimate_state(threshold) && $delta > 0 } {
			set k $_estimate_state(new_value_weight)
			set _estimate_state(moving_average) \
				[expr { $_estimate_state(moving_average) * (1.0 -  $k) + $delta * $k }]
		}
		set _estimate_state(last_arrival) $arrival_time

		set ::settings($_scale_period_name) $_estimate_state(moving_average)
	}

} ;# ::device::scale::period



namespace eval ::device::scale::history {

	# Need to map algorithms to various uses
	# Potentially redefine the procs on scale connect, if they differ in requirements
	#
	# raw scale data always written to .shot file -- DO NOT OVERRIDE weight_raw
	#
	# shot weight, raw	weight_raw			::de1(scale_sensor_weight)
	# shot weight, slow	weight_estimate			::de1(scale_weight)
	# flow rate, fast	flow_estimate_raw		::de1(scale_weight_rate_raw)
	# flow rate, slow	flow_estimate			::de1(scale_weight_rate)
	# drink weight		final_weight_estimate		::de1(final_*_weight), ::settings(drink_weight)
	# shot weight, SAW	(::saw) weight_now		(used internally)
	# flow rate, SAW	(::saw) flow_now		(used internally)

	###
	### DO NOT OVERRIDE weight_raw -- ALWAYS should record truly raw sensor weight
	###

	proc setup_default_estimation_mapping {args} {

		proc ::device::scale::history::weight_estimate {} {
			::device::scale::history::weight_raw
		}

		proc ::device::scale::history::flow_estimate_raw {} {
			::device::scale::history::flow_estimate_fd
		}

		proc ::device::scale::history::flow_estimate_raw_time {} {
			::device::scale::history::flow_estimate_time_fd
		}

		proc ::device::scale::history::flow_estimate {} {
			::device::scale::history::flow_estimate_fd
		}

		proc ::device::scale::history::flow_estimate_time {} {
			::device::scale::history::flow_estimate_time_fd
		}

		proc ::device::scale::history::final_weight_estimate {} {
			::device::scale::history::weight_estimate_median
		}
	}

	proc setup_median_estimation_mapping {args} {

		proc ::device::scale::history::weight_estimate {} {
			::device::scale::history::weight_estimate_median
		}

		proc ::device::scale::history::flow_estimate_raw {} {
			::device::scale::history::flow_estimate_median
		}

		proc ::device::scale::history::flow_estimate_raw_time {} {
			::device::scale::history::flow_estimate_time_median
		}

		proc ::device::scale::history::flow_estimate {} {
			::device::scale::history::flow_estimate_median
		}

		proc ::device::scale::history::flow_estimate_time {} {
			::device::scale::history::flow_estimate_time_median
		}

		proc ::device::scale::history::final_weight_estimate {} {
			::device::scale::history::weight_estimate_median
		}
	}

	# See ::device::scale::saw for other mappings


	variable _scale_raw_weight
	variable _scale_raw_arrival

	variable scale_raw_weight_shot
	variable scale_raw_arrival_shot

	variable _final_weight_name

	variable _espresso_start 0

	variable _is_recording_flag False

	variable _lslr_state
	array set _lslr_state [list valid False m 0 b 0]

	# Used for finite-difference, LSLR, as well as most of median estimation
	# 11 samples is 10 intervals, ~1 second

	proc samples_for_estimate {} {
		expr { 11 }
	}

	# Used for median flow estimation "end points"
	# on a base of samples_for_estimate
	#
	# 0 1 2 3 4 5 6 7 8 9 10 11 12 13 14
	# ---------           --------------    <= samples_for_median_ends
	#     |.....................|           <= samples_for_estimate

	proc samples_for_median_ends {} {
		expr { 5 }
	}

	proc samples_for_shift_register {} {

		expr { [samples_for_estimate] + [samples_for_median_ends] - 1 }
	}

	proc shift_in {shift_register value} {

		upvar $shift_register sr

		set sr [lreplace $sr 0 0]
		lappend sr $value
	}

	# TODO: Init scale interval based on scale type (or at least exceptions)

	proc init {} {

		variable _scale_raw_weight [lrepeat [samples_for_shift_register] 0]
		variable _scale_raw_arrival [lrepeat [samples_for_shift_register] 0]

		variable scale_raw_weight_shot
		variable scale_raw_arrival_shot

		variable _final_weight_name

		variable _espresso_start 0

		variable _is_recording_flag

		# This will clear _is_recording_flag; is set to False on loading module

		if { [is_recording] } { stop_recording }

		reset_shot_record

		_lslr_clear
	}

	proc on_tare_seen {args} {

		variable _scale_raw_weight [lrepeat [samples_for_shift_register] 0]
		variable _scale_raw_arrival [lrepeat [samples_for_shift_register] 0]

		_lslr_clear

		msg -DEBUG "::device::scale::history::on_tare_seen"
	}

	proc reset_shot_record {} {

		variable scale_raw_weight_shot
		variable scale_raw_arrival_shot

		set scale_raw_weight_shot  [list]
		set scale_raw_arrival_shot [list]

		msg -DEBUG "::device::scale::history::reset_shot_record"
	}


	proc push_mass { mass t } {

		variable _scale_raw_weight
		variable _scale_raw_arrival

		variable scale_raw_weight_shot
		variable scale_raw_arrival_shot

		variable _final_weight_name

		_lslr_clear

		shift_in _scale_raw_weight $mass
		shift_in _scale_raw_arrival $t

		if { [is_recording] } {
			lappend scale_raw_weight_shot $mass
			lappend scale_raw_arrival_shot $t
		}
	}


	proc weight_raw {} {

		variable _scale_raw_weight

		expr { [lindex $_scale_raw_weight end] }
	}


	#
	# Finite-difference flow estimate
	#
	# Nominal delay flow: 5 -- (samples_for_estimate - 1) / 2
	#

	proc flow_estimate_fd {} {

		variable _scale_raw_weight

		if {[llength $_scale_raw_weight] < [samples_for_estimate]} {return 0}

		set intervals [ expr { [samples_for_estimate] - 1 }]
		expr { ( [lindex $_scale_raw_weight end] - [lindex $_scale_raw_weight end-$intervals] ) \
			       / ( [::device::scale::period::estimate] * $intervals ) }
	}


	proc flow_estimate_time_fd {} {

		# Center of window

		variable _scale_raw_arrival

		if {[llength $_scale_raw_arrival] < [samples_for_estimate]} {return 0}

		set intervals [ expr { [samples_for_estimate] - 1 }]
		expr { ( [lindex $_scale_raw_arrival end] + [lindex $_scale_raw_arrival end-$intervals] ) / 2.0 }
	}


	#
	# Least squares linear regression
	#
	# Nominal delay mass: 0
	# Nominal delay flow: 5 -- (samples_for_estimate - 1) / 2
	#

	proc _lslr_clear {} {

		variable _lslr_state
		array set _lslr_state [list valid False m 0 b 0]
	}


	proc _lslr_core {} {

		#
		# Least Squares Linear Regression
		#
		# m = (N * sum_xy - sum_x * sum_y) / (N * sum_xx - (sum_x)^2)
		# b = (sum_y - m * sum_x) / N
		#
		# 1 through k
		# sum of k = n(n+1)/2
		# sum of k^2 = n(n+1)(2n+1)/6
		#
		# 0 through -(n-1)tau
		# sum_x = -tau * n(n-1)/2
		# sum_xx = tau^2 * (n)(n-1)(2n-1)/6
		#

		variable _scale_raw_weight
		variable _lslr_state

		# Tcl potentially leaks what should be locals over globals of the same name
		# (there is no "local" declaration in Tcl either)

		variable n_est [samples_for_estimate]
		variable sum_n [expr { $n_est * ($n_est - 1) / 2 }]
		variable sum_nn [expr { $n_est * ($n_est - 1) * (2 * $n_est - 1) / 6 }]

		variable tau [::device::scale::period::estimate]

		variable sum_x [expr { -$sum_n * $tau }]
		variable sum_xx [expr { $sum_nn * $tau * $tau }]

		variable sum_xy 0
		variable sum_y 0

		variable x
		variable y

		for {set x [expr { - ( $n_est - 1 ) }]} {$x <= 0} {incr x} {

			set y [lindex $_scale_raw_weight end+${x}]
			set sum_y [expr {$sum_y + $y}]
			set sum_xy [expr {$sum_xy + ($x * $y)}]
		}
		set sum_xy [expr { $tau * $sum_xy }]

		set _lslr_state(m) [expr { ($n_est * $sum_xy - $sum_x * $sum_y) / ($n_est * $sum_xx - $sum_x * $sum_x) }]
		set _lslr_state(b) [expr { ($sum_y - $m * $sum_x) / $n_est }]
		set _lslr_state(valid) True
	}

	proc weight_estimate_lslr {} {

		variable _lslr_state

		if { ! $_lslr_state(valid) } { _lslr_core }
		return $_lslr_state(b)
	}

	proc flow_estimate_lslr {} {

		variable _lslr_state

		if { ! $_lslr_state(valid) } { _lslr_core }
		return $_lslr_state(m)
	}

	proc flow_estimate_time_lslr {} {

		# Center of window

		variable _scale_raw_arrival

		if {[llength $_scale_raw_arrival] < [samples_for_estimate]} {return 0}

		set intervals [ expr { [samples_for_estimate] - 1 }]
		expr { ( [lindex $_scale_raw_arrival end] + [lindex $_scale_raw_arrival end-$intervals] ) / 2.0 }
	}


	#
	# Median
	#
	# Nominal delay mass: 5 -- (samples_for_estimate - 1) / 2
	# Nominal delay flow: 7 -- (samples_for_estimate - 1) / 2 + (samples_for_median_ends - 1) / 2
	#

	proc median {numeric_list} {

		if {[llength $numeric_list] == 0} {return 0}

		set sorted [lsort -real -increasing $numeric_list]
		set nlist [llength $sorted]
		set half [expr { $nlist / 2 }]
		if { $nlist % 2 } {
			return [lindex $sorted [expr { $nlist / 2 }]]
		} else {
			return [expr { ( [lindex $sorted [expr { $half - 1 }]] + [lindex $sorted $half] ) / 2.0 }]
		}
	}

	proc weight_estimate_median {} {

		return [median [lrange $::device::scale::history::_scale_raw_weight 0 [expr { [samples_for_estimate] - 1 }]]]
	}

	proc weight_estimate_time_median {} {

		# Center of window

		variable _scale_raw_arrival

		if {[llength $_scale_raw_arrival] < [samples_for_estimate]} {return 0}

		set intervals [ expr { [samples_for_estimate] - 1 }]
		expr { ( [lindex $_scale_raw_arrival end] + [lindex $_scale_raw_arrival end-$intervals] ) / 2.0 }
	}


	# Median flow estimates are the difference between medians
	# taken at the begining and delayed by (samples_for_estimate - 1)
	#
	# 0 1 2 3 4 5 6 7 8 9 10 11 12 13 14
	# ---------           --------------    <= samples_for_median_ends
	#     |.....................|           <= samples_for_estimate

	proc flow_estimate_median {} {

		set new_i0 0
		set new_i1 [expr { [samples_for_median_ends] - 1 } ]
		set old_i0 [expr { [samples_for_estimate] - 1 } ]
		set old_i1 [expr { $old_i0 + [samples_for_median_ends] - 1 } ]

		set new_t0 [lindex $::device::scale::history::_scale_raw_arrival end]
		set new_t1 [lindex $::device::scale::history::_scale_raw_arrival end-$new_i1]
		set old_t0 [lindex $::device::scale::history::_scale_raw_arrival end-$old_i0]
		set old_t1 [lindex $::device::scale::history::_scale_raw_arrival end-$old_i1]

		set dt [expr { (($new_t0 + $new_t1) / 2.0) - (($old_t0 + $old_t1) / 2.0) }]

		# Return 0 until the shift register is filled

		if { $old_t1 == 0 } { return 0 }

		# Newest elements are at the end of the list, "backwards" from lindex

		set new [median [lrange $::device::scale::history::_scale_raw_weight end-$new_i1 end-$new_i0]]
		set old [median [lrange $::device::scale::history::_scale_raw_weight end-$old_i1 end-$old_i0]]

		return [expr { ($new - $old) / $dt }]
	}

	proc flow_estimate_time_median {} {


		set new_i0 0
		set new_i1 [expr { [samples_for_median_ends] - 1 } ]
		set old_i0 [expr { [samples_for_estimate] - 1 } ]
		set old_i1 [expr { $old_i0 + [samples_for_median_ends] - 1 } ]

		set new_t0 [lindex $::device::scale::history::_scale_raw_arrival end]
		set new_t1 [lindex $::device::scale::history::_scale_raw_arrival end-$new_i1]
		set old_t0 [lindex $::device::scale::history::_scale_raw_arrival end-$old_i0]
		set old_t1 [lindex $::device::scale::history::_scale_raw_arrival end-$old_i1]

		if { $old_t1 == 0 } { return 0 }

		return [expr { ((($new_t0 + $new_t1) / 2.0) + (($old_t0 + $old_t1) / 2.0)) / 2.0 }]
	}




	proc update_drink_weights {} {

		if { [::de1::state::is_flow_during_state] } {

			set cwe [::device::scale::history::weight_estimate]

		} else {

			set cwe [::device::scale::history::final_weight_estimate]
			set cwe [::tcl::mathfunc::max $cwe [set $::device::scale::history::_final_weight_name]]
		}

		set $::device::scale::history::_final_weight_name $cwe
		set ::settings(drink_weight) [round_to_one_digits $cwe]
	}




	proc is_recording {} {

		variable _is_recording_flag

		expr {$_is_recording_flag}
	}

	proc start_recording {} {

		variable _is_recording_flag

		if { [is_recording] } {
			msg -WARNING "::device::scale::start_recording: already recording"

		} else {
			reset_shot_record
			set _is_recording_flag True
			msg -DEBUG "::device::scale::start_recording"
			if { [::device::scale::expecting_present]  && ! [::device::scale::is_connected] } {
				::gui::notify::scale_event not_connected
			}
		}
	}

	proc stop_recording {args} {

		variable _is_recording_flag

		if { ! [is_recording] } {
			msg -NOTICE "::device::scale::stop_recording: already not recording"

		} else {
			set _is_recording_flag False
			msg -DEBUG "::device::scale::stop_recording"
			::gui::notify::scale_event record_complete
		}
	}


	proc on_state_change {event_dict} {

		variable _final_weight_name

		set this_state [dict get $event_dict this_state]
		set previous_state [dict get $event_dict previous_state]

		switch -exact $this_state {

			Espresso {
				set _final_weight_name ::de1(final_espresso_weight)
				start_recording
			}

			HotWater {
				set _final_weight_name ::de1(final_water_weight)
				start_recording
			}

			default {
				return
			}
		}
	}


	# Reference for espresso_clock changes after Espresso mode, so need to capture during flow
	# No guarantee that it won't be reset prior to a callback for entering Idle

	proc capture_espresso_clock_reference {} {

		variable _espresso_start [expr { $::timers(espresso_start) / 1000.0 }]
	}


	# History for shot file

	proc format_for_history {data_name} {

		upvar $data_name shotfile_list

		variable _espresso_start
		variable scale_raw_weight_shot
		variable scale_raw_arrival_shot

		append shotfile_list "espresso_start $_espresso_start\n"
		append shotfile_list "scale_raw_weight {$scale_raw_weight_shot}\n"
		append shotfile_list "scale_raw_arrival {[lmap t $scale_raw_arrival_shot \
									{format "%0.3f" [expr { $t - $_espresso_start} ]}]}\n"

		# Collect information on how long after flow stops is drink_weight reached
		# lmap v $test_list { expr $v > 1 }
		# ::tcl::mathfunc::max {*}$test_list
		# lsearch -real -start 3 $test_list 1.1
		#    Not -sorted -increasing as may decrease at the end
	}

} ;# ::device::scale::history


namespace eval ::device::scale::saw {

	variable _early_by_grams 0
	variable _early_by_flow 0
	variable _ignore_first_seconds 0

	variable _mode_timer

	variable _target 0

	variable _is_active_flag False

	variable lag_time_estimation	0.0
	variable _lag_time_de1 		0.1

	proc setup_default_estimation_mapping {args} {

		proc ::device::scale::saw::weight_now {} {
			::device::scale::history::weight_raw
		}

		set ::device::scale::saw::lag_time_estimation  0.0

		proc ::device::scale::saw::flow_now {} {
			::device::scale::history::flow_estimate_fd
		}
	}

	proc setup_median_estimation_mapping {args} {

		proc ::device::scale::saw::weight_now {} {
			::device::scale::history::weight_estimate_median
		}

		set ::device::scale::saw::lag_time_estimation  0.5

		proc ::device::scale::saw::flow_now {} {
			::device::scale::history::flow_estimate_median
		}
	}


	proc check_for_saw {} {

		variable _target
		variable _early_by_grams
		variable _early_by_flow
		variable _ignore_first_seconds
		variable _mode_timer

		if {[::device::scale::saw::is_tracking_state] && $_target > 0} {

			set thisweight [weight_now]

			set stop_early_by [expr { $_early_by_grams + [flow_now] * $_early_by_flow }]

			if {    [$_mode_timer] > $_ignore_first_seconds \
					&& ! $::de1(scale_autostop_triggered) \
					&& [round_to_one_digits $thisweight] > \
						[round_to_one_digits [expr { $_target - $stop_early_by }]]} {

				start_idle

				# As there might be a delay between request and stop
				# and weight updates keep arriving, don't ask twice

				set ::de1(scale_autostop_triggered) True

				msg -INFO "Weight based stop was triggered at ${thisweight} g for ${_target} g target"
				::gui::notify::scale_event saw_stop
			}
		}
	}

	# NB: autotare is expected for SAW to work, see ::device::scale::autotare_states

	proc is_tracking_state {{state_text "None"} {substate_text "None"}} {

		if { $state_text == "None" } { set state_text [::de1::state::current_state] }

		expr { $state_text in {{Espresso} {HotWater}} }
	}

	proc is_active {} {

		variable _is_active_flag

		return expr {$_is_active_flag}
	}


	proc start_active {} {

		variable _is_active_flag

		if { [is_active] } {
			msg -NOTICE "::device::scale::saw::start_active: already active"

		} else {
			reset_shot_record
			set _is_active_flag True
			msg -DEBUG "::device::scale::saw::start_active"
		}
	}

	proc stop_active {} {

		variable _is_active_flag

		if { ! [is_active] } {
			msg -NOTICE "::device::scale::saw::stop_active: already not active"

		} else {
			set _is_active_flag False
			msg -DEBUG "::device::scale::saw::stop_active"
		}
	}

	proc on_espresso_start {args} {

		variable _target
		variable _early_by_grams
		variable _early_by_flow
		variable _ignore_first_seconds
		variable _mode_timer

		switch $::settings(settings_profile_type) {
			settings_2c	{ set _target $::settings(final_desired_shot_weight_advanced) }
			default 	{ set _target $::settings(final_desired_shot_weight) }
		}
		# Ensure testable with > 0
		set _target [scan $_target %g]

		set _early_by_grams 0
		set _early_by_flow [expr { $::settings(stop_weight_before_seconds) \
						   + [::device::scale::sensor_lag] \
						   + $::device::scale::saw::lag_time_estimation \
						   + $::device::scale::saw::_lag_time_de1 }]

		# From current Stable code
		set _ignore_first_seconds 5
		set _mode_timer "espresso_timer"

		msg -DEBUG "::device::scale::saw::on_espresso_start"

		if { $_target > 0 } { ::device::scale::saw::warn_if_scale_not_reporting }
	}

	proc on_hotwater_start {args} {

		variable _target
		variable _early_by_grams
		variable _early_by_flow
		variable _ignore_first_seconds
		variable _mode_timer

		if { $::settings(water_stop_on_scale) } {
			set _target $::settings(water_volume)
		} else {
			set _target 0
		}
		# Ensure testable with > 0
		set _target [scan $_target %g]

		set _early_by_grams 0
		set _early_by_flow [expr { 0.0 \
						   + [::device::scale::sensor_lag] \
						   + $::device::scale::saw::lag_time_estimation \
						   + $::device::scale::saw::_lag_time_de1 }]

		# From current Stable code
		set _ignore_first_seconds 2.5
		set _mode_timer "water_pour_timer"

		msg -DEBUG "::device::scale::saw::on_hotwater_start"
		if { $_target > 0 } { ::device::scale::saw::warn_if_scale_not_reporting }
	}

	proc on_major_state_change {event_dict} {

		if {[::device::scale::saw::is_tracking_state [dict get $event_dict this_state]]} {

			set ::de1(scale_autostop_triggered) False
		}

		switch  [dict get $event_dict this_state] {

			Espresso { on_espresso_start }

			HotWater { on_hotwater_start }
		}
	}

	proc warn_if_scale_not_reporting {args} {

		set last_update_ago [expr { ( ([clock milliseconds] / 1000.0) \
						      - [::device::scale::last_weight_update_time] ) }]

		if { $last_update_ago > $::device::scale::warn_if_no_updates_within \
			     &&  [::device::scale::expecting_present] } {

			msg -NOTICE "::device::scale::saw::warn_if_scale_not_reporting last at $last_update_ago seconds ago"
			::gui::notify::scale_event no_updates
		}

	}

} ;# ::device::scale::saw


namespace eval ::device::scale::callbacks {

	proc on_major_state_change {event_dict} {

		set this_state [dict get $event_dict this_state]

		if { [::device::scale::is_autotare_state $this_state] } {

			set ::device::scale::_initial_tare_after_id \
				[after $::device::scale::_tare_holdoff_initial \
					 { device::scale::tare ; set ::device::scale::_initial_tare_after_id "" }]
		}

		# bluetooth.tcl: timer off is badly named, it actually is "timer set to zero"

		if { [::de1::state::is_flow_state $this_state] && $::device::scale::run_timer } { scale_timer_off }
	}

	proc on_connect {event_dict} {

		::device::scale::init
		::device::scale::watchdog_first

		set ::device::scale::run_timer		   False
		set ::device::scale::_tare_holdoff_initial 200
		set ::device::scale::_tare_holdoff_repeat  200

		if { [info exists ::settings(high_vibration_scale_filtering) ] \
			     && $::settings(high_vibration_scale_filtering) } {

			::device::scale::history::setup_median_estimation_mapping
			::device::scale::saw::setup_median_estimation_mapping
			msg -NOTICE "::device::scale: high_vibration_scale_filtering selected"

		} else {

			::device::scale::history::setup_default_estimation_mapping
			::device::scale::saw::setup_default_estimation_mapping
			msg -NOTICE "::device::scale: default filtering selected"
		}

		switch $::settings(scale_type) {

			decentscale {

				set ::device::scale::run_timer True

				# See commit a8a61e1 Jan-18-2020:
				#     slightly more delay (500ms) with tare on espresso start,
				#     to make sure we don't have a ble command splat with decent scale

				set ::device::scale::_tare_holdoff_initial 500

				# (Here is a good place to select different weight-estimation algorithms)
			}

			felicita {

				set ::device::scale::run_timer True
			}
		}
	}


	proc on_disconnect {event_dict} {

		::device::scale::_watchdog_cancel ::device::scale::_watchdog_entry_id entry
		::device::scale::_watchdog_cancel ::device::scale::_watchdog_leave_id leave

		::gui::notify::scale_event not_connected
	}

	proc on_flow_change_manage_timer {event_dict} {

		if { ! $::device::scale::run_timer } { return }

		if { [::de1::state::flow_phase \
			      [dict get $event_dict this_state] \
			      [dict get $event_dict this_substate]] == "during" } {

			scale_timer_start

		} elseif { [::de1::state::flow_phase \
				       [dict get $event_dict previous_state] \
				       [dict get $event_dict previous_substate]] == "during" } {

			scale_timer_stop
		}
	}



	::de1::event::listener::on_major_state_change_add -noidle ::device::scale::callbacks::on_major_state_change

	::de1::event::listener::on_major_state_change_add ::device::scale::history::on_state_change

	::de1::event::listener::on_major_state_change_add ::device::scale::saw::on_major_state_change

	::de1::event::listener::after_flow_complete_add ::device::scale::history::stop_recording

	# -noidle should be close enough for scale's inbuilt timer
	::de1::event::listener::on_flow_change_add -noidle ::device::scale::callbacks::on_flow_change_manage_timer

	::device::scale::event::listener::on_connect_add -noidle ::device::scale::callbacks::on_connect

	::device::scale::event::listener::on_disconnect_add -noidle ::device::scale::callbacks::on_disconnect

} ;# ::device::scale::callbacks
