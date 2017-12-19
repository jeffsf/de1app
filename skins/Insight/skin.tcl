set ::skindebug 0
set ::debugging 0

puts "debugging: $::debugging"

package require de1plus 1.0

##############################################################################################################################################################################################################################################################################
# the graphics for each of the main espresso machine modes
add_de1_page "off" "espresso_1.png"
add_de1_page "off_zoomed off_zoomed_temperature" "espresso_1_zoomed.png"

if {$::settings(display_rate_espresso) == 1} {
	add_de1_page "espresso_3" "espresso_3.png"
	add_de1_page "espresso_3_zoomed espresso_3_zoomed_temperature" "espresso_3_zoomed.png"
} else {
	# no need to display the heart icon after espresso is finished, if "Rate espresso" is disabled
	add_de1_page "espresso_3" "espresso_1.png"
	add_de1_page "espresso_3_zoomed espresso_3_zoomed_temperature" "espresso_1_zoomed.png"
}

add_de1_page "espresso" "espresso_2.png"
add_de1_page "espresso_zoomed espresso_zoomed_temperature" "espresso_2_zoomed.png" 

add_de1_page "steam" "steam_2.png"
add_de1_page "steam_1" "steam_1.png"
add_de1_page "steam_3" "steam_3.png"

add_de1_page "water" "water_2.png"
add_de1_page "water_1" "water_1.png"
add_de1_page "water_3" "water_3.png"

add_de1_page "preheat_1" "preheat_1.png"
add_de1_page "preheat_2" "preheat_2.png"
add_de1_page "preheat_3" "preheat_3.png"
add_de1_page "preheat_4" "preheat_4.png"

# most skins will not bother replacing these graphics
add_de1_page "sleep" "sleep.jpg" "default"
add_de1_page "tankfilling" "filling_tank.jpg" "default"
add_de1_page "tankempty" "fill_tank.jpg" "default"
add_de1_page "message" "settings_message.jpg" "default"
add_de1_page "cleaning" "cleaning.jpg" "default"
add_de1_page "descaling" "descaling.jpg" "default"

set_de1_screen_saver_directory "[homedir]/saver"

# include the generic settings features for all DE1 skins.  
source "[homedir]/skins/default/de1_skin_settings.tcl"


set ::current_espresso_page "off"


# labels for PREHEAT tab on
add_de1_text "preheat_1 preheat_2 preheat_3 preheat_4" 405 100 -text [translate "FLUSH"] -font Helv_10_bold -fill "#2d3046" -anchor "center" 
add_de1_text "preheat_1 preheat_2 preheat_3 preheat_4" 1035 100 -text [translate "ESPRESSO"] -font Helv_10_bold -fill "#5a5d75" -anchor "center" 
add_de1_text "preheat_1 preheat_2 preheat_3 preheat_4" 1665 100 -text [translate "STEAM"] -font Helv_10_bold -fill "#5a5d75" -anchor "center" 
add_de1_text "preheat_1 preheat_2 preheat_3 preheat_4" 2290 100 -text [translate "WATER"] -font Helv_10_bold -fill "#5a5d75" -anchor "center" 

# labels for ESPRESSO tab on
add_de1_text "off espresso espresso_3" 405 100 -text [translate "FLUSH"] -font Helv_10_bold -fill "#5a5d75" -anchor "center" 
add_de1_text "off espresso espresso_3" 1035 100 -text [translate "ESPRESSO"] -font Helv_10_bold -fill "#2d3046" -anchor "center" 
add_de1_text "off espresso espresso_3" 1665 100 -text [translate "STEAM"] -font Helv_10_bold -fill "#5a5d75" -anchor "center" 
add_de1_text "off_zoomed espresso_3_zoomed espresso_zoomed off_zoomed_temperature espresso_zoomed_temperature espresso_3_zoomed_temperature" 2350 90 -text [translate "STEAM"] -font Helv_10_bold -fill "#5a5d75" -anchor "center" 
add_de1_text "off espresso espresso_3" 2290 100 -text [translate "WATER"] -font Helv_10_bold -fill "#5a5d75" -anchor "center" 

# labels for STEAM tab on
add_de1_text "steam steam_1 steam_3" 405 100 -text [translate "FLUSH"] -font Helv_10_bold -fill "#5a5d75" -anchor "center" 
add_de1_text "steam steam_1 steam_3" 1035 100 -text [translate "ESPRESSO"] -font Helv_10_bold -fill "#5a5d75" -anchor "center" 
add_de1_text "steam steam_1 steam_3" 1665 100 -text [translate "STEAM"] -font Helv_10_bold -fill "#2d3046" -anchor "center" 
add_de1_text "steam steam_1 steam_3" 2290 100 -text [translate "WATER"] -font Helv_10_bold -fill "#5a5d75" -anchor "center" 

# labels for HOT WATER tab on
add_de1_text "water water_1 water_3" 405 100 -text [translate "FLUSH"] -font Helv_10_bold -fill "#5a5d75" -anchor "center" 
add_de1_text "water water_1 water_3" 1035 100 -text [translate "ESPRESSO"] -font Helv_10_bold -fill "#5a5d75" -anchor "center" 
add_de1_text "water water_1 water_3" 1665 100 -text [translate "STEAM"] -font Helv_10_bold -fill "#5a5d75" -anchor "center" 
add_de1_text "water water_1 water_3" 2290 100 -text [translate "WATER"] -font Helv_10_bold -fill "#2d3046" -anchor "center" 

# buttons for moving between tabs, available at all times that the espresso machine is not doing something hot
add_de1_button "off espresso_3 preheat_3 preheat_4 steam_1 steam_3 water_1 water_3 water_4" {say [translate {pre-heat}] $::settings(sound_button_in); set_next_page off preheat_1; page_show preheat_1; if {$::settings(one_tap_mode) == 1} { start_hot_water_rinse } } 0 0 641 188
add_de1_button "espresso_3 preheat_1 preheat_3 preheat_4 steam_1 steam_3 water_1 water_3 water_4" {say [translate {espresso}] $::settings(sound_button_in); set_next_page off $::current_espresso_page; page_show off; if {$::settings(one_tap_mode) == 1} { start_espresso } } 642 0 1277 188
add_de1_button "off espresso_3 preheat_1 preheat_3 preheat_4 steam_3 water_1 water_3 water_4" {say [translate {steam}] $::settings(sound_button_in); set_next_page off steam_1; page_show off; if {$::settings(one_tap_mode) == 1} { start_steam } } 1278 0 1904 188
add_de1_button "off_zoomed espresso_3_zoomed espresso_zoomed off_zoomed_temperature espresso_zoomed_temperature espresso_3_zoomed_temperature" {say [translate {steam}] $::settings(sound_button_in); set_next_page off steam_1; page_show off; if {$::settings(one_tap_mode) == 1} { start_steam } } 2020 0 2550 180
add_de1_button "off espresso_3 preheat_1 preheat_3 preheat_4 steam_1 steam_3 water_3 water_4" {say [translate {water}] $::settings(sound_button_in); set_next_page off water_1; page_show off; if {$::settings(one_tap_mode) == 1} { start_water } } 1905 0 2560 188

# when the espresso machine is doing something, the top tabs have to first stop that function, then the tab can change
add_de1_button "preheat_2 steam water espresso espresso_3" {say [translate {pre-heat}] $::settings(sound_button_in);set_next_page off preheat_1; start_idle; if {$::settings(one_tap_mode) == 1} { start_hot_water_rinse } } 0 0 641 188
add_de1_button "preheat_2 steam water espresso espresso_3" {say [translate {espresso}] $::settings(sound_button_in);set ::current_espresso_page off; set_next_page $::current_espresso_page off; start_idle; if {$::settings(one_tap_mode) == 1} { start_espresso } } 642 0 1277 188
add_de1_button "preheat_2 steam water espresso espresso_3" {say [translate {steam}] $::settings(sound_button_in);set_next_page off steam_1; start_idle; if {$::settings(one_tap_mode) == 1} { start_steam } } 1278 0 1904 188
add_de1_button "preheat_2 steam water espresso espresso_3" {say [translate {water}] $::settings(sound_button_in);set_next_page off water_1; start_idle; if {$::settings(one_tap_mode) == 1} { start_water } } 1905 0 2560 188


################################################################################################################################################################################################################################################################################################
# espresso charts

set charts_width 1990
if {$::debugging == 1} {
	set charts_width 400
	add_de1_variable "off espresso espresso_3" 450 220 -text "" -font Helv_6 -fill "#5a5d75" -anchor "nw" -justify left -width 780 -textvariable {$::debuglog}
}


#######################
# 3 equal sized charts
add_de1_widget "off espresso espresso_1 espresso_2 espresso_3" graph 20 267 { 
	bind $widget [platform_button_press] { 
		say [translate {zoom}] $::settings(sound_button_in); 
		set_next_page off off_zoomed; 
		set_next_page espresso espresso_zoomed; 
		set_next_page espresso_3 espresso_3_zoomed; 
		page_show $::de1(current_context);
	}
	$widget element create line_espresso_pressure_goal -xdata espresso_elapsed -ydata espresso_pressure_goal -symbol none -label "" -linewidth [rescale_x_skin 8] -color #69fdb3  -smooth quadratic -pixels 0 -dashes {5 5}; 
	$widget element create line_espresso_pressure -xdata espresso_elapsed -ydata espresso_pressure -symbol none -label "" -linewidth [rescale_x_skin 10] -color #18c37e  -smooth quadratic -pixels 0; 
	$widget element create god_line_espresso_pressure -xdata espresso_elapsed -ydata god_espresso_pressure -symbol none -label "" -linewidth [rescale_x_skin 20] -color #c5ffe7  -smooth quadratic -pixels 0; 
	$widget element create line_espresso_state_change_1 -xdata espresso_elapsed -ydata espresso_state_change -label "" -linewidth [rescale_x_skin 6] -color #AAAAAA  -pixels 0 ; 
	
	if {$::settings(display_pressure_delta_line) == 1} {
		$widget element create line_espresso_pressure_delta2  -xdata espresso_elapsed -ydata espresso_pressure_delta -symbol none -label "" -linewidth [rescale_x_skin 2] -color #40dc94 -pixels 0 -smooth quadratic 
	}

	$widget axis configure x -color #008c4c -tickfont Helv_6 ; 
	$widget axis configure y -color #008c4c -tickfont Helv_6 -min 0.0 -max $::de1(max_pressure) -subdivisions 5 -majorticks {1 3 5 7 9 11}

} -plotbackground #FFFFFF -width [rescale_x_skin $charts_width] -height [rescale_y_skin 406] -borderwidth 1 -background #FFFFFF -plotrelief flat

add_de1_widget "off espresso espresso_1 espresso_2 espresso_3" graph 20 723 {
	bind $widget [platform_button_press] { 
		say [translate {zoom}] $::settings(sound_button_in); 
		set_next_page off off_zoomed; 
		set_next_page espresso espresso_zoomed; 
		set_next_page espresso_3 espresso_3_zoomed; 
		page_show $::de1(current_context);
	} 
	$widget element create line_espresso_flow_goal  -xdata espresso_elapsed -ydata espresso_flow_goal -symbol none -label "" -linewidth [rescale_x_skin 8] -color #7aaaff -smooth quadratic -pixels 0  -dashes {5 5}; 

	$widget element create line_espresso_flow  -xdata espresso_elapsed -ydata espresso_flow -symbol none -label "" -linewidth [rescale_x_skin 12] -color #4e85f4 -smooth quadratic -pixels 0; 

	if {$::settings(display_flow_delta_line) == 1} {
		$widget element create line_espresso_flow_delta  -xdata espresso_elapsed -ydata espresso_flow_delta -symbol none -label "" -linewidth [rescale_x_skin 2] -color #98c5ff -pixels 0 -smooth quadratic 
	}

	if {$::settings(display_weight_delta_line) == 1} {	
		$widget element create line_espresso_flow_weight  -xdata espresso_elapsed -ydata espresso_flow_weight -symbol none -label "" -linewidth [rescale_x_skin 6] -color #a2693d -smooth quadratic -pixels 0; 
		$widget element create god_line_espresso_flow_weight  -xdata espresso_elapsed -ydata god_espresso_flow_weight -symbol none -label "" -linewidth [rescale_x_skin 12] -color #edd4c1 -smooth quadratic -pixels 0; 
	}

	$widget element create god_line_espresso_flow  -xdata espresso_elapsed -ydata god_espresso_flow -symbol none -label "" -linewidth [rescale_x_skin 24] -color #e4edff -smooth quadratic -pixels 0; 
	$widget element create line_espresso_state_change_2 -xdata espresso_elapsed -ydata espresso_state_change -label "" -linewidth [rescale_x_skin 6] -color #AAAAAA  -pixels 0; 
	$widget axis configure x -color #206ad4 -tickfont Helv_6 ; 

	$widget axis configure y -color #206ad4 -tickfont Helv_6 -min 0.0 -max 6 -subdivisions 2 -majorticks {1 2 3 4 5 6}
} -width [rescale_x_skin $charts_width] -height [rescale_y_skin 410]  -plotbackground #FFFFFF -borderwidth 1 -background #FFFFFF -plotrelief flat


add_de1_widget "off espresso espresso_1 espresso_2 espresso_3" graph 20 1174 {
	bind $widget [platform_button_press] { 
		say [translate {zoom}] $::settings(sound_button_in); 
		set_next_page off off_zoomed_temperature; 
		set_next_page espresso espresso_zoomed_temperature; 
		set_next_page espresso_3 espresso_3_zoomed_temperature; 
		page_show $::de1(current_context);
	} 

	$widget element create line_espresso_temperature_goal -xdata espresso_elapsed -ydata espresso_temperature_goal -symbol none -label ""  -linewidth [rescale_x_skin 8] -color #ffa5a6 -smooth quadratic -pixels 0 -dashes {5 5}; 
	$widget element create line_espresso_temperature_basket -xdata espresso_elapsed -ydata espresso_temperature_basket -symbol none -label ""  -linewidth [rescale_x_skin 12] -color #e73249 -smooth quadratic -pixels 0; 

	$widget element create god_line_espresso_temperature_basket -xdata espresso_elapsed -ydata god_espresso_temperature_basket -symbol none -label ""  -linewidth [rescale_x_skin 24] -color #ffe4e7 -smooth quadratic -pixels 0; 
	$widget element create line_espresso_state_change_3 -xdata espresso_elapsed -ydata espresso_state_change -label "" -linewidth [rescale_x_skin 6] -color #AAAAAA  -pixels 0 ; 


	$widget axis configure x -color #e73249 -tickfont Helv_6; 
	$widget axis configure y -color #e73249 -tickfont Helv_6 -subdivisions 5; 
	set ::temperature_chart_widget $widget
} -width [rescale_x_skin $charts_width] -height [rescale_y_skin 410]  -plotbackground #FFFFFF -borderwidth 0 -background #FFFFFF -plotrelief flat

proc update_temperature_charts_y_axis {} {
	$::temperature_chart_widget axis configure y -color #e73249 -tickfont Helv_6 -subdivisions 2 -min [expr {[return_temperature_number $::settings(espresso_temperature)] - 10}] -max [expr {[return_temperature_number $::settings(espresso_temperature)] + 3}]; 
}

####

add_de1_text "off_zoomed espresso_zoomed espresso_3_zoomed" 1970 30 -text [translate "Flow (mL/s)"] -font Helv_7_bold -fill "#206ad4" -justify "left" -anchor "ne"
add_de1_text "off_zoomed espresso_zoomed espresso_3_zoomed" 40 30 -text [translate "Pressure (bar)"] -font Helv_7_bold -fill "#008c4c" -justify "left" -anchor "nw"
add_de1_text "off_zoomed_temperature espresso_zoomed_temperature espresso_3_zoomed_temperature" 40 30 -text [translate "Temperature ([return_html_temperature_units]) :"] -font Helv_7_bold -fill "#e73249" -justify "left" -anchor "nw"

add_de1_text "off espresso espresso_3" 40 220 -text [translate "Pressure (bar)"] -font Helv_7_bold -fill "#008c4c" -justify "left" -anchor "nw"

add_de1_text "off espresso espresso_3" 40 677 -text [translate "Flow (mL/s)"] -font Helv_7_bold -fill "#206ad4" -justify "left" -anchor "nw"
if {$::settings(display_weight_delta_line) == 1} {	
	#set distance [font_width "Flow (mL/s)" Helv_7_bold]
	add_de1_text "off espresso espresso_3" 1970 677 -text [translate "Weight (g/s)"] -font Helv_7_bold -fill "#a2693d" -justify "left" -anchor "ne" 
	
	#set distance [font_width "Weight (g/s)" Helv_7_bold]
	add_de1_text "off_zoomed espresso_zoomed espresso_3_zoomed" 1600 30 -text [translate "Weight (g/s)"] -font Helv_7_bold -fill "#a2693d" -justify "left" -anchor "ne" 	
}

add_de1_text "off espresso espresso_3" 40 1128 -text [translate "Temperature ([return_html_temperature_units]) :"] -font Helv_7_bold -fill "#e73249" -justify "left" -anchor "nw"


if {$::settings(waterlevel_indicator_on) == 1} {
	# water level sensor 
	add_de1_widget "off espresso espresso_3 off_zoomed espresso_zoomed espresso_3_zoomed off_zoomed_temperature espresso_zoomed_temperature espresso_3_zoomed_temperature" scale 2528 694 {after 1000 water_level_color_check $widget} -from 40 -to 5 -background #7ad2ff -foreground #0000FF -borderwidth 1 -bigincrement .1 -resolution .1 -length [rescale_x_skin 594] -showvalue 0 -width [rescale_y_skin 16] -variable ::de1(water_level) -state disabled -sliderrelief flat -font Helv_10_bold -sliderlength [rescale_x_skin 50] -relief flat -troughcolor #ffffff -borderwidth 0  -highlightthickness 0

	# causes the water level widget to change between colors (blinking) at an inreasing rate as the water level goes lower
	proc water_level_color_check {widget} {
		if {$::settings(waterlevel_indicator_blink) != 1} {
			return
		}
		if {[info exists ::water_level_color_check_count] != 1} {
			set ::water_level_color_check_count  0
		}
		incr ::water_level_color_check_count 
		set colors [list  "#7ad2ff"  "#98eeff"]
		if {$::water_level_color_check_count > [expr {-1 + [llength $colors]}] } {
			set ::water_level_color_check_count 0
		}

		if {$::de1(water_level) > $::settings(waterlevel_blink_start_level)} {
			# check the water rate infrequently if there is enough water and don't blink it
			set color "#7ad2ff"
			set blinkrate 5000
		} else {
			set color [lindex $colors $::water_level_color_check_count]
			if {$::de1(water_level) > 10} {
				set blinkrate 2000
			} elseif {$::de1(water_level) > 7} {
				set blinkrate 1000
			} elseif {$::de1(water_level) > 5} {
				set blinkrate 500
			} else {
				set blinkrate 250
			}
		}

		$widget configure -background $color
		after $blinkrate water_level_color_check $widget
	}
}


#######################
# zoomed espresso
add_de1_widget "off_zoomed espresso_zoomed espresso_3_zoomed" graph 20 74 {
	bind $widget [platform_button_press] { 
		say [translate {zoom}] $::settings(sound_button_in); 
		set_next_page espresso_3 espresso_3; 
		set_next_page espresso_3_zoomed espresso_3; 
		set_next_page espresso espresso; 
		set_next_page espresso_zoomed espresso; 
		set_next_page off off; 
		set_next_page off_zoomed off; 
		page_show $::de1(current_context)
	} 
	$widget element create line_espresso_pressure_goal -xdata espresso_elapsed -ydata espresso_pressure_goal -symbol none -label "" -linewidth [rescale_x_skin 8] -color #69fdb3  -smooth quadratic -pixels 0 -dashes {5 5}; 
	$widget element create line2_espresso_pressure -xdata espresso_elapsed -ydata espresso_pressure -symbol none -label "" -linewidth [rescale_x_skin 12] -color #18c37e  -smooth quadratic -pixels 0; 

	if {$::settings(display_pressure_delta_line) == 1} {
		$widget element create line_espresso_pressure_delta_1  -xdata espresso_elapsed -ydata espresso_pressure_delta -symbol none -label "" -linewidth [rescale_x_skin 2] -color #40dc94 -pixels 0 -smooth quadratic 
	}

	$widget element create line_espresso_flow_goal_2x  -xdata espresso_elapsed -ydata espresso_flow_goal_2x -symbol none -label "" -linewidth [rescale_x_skin 8] -color #7aaaff -smooth quadratic -pixels 0  -dashes {5 5}; 
	$widget element create line_espresso_flow_2x  -xdata espresso_elapsed -ydata espresso_flow_2x -symbol none -label "" -linewidth [rescale_x_skin 12] -color #4e85f4 -smooth quadratic -pixels 0; 
	$widget element create god_line_espresso_flow_2x  -xdata espresso_elapsed -ydata god_espresso_flow_2x -symbol none -label "" -linewidth [rescale_x_skin 24] -color #e4edff -smooth quadratic -pixels 0; 

	if {$::settings(display_flow_delta_line) == 1} {
		$widget element create line_espresso_flow_delta_1  -xdata espresso_elapsed -ydata espresso_flow_delta -symbol none -label "" -linewidth [rescale_x_skin 2] -color #98c5ff -pixels 0 -smooth quadratic 
	}

	if {$::settings(display_weight_delta_line) == 1} {	
		$widget element create line_espresso_flow_weight_2x  -xdata espresso_elapsed -ydata espresso_flow_weight_2x -symbol none -label "" -linewidth [rescale_x_skin 8] -color #a2693d -smooth quadratic -pixels 0; 
		$widget element create god_line_espresso_flow_weight_2x  -xdata espresso_elapsed -ydata god_espresso_flow_weight_2x -symbol none -label "" -linewidth [rescale_x_skin 16] -color #edd4c1 -smooth quadratic -pixels 0; 

	}

	$widget element create god_line2_espresso_pressure -xdata espresso_elapsed -ydata god_espresso_pressure -symbol none -label "" -linewidth [rescale_x_skin 24] -color #c5ffe7  -smooth quadratic -pixels 0; 
	$widget element create line_espresso_state_change_1 -xdata espresso_elapsed -ydata espresso_state_change -label "" -linewidth [rescale_x_skin 6] -color #AAAAAA  -pixels 0 ; 

	$widget axis configure x -color #5a5d75 -tickfont Helv_7_bold; 
	$widget axis configure y -color #008c4c -tickfont Helv_7_bold -min 0.0 -max $::de1(max_pressure) -subdivisions 5 -majorticks {0 1 2 3 4 5 6 7 8 9 10 11 12}  -hide 0;
	$widget axis configure y2 -color #206ad4 -tickfont Helv_7_bold -min 0.0 -max 6 -subdivisions 2 -majorticks {0 0.5 1 1.5 2 2.5 3 3.5 4 4.5 5 5.5 6} -hide 0; 
	#$widget axis configure y2 -color #206ad4 -tickfont Helv_6 -gridminor 0 -min 0.0 -max $::de1(max_flowrate) -majorticks {0 0.5 1 1.5 2 2.5 3 3.5 4 4.5 5 5.5 6} -hide 0; 
} -plotbackground #FFFFFF -width [rescale_x_skin 1990] -height [rescale_y_skin 1516] -borderwidth 1 -background #FFFFFF -plotrelief flat

#######################



#######################
# zoomed temperature
add_de1_widget "off_zoomed_temperature espresso_zoomed_temperature espresso_3_zoomed_temperature" graph 20 74 {
	bind $widget [platform_button_press] { 
		say [translate {zoom}] $::settings(sound_button_in); 
		set_next_page espresso_3 espresso_3; 
		set_next_page espresso_3_zoomed_temperature espresso_3; 
		set_next_page espresso espresso; 
		set_next_page espresso_zoomed_temperature espresso; 
		set_next_page off off; 
		set_next_page off_zoomed_temperature off; 
		page_show $::de1(current_context)
	} 
	$widget element create line_espresso_temperature_goal -xdata espresso_elapsed -ydata espresso_temperature_goal -symbol none -label ""  -linewidth [rescale_x_skin 6] -color #ffa5a6 -smooth quadratic -pixels 0 -dashes {5 5}; 
	$widget element create line_espresso_temperature_basket -xdata espresso_elapsed -ydata espresso_temperature_basket -symbol none -label ""  -linewidth [rescale_x_skin 10] -color #e73249 -smooth quadratic -pixels 0; 
	$widget element create god_line_espresso_temperature_basket -xdata espresso_elapsed -ydata god_espresso_temperature_basket -symbol none -label ""  -linewidth [rescale_x_skin 20] -color #ffe4e7 -smooth quadratic -pixels 0; 
	$widget element create line_espresso_state_change_4 -xdata espresso_elapsed -ydata espresso_state_change -label "" -linewidth [rescale_x_skin 6] -color #AAAAAA  -pixels 0 ; 
	$widget axis configure x -color #e73249 -tickfont Helv_6; 
	$widget axis configure y -color #e73249 -tickfont Helv_6 -subdivisions 5; 
	set ::temperature_chart_zoomed_widget $widget
} -plotbackground #FFFFFF -width [rescale_x_skin 1990] -height [rescale_y_skin 1516] -borderwidth 1 -background #FFFFFF -plotrelief flat

proc update_temperature_charts_y_axis {} {
	$::temperature_chart_widget axis configure y -min [expr {[return_temperature_number $::settings(espresso_temperature)] - $::settings(espresso_chart_under)}] -max [expr {[return_temperature_number $::settings(espresso_temperature)] + $::settings(espresso_chart_over)}]; 
	$::temperature_chart_zoomed_widget axis configure y -min [expr {[return_temperature_number $::settings(espresso_temperature)] - $::settings(espresso_chart_under)}] -max [expr {[return_temperature_number $::settings(espresso_temperature)] + $::settings(espresso_chart_over)}]; 
}
update_temperature_charts_y_axis


#######################

# click anywhere on the chart to zoom pressure/flow.  This button is only to cover the parts that aren't overlaid by the charts, such as the text labels
add_de1_button "off espresso espresso_3" {
		say [translate {zoom}] $::settings(sound_button_in); 
		set_next_page off off_zoomed; 
		set_next_page espresso espresso_zoomed; 
		set_next_page espresso_3 espresso_3_zoomed; 
		page_show $::de1(current_context);
} 10 200 2012 1135

# click anywhere on the chart to zoom pressure/flow.  This button is only to cover the parts that aren't overlaid by the charts, such as the text labels
add_de1_button "off espresso espresso_3" {
		say [translate {zoom}] $::settings(sound_button_in); 
		set_next_page off off_zoomed_temperature;
		set_next_page espresso espresso_zoomed_temperature;
		set_next_page espresso_3 espresso_3_zoomed_temperature;
		page_show $::de1(current_context);
} 10 1136 2012 1600

add_de1_button "off_zoomed espresso_zoomed espresso_3_zoomed" {
		say [translate {zoom}] $::settings(sound_button_in); 
		set_next_page espresso_3 espresso_3; 
		set_next_page espresso_3_zoomed espresso_3; 
		set_next_page espresso espresso; 
		set_next_page espresso_zoomed espresso; 
		set_next_page off off; 
		set_next_page off_zoomed off; 
		page_show $::de1(current_context);
} 1 1 2012 1135

add_de1_button "off_zoomed_temperature espresso_zoomed_temperature espresso_3_zoomed_temperature" {
		say [translate {zoom}] $::settings(sound_button_in); 
		set_next_page espresso_3 espresso_3; 
		set_next_page espresso_3_zoomed_temperature espresso_3; 
		set_next_page espresso espresso; 
		set_next_page espresso_zoomed_temperature espresso; 
		set_next_page off off; 
		set_next_page off_zoomed_temperature off; 
		page_show $::de1(current_context);
} 1 1 2012 1600

# the "go to sleep" button and the whole-screen button for coming back awake
add_de1_button "saver descaling cleaning" {say [translate {awake}] $::settings(sound_button_in); set_next_page off off; start_idle} 0 0 2560 1600

if {$::debugging == 1} {
#	add_de1_button "off espresso_3 preheat_1 preheat_3 preheat_4 steam_1 steam_3 water_1 water_3 water_4 off_zoomed espresso_3_zoomed off_zoomed_temperature espresso_3_zoomed_temperature" {say [translate {sleep}] $::settings(sound_button_in); start_sleep} 2014 1442 2284 1600
	add_de1_button "off espresso_3 preheat_1 preheat_3 preheat_4 steam_1 steam_3 water_1 water_3 water_4 off_zoomed espresso_3_zoomed off_zoomed_temperature espresso_3_zoomed_temperature" {say [translate {sleep}] $::settings(sound_button_in); app_exit} 2014 1420 2284 1600
} else {
	add_de1_button "off espresso_3 preheat_1 preheat_3 preheat_4 steam_1 steam_3 water_1 water_3 water_4 off_zoomed espresso_3_zoomed off_zoomed_temperature espresso_3_zoomed_temperature" {say [translate {sleep}] $::settings(sound_button_in); set ::current_espresso_page "off"; start_sleep} 2014 1420 2284 1600
}
add_de1_text "sleep" 2500 1440 -justify right -anchor "ne" -text [translate "Going to sleep"] -font Helv_20_bold -fill "#DDDDDD" 

# settings button 
add_de1_button "off off_zoomed espresso_3 espresso_3_zoomed steam_1 water_1 preheat_1 steam_3 water_3 preheat_3 off_zoomed_temperature espresso_3_zoomed_temperature" { say [translate {settings}] $::settings(sound_button_in); show_settings } 2285 1420 2560 1600

add_de1_variable "off off_zoomed off_zoomed_temperature" 2290 390 -text [translate "START"] -font Helv_20_bold -fill "#2d3046" -anchor "center" -textvariable {[start_text_if_espresso_ready]} 
add_de1_variable "espresso espresso_zoomed espresso_zoomed_temperature" 2290 390 -text [translate "STOP"] -font Helv_20_bold -fill "#2d3046" -anchor "center" -textvariable {[stop_text_if_espresso_stoppable]} 
add_de1_variable "espresso_3 espresso_3_zoomed espresso_3_zoomed_temperature" 2290 390 -text [translate "RESTART"] -font Helv_18_bold -fill "#2d3046" -anchor "center" -textvariable {[espresso_history_save_from_gui]} 

add_de1_text "off off_zoomed espresso_3 espresso_3_zoomed espresso espresso_zoomed off_zoomed_temperature espresso_zoomed_temperature espresso_3_zoomed_temperature" 2295 470 -text [translate "ESPRESSO"] -font Helv_10 -fill "#7f879a" -anchor "center" 
add_de1_variable "off off_zoomed espresso espresso_zoomed espresso_3 espresso_3_zoomed off_zoomed_temperature espresso_zoomed_temperature espresso_3_zoomed_temperature" 2295 520 -text "" -font Helv_7 -fill "#999999" -anchor "center" -textvariable {[de1_substate_text]} 

# indicate whether we are connected to the DE1+ or not
add_de1_variable "off off_zoomed espresso espresso_zoomed espresso_3 espresso_3_zoomed off_zoomed_temperature espresso_zoomed_temperature espresso_3_zoomed_temperature" 2295 560 -justify center -anchor "center" -text "" -font Helv_6 -fill "#CCCCCC" -width 520 -textvariable {[de1_connected_state]} 

##########################################################################################################################################################################################################################################################################
# making espresso now

# make and stop espresso button
add_de1_button "off off_zoomed espresso_3 espresso_3_zoomed off_zoomed_temperature espresso_3_zoomed_temperature" {say [translate {espresso}] $::settings(sound_button_in);set ::current_espresso_page espresso_3; set_next_page off espresso_3; start_espresso} 2020 200 2560 680
add_de1_button "espresso" {say [translate {stop}] $::settings(sound_button_in);set_next_page off espresso_3; start_idle;} 2020 200 2560 680
add_de1_button "espresso_zoomed" {say [translate {stop}] $::settings(sound_button_in); set_next_page off espresso_3_zoomed; start_idle;} 2020 200 2560 680
add_de1_button "espresso_zoomed_temperature" {say [translate {stop}] $::settings(sound_button_in); set_next_page off espresso_3_zoomed_temperature; start_idle;} 2020 200 2560 680

# future feature
# add_de1_button "off off_zoomed espresso_3 espresso_3_zoomed" {say [translate {rinse}] $::settings(sound_button_in);set_next_page off espresso_3; start_espresso} 2020 631 2560 825

##########################################################################################################################################################################################################################################################################


##########################################################################################################################################################################################################################################################################
# data card displayed during espresso making

set pos_top 720
set spacer 38
#set paragraph 20

set column2 2180
if {$::settings(enable_fahrenheit) == 1} {
	set column2 2195
}

set dark "#5a5d75"
set lighter "#969eb1"
set lightest "#bec7db"

add_de1_text "off off_zoomed espresso espresso_zoomed espresso_3 espresso_3_zoomed off_zoomed_temperature espresso_zoomed_temperature espresso_3_zoomed_temperature" 2060 [expr {$pos_top + (0 * $spacer)}] -justify right -anchor "nw" -text [translate "Time"] -font Helv_7_bold -fill $dark -width [rescale_x_skin 520]
	add_de1_variable "off off_zoomed espresso espresso_zoomed espresso_3 espresso_3_zoomed off_zoomed_temperature espresso_zoomed_temperature espresso_3_zoomed_temperature" 2060 [expr {$pos_top + (1 * $spacer)}] -justify left -anchor "nw" -text "" -font Helv_7  -fill $lighter -width [rescale_x_skin 520] -textvariable {[preinfusion_timer][translate "s"] [translate "preinfusion"]} 
	add_de1_variable "off off_zoomed espresso espresso_zoomed espresso_3 espresso_3_zoomed off_zoomed_temperature espresso_zoomed_temperature espresso_3_zoomed_temperature" 2060 [expr {$pos_top + (2 * $spacer)}] -justify left -anchor "nw" -text "" -font Helv_7  -fill $lighter -width [rescale_x_skin 520] -textvariable {[pour_timer][translate "s"] [translate "pouring"]} 
	add_de1_variable "off off_zoomed espresso espresso_zoomed espresso_3 espresso_3_zoomed off_zoomed_temperature espresso_zoomed_temperature espresso_3_zoomed_temperature" 2060 [expr {$pos_top + (3 * $spacer)}] -justify left -anchor "nw" -text "" -font Helv_7 -fill $lighter -width [rescale_x_skin 520] -textvariable {[elapsed_timer][translate "s"] [translate "total"]} 
	add_de1_variable "espresso_3 espresso_3_zoomed espresso_3_zoomed_temperature" 2060 [expr {$pos_top + (4 * $spacer)}] -justify left -anchor "nw" -font Helv_7 -text "" -fill $lighter -width [rescale_x_skin 520] -textvariable {[done_timer][translate "s"] [translate "done"]} 

add_de1_text "off off_zoomed espresso espresso_zoomed espresso_3 espresso_3_zoomed off_zoomed_temperature espresso_zoomed_temperature espresso_3_zoomed_temperature" 2510 [expr {$pos_top + (0 * $spacer)}] -justify right -anchor "ne" -text [translate "Volume"] -font Helv_7_bold -fill $dark -width [rescale_x_skin 520]
	add_de1_variable "off off_zoomed espresso espresso_zoomed espresso_3 espresso_3_zoomed off_zoomed_temperature espresso_zoomed_temperature espresso_3_zoomed_temperature" 2510 [expr {$pos_top + (1 * $spacer)}] -justify left -anchor "ne" -text "" -font Helv_7  -fill $lighter -width [rescale_x_skin 520] -textvariable {[preinfusion_volume]} 
	add_de1_variable "off off_zoomed espresso espresso_zoomed espresso_3 espresso_3_zoomed off_zoomed_temperature espresso_zoomed_temperature espresso_3_zoomed_temperature" 2510 [expr {$pos_top + (2 * $spacer)}] -justify left -anchor "ne" -text "" -font Helv_7  -fill $lighter -width [rescale_x_skin 520] -textvariable {[pour_volume]} 
	add_de1_variable "off off_zoomed espresso espresso_zoomed espresso_3 espresso_3_zoomed off_zoomed_temperature espresso_zoomed_temperature espresso_3_zoomed_temperature" 2510 [expr {$pos_top + (3 * $spacer)}] -justify left -anchor "ne" -text "" -font Helv_7 -fill $lighter -width [rescale_x_skin 520] -textvariable {[watervolume_text]} 


#######################
# temperature
add_de1_text "off off_zoomed espresso_3 espresso_3_zoomed off_zoomed_temperature espresso_3_zoomed_temperature" 2060 [expr {$pos_top + (6 * $spacer)}] -justify right -anchor "nw" -text [translate "Temperature"] -font Helv_7_bold -fill $dark -width [rescale_x_skin 520]
add_de1_text "espresso espresso_zoomed espresso_zoomed_temperature" 2060 [expr {$pos_top + (5 * $spacer)}] -justify right -anchor "nw" -text [translate "Temperature"] -font Helv_7_bold -fill $dark -width [rescale_x_skin 520]
	add_de1_text "espresso espresso_zoomed espresso_zoomed_temperature" $column2 [expr {$pos_top + (6 * $spacer)}] -justify right -anchor "nw" -text [translate "goal"] -font Helv_7 -fill $lighter -width [rescale_x_skin 520]
	add_de1_text "off off_zoomed espresso_3 espresso_3_zoomed off_zoomed_temperature espresso_3_zoomed_temperature" $column2 [expr {$pos_top + (7 * $spacer)}] -justify right -anchor "nw" -text [translate "goal"] -font Helv_7 -fill $lighter -width [rescale_x_skin 520]
	add_de1_variable "espresso espresso_zoomed espresso_zoomed_temperature" 2060 [expr {$pos_top + (6 * $spacer)}] -justify left -anchor "nw" -font Helv_7 -fill $lighter -width [rescale_x_skin 520] -textvariable {[espresso_goal_temp_text]} 
	add_de1_variable "off off_zoomed espresso_3 espresso_3_zoomed off_zoomed_temperature espresso_3_zoomed_temperature" 2060 [expr {$pos_top + (7 * $spacer)}] -justify left -anchor "nw" -font Helv_7 -fill $lighter -width [rescale_x_skin 520] -textvariable {[espresso_goal_temp_text]} 

	add_de1_text "off off_zoomed  off_zoomed_temperature" $column2 [expr {$pos_top + (8 * $spacer)}] -justify right -anchor "nw" -text [translate "metal"] -font Helv_7 -fill $lighter -width [rescale_x_skin 520]
	add_de1_variable "off off_zoomed off_zoomed_temperature" 2060 [expr {$pos_top + (8 * $spacer)}] -justify left -anchor "nw" -font Helv_7 -fill $lighter -width [rescale_x_skin 520] -textvariable {[group_head_heater_temperature_text]} 

	if {$::settings(display_group_head_delta_number) == 1} {
		add_de1_variable "off off_zoomed espresso_3 espresso_3_zoomed off_zoomed_temperature espresso_3_zoomed_temperature" 2380 [expr {$pos_top + (8 * $spacer)}] -justify left -anchor "ne" -font Helv_7 -fill $lightest -width [rescale_x_skin 520] -textvariable {[return_delta_temperature_measurement [diff_group_temp_from_goal]]} 
	}

	add_de1_text "espresso espresso_zoomed espresso_zoomed_temperature" $column2 [expr {$pos_top + (7 * $spacer)}] -justify right -anchor "nw" -text [translate "coffee"] -font Helv_7 -fill $lighter -width [rescale_x_skin 520]
	add_de1_variable "espresso espresso_zoomed espresso_zoomed_temperature" 2060 [expr {$pos_top + (7 * $spacer)}] -justify left -anchor "nw" -text "" -font Helv_7 -fill $lighter -width [rescale_x_skin 520] -textvariable {[watertemp_text]} 
	add_de1_variable "espresso espresso_zoomed espresso_zoomed_temperature" 2510 [expr {$pos_top + (7 * $spacer)}] -justify left -anchor "ne" -text "" -font Helv_7 -fill $lightest -width [rescale_x_skin 520] -textvariable {[return_delta_temperature_measurement [diff_espresso_temp_from_goal]]} 

	add_de1_text "espresso espresso_zoomed espresso_zoomed_temperature" $column2 [expr {$pos_top + (8 * $spacer)}] -justify right -anchor "nw" -text [translate "water"] -font Helv_7 -fill $lighter -width [rescale_x_skin 520]
	add_de1_variable "espresso espresso_zoomed espresso_zoomed_temperature" 2060 [expr {$pos_top + (8 * $spacer)}] -justify left -anchor "nw" -font Helv_7 -fill $lighter -width [rescale_x_skin 520] -textvariable {[mixtemp_text]} 
	if {$::settings(display_espresso_water_delta_number) == 1} {
		add_de1_variable "espresso espresso_zoomed espresso_zoomed_temperature" 2510 [expr {$pos_top + (8 * $spacer)}] -justify left -anchor "ne" -font Helv_7 -fill $lightest -width [rescale_x_skin 520] -textvariable {[return_delta_temperature_measurement [diff_brew_temp_from_goal] ]} 
		# thermometer widget from http://core.tcl.tk/bwidget/doc/bwidget/BWman/index.html
	    add_de1_widget "espresso espresso_zoomed espresso_zoomed_temperature" ProgressBar 2400 [expr {$pos_top + (9.2 * $spacer)}] {} -width [rescale_y_skin 108] -height [rescale_x_skin 16] -type normal  -variable ::positive_diff_brew_temp_from_goal -fg #ff8888 -bg #FFFFFF -maximum 10 -borderwidth 1 -relief flat
	}
#######################
	#add_de1_widget "off espresso espresso_3 off_zoomed espresso_zoomed espresso_3_zoomed off_zoomed_temperature espresso_zoomed_temperature espresso_3_zoomed_temperature" scale 2528 694 {after 1000 water_level_color_check $widget} -from 40 -to 5 -background #7ad2ff -foreground #0000FF -borderwidth 1 -bigincrement .1 -resolution .1 -length [rescale_x_skin 594] -showvalue 0 -width [rescale_y_skin 16] -variable ::de1(water_level) -state disabled -sliderrelief flat -font Helv_10_bold -sliderlength [rescale_x_skin 50] -relief flat -troughcolor #ffffff -borderwidth 0  -highlightthickness 0



#######################
# flow 
add_de1_text "espresso espresso_zoomed espresso_zoomed_temperature" 2060 [expr {$pos_top + (10.5 * $spacer)}] -justify right -anchor "nw" -text [translate "Flow"] -font Helv_7_bold -fill $dark -width [rescale_x_skin 520]
	#add_de1_variable "off off_zoomed espresso espresso_zoomed espresso_3 espresso_3_zoomed off_zoomed_temperature espresso_zoomed_temperature espresso_3_zoomed_temperature" 2060 [expr {$pos_top + (6.5 * $spacer)}] -justify left -anchor "nw" -text "" -font Helv_7 -fill $lighter -width [rescale_x_skin 520] -textvariable {[watervolume_text] [translate "total"]} 
	add_de1_variable "espresso espresso_zoomed espresso_zoomed_temperature" 2060 [expr {$pos_top + (11.5 * $spacer)}] -justify left -anchor "nw" -text "" -font Helv_7 -fill $lighter -width [rescale_x_skin 520] -textvariable {[waterflow_text]} 
	add_de1_variable "espresso espresso_zoomed espresso_zoomed_temperature" 2060 [expr {$pos_top + (12.5 * $spacer)}] -justify left -anchor "nw" -text "" -font Helv_7 -fill $lighter -width [rescale_x_skin 520] -textvariable {[pressure_text]} 
#######################

#######################
# weight
add_de1_variable "off off_zoomed espresso_3 espresso_3_zoomed off_zoomed_temperature espresso_3_zoomed_temperature" 2510 [expr {$pos_top + (6 * $spacer)}] -justify right -anchor "ne" -font Helv_7_bold -fill $dark -width [rescale_x_skin 520] -textvariable {[waterweight_label_text]}
add_de1_variable "espresso espresso_zoomed espresso_zoomed_temperature" 2510 [expr {$pos_top + (10.5 * $spacer)}] -justify right -anchor "ne" -font Helv_7_bold -fill $dark -width [rescale_x_skin 520] -textvariable {[waterweight_label_text]}
	add_de1_variable "off off_zoomed espresso_3 espresso_3_zoomed off_zoomed_temperature espresso_3_zoomed_temperature" 2510 [expr {$pos_top + (7 * $spacer)}] -justify left -anchor "ne" -text "" -font Helv_7 -fill $lighter -width [rescale_x_skin 520] -textvariable {[finalwaterweight_text]} 
	add_de1_variable "espresso espresso_zoomed espresso_zoomed_temperature" 2510 [expr {$pos_top + (11.5 * $spacer)}] -justify left -anchor "ne" -text "" -font Helv_7 -fill $lighter -width [rescale_x_skin 520] -textvariable {[waterweight_text]} 
	add_de1_variable "espresso espresso_zoomed espresso_zoomed_temperature" 2510 [expr {$pos_top + (12.5 * $spacer)}] -justify left -anchor "ne" -text "" -font Helv_7 -fill $lighter -width [rescale_x_skin 520] -textvariable {[waterweightflow_text]} 

	if {$::settings(skale_bluetooth_address) != ""} {
		set ::de1(scale_weight_rate) -1
		add_de1_widget "off off_zoomed espresso_3 espresso_3_zoomed off_zoomed_temperature espresso_3_zoomed_temperature" ProgressBar 2400 [expr {$pos_top + (8.3 * $spacer)}] {} -width [rescale_y_skin 108] -height [rescale_x_skin 16] -type normal  -variable ::de1(scale_weight_rate) -fg #a2693d -bg #FFFFFF -maximum 6 -borderwidth 1 -relief flat
		add_de1_widget "espresso espresso_zoomed espresso_zoomed_temperature" ProgressBar 2400 [expr {$pos_top + (13.8 * $spacer)}] {} -width [rescale_y_skin 108] -height [rescale_x_skin 16] -type normal  -variable ::de1(scale_weight_rate) -fg #a2693d -bg #FFFFFF -maximum 6 -borderwidth 1 -relief flat
	}
#######################


# this feature is always on now
set ::settings(display_rate_espresso) 1
if {$::settings(display_rate_espresso) == 1} {
	add_de1_button "espresso_3 espresso_3_zoomed espresso_3_zoomed_temperature" {say [translate {describe}] $::settings(sound_button_in); unset -nocomplain ::settings_backup; array set ::settings_backup [array get ::settings]; set_next_page off describe_espresso; page_show off} 2020 1000 2560 1350
	source "[homedir]/skins/Insight/scentone.tcl"
}


##########################################################################################################################################################################################################################################################################


##########################################################################################################################################################################################################################################################################
# settings for preheating a cup

add_de1_variable "preheat_1" 1390 775 -text [translate "START"] -font Helv_20_bold -fill "#2d3046" -anchor "center" -textvariable {[start_text_if_espresso_ready]} 
add_de1_text "preheat_1 preheat_2 preheat_3" 1390 865 -text [translate "FLUSH"] -font Helv_10 -fill "#7f879a" -anchor "center" 
add_de1_variable "preheat_2" 1390 775 -text [translate "STOP"] -font Helv_20_bold -fill "#2d3046" -anchor "center"  -textvariable {[stop_text_if_espresso_stoppable]} 
add_de1_variable "preheat_3" 1390 775 -text [translate "RESTART"] -font Helv_20_bold -fill "#7f879a" -anchor "center" -textvariable {[restart_text_if_espresso_ready]} 

add_de1_button "preheat_1 preheat_3" {say [translate {pre-heat cup}] $::settings(sound_button_in); set ::settings(preheat_temperature) 90; set_next_page water preheat_2; start_water} 1030 210 2560 1400
add_de1_button "preheat_2" {say [translate {stop}] $::settings(sound_button_in); set_next_page off preheat_3; start_idle} 0 189 2560 1600
add_de1_button "preheat_3" {say "" $::settings(sound_button_in); set_next_page off preheat_1; start_idle} 0 210 1000 1400
add_de1_button "preheat_1" {say "" $::settings(sound_button_in);vertical_clicker 50 10 ::settings(preheat_volume) 10 250 %x %y %x0 %y0 %x1 %y1; save_settings; de1_send_steam_hotwater_settings} 100 510 900 1200 ""

add_de1_text "preheat_1" 70 250 -text [translate "1) How much water?"] -font Helv_9 -fill "#5a5d75" -anchor "nw" -width [rescale_x_skin 900]
add_de1_text "preheat_2 preheat_3" 70 250 -text [translate "1) How much water?"] -font Helv_9 -fill "#7f879a" -anchor "nw" -width [rescale_x_skin 900]
add_de1_text "preheat_1" 1070 250 -text [translate "2) The group head will pour hot water out"] -font Helv_9 -fill "#5a5d75" -anchor "nw" -width [rescale_x_skin 650]
add_de1_text "preheat_2" 1070 250 -text [translate "2) Hot water is pouring out"] -font Helv_9 -fill "#5a5d75" -anchor "nw" -width [rescale_x_skin 650]
add_de1_text "preheat_3 " 1070 250 -text [translate "2) The group head will pour hot water out"] -font Helv_9 -fill "#7f879a" -anchor "nw" -width [rescale_x_skin 650]

add_de1_text "preheat_1" 1840 250 -text [translate "3) Your group head is now clean"] -font Helv_9 -fill "#b1b9cd" -anchor "nw" -width [rescale_x_skin 680]
add_de1_text "preheat_3" 1840 250 -text [translate "3) Your group head is now clean"] -font Helv_9 -fill "#5a5d75" -anchor "nw" -width [rescale_x_skin 680]

add_de1_variable "preheat_1" 540 1250 -text "" -font Helv_10_bold -fill "#2d3046" -anchor "center" -textvariable {[return_liquid_measurement $::settings(preheat_volume)]}
add_de1_variable "preheat_2 preheat_3" 540 1250 -text "" -font Helv_10_bold -fill "#7f879a" -anchor "center" -textvariable {[return_liquid_measurement $::settings(preheat_volume)]}
add_de1_text "preheat_1 preheat_2 preheat_3" 540 1300  -text [translate "VOLUME"] -font Helv_7 -fill "#7f879a" -anchor "center" 

add_de1_text "preheat_2" 1880 1300 -justify right -anchor "nw" -text [translate "Total volume:"] -font Helv_8 -fill "#7f879a" -width [rescale_x_skin 520]
add_de1_variable "preheat_2" 2470 1300 -justify left -anchor "ne" -text "" -font Helv_8 -fill "#42465c" -width [rescale_x_skin 520] -textvariable {[watervolume_text]} 

add_de1_text "preheat_3" 1880 1300 -justify right -anchor "nw" -text [translate "Done:"] -font Helv_8 -fill "#7f879a" -width [rescale_x_skin 520]
add_de1_variable "preheat_3" 2460 1300 -justify left -anchor "ne" -font Helv_8 -text "" -fill "#42465c" -width [rescale_x_skin 520] -textvariable {[done_timer][translate "s"]} 
add_de1_text "preheat_3" 1880 1250 -justify right -anchor "nw" -text [translate "Total volume:"] -font Helv_8 -fill "#7f879a" -width [rescale_x_skin 520]
add_de1_variable "preheat_3" 2470 1250 -justify left -anchor "ne" -text "" -font Helv_8 -fill "#42465c" -width [rescale_x_skin 520] -textvariable {[watervolume_text]} 

##########################################################################################################################################################################################################################################################################

##########################################################################################################################################################################################################################################################################
# settings for dispensing hot water

# future feature
# add_de1_text "water_1 water_3" 1390 1270 -text [translate "Rinse"] -font Helv_10_bold -fill "#eae9e9" -anchor "center" 

add_de1_variable "water_1" 1390 775 -text [translate "START"] -font Helv_20_bold -fill "#2d3046" -anchor "center" -textvariable {[start_text_if_espresso_ready]} 
add_de1_variable "water_3" 1390 775 -text [translate "RESTART"] -font Helv_20_bold -fill "#7f879a" -anchor "center" -textvariable {[restart_text_if_espresso_ready]} 
add_de1_variable "water" 1390 775 -text [translate "STOP"] -font Helv_20_bold -fill "#2d3046" -anchor "center"  -textvariable {[stop_text_if_espresso_stoppable]} 

add_de1_text "water_1 water water_3" 1390 865 -text [translate "WATER"] -font Helv_10 -fill "#7f879a" -anchor "center" 
add_de1_button "water_1 water_3" {say [translate {hot water}] $::settings(sound_button_in); set_next_page water water; start_water} 1030 210 2560 1100
add_de1_button "water" {say [translate {stop}] $::settings(sound_button_in); set_next_page off water_3 ; start_idle} 0 189 2560 1600

# future feature
#add_de1_button "water_1 water_3" {say [translate {rinse}] $::settings(sound_button_in); set_next_page water water; start_water} 1030 1101 1760 1400

add_de1_button "water_1" {say "" $::settings(sound_button_in);vertical_clicker 50 10 ::settings(water_volume) 10 250 %x %y %x0 %y0 %x1 %y1; save_settings; de1_send_steam_hotwater_settings} 0 400 550 1200 ""
add_de1_button "water_1" {say "" $::settings(sound_button_in);vertical_clicker 10 1 ::settings(water_temperature) 20 100 %x %y %x0 %y0 %x1 %y1; save_settings; de1_send_steam_hotwater_settings} 551 400 1029 1200 ""

#add_de1_button "water_1" {say "" $::settings(sound_button_in);vertical_slider ::settings(water_volume) 1 400 %x %y %x0 %y0 %x1 %y1} 0 210 550 1400 "mousemove"
#add_de1_button "water_1" {say "" $::settings(sound_button_in);vertical_slider ::settings(water_temperature) 20 96 %x %y %x0 %y0 %x1 %y1} 551 210 1029 1400 "mousemove"

add_de1_text "water_1" 70 250 -text [translate "1) Settings"] -font Helv_10 -fill "#5a5d75" -anchor "nw" -width 900

add_de1_text "water_1" 1070 250 -text [translate "2) Hot water will pour"] -font Helv_9 -fill "#5a5d75" -anchor "nw" -width [rescale_x_skin 650]
add_de1_text "water" 1070 250 -text [translate "2) Hot water is pouring"] -font Helv_9 -fill "#5a5d75" -anchor "nw" -width [rescale_x_skin 650]
add_de1_text "water_3" 1840 250 -text [translate "3) Done"] -font Helv_9 -fill "#5a5d75" -anchor "nw" -width [rescale_x_skin 650]


add_de1_text "water water_3" 70 250 -text [translate "1) Settings"] -font Helv_9 -fill "#b1b9cd" -anchor "nw" -width [rescale_x_skin 900]
add_de1_text "water_3" 1070 250 -text [translate "2) Hot water will pour"] -font Helv_9 -fill "#b1b9cd" -anchor "nw" -width [rescale_x_skin 650]

add_de1_variable "water_1" 300 1250 -text "" -font Helv_10_bold -fill "#2d3046" -anchor "center"  -textvariable {[return_liquid_measurement $::settings(water_volume)]}
add_de1_text "water_1" 300 1300  -text [translate "VOLUME"] -font Helv_7 -fill "#7f879a" -anchor "center" 
add_de1_variable "water_1" 755 1250 -text "" -font Helv_10_bold -fill "#2d3046" -anchor "center" -textvariable {[return_temperature_measurement $::settings(water_temperature)]}
add_de1_text "water_1" 755 1300 -text [translate "TEMP"] -font Helv_7 -fill "#7f879a" -anchor "center" 

add_de1_variable "water water_3" 300 1250 -text "" -font Helv_10_bold -fill "#7f879a" -anchor "center"  -textvariable {[return_liquid_measurement $::settings(water_volume)]}
add_de1_text "water water_3" 300 1300  -text [translate "VOLUME"] -font Helv_7 -fill "#b1b9cd" -anchor "center" 
add_de1_variable "water water_3" 755 1250 -text "" -font Helv_10_bold -fill "#7f879a" -anchor "center" -textvariable {[return_temperature_measurement $::settings(water_temperature)]}
add_de1_text "water water_3" 755 1300 -text [translate "TEMP"] -font Helv_7 -fill "#b1b9cd" -anchor "center" 
add_de1_button "water_3" {say "" $::settings(sound_button_in); set_next_page off water_1; start_idle} 0 210 1000 1400

# data card
add_de1_text "water" 1870 1250 -justify right -anchor "nw" -text [translate "Time"] -font Helv_8_bold -fill "#5a5d75" -width [rescale_x_skin 520]
add_de1_text "water_3" 1870 1200 -justify right -anchor "nw" -text [translate "Time"] -font Helv_8_bold -fill "#5a5d75" -width [rescale_x_skin 520]
add_de1_text "water" 1870 1300 -justify right -anchor "nw" -text [translate "Pouring:"] -font Helv_8 -fill "#7f879a" -width [rescale_x_skin 520]
add_de1_variable "water" 2470 1300 -justify left -anchor "ne" -font Helv_8 -fill "#42465c" -width [rescale_x_skin 520] -text "" -textvariable {[water_timer][translate "s"]} 
add_de1_text "water_3" 1870 1250 -justify right -anchor "nw" -text [translate "Pouring:"] -font Helv_8 -fill "#7f879a" -width [rescale_x_skin 520]
add_de1_variable "water_3" 2470 1250 -justify left -anchor "ne" -font Helv_8 -fill "#42465c" -width [rescale_x_skin 520] -text "" -textvariable {[water_timer][translate "s"]} 
add_de1_text "water_3" 1870 1300 -justify right -anchor "nw" -text [translate "Done:"] -font Helv_8 -fill "#7f879a" -width [rescale_x_skin 520]
add_de1_variable "water_3" 2470 1300 -justify left -anchor "ne" -font Helv_8 -text "" -fill "#42465c" -width [rescale_x_skin 520] -textvariable {[done_timer][translate "s"]} 


add_de1_text "water " 1870 250 -justify right -anchor "nw" -text [translate "Information"] -font Helv_8_bold -fill "#5a5d75" -width [rescale_x_skin 520]
add_de1_text "water " 1870 300 -justify right -anchor "nw" -text [translate "Water temperature:"] -font Helv_8 -fill "#7f879a" -width [rescale_x_skin 520]
add_de1_variable "water" 2470 300 -justify left -anchor "ne" -font Helv_8 -fill "#42465c" -width [rescale_x_skin 520] -text "" -textvariable {[watertemp_text]} 
add_de1_text "water " 1870 350 -justify right -anchor "nw" -text [translate "Total volume:"] -font Helv_8 -fill "#7f879a" -width [rescale_x_skin 520]
add_de1_variable "water" 2470 350 -justify left -anchor "ne" -text "" -font Helv_8 -fill "#42465c" -width [rescale_x_skin 520] -textvariable {[watervolume_text]} 
add_de1_text "water " 1870 400 -justify right -anchor "nw" -text [translate "Flow rate:"] -font Helv_8 -fill "#7f879a" -width [rescale_x_skin 520]
add_de1_variable "water" 2470 400 -justify left -anchor "ne" -text "" -font Helv_8 -fill "#42465c" -width [rescale_x_skin 520] -textvariable {[waterflow_text]} 

add_de1_text "water_3" 1870 350 -justify right -anchor "nw" -text [translate "Information"] -font Helv_8_bold -fill "#5a5d75" -width [rescale_x_skin 520]
add_de1_text "water_3" 1870 400 -justify right -anchor "nw" -text [translate "Water temperature:"] -font Helv_8 -fill "#7f879a" -width [rescale_x_skin 520]
add_de1_variable "water_3" 2470 400 -justify left -anchor "ne" -font Helv_8 -fill "#42465c" -width [rescale_x_skin 520] -text "" -textvariable {[watertemp_text]} 
add_de1_text "water_3" 1870 450 -justify right -anchor "nw" -text [translate "Total volume:"] -font Helv_8 -fill "#7f879a" -width [rescale_x_skin 520]
add_de1_variable "water_3" 2470 450 -justify left -anchor "ne" -text "" -font Helv_8 -fill "#42465c" -width [rescale_x_skin 520] -textvariable {[watervolume_text]} 




##########################################################################################################################################################################################################################################################################



##########################################################################################################################################################################################################################################################################
# settings for steam

# future feature
#add_de1_text "steam_1 steam_3" 1390 1270 -text [translate "Rinse"] -font Helv_10_bold -fill "#eae9e9" -anchor "center" 

#add_de1_text "steam_3" 2180 1280 -text [translate "Rinse"] -font Helv_10_bold -fill "#eae9e9" -anchor "center" 

add_de1_variable "steam_1" 1390 775 -text [translate "START"] -font Helv_20_bold -fill "#2d3046" -anchor "center" -textvariable {[start_text_if_espresso_ready]} 
add_de1_variable "steam" 1390 775 -text [translate "STOP"] -font Helv_20_bold -fill "#2d3046" -anchor "center"  -textvariable {[stop_text_if_espresso_stoppable]} 
add_de1_variable "steam_3" 1390 775 -text [translate "RESTART"] -font Helv_20_bold -fill "#2d3046" -anchor "center" -textvariable {[restart_text_if_espresso_ready]} 

add_de1_text "steam_1 steam steam_3" 1390 865 -text [translate "STEAM"] -font Helv_10 -fill "#7f879a" -anchor "center" 

add_de1_button "steam_1 steam_3" {say [translate {steam}] $::settings(sound_button_in); start_steam} 1030 210 2560 1100

# future feature
#add_de1_button "steam_1" {say [translate {rinse}] $::settings(sound_button_in); start_steam} 1030 1101 1760 1400

add_de1_button "steam" {say [translate {stop}] $::settings(sound_button_in); set_next_page off steam_3; start_idle} 0 189 2560 1600
add_de1_button "steam_3" {say "" $::settings(sound_button_in); set_next_page off steam_1; start_idle} 0 210 1000 1400
add_de1_button "steam_1" {say "" $::settings(sound_button_in);vertical_clicker 10 1 ::settings(steam_timeout) 1 250 %x %y %x0 %y0 %x1 %y1; save_settings; de1_send_steam_hotwater_settings} 200 400 900 1200 ""


add_de1_text "steam_1" 70 250 -text [translate "1) Choose auto-off time"] -font Helv_9 -fill "#5a5d75" -anchor "nw" -width [rescale_x_skin 900]
add_de1_text "steam steam_3" 70 250 -text [translate "1) Choose auto-off time"] -font Helv_9 -fill "#b1b9cd" -anchor "nw" -width [rescale_x_skin 900]
add_de1_text "steam_1" 1070 250 -text [translate "2) Steam your milk"] -font Helv_9 -fill "#5a5d75" -anchor "nw" -width [rescale_x_skin 650]
add_de1_text "steam" 1070 250 -text [translate "2) Steaming your milk"] -font Helv_9 -fill "#5a5d75" -anchor "nw" -width [rescale_x_skin 650]
add_de1_text "steam_3" 1070 250 -text [translate "2) Steam your milk"] -font Helv_9 -fill "#b1b9cd" -anchor "nw" -width [rescale_x_skin 650]
add_de1_text "steam_3" 1840 250 -text [translate "3) Make amazing latte art"] -font Helv_9 -fill "#5a5d75" -anchor "nw" -width [rescale_x_skin 680]

add_de1_variable "steam_1" 537 1250 -text "" -font Helv_10_bold -fill "#2d3046" -anchor "center"  -textvariable {[round_to_integer $::settings(steam_timeout)][translate "s"]}
add_de1_variable "steam steam_3" 537 1250 -text "" -font Helv_10_bold -fill "#7f879a" -anchor "center"  -textvariable {[round_to_integer $::settings(steam_timeout)][translate "s"]}
add_de1_text "steam_1 steam steam_3" 537 1300 -text [translate "AUTO-OFF"] -font Helv_7 -fill "#7f879a" -anchor "center" 


add_de1_text "steam steam_3" 1870 1200 -justify right -anchor "nw" -text [translate "Time"] -font Helv_8_bold -fill "#5a5d75" -width [rescale_x_skin 520]
add_de1_text "steam steam_3" 1870 1250 -justify right -anchor "nw" -text [translate "Steaming:"] -font Helv_8 -fill "#7f879a" -width [rescale_x_skin 520]
add_de1_variable "steam steam_3" 2470 1250 -justify left -anchor "ne" -font Helv_8 -text "" -fill "#42465c" -width [rescale_x_skin 520] -textvariable {[steam_timer][translate "s"]} 
add_de1_text "steam_3" 1870 1300 -justify right -anchor "nw" -text [translate "Done:"] -font Helv_8 -fill "#7f879a" -width [rescale_x_skin 520]
add_de1_variable "steam_3" 2470 1300 -justify left -anchor "ne" -font Helv_8 -text "" -fill "#42465c" -width [rescale_x_skin 520] -textvariable {[done_timer][translate "s"]} 
add_de1_text "steam" 1870 1300 -justify right -anchor "nw" -text [translate "Auto-Off:"] -font Helv_8 -fill "#7f879a" -width [rescale_x_skin 520]
add_de1_variable "steam" 2470 1300 -justify left -anchor "ne" -font Helv_8 -text "" -fill "#42465c" -width [rescale_x_skin 520] -textvariable {[setting_steam_max_time][translate "s"]} 

add_de1_text "steam" 1870 250 -justify right -anchor "nw" -text [translate "Information"] -font Helv_8_bold -fill "#5a5d75" -width [rescale_x_skin 520]
add_de1_text "steam" 1870 300 -justify right -anchor "nw" -text [translate "Temperature:"] -font Helv_8 -fill "#7f879a" -width [rescale_x_skin 520]
add_de1_variable "steam" 2470 300 -justify left -anchor "ne" -font Helv_8 -text "" -fill "#42465c" -width [rescale_x_skin 520] -textvariable {[steamtemp_text]} 
add_de1_text "steam" 1870 350 -justify right -anchor "nw" -text [translate "Pressure (bar):"] -font Helv_8 -fill "#7f879a" -width [rescale_x_skin 520]
add_de1_variable "steam" 2470 350 -justify left -anchor "ne" -font Helv_8 -text "" -fill "#42465c" -width [rescale_x_skin 520] -textvariable {[pressure_text]} 
add_de1_text "steam" 1870 400 -justify right -anchor "nw" -text [translate "Flow rate:"] -font Helv_8 -fill "#7f879a" -width [rescale_x_skin 520]
add_de1_variable "steam" 2470 400 -justify left -anchor "ne" -text "" -font Helv_8 -fill "#42465c" -width [rescale_x_skin 520] -textvariable {[waterflow_text]} 
add_de1_text "steam" 1870 450 -justify right -anchor "nw" -text [translate "Total volume:"] -font Helv_8 -fill "#7f879a" -width [rescale_x_skin 520]
add_de1_variable "steam" 2470 450 -justify left -anchor "ne" -text "" -font Helv_8 -fill "#42465c" -width [rescale_x_skin 520] -textvariable {[watervolume_text]} 


#set_next_page off settings_2c;