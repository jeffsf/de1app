set ::skindebug 0

##############################################################################################################################################################################################################################################################################
# SETTINGS page

# tapping the logo exits the app
add_de1_button "off" "exit" 800 0 1750 500
add_de1_button "settings_1 settings_2 settings_3 settings_4 settings_1a" "say [translate {sleep}] $::settings(sound_button_in);start_sleep" 0 1424 350 1600

add_de1_text "settings_1" 1400 1318 -text [translate "Advanced settings"] -font Helv_10_bold -fill "#eae9e9" -anchor "center"
add_de1_text "settings_1a" 2270 286 -text [translate "Simple settings"] -font Helv_10_bold -fill "#eae9e9" -anchor "center"
add_de1_button "settings_1" {say [translate {advanced}] $::settings(sound_button_in); set_next_page off settings_1a; set_next_page settings_1 settings_1a; page_show settings_1a} 1100 1206 1700 1406
add_de1_button "settings_1a" {say [translate {simple}] $::settings(sound_button_in); set_next_page off settings_1; set_next_page settings_1 settings_1; page_show settings_1} 2000 210 2540 380


# 1st batch of settings
add_de1_widget "settings_1" checkbutton 40 780 {} -text [translate "Preinfusion"] -indicatoron true  -font Helv_15_bold -bg #FFFFFF -anchor nw -foreground #2d3046 -variable ::settings(preinfusion_enabled) -command update_de1_explanation_chart -borderwidth 0 -selectcolor #FFFFFF -highlightthickness 0 -activebackground #FFFFFF

add_de1_widget "settings_1" scale 560 820 {} -to 1 -from 10 -background #FFFFFF -borderwidth 1 -bigincrement 1 -resolution 0.1 -length 500 -width 150 -variable ::settings(espresso_pressure) -font Helv_15_bold -sliderlength 75 -relief flat -command update_de1_explanation_chart -foreground #4e85f4 -troughcolor #EEEEEE -borderwidth 0  -highlightthickness 0 
add_de1_text "settings_1" 680 1325 -text [translate "Hold pressure"] -font Helv_15_bold -fill "#2d3046" -anchor "nw" -width 600 -justify "left"

add_de1_widget "settings_1" scale 850 750 {} -from 0 -to 60 -background #FFFFFF -borderwidth 1 -bigincrement 1 -resolution 1 -length 800 -width 150 -variable ::settings(pressure_hold_time) -font Helv_10_bold -sliderlength 75 -relief flat -command update_de1_explanation_chart -orient horizontal -foreground #4e85f4 -troughcolor #EEEEEE -borderwidth 0  -highlightthickness 0 
add_de1_text "settings_1" 1250 980 -text [translate "Hold time"] -font Helv_15_bold -fill "#2d3046" -anchor "n" -width 380 -justify "center"

add_de1_widget "settings_1" scale 1700 750 {} -from 0 -to 60 -background #FFFFFF -borderwidth 1 -bigincrement 1 -resolution 1 -length 800 -width 150 -variable ::settings(espresso_decline_time) -font Helv_10_bold -sliderlength 75 -relief flat -command update_de1_explanation_chart -orient horizontal -foreground #4e85f4 -troughcolor #EEEEEE -borderwidth 0  -highlightthickness 0 
add_de1_text "settings_1" 2010 980 -text [translate "Decline time"] -font Helv_15_bold -fill "#2d3046" -anchor "n" -width 980 -justify "center"

add_de1_widget "settings_1" scale 2226 985 {} -to 0 -from 10 -background #FFFFFF -borderwidth 1 -bigincrement 1 -resolution 0.1 -length 330  -width 150 -variable ::settings(pressure_end) -font Helv_15_bold -sliderlength 75 -relief flat -command update_de1_explanation_chart -foreground #4e85f4 -troughcolor #EEEEEE -borderwidth 0  -highlightthickness 0 
add_de1_text "settings_1" 2495 1325 -text [translate "Final pressure"] -font Helv_15_bold -fill "#2d3046" -anchor "ne" -width 700 -justify "left"

add_de1_button "settings_1" {say [translate {temperature}] $::settings(sound_button_in);vertical_slider ::settings(espresso_temperature) 80 95 %x %y %x0 %y0 %x1 %y1} 0 860 450 1400 "mousemove"
add_de1_text "settings_1" 320 1090  -text [translate "TEMP"] -font Helv_8 -fill "#7f879a" -anchor "center" 
add_de1_variable "settings_1" 320 1170 -text "" -font Helv_10_bold -fill "#2d3046" -anchor "center" -textvariable {[return_temperature_measurement $::settings(espresso_temperature)]}

add_de1_widget "settings_1" graph 24 220 { 
	update_de1_explanation_chart;
	$widget element create line_espresso_de1_explanation_chart_pressure -xdata espresso_de1_explanation_chart_elapsed -ydata espresso_de1_explanation_chart_pressure -symbol circle -label "" -linewidth 10 -color #4e85f4  -smooth quadratic -pixels 15; 
	$widget axis configure x -color #5a5d75 -tickfont Helv_6 -command graph_seconds_axis_format; 
	$widget axis configure y -color #5a5d75 -tickfont Helv_6 -min 0.0 -max $::de1(max_pressure) -majorticks {0 1 2 3 4 5 6 7 8 9 10 11 12} -title [translate "pressure (bar)"] -titlefont Helv_10;

	bind $widget [platform_button_press] { 
		say [translate {refresh chart}] $::settings(sound_button_in); 
		update_de1_explanation_chart} 
	} -plotbackground #EEEEEE -width 2500 -height 500 -borderwidth 1 -background #FFFFFF -plotrelief raised


add_de1_widget "settings_4" checkbutton 90 400 {} -text [translate "Use Fahrenheit"] -indicatoron true  -font Helv_10 -bg #FFFFFF -anchor nw -foreground #2d3046 -variable ::settings(enable_fahrenheit)  -borderwidth 0 -selectcolor #FFFFFF -highlightthickness 0 -activebackground #FFFFFF
add_de1_widget "settings_4" checkbutton 90 500 {} -text [translate "Use fluid ounces"] -indicatoron true  -font Helv_10 -bg #FFFFFF -anchor nw -foreground #2d3046 -variable ::settings(enable_fluid_ounces)  -borderwidth 0 -selectcolor #FFFFFF -highlightthickness 0 -activebackground #FFFFFF
add_de1_widget "settings_4" checkbutton 90 600 {} -text [translate "Enable flight mode"] -indicatoron true  -font Helv_10 -bg #FFFFFF -anchor nw -foreground #2d3046 -variable ::settings(flight_mode_enable)  -borderwidth 0 -selectcolor #FFFFFF -highlightthickness 0 -activebackground #FFFFFF

add_de1_widget "settings_4" scale 90 700 {} -from 1 -to 90 -background #FFFFFF -borderwidth 1 -bigincrement 1 -resolution 1 -length 1100 -width 135 -variable ::settings(flight_mode_angle) -font Helv_10_bold -sliderlength 75 -relief flat -orient horizontal -foreground #4e85f4 -troughcolor #EEEEEE -borderwidth 0  -highlightthickness 0 
add_de1_text "settings_4" 90 905 -text [translate "Flight mode: start angle"] -font Helv_9 -fill "#2d3046" -anchor "nw" -width 800 -justify "left"

add_de1_text "settings_4" 90 905 -text [translate "Flight mode: start angle"] -font Helv_9 -fill "#2d3046" -anchor "nw" -width 800 -justify "left"
add_de1_text "settings_4" 310 1306 -text [translate "Clean: steam"] -font Helv_10_bold -fill "#eae9e9" -anchor "center"
add_de1_text "settings_4" 995 1306 -text [translate "Clean: espresso"] -font Helv_10_bold -fill "#eae9e9" -anchor "center"

# future clean steam feature
add_de1_button "settings_4" {} 30 1206 590 1406
# future clean espresso feature
add_de1_button "settings_4" {} 700 1206 1260 1406


add_de1_text "settings_4" 90 250 -text [translate "Other settings"] -font Helv_10_bold -fill "#7f879a" -justify "left" -anchor "nw"

add_de1_widget "settings_4" entry 1340 380 {} -width 60 -font Helv_15_bold -bg #FFFFFF  -foreground #2d3046 -textvariable ::settings(machine_name) 
add_de1_text "settings_4" 1350 470 -text [translate "Name your machine"] -font Helv_9 -fill "#2d3046" -anchor "nw" -width 800 -justify "left"

add_de1_text "settings_4" 1350 250 -text [translate "Information"] -font Helv_10_bold -fill "#7f879a" -justify "left" -anchor "nw"
add_de1_text "settings_4" 1350 600 -text [translate "Version: 1.0 beta 4"] -font Helv_9 -fill "#2d3046" -anchor "nw" -width 800 -justify "left"
add_de1_text "settings_4" 1350 660 -text [translate "Serial number: 0000001"] -font Helv_9 -fill "#2d3046" -anchor "nw" -width 800 -justify "left"

add_de1_button "settings_4" {say [translate {awake time}] $::settings(sound_button_in);vertical_slider ::settings(alarm_wake) 0 86400 %x %y %x0 %y0 %x1 %y1} 1330 800 1925 1260 "mousemove"
add_de1_text "settings_4" 1700 1220 -text [translate "Awake"] -font Helv_9 -fill "#2d3046" -anchor "center" -width 800 -justify "center"
add_de1_variable "settings_4" 1700 1300 -text "" -font Helv_10_bold -fill "#2d3046" -anchor "center" -textvariable {[format_alarm_time $::settings(alarm_wake)]}

add_de1_button "settings_4" {say [translate {sleep time}] $::settings(sound_button_in);vertical_slider ::settings(alarm_sleep) 0 86400 %x %y %x0 %y0 %x1 %y1} 1925 800 2500 1260 "mousemove"
add_de1_text "settings_4" 2150 1220 -text [translate "Asleep"] -font Helv_9 -fill "#2d3046" -anchor "center" -width 800 -justify "center"
add_de1_variable "settings_4" 2150 1300 -text "" -font Helv_10_bold -fill "#2d3046" -anchor "center" -textvariable {[format_alarm_time $::settings(alarm_sleep)]}

add_de1_text "settings_3" 90 250 -text [translate "Screen settings"] -font Helv_10_bold -fill "#7f879a" -justify "left" -anchor "nw"
add_de1_text "settings_3" 1350 250 -text [translate "Speaking"] -font Helv_10_bold -fill "#7f879a" -justify "left" -anchor "nw"

add_de1_widget "settings_3" scale 90 310 {} -from 0 -to 100 -background #FFFFFF -borderwidth 1 -bigincrement 1 -resolution 1 -length 1100 -width 135 -variable ::settings(app_brightness) -font Helv_10_bold -sliderlength 75 -relief flat -orient horizontal -foreground #4e85f4 -troughcolor #EEEEEE -borderwidth 0  -highlightthickness 0 
add_de1_text "settings_3" 90 525 -text [translate "App brightness"] -font Helv_8 -fill "#2d3046" -anchor "nw" -width 800 -justify "left"

add_de1_widget "settings_3" scale 90 580 {} -from 0 -to 100 -background #FFFFFF -borderwidth 1 -bigincrement 1 -resolution 1 -length 1100 -width 135 -variable ::settings(saver_brightness) -font Helv_10_bold -sliderlength 75 -relief flat -orient horizontal -foreground #4e85f4 -troughcolor #EEEEEE -borderwidth 0  -highlightthickness 0 
add_de1_text "settings_3" 90 785 -text [translate "Screen saver brightness"] -font Helv_8 -fill "#2d3046" -anchor "nw" -width 800 -justify "left"

add_de1_widget "settings_3" scale 90 840 {} -from 0 -to 120 -background #FFFFFF -borderwidth 1 -bigincrement 1 -resolution 1 -length 1100 -width 135 -variable ::settings(screen_saver_delay) -font Helv_10_bold -sliderlength 75 -relief flat -orient horizontal -foreground #4e85f4 -troughcolor #EEEEEE -borderwidth 0  -highlightthickness 0 
add_de1_text "settings_3" 90 1045 -text [translate "Screen saver delay"] -font Helv_8 -fill "#2d3046" -anchor "nw" -width 800 -justify "left"

add_de1_widget "settings_3" scale 90 1100 {} -from 1 -to 120 -background #FFFFFF -borderwidth 1 -bigincrement 1 -resolution 1 -length 1100 -width 135 -variable ::settings(screen_saver_change_interval) -font Helv_10_bold -sliderlength 75 -relief flat -orient horizontal -foreground #4e85f4 -troughcolor #EEEEEE -borderwidth 0  -highlightthickness 0 
add_de1_text "settings_3" 90 1305 -text [translate "Screen saver change interval"] -font Helv_8 -fill "#2d3046" -anchor "nw" -width 800 -justify "left"

add_de1_widget "settings_3" checkbutton 1350 400 {} -text [translate "Enable spoken prompts"] -indicatoron true  -font Helv_10 -bg #FFFFFF -anchor nw -foreground #2d3046 -variable ::settings(enable_spoken_prompts)  -borderwidth 0 -selectcolor #FFFFFF -highlightthickness 0 -activebackground #FFFFFF

add_de1_widget "settings_3" scale 1350 580 {} -from 0 -to 4 -background #FFFFFF -borderwidth 1 -bigincrement .1 -resolution .1 -length 1100 -width 135 -variable ::settings(speaking_rate) -font Helv_10_bold -sliderlength 75 -relief flat -orient horizontal -foreground #4e85f4 -troughcolor #EEEEEE -borderwidth 0  -highlightthickness 0 
add_de1_text "settings_3" 1350 785 -text [translate "Speaking speed"] -font Helv_8 -fill "#2d3046" -anchor "nw" -width 800 -justify "left"

add_de1_widget "settings_3" scale 1350 840 {} -from 0 -to 3 -background #FFFFFF -borderwidth 1 -bigincrement .1 -resolution .1 -length 1100 -width 135 -variable ::settings(speaking_pitch) -font Helv_10_bold -sliderlength 75 -relief flat -orient horizontal -foreground #4e85f4 -troughcolor #EEEEEE -borderwidth 0  -highlightthickness 0 
add_de1_text "settings_3" 1350 1045 -text [translate "Speaking pitch"] -font Helv_8 -fill "#2d3046" -anchor "nw" -width 800 -justify "left"

add_de1_button "off" {after 300 update_de1_explanation_chart;unset -nocomplain ::settings_backup; array set ::settings_backup [array get ::settings]; set_next_page off settings_1; page_show settings_1} 2000 0 2560 500
add_de1_text "settings_1 settings_2 settings_3 settings_4 settings_1a" 2275 1520 -text [translate "Save"] -font Helv_10_bold -fill "#eae9e9" -anchor "center"
add_de1_text "settings_1 settings_2 settings_3 settings_4 settings_1a" 1760 1520 -text [translate "Cancel"] -font Helv_10_bold -fill "#eae9e9" -anchor "center"

# labels for PREHEAT tab on
add_de1_text "settings_1 settings_1a" 330 100 -text [translate "ESPRESSO"] -font Helv_10_bold -fill "#2d3046" -anchor "center" 
add_de1_text "settings_1 settings_1a" 960 100 -text [translate "WATER/STEAM"] -font Helv_10_bold -fill "#5a5d75" -anchor "center" 
add_de1_text "settings_1 settings_1a" 1590 100 -text [translate "SCREEN/SOUNDS"] -font Helv_10_bold -fill "#5a5d75" -anchor "center" 
add_de1_text "settings_1 settings_1a" 2215 100 -text [translate "OTHER/INFO"] -font Helv_10_bold -fill "#5a5d75" -anchor "center" 

########################################
# labels for WATER/STEAM tab on
add_de1_text "settings_2" 330 100 -text [translate "ESPRESSO"] -font Helv_10_bold -fill "#5a5d75" -anchor "center" 
add_de1_text "settings_2" 960 100 -text [translate "WATER/STEAM"] -font Helv_10_bold -fill "#2d3046" -anchor "center" 
add_de1_text "settings_2" 1590 100 -text [translate "SCREEN/SOUNDS"] -font Helv_10_bold -fill "#5a5d75" -anchor "center" 
add_de1_text "settings_2" 2215 100 -text [translate "OTHER/INFO"] -font Helv_10_bold -fill "#5a5d75" -anchor "center" 

add_de1_button "settings_2" {say [translate {water temperature}] $::settings(sound_button_in);vertical_slider ::settings(water_temperature) $::de1(water_min_temperature) $::de1(water_max_temperature) %x %y %x0 %y0 %x1 %y1} 50 680 570 1260 "mousemove"
add_de1_variable "settings_2" 380 1320 -text "" -font Helv_10_bold -fill "#2d3046" -anchor "center" -textvariable {[return_temperature_measurement $::settings(water_temperature)]}

add_de1_button "settings_2" {say [translate {water time}] $::settings(sound_button_in);vertical_slider ::settings(water_max_time) $::de1(water_time_min) $::de1(water_time_max) %x %y %x0 %y0 %x1 %y1} 571 500 1250 1260 "mousemove"
add_de1_variable "settings_2" 900 1320 -text "" -font Helv_10_bold -fill "#2d3046" -anchor "center" -textvariable {[round_to_integer $::settings(water_max_time)] [translate "seconds"]}

add_de1_button "settings_2" {say [translate {steam temperature}] $::settings(sound_button_in);vertical_slider ::settings(steam_temperature) $::de1(steam_min_temperature) $::de1(steam_max_temperature) %x %y %x0 %y0 %x1 %y1} 1330 680 1850 1260 "mousemove"
add_de1_variable "settings_2" 1640 1320 -text "" -font Helv_10_bold -fill "#2d3046" -anchor "center" -textvariable {[return_temperature_measurement $::settings(steam_temperature)]}

add_de1_button "settings_2" {say [translate {steam time}] $::settings(sound_button_in);vertical_slider ::settings(steam_max_time) $::de1(steam_time_min) $::de1(steam_time_max) %x %y %x0 %y0 %x1 %y1} 1851 500 2500 1260 "mousemove"
add_de1_variable "settings_2" 2170 1320 -text "" -font Helv_10_bold -fill "#2d3046" -anchor "center" -textvariable {[round_to_integer $::settings(steam_max_time)] [translate "seconds"]}

add_de1_text "settings_2" 230 280 -text [translate "Hot water"] -font Helv_15_bold -fill "#7f879a" -justify "left" -anchor "nw"
add_de1_text "settings_2" 1510 280 -text [translate "Steam"] -font Helv_15_bold -fill "#7f879a" -justify "left" -anchor "nw"



# labels for STEAM tab on
add_de1_text "settings_3" 330 100 -text [translate "ESPRESSO"] -font Helv_10_bold -fill "#5a5d75" -anchor "center" 
add_de1_text "settings_3" 960 100 -text [translate "WATER/STEAM"] -font Helv_10_bold -fill "#5a5d75" -anchor "center" 
add_de1_text "settings_3" 1590 100 -text [translate "SCREEN/SOUNDS"] -font Helv_10_bold -fill "#2d3046" -anchor "center" 
add_de1_text "settings_3" 2215 100 -text [translate "OTHER/INFO"] -font Helv_10_bold -fill "#5a5d75" -anchor "center" 

# labels for HOT WATER tab on
add_de1_text "settings_4" 330 100 -text [translate "ESPRESSO"] -font Helv_10_bold -fill "#5a5d75" -anchor "center" 
add_de1_text "settings_4" 960 100 -text [translate "WATER/STEAM"] -font Helv_10_bold -fill "#5a5d75" -anchor "center" 
add_de1_text "settings_4" 1590 100 -text [translate "SCREEN/SOUNDS"] -font Helv_10_bold -fill "#5a5d75" -anchor "center" 
add_de1_text "settings_4" 2215 100 -text [translate "OTHER/INFO"] -font Helv_10_bold -fill "#2d3046" -anchor "center" 

# buttons for moving between tabs, available at all times that the espresso machine is not doing something hot
add_de1_button "settings_1 settings_2 settings_3 settings_4 settings_1a" {after 300 update_de1_explanation_chart; say [translate {settings}] $::settings(sound_button_in); set_next_page off settings_1; page_show settings_1} 0 0 641 188
add_de1_button "settings_1 settings_2 settings_3 settings_4 settings_1a" {say [translate {settings}] $::settings(sound_button_in); set_next_page off settings_2; page_show settings_2} 642 0 1277 188
add_de1_button "settings_1 settings_2 settings_3 settings_4 settings_1a" {say [translate {settings}] $::settings(sound_button_in); set_next_page off settings_3; page_show settings_3} 1278 0 1904 188
add_de1_button "settings_1 settings_2 settings_3 settings_4 settings_1a" {say [translate {settings}] $::settings(sound_button_in); set_next_page off settings_4; page_show settings_4} 1905 0 2560 188

add_de1_button "settings_1 settings_2 settings_3 settings_4 settings_1a" {say [translate {save}] $::settings(sound_button_in); save_settings; set_next_page off off; page_show off} 2016 1430 2560 1600
add_de1_button "settings_1 settings_2 settings_3 settings_4 settings_1a" {unset -nocomplain ::settings; array set ::settings [array get ::settings_backup]; say [translate {cancel}] $::settings(sound_button_in); set_next_page off off; page_show off} 1505 1430 2015 1600


##################

# advanced espresso settings

# text on the first espresso page
add_de1_text "settings_1a" 65 240 -text [translate "1) Preinfuse the coffee puck with hot water"] -font Helv_9 -fill "#5a5d75" -justify "left" -anchor "nw"
add_de1_text "settings_1a" 65 870 -text [translate "2) Make espresso"] -font Helv_9 -fill "#5a5d75" -justify "left" -anchor "nw"
add_de1_text "settings_1a" 80 330 -text [translate "PREINFUSE AT:"] -font Helv_7_bold -fill "#7f879a" -justify "left" -anchor "nw"
add_de1_text "settings_1a" 735 330 -text [translate "STOP PREINFUSION WHEN..."] -font Helv_7_bold -fill "#7f879a" -justify "left" -anchor "nw"

add_de1_variable "settings_1a" 232 757 -text "" -font Helv_9_bold -fill "#2d3046" -anchor "center" -textvariable {[return_flow_measurement $::settings(preinfusion_flow_rate)]}
add_de1_variable "settings_1a" 490 490 -text "" -font Helv_9_bold -fill "#2d3046" -anchor "center" -textvariable {[return_temperature_measurement $::settings(preinfusion_temperature)]}
add_de1_variable "settings_1a" 835 757 -text "" -font Helv_9_bold -fill "#2d3046" -anchor "center" -textvariable {[setting_espresso_stop_flow_text]}
add_de1_variable "settings_1a" 1132 757 -text "" -font Helv_9_bold -fill "#2d3046" -anchor "center" -textvariable {[setting_espresso_stop_pressure_text]}

add_de1_variable "settings_1a" 1423 757 -text "" -font Helv_9_bold -fill "#2d3046" -anchor "center" -textvariable {[return_liquid_measurement $::settings(preinfusion_stop_volumetric)]}
add_de1_variable "settings_1a" 1717 757 -text "" -font Helv_9_bold -fill "#2d3046" -anchor "center" -textvariable {[round_to_one_digits $::settings(preinfusion_stop_timeout)][translate "s"]}


add_de1_text "settings_1a" 232 703  -text [translate "FLOW RATE"] -font Helv_7 -fill "#7f879a" -anchor "center" 
add_de1_text "settings_1a" 490 432 -text [translate "TEMP"] -font Helv_7 -fill "#7f879a" -anchor "center" 

add_de1_text "settings_1a" 835 670 -text [translate "FLOW RATE SLOWS TO"] -font Helv_7 -fill "#7f879a" -anchor "center"  -width 250 -justify center
add_de1_text "settings_1a" 980 722 -text [translate "OR"] -font Helv_7 -fill "#7f879a" -anchor "center"

add_de1_text "settings_1a" 1132 670 -text [translate "PRESSURE GOES OVER"] -font Helv_7 -fill "#7f879a" -anchor "center"  -width 250 -justify center
add_de1_text "settings_1a" 1280 722 -text [translate "OR"] -font Helv_7 -fill "#7f879a" -anchor "center"

add_de1_text "settings_1a" 1423 670 -text [translate "WATER REACHES"] -font Helv_7 -fill "#7f879a" -anchor "center"  -width 250 -justify center
add_de1_text "settings_1a" 1570 722 -text [translate "OR"] -font Helv_7 -fill "#7f879a" -anchor "center"

add_de1_text "settings_1a" 1717 670 -text [translate "TIME-OUT"] -font Helv_7 -fill "#7f879a" -anchor "center"  -width 250 -justify center

# the espresso recipe steps
add_de1_text "settings_1a" 76 957 -text [espresso_frame_title 1] -font Helv_6_bold -fill "#2d3046" -anchor "nw" -justify "left" -width 760
add_de1_text "settings_1a" 76 997 -text [espresso_frame_description 1] -font Helv_6 -fill "#7f879a" -anchor "nw"  -width 760 -justify left

add_de1_text "settings_1a" 76 1174 -text [espresso_frame_title 2] -font Helv_6_bold -fill "#2d3046" -anchor "nw" -justify "left" -width 760
add_de1_text "settings_1a" 76 1214 -text [espresso_frame_description 2] -font Helv_6 -fill "#7f879a" -anchor "nw"  -width 760 -justify left

add_de1_text "settings_1a" 893 957 -text [espresso_frame_title 3] -font Helv_6_bold -fill "#2d3046" -anchor "nw" -justify "left" -width 760
add_de1_text "settings_1a" 893 997 -text [espresso_frame_description 3] -font Helv_6 -fill "#7f879a" -anchor "nw"  -width 760 -justify left

add_de1_text "settings_1a" 893 1174 -text [espresso_frame_title 4] -font Helv_6_bold -fill "#2d3046" -anchor "nw" -justify "left" -width 760
add_de1_text "settings_1a" 893 1214 -text [espresso_frame_description 4] -font Helv_6 -fill "#7f879a" -anchor "nw"  -width 760 -justify left

add_de1_text "settings_1a" 1710 957 -text [espresso_frame_title 5] -font Helv_6_bold -fill "#2d3046" -anchor "nw" -justify "left" -width 760
add_de1_text "settings_1a" 1710 997 -text [espresso_frame_description 5] -font Helv_6 -fill "#7f879a" -anchor "nw"  -width 760 -justify left

add_de1_text "settings_1a" 1710 1174 -text [espresso_frame_title 6] -font Helv_6_bold -fill "#2d3046" -anchor "nw" -justify "left" -width 760
add_de1_text "settings_1a" 1710 1214 -text [espresso_frame_description 6] -font Helv_6 -fill "#7f879a" -anchor "nw"  -width 760 -justify left

# make and stop espresso button
#add_de1_button "settings_1a" {say [translate {esspresso}] $::settings(sound_button_in);set_next_page off espresso_3; start_espresso} 1900 200 2560 690
#add_de1_button "settings_1a" {say [translate {rinse}] $::settings(sound_button_in);set_next_page off espresso_3; start_espresso} 1900 691 2560 855
add_de1_button "settings_1a" {say [translate {flow rate}] $::settings(sound_button_in);vertical_slider ::settings(preinfusion_flow_rate) 0.1 6 %x %y %x0 %y0 %x1 %y1} 0 320 400 830 "mousemove"
add_de1_button "settings_1a" {say [translate {temperature}] $::settings(sound_button_in);vertical_slider ::settings(preinfusion_temperature) 80 96 %x %y %x0 %y0 %x1 %y1} 401 320 700 830 "mousemove"
add_de1_button "settings_1a" {say [translate {stop at flow rate}] $::settings(sound_button_in); set ::settings(preinfusion_stop_pressure) {0}; vertical_slider ::settings(preinfusion_stop_flow_rate) 0.1 6 %x %y %x0 %y0 %x1 %y1} 701 320 980 830 "mousemove"
add_de1_button "settings_1a" {say [translate {stop at pressure}] $::settings(sound_button_in); set ::settings(preinfusion_stop_flow_rate) {0}; vertical_slider ::settings(preinfusion_stop_pressure) 0 6 %x %y %x0 %y0 %x1 %y1} 981 320 1280 830 "mousemove"
add_de1_button "settings_1a" {say [translate {stop when water reaches}] $::settings(sound_button_in);vertical_slider ::settings(preinfusion_stop_volumetric) 0.1 50 %x %y %x0 %y0 %x1 %y1} 1281 320 1570 830 "mousemove"
add_de1_button "settings_1a" {say [translate {preinfusion time-out}] $::settings(sound_button_in);vertical_slider ::settings(preinfusion_stop_timeout) 0 120 %x %y %x0 %y0 %x1 %y1} 1571 320 1870 830 "mousemove"



# END OF SETTINGS page
##############################################################################################################################################################################################################################################################################


##############################################################################################################################################################################################################################################################################
# the STEAM button and translatable text for it

	add_de1_text "steam" 1790 640 -text [translate "STEAM"] -font Helv_15_bold -fill "#2d3046" -anchor "nw" 
	add_de1_variable "steam" 1790 700 -text "" -font Helv_9_bold -fill "#7f879a" -anchor "nw" -textvariable {[translate [de1_substate_text]]} 

	# variables to display during steam
	add_de1_text "steam" 1790 780 -justify right -anchor "nw" -text [translate "Time"] -font Helv_8_bold -fill "#5a5d75" -width 520

	add_de1_text "steam" 1790 830 -justify right -anchor "nw" -text [translate "Elapsed:"] -font Helv_8 -fill "#7f879a" -width 520
	add_de1_variable "steam" 2310 830 -justify left -anchor "ne" -font Helv_8 -text "" -fill "#42465c" -width 520 -textvariable {[steam_timer][translate "s"]} 
	add_de1_text "steam" 1790 880 -justify right -anchor "nw" -text [translate "Auto-Off:"] -font Helv_8 -fill "#7f879a" -width 520
	add_de1_variable "steam" 2310 880 -justify left -anchor "ne" -font Helv_8 -text "" -fill "#42465c" -width 520 -textvariable {[setting_steam_max_time][translate "s"]} 

	add_de1_text "steam" 1790 970 -justify right -anchor "nw" -text [translate "Characteristics"] -font Helv_8_bold -fill "#5a5d75" -width 520
	add_de1_text "steam" 1790 1020 -justify right -anchor "nw" -text [translate "Temp:"] -font Helv_8 -fill "#7f879a" -width 520
	add_de1_variable "steam" 2310 1020 -justify left -anchor "ne" -font Helv_8 -text "" -fill "#42465c" -width 520 -textvariable {[steamtemp_text]} 
	add_de1_text "steam" 1790 1070 -justify right -anchor "nw" -text [translate "Pressure:"] -font Helv_8 -fill "#7f879a" -width 520
	add_de1_variable "steam" 2310 1070 -justify left -anchor "ne" -font Helv_8 -text "" -fill "#42465c" -width 520 -textvariable {[pressure_text]} 

	add_de1_text "steam" 1790 1120 -justify right -anchor "nw" -text [translate "Flow rate:"] -font Helv_8 -fill "#7f879a" -width 520
	add_de1_variable "steam" 2310 1120 -justify left -anchor "ne" -text "" -font Helv_8 -fill "#42465c" -width 520 -textvariable {[waterflow_text]} 
	add_de1_text "steam" 1790 1170 -justify right -anchor "nw" -text [translate "Volume:"] -font Helv_8 -fill "#7f879a" -width 520
	add_de1_variable "steam" 2310 1170 -justify left -anchor "ne" -text "" -font Helv_8 -fill "#42465c" -width 520 -textvariable {[watervolume_text]} 

# when it steam mode, tapping anywhere on the screen tells the DE1 to stop.
add_de1_button "steam" "say [translate {stop}] $::settings(sound_button_in);start_idle" 0 0 2560 1600

# STEAM related info to display when the espresso machine is idle
add_de1_text "off" 2048 1076 -text [translate "STEAM"] -font Helv_10_bold -fill "#2d3046" -anchor "center" 
add_de1_text "off" 2053 1156 -justify right -anchor "ne" -text [translate "Auto-Off:"] -font Helv_8 -fill "#7f879a" -width 520
add_de1_variable "off" 2058 1156 -justify left -anchor "nw" -font Helv_8 -text "" -fill "#42465c" -width 520 -textvariable {[setting_steam_max_time_text]} 
add_de1_text "off" 2053 1206 -justify right -anchor "ne" -text [translate "Temp:"] -font Helv_8 -fill "#7f879a" -width 520
add_de1_variable "off" 2058 1206 -justify left -anchor "nw" -font Helv_8 -text "" -fill "#42465c" -width 520 -textvariable {[setting_steam_temperature_text]} 
add_de1_variable "off" 2053 1256 -justify right -anchor "ne" -text "" -font Helv_8 -fill "#7f879a" -width 520 -textvariable {[steam_heater_action_text]} 
add_de1_variable "off" 2058 1256 -justify left -anchor "nw" -font Helv_8 -text "" -fill "#42465c" -width 520 -textvariable {[steam_heater_temperature_text]} 

# when someone taps on the steam button
add_de1_button "off" "say [translate {steam}] $::settings(sound_button_in);start_steam" 1748 616 2346 1414

##############################################################################################################################################################################################################################################################################
# the ESPRESSO button and translatable text for it

	add_de1_text "espresso" 980 620 -text [translate "ESPRESSO"] -font Helv_15_bold -fill "#2d3046" -anchor "nw" 
	add_de1_variable "espresso" 980 680 -text "" -font Helv_9_bold -fill "#7f879a" -anchor "nw" -textvariable {[translate [de1_substate_text]]} 

	add_de1_text "espresso" 980 785 -justify right -anchor "nw" -text [translate "Time"] -font Helv_8_bold -fill "#5a5d75" -width 520

	add_de1_text "espresso" 980 840 -justify right -anchor "nw" -text [translate "Elapsed:"] -font Helv_8 -fill "#7f879a" -width 520
	add_de1_variable "espresso" 1570 840 -justify left -anchor "ne" -text "" -font Helv_8 -fill "#42465c" -width 520 -textvariable {[timer][translate "s"]} 

	add_de1_text "espresso" 980 890 -justify right -anchor "nw" -text [translate "Auto off:"] -font Helv_8 -fill "#7f879a" -width 520
	add_de1_variable "espresso" 1570 890 -justify left -anchor "ne" -text "" -font Helv_8  -fill "#42465c" -width 520 -textvariable {[setting_espresso_max_time][translate "s"]} 

	add_de1_text "espresso" 980 940 -justify right -anchor "nw" -text [translate "Preinfusion:"] -font Helv_8 -fill "#7f879a" -width 520
	add_de1_variable "espresso" 1570 940 -justify left -anchor "ne" -text "" -font Helv_8  -fill "#42465c" -width 520 -textvariable {[preinfusion_timer][translate "s"]} 

	add_de1_text "espresso" 980 990 -justify right -anchor "nw" -text [translate "Pouring:"] -font Helv_8 -fill "#7f879a" -width 520
	add_de1_variable "espresso" 1570 990 -justify left -anchor "ne" -text "" -font Helv_8  -fill "#42465c" -width 520 -textvariable {[pour_timer][translate "s"]} 


	add_de1_text "espresso" 980 1070 -justify right -anchor "nw" -text [translate "Characteristics"] -font Helv_8_bold -fill "#5a5d75" -width 520

	add_de1_text "espresso" 980 1120 -justify right -anchor "nw" -text [translate "Pressure:"] -font Helv_8 -fill "#7f879a" -width 520
	add_de1_variable "espresso" 1570 1120 -justify left -anchor "ne" -text "" -font Helv_8 -fill "#42465c" -width 520 -textvariable {[pressure_text]} 
	add_de1_text "espresso" 980 1170 -justify right -anchor "nw" -text [translate "Basket temp:"] -font Helv_8 -fill "#7f879a" -width 520
	add_de1_variable "espresso" 1570 1170 -justify left -anchor "ne" -text "" -font Helv_8 -fill "#42465c" -width 520 -textvariable {[watertemp_text]} 
	add_de1_text "espresso" 980 1220 -justify right -anchor "nw" -text [translate "Mix temp:"] -font Helv_8 -fill "#7f879a" -width 520
	add_de1_variable "espresso" 1570 1220 -justify left -anchor "ne" -text "" -font Helv_8 -fill "#42465c" -width 520 -textvariable {[mixtemp_text]} 


	add_de1_text "espresso" 980 1270 -justify right -anchor "nw" -text [translate "Flow rate:"] -font Helv_8 -fill "#7f879a" -width 520
	add_de1_variable "espresso" 1570 1270 -justify left -anchor "ne" -text "" -font Helv_8 -fill "#42465c" -width 520 -textvariable {[waterflow_text]} 
	add_de1_text "espresso" 980 1320 -justify right -anchor "nw" -text [translate "Volume:"] -font Helv_8 -fill "#7f879a" -width 520
	add_de1_variable "espresso" 1570 1320 -justify left -anchor "ne" -text "" -font Helv_8 -fill "#42465c" -width 520 -textvariable {[watervolume_text]} 

	if {$::settings(flight_mode_enable) == 1} {
		add_de1_text "espresso" 980 1370 -justify right -anchor "nw" -text [translate "Flight mode:"] -font Helv_8 -fill "#7f879a" -width 520
		add_de1_variable "espresso" 1570 1370 -justify left -anchor "ne" -text "" -font Helv_8 -fill "#42465c" -width 520 -textvariable {[accelerometer_angle]º} 
	}

add_de1_button "espresso" "say [translate {stop}] $::settings(sound_button_in);start_idle" 0 0 2560 1600

add_de1_text "off" 1280 1076 -text [translate "ESPRESSO"] -font Helv_10_bold -fill "#2d3046" -anchor "center" 
add_de1_text "off" 1275 1156 -justify right -anchor "ne" -text [translate "Auto off:"] -font Helv_8 -fill "#7f879a" -width 520
add_de1_variable "off" 1280 1156 -justify left -anchor "nw" -text "" -font Helv_8  -fill "#42465c" -width 520 -textvariable {[setting_espresso_max_time_text]} 

add_de1_text "off" 1275 1206 -justify right -anchor "ne" -text [translate "Peak pressure:"] -font Helv_8 -fill "#7f879a" -width 520
add_de1_variable "off" 1280 1206 -justify left -anchor "nw" -text "" -font Helv_8 -fill "#42465c" -width 520 -textvariable {[setting_espresso_pressure_text]} 


add_de1_text "off" 1275 1256 -justify right -anchor "ne" -text [translate "Water temp:"] -font Helv_8 -fill "#7f879a" -width 520
add_de1_variable "off" 1280 1256 -justify left -anchor "nw" -text "" -font Helv_8  -fill "#42465c" -width 520 -textvariable {[setting_espresso_temperature_text]} 

add_de1_variable "off" 1275 1306 -justify right -anchor "ne" -text "" -font Helv_8 -fill "#7f879a" -width 520 -textvariable {[group_head_heater_action_text]} 
add_de1_variable "off" 1280 1306 -justify left -anchor "nw" -text "" -font Helv_8 -fill "#42465c" -width 520 -textvariable {[group_head_heater_temperature_text]} 

# we spell espresso with two SSs so that it is pronounced like Italians say it
add_de1_button "off" "say [translate {esspresso}] $::settings(sound_button_in);start_espresso" 948 584 1606 1444

##############################################################################################################################################################################################################################################################################
# the HOT WATER button and translatable text for it
	add_de1_text "water" 240 640 -text [translate "HOT WATER"] -font Helv_15_bold -fill "#2d3046" -anchor "nw" 
	add_de1_variable "water" 240 700 -text "" -font Helv_9_bold -fill "#73768f" -anchor "nw" -textvariable {[translate [de1_substate_text]]} 

	add_de1_text "water" 240 780 -justify right -anchor "nw" -text [translate "Time"] -font Helv_8_bold -fill "#5a5d75" -width 520
	#add_de1_text "water" 500 920 -justify right -anchor "center" -text [translate "- Time -"] -font Helv_10_bold -fill "#42465c" -width 520
	add_de1_text "water" 240 830 -justify right -anchor "nw" -text [translate "Elapsed:"] -font Helv_8 -fill "#7f879a" -width 520
	add_de1_variable "water" 770 830 -justify left -anchor "ne" -font Helv_8 -fill "#42465c" -width 520 -text "" -textvariable {[water_timer][translate "s"]} 
	add_de1_text "water" 240 880 -justify right -anchor "nw" -text [translate "Auto off:"] -font Helv_8 -fill "#7f879a" -width 520
	add_de1_variable "water" 770 880 -justify left -anchor "ne" -font Helv_8 -fill "#42465c" -width 520 -text "" -textvariable {[setting_water_max_time][translate "s"]} 

	add_de1_text "water" 240 970 -justify right -anchor "nw" -text [translate "Characteristics"] -font Helv_8_bold -fill "#5a5d75" -width 520
	#add_de1_text "water" 500 1120 -justify right -anchor "center" -text [translate "- Characteristics -"] -font Helv_10_bold -fill "#42465c" -width 520

	add_de1_text "water" 240 1020 -justify right -anchor "nw" -text [translate "Water temp:"] -font Helv_8 -fill "#7f879a" -width 520
	add_de1_variable "water" 770 1020 -justify left -anchor "ne" -font Helv_8 -fill "#42465c" -width 520 -text "" -textvariable {[watertemp_text]} 


	add_de1_text "water" 240 1070 -justify right -anchor "nw" -text [translate "Flow rate:"] -font Helv_8 -fill "#7f879a" -width 520
	add_de1_variable "water" 770 1070 -justify left -anchor "ne" -text "" -font Helv_8 -fill "#42465c" -width 520 -textvariable {[waterflow_text]} 
	add_de1_text "water" 240 1120 -justify right -anchor "nw" -text [translate "Volume:"] -font Helv_8 -fill "#7f879a" -width 520
	add_de1_variable "water" 770 1120 -justify left -anchor "ne" -text "" -font Helv_8 -fill "#42465c" -width 520 -textvariable {[watervolume_text]} 

add_de1_button "water" "say [translate {stop}] $::settings(sound_button_in);start_idle" 0 0 2560 1600




add_de1_text "off" 510 1076 -text [translate "HOT WATER"] -font Helv_10_bold -fill "#2d3046" -anchor "center" 
add_de1_text "off" 500 1156 -justify right -anchor "ne" -text [translate "Auto off:"] -font Helv_8 -fill "#7f879a" -width 520
add_de1_variable "off" 505 1156 -justify left -anchor "nw" -font Helv_8 -fill "#42465c" -width 520 -text "" -textvariable {[setting_water_max_time_text]} 
add_de1_text "off" 500 1206 -justify right -anchor "ne" -text [translate "Temp:"] -font Helv_8 -fill "#7f879a" -width 520
add_de1_variable "off" 505 1206 -justify left -anchor "nw" -font Helv_8 -fill "#42465c" -width 520 -text "" -textvariable {[setting_water_temperature_text]} 

#add_de1_text "water" 2053 1256 -justify right -anchor "ne" -text [translate "Flow:"] -font Helv_8 -fill "#7f879a" -width 520
#add_de1_variable "water" 2058 1256 -justify left -anchor "nw"  -font Helv_8 -fill "#42465c" -width 520 -text "-" -textvariable {[waterflow_text]} 
#add_de1_text "water" 2053 1306 -justify right -anchor "ne" -text [translate "Total:"] -font Helv_8 -fill "#7f879a" -width 520
#add_de1_variable "water" 2058 1306 -justify left -anchor "nw" -font Helv_8 -fill "#42465c" -width 520 -text "-" -textvariable {[watervolume_text]} 
add_de1_button "off" "say [translate {water}] $::settings(sound_button_in);start_water" 210 612 808 1416
#add_btn_screen "water" "stop"
#add_de1_action "water" "start_water"

##############################################################################################################################################################################################################################################################################
# when state change to "off", send the command to the DE1 to go idle
#add_de1_action "off" "stop"

# tapping the power button tells the DE1 to go to sleep, and it will after a few seconds, at which point we display the screen saver
add_de1_button "off" "say [translate {sleep}] $::settings(sound_button_in);start_sleep" 0 0 400 400
add_de1_button "saver" "say [translate {awake}] $::settings(sound_button_in);start_idle" 0 0 2560 1600

add_de1_text "sleep" 2500 1450 -justify right -anchor "ne" -text [translate "Going to sleep"] -font Helv_20_bold -fill "#DDDDDD" 
add_de1_button "sleep" "say [translate {sleep}] $::settings(sound_button_in);start_sleep" 0 0 2560 1600
#add_de1_action "sleep" "do_sleep"

add_de1_button "off" "exit" 800 0 1750 500
#add_de1_action "exit" "app_exit"


# Sleeping cafe photo obtained under creative commons from https://www.flickr.com/photos/curious_e/16300930781/

# turn the screen saver or splash screen off by tapping the page

#add_btn_screen "saver" "off"
#add_btn_screen "splash" "off"

# the SETTINGS button currently exits the app
#add_de1_button "off" "app_exit" 2200 0 2600 400
#add_de1_action "settings" "do_settings"
