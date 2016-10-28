set ::skindebug 0

#add_de1_variable "off" 10 599 -justify left -anchor "nw" -font Helv_8 -text "" -fill "#42465c" -width 260  -textvariable {[accelerometer_angle_text]} 

##############################################################################################################################################################################################################################################################################
# SETTINGS page

# tapping the logo exits the app
add_de1_button "off" "exit" 400 0 875 225 
add_de1_button "settings_1 settings_2 settings_3 settings_4" "say [translate {sleep}] $::settings(sound_button_in);start_sleep" 0 641 175 720 


# 1st batch of settings
add_de1_widget "settings_1" checkbutton 20 351 {} -text [translate "Preinfusion"] -indicatoron true  -font Helv_15_bold -bg #FFFFFF -anchor nw -foreground #2d3046 -variable ::settings(preinfusion_enabled) -command update_de1_explanation_chart -borderwidth 0 -selectcolor #FFFFFF -highlightthickness 0 -activebackground #FFFFFF

add_de1_widget "settings_1" scale 280 369 {} -to 1 -from 10 -background #FFFFFF -borderwidth 1 -bigincrement 1 -resolution 0.1 -length 225  -width 75  -variable ::settings(espresso_pressure) -font Helv_15_bold -sliderlength 75 -relief flat -command update_de1_explanation_chart -foreground #4e85f4 -troughcolor #EEEEEE -borderwidth 0  -highlightthickness 0 
add_de1_text "settings_1" 340 596 -text [translate "Hold pressure"] -font Helv_15_bold -fill "#2d3046" -anchor "nw" -width 300  -justify "left"

add_de1_widget "settings_1" scale 425 338 {} -from 0 -to 60 -background #FFFFFF -borderwidth 1 -bigincrement 1 -resolution 1 -length 360  -width 75  -variable ::settings(pressure_hold_time) -font Helv_10_bold -sliderlength 75 -relief flat -command update_de1_explanation_chart -orient horizontal -foreground #4e85f4 -troughcolor #EEEEEE -borderwidth 0  -highlightthickness 0 
add_de1_text "settings_1" 625 441 -text [translate "Hold time"] -font Helv_15_bold -fill "#2d3046" -anchor "n" -width 190  -justify "center"

add_de1_widget "settings_1" scale 850 338 {} -from 0 -to 60 -background #FFFFFF -borderwidth 1 -bigincrement 1 -resolution 1 -length 360  -width 75  -variable ::settings(espresso_decline_time) -font Helv_10_bold -sliderlength 75 -relief flat -command update_de1_explanation_chart -orient horizontal -foreground #4e85f4 -troughcolor #EEEEEE -borderwidth 0  -highlightthickness 0 
add_de1_text "settings_1" 1005 441 -text [translate "Decline time"] -font Helv_15_bold -fill "#2d3046" -anchor "n" -width 490  -justify "center"

add_de1_widget "settings_1" scale 1113 443 {} -to 0 -from 10 -background #FFFFFF -borderwidth 1 -bigincrement 1 -resolution 0.1 -length 149   -width 75  -variable ::settings(pressure_end) -font Helv_15_bold -sliderlength 75 -relief flat -command update_de1_explanation_chart -foreground #4e85f4 -troughcolor #EEEEEE -borderwidth 0  -highlightthickness 0 
add_de1_text "settings_1" 1247 596 -text [translate "Final pressure"] -font Helv_15_bold -fill "#2d3046" -anchor "ne" -width 350  -justify "left"

add_de1_button "settings_1" {say [translate {temperature}] $::settings(sound_button_in);vertical_slider ::settings(espresso_temperature) 80 95 %x %y %x0 %y0 %x1 %y1} 0 387 225 630 "mousemove"
add_de1_text "settings_1" 160 491  -text [translate "TEMP"] -font Helv_8 -fill "#7f879a" -anchor "center" 
add_de1_variable "settings_1" 160 527 -text "" -font Helv_10_bold -fill "#2d3046" -anchor "center" -textvariable {[return_temperature_measurement $::settings(espresso_temperature)]}

add_de1_widget "settings_1" graph 12 99 { 
	update_de1_explanation_chart;
	$widget element create line_espresso_de1_explanation_chart_pressure -xdata espresso_de1_explanation_chart_elapsed -ydata espresso_de1_explanation_chart_pressure -symbol circle -label "" -linewidth 5  -color #4e85f4  -smooth quadratic -pixels 15; 
	$widget axis configure x -color #5a5d75 -tickfont Helv_6 -command graph_seconds_axis_format; 
	$widget axis configure y -color #5a5d75 -tickfont Helv_6 -min 0.0 -max $::de1(max_pressure) -majorticks {0 1 2 3 4 5 6 7 8 9 10 11 12} -title [translate "pressure (bar)"] -titlefont Helv_10;

	bind $widget [platform_button_press] { 
		say [translate {refresh chart}] $::settings(sound_button_in); 
		update_de1_explanation_chart} 
	} -plotbackground #EEEEEE -width 1250  -height 225  -borderwidth 1 -background #FFFFFF -plotrelief raised


add_de1_widget "settings_4" checkbutton 45 180 {} -text [translate "Use Fahrenheit"] -indicatoron true  -font Helv_10 -bg #FFFFFF -anchor nw -foreground #2d3046 -variable ::settings(enable_fahrenheit)  -borderwidth 0 -selectcolor #FFFFFF -highlightthickness 0 -activebackground #FFFFFF
add_de1_widget "settings_4" checkbutton 45 225 {} -text [translate "Use fluid ounces"] -indicatoron true  -font Helv_10 -bg #FFFFFF -anchor nw -foreground #2d3046 -variable ::settings(enable_fluid_ounces)  -borderwidth 0 -selectcolor #FFFFFF -highlightthickness 0 -activebackground #FFFFFF
add_de1_widget "settings_4" checkbutton 45 270 {} -text [translate "Enable flight mode"] -indicatoron true  -font Helv_10 -bg #FFFFFF -anchor nw -foreground #2d3046 -variable ::settings(flight_mode_enable)  -borderwidth 0 -selectcolor #FFFFFF -highlightthickness 0 -activebackground #FFFFFF

add_de1_widget "settings_4" scale 45 315 {} -from 1 -to 90 -background #FFFFFF -borderwidth 1 -bigincrement 1 -resolution 1 -length 495  -width 67  -variable ::settings(flight_mode_angle) -font Helv_10_bold -sliderlength 75 -relief flat -orient horizontal -foreground #4e85f4 -troughcolor #EEEEEE -borderwidth 0  -highlightthickness 0 
add_de1_text "settings_4" 45 407 -text [translate "Flight mode: start angle"] -font Helv_9 -fill "#2d3046" -anchor "nw" -width 400  -justify "left"

add_de1_text "settings_4" 45 407 -text [translate "Flight mode: start angle"] -font Helv_9 -fill "#2d3046" -anchor "nw" -width 400  -justify "left"
add_de1_text "settings_4" 155 588 -text [translate "Clean: steam"] -font Helv_10_bold -fill "#eae9e9" -anchor "center"
add_de1_text "settings_4" 497 588 -text [translate "Clean: espresso"] -font Helv_10_bold -fill "#eae9e9" -anchor "center"

# future clean steam feature
add_de1_button "settings_4" {} 15 543 295 633 
# future clean espresso feature
add_de1_button "settings_4" {} 350 543 630 633 


add_de1_text "settings_4" 45 113 -text [translate "Other settings"] -font Helv_10_bold -fill "#7f879a" -justify "left" -anchor "nw"

add_de1_widget "settings_4" entry 670 171 {} -width 30  -font Helv_15_bold -bg #FFFFFF  -foreground #2d3046 -textvariable ::settings(machine_name) 
add_de1_text "settings_4" 675 212 -text [translate "Name your machine"] -font Helv_9 -fill "#2d3046" -anchor "nw" -width 400  -justify "left"

add_de1_text "settings_4" 675 113 -text [translate "Information"] -font Helv_10_bold -fill "#7f879a" -justify "left" -anchor "nw"
add_de1_text "settings_4" 675 270 -text [translate "Version: 1.0 beta 4"] -font Helv_9 -fill "#2d3046" -anchor "nw" -width 400  -justify "left"
add_de1_text "settings_4" 675 297 -text [translate "Serial number: 0000001"] -font Helv_9 -fill "#2d3046" -anchor "nw" -width 400  -justify "left"

add_de1_button "settings_4" {say [translate {awake time}] $::settings(sound_button_in);vertical_slider ::settings(alarm_wake) 0 86400 %x %y %x0 %y0 %x1 %y1} 665 360 962 567 "mousemove"
add_de1_text "settings_4" 850 549 -text [translate "Awake"] -font Helv_9 -fill "#2d3046" -anchor "center" -width 400  -justify "center"
add_de1_variable "settings_4" 850 585 -text "" -font Helv_10_bold -fill "#2d3046" -anchor "center" -textvariable {[format_alarm_time $::settings(alarm_wake)]}

add_de1_button "settings_4" {say [translate {sleep time}] $::settings(sound_button_in);vertical_slider ::settings(alarm_sleep) 0 86400 %x %y %x0 %y0 %x1 %y1} 962 360 1250 567 "mousemove"
add_de1_text "settings_4" 1075 549 -text [translate "Asleep"] -font Helv_9 -fill "#2d3046" -anchor "center" -width 400  -justify "center"
add_de1_variable "settings_4" 1075 585 -text "" -font Helv_10_bold -fill "#2d3046" -anchor "center" -textvariable {[format_alarm_time $::settings(alarm_sleep)]}

add_de1_text "settings_3" 45 113 -text [translate "Screen settings"] -font Helv_10_bold -fill "#7f879a" -justify "left" -anchor "nw"
add_de1_text "settings_3" 675 113 -text [translate "Speaking"] -font Helv_10_bold -fill "#7f879a" -justify "left" -anchor "nw"

add_de1_widget "settings_3" scale 45 140 {} -from 0 -to 100 -background #FFFFFF -borderwidth 1 -bigincrement 1 -resolution 1 -length 495  -width 67  -variable ::settings(app_brightness) -font Helv_10_bold -sliderlength 75 -relief flat -orient horizontal -foreground #4e85f4 -troughcolor #EEEEEE -borderwidth 0  -highlightthickness 0 
add_de1_text "settings_3" 45 236 -text [translate "App brightness"] -font Helv_8 -fill "#2d3046" -anchor "nw" -width 400  -justify "left"

add_de1_widget "settings_3" scale 45 261 {} -from 0 -to 100 -background #FFFFFF -borderwidth 1 -bigincrement 1 -resolution 1 -length 495  -width 67  -variable ::settings(saver_brightness) -font Helv_10_bold -sliderlength 75 -relief flat -orient horizontal -foreground #4e85f4 -troughcolor #EEEEEE -borderwidth 0  -highlightthickness 0 
add_de1_text "settings_3" 45 353 -text [translate "Screen saver brightness"] -font Helv_8 -fill "#2d3046" -anchor "nw" -width 400  -justify "left"

add_de1_widget "settings_3" scale 45 378 {} -from 0 -to 120 -background #FFFFFF -borderwidth 1 -bigincrement 1 -resolution 1 -length 495  -width 67  -variable ::settings(screen_saver_delay) -font Helv_10_bold -sliderlength 75 -relief flat -orient horizontal -foreground #4e85f4 -troughcolor #EEEEEE -borderwidth 0  -highlightthickness 0 
add_de1_text "settings_3" 45 470 -text [translate "Screen saver delay"] -font Helv_8 -fill "#2d3046" -anchor "nw" -width 400  -justify "left"

add_de1_widget "settings_3" scale 45 495 {} -from 1 -to 120 -background #FFFFFF -borderwidth 1 -bigincrement 1 -resolution 1 -length 495  -width 67  -variable ::settings(screen_saver_change_interval) -font Helv_10_bold -sliderlength 75 -relief flat -orient horizontal -foreground #4e85f4 -troughcolor #EEEEEE -borderwidth 0  -highlightthickness 0 
add_de1_text "settings_3" 45 587 -text [translate "Screen saver change interval"] -font Helv_8 -fill "#2d3046" -anchor "nw" -width 400  -justify "left"

add_de1_widget "settings_3" checkbutton 675 180 {} -text [translate "Enable spoken prompts"] -indicatoron true  -font Helv_10 -bg #FFFFFF -anchor nw -foreground #2d3046 -variable ::settings(enable_spoken_prompts)  -borderwidth 0 -selectcolor #FFFFFF -highlightthickness 0 -activebackground #FFFFFF

add_de1_widget "settings_3" scale 675 261 {} -from 0 -to 4 -background #FFFFFF -borderwidth 1 -bigincrement .1 -resolution .1 -length 495  -width 67  -variable ::settings(speaking_rate) -font Helv_10_bold -sliderlength 75 -relief flat -orient horizontal -foreground #4e85f4 -troughcolor #EEEEEE -borderwidth 0  -highlightthickness 0 
add_de1_text "settings_3" 675 353 -text [translate "Speaking speed"] -font Helv_8 -fill "#2d3046" -anchor "nw" -width 400  -justify "left"

add_de1_widget "settings_3" scale 675 378 {} -from 0 -to 3 -background #FFFFFF -borderwidth 1 -bigincrement .1 -resolution .1 -length 495  -width 67  -variable ::settings(speaking_pitch) -font Helv_10_bold -sliderlength 75 -relief flat -orient horizontal -foreground #4e85f4 -troughcolor #EEEEEE -borderwidth 0  -highlightthickness 0 
add_de1_text "settings_3" 675 470 -text [translate "Speaking pitch"] -font Helv_8 -fill "#2d3046" -anchor "nw" -width 400  -justify "left"

add_de1_button "off" {after 300 update_de1_explanation_chart;unset -nocomplain ::settings_backup; array set ::settings_backup [array get ::settings]; set_next_page off settings_1; page_show settings_1} 1000 0 1280 225 
add_de1_text "settings_1 settings_2 settings_3 settings_4" 1137 684 -text [translate "Save"] -font Helv_10_bold -fill "#eae9e9" -anchor "center"
add_de1_text "settings_1 settings_2 settings_3 settings_4" 880 684 -text [translate "Cancel"] -font Helv_10_bold -fill "#eae9e9" -anchor "center"

# labels for PREHEAT tab on
add_de1_text "settings_1" 165 45 -text [translate "ESPRESSO"] -font Helv_10_bold -fill "#2d3046" -anchor "center" 
add_de1_text "settings_1" 480 45 -text [translate "WATER/STEAM"] -font Helv_10_bold -fill "#5a5d75" -anchor "center" 
add_de1_text "settings_1" 795 45 -text [translate "SCREEN/SOUNDS"] -font Helv_10_bold -fill "#5a5d75" -anchor "center" 
add_de1_text "settings_1" 1107 45 -text [translate "OTHER/INFO"] -font Helv_10_bold -fill "#5a5d75" -anchor "center" 

########################################
# labels for WATER/STEAM tab on
add_de1_text "settings_2" 165 45 -text [translate "ESPRESSO"] -font Helv_10_bold -fill "#5a5d75" -anchor "center" 
add_de1_text "settings_2" 480 45 -text [translate "WATER/STEAM"] -font Helv_10_bold -fill "#2d3046" -anchor "center" 
add_de1_text "settings_2" 795 45 -text [translate "SCREEN/SOUNDS"] -font Helv_10_bold -fill "#5a5d75" -anchor "center" 
add_de1_text "settings_2" 1107 45 -text [translate "OTHER/INFO"] -font Helv_10_bold -fill "#5a5d75" -anchor "center" 

add_de1_button "settings_2" {say [translate {water temperature}] $::settings(sound_button_in);vertical_slider ::settings(water_temperature) $::de1(water_min_temperature) $::de1(water_max_temperature) %x %y %x0 %y0 %x1 %y1} 25 306 285 567 "mousemove"
add_de1_variable "settings_2" 190 594 -text "" -font Helv_10_bold -fill "#2d3046" -anchor "center" -textvariable {[return_temperature_measurement $::settings(water_temperature)]}

add_de1_button "settings_2" {say [translate {water time}] $::settings(sound_button_in);vertical_slider ::settings(water_max_time) $::de1(water_time_min) $::de1(water_time_max) %x %y %x0 %y0 %x1 %y1} 285 225 625 567 "mousemove"
add_de1_variable "settings_2" 450 594 -text "" -font Helv_10_bold -fill "#2d3046" -anchor "center" -textvariable {[round_to_integer $::settings(water_max_time)] [translate "seconds"]}

add_de1_button "settings_2" {say [translate {steam temperature}] $::settings(sound_button_in);vertical_slider ::settings(steam_temperature) $::de1(steam_min_temperature) $::de1(steam_max_temperature) %x %y %x0 %y0 %x1 %y1} 665 306 925 567 "mousemove"
add_de1_variable "settings_2" 820 594 -text "" -font Helv_10_bold -fill "#2d3046" -anchor "center" -textvariable {[return_temperature_measurement $::settings(steam_temperature)]}

add_de1_button "settings_2" {say [translate {steam time}] $::settings(sound_button_in);vertical_slider ::settings(steam_max_time) $::de1(steam_time_min) $::de1(steam_time_max) %x %y %x0 %y0 %x1 %y1} 925 225 1250 567 "mousemove"
add_de1_variable "settings_2" 1085 594 -text "" -font Helv_10_bold -fill "#2d3046" -anchor "center" -textvariable {[round_to_integer $::settings(steam_max_time)] [translate "seconds"]}

add_de1_text "settings_2" 115 126 -text [translate "Hot water"] -font Helv_15_bold -fill "#7f879a" -justify "left" -anchor "nw"
add_de1_text "settings_2" 755 126 -text [translate "Steam"] -font Helv_15_bold -fill "#7f879a" -justify "left" -anchor "nw"

########################################

# labels for STEAM tab on
add_de1_text "settings_3" 165 45 -text [translate "ESPRESSO"] -font Helv_10_bold -fill "#5a5d75" -anchor "center" 
add_de1_text "settings_3" 480 45 -text [translate "WATER/STEAM"] -font Helv_10_bold -fill "#5a5d75" -anchor "center" 
add_de1_text "settings_3" 795 45 -text [translate "SCREEN/SOUNDS"] -font Helv_10_bold -fill "#2d3046" -anchor "center" 
add_de1_text "settings_3" 1107 45 -text [translate "OTHER/INFO"] -font Helv_10_bold -fill "#5a5d75" -anchor "center" 

# labels for HOT WATER tab on
add_de1_text "settings_4" 165 45 -text [translate "ESPRESSO"] -font Helv_10_bold -fill "#5a5d75" -anchor "center" 
add_de1_text "settings_4" 480 45 -text [translate "WATER/STEAM"] -font Helv_10_bold -fill "#5a5d75" -anchor "center" 
add_de1_text "settings_4" 795 45 -text [translate "SCREEN/SOUNDS"] -font Helv_10_bold -fill "#5a5d75" -anchor "center" 
add_de1_text "settings_4" 1107 45 -text [translate "OTHER/INFO"] -font Helv_10_bold -fill "#2d3046" -anchor "center" 

# buttons for moving between tabs, available at all times that the espresso machine is not doing something hot
add_de1_button "settings_1 settings_2 settings_3 settings_4" {after 300 update_de1_explanation_chart; say [translate {settings}] $::settings(sound_button_in); set_next_page off settings_1; page_show settings_1} 0 0 320 85 
add_de1_button "settings_1 settings_2 settings_3 settings_4" {say [translate {settings}] $::settings(sound_button_in); set_next_page off settings_2; page_show settings_2} 321 0 638 85 
add_de1_button "settings_1 settings_2 settings_3 settings_4" {say [translate {settings}] $::settings(sound_button_in); set_next_page off settings_3; page_show settings_3} 639 0 952 85 
add_de1_button "settings_1 settings_2 settings_3 settings_4" {say [translate {settings}] $::settings(sound_button_in); set_next_page off settings_4; page_show settings_4} 952 0 1280 85 

add_de1_button "settings_1 settings_2 settings_3 settings_4" {say [translate {save}] $::settings(sound_button_in); save_settings; set_next_page off off; page_show off} 1008 644 1280 720 
add_de1_button "settings_1 settings_2 settings_3 settings_4" {unset -nocomplain ::settings; array set ::settings [array get ::settings_backup]; say [translate {cancel}] $::settings(sound_button_in); set_next_page off off; page_show off} 752 644 1007 720 

# END OF SETTINGS page
##############################################################################################################################################################################################################################################################################



##############################################################################################################################################################################################################################################################################


##############################################################################################################################################################################################################################################################################
# the STEAM button and translatable text for it

add_de1_text "steam" 1024 484 -text [translate "STEAM"] -font Helv_10_bold -fill "#2d3046" -anchor "center" 
add_de1_variable "steam" 1024 511 -text "" -font Helv_9_bold -fill "#7f879a" -anchor "center" -textvariable {"[translate [de1_substate_text]]"} 

# variables to display during steam
add_de1_text "steam" 1026 529 -justify right -anchor "ne" -text [translate "Elapsed:"] -font Helv_8 -fill "#7f879a" -width 260 
add_de1_variable "steam" 1029 529 -justify left -anchor "nw" -font Helv_8 -text "" -fill "#42465c" -width 260  -textvariable {[steam_timer][translate "s"]} 
add_de1_text "steam" 1026 552 -justify right -anchor "ne" -text [translate "Auto off:"] -font Helv_8 -fill "#7f879a" -width 260 
add_de1_variable "steam" 1029 552 -justify left -anchor "nw" -font Helv_8 -text "" -fill "#42465c" -width 260  -textvariable {[setting_steam_max_time_text]} 
add_de1_text "steam" 1026 574 -justify right -anchor "ne" -text [translate "Steam temp:"] -font Helv_8 -fill "#7f879a" -width 260 
add_de1_variable "steam" 1029 574 -justify left -anchor "nw" -font Helv_8 -text "" -fill "#42465c" -width 260  -textvariable {[steamtemp_text]} 
#add_de1_text "steam" 1026 597 -justify right -anchor "ne" -text [translate "Pressure:"] -font Helv_8 -fill "#7f879a" -width 260 
#add_de1_variable "steam" 1029 597 -justify left -anchor "nw" -font Helv_8 -text "" -fill "#42465c" -width 260  -textvariable {[pressure_text]} 


# 
#add_de1_action "steam" "do_steam"
# when it steam mode, tapping anywhere on the screen tells the DE1 to stop.
add_de1_button "steam" "say [translate {stop}] $::settings(sound_button_in);start_idle" 0 0 1280 720 

# STEAM related info to display when the espresso machine is idle
add_de1_text "off" 1024 484 -text [translate "STEAM"] -font Helv_10_bold -fill "#2d3046" -anchor "center" 
add_de1_text "off" 1026 520 -justify right -anchor "ne" -text [translate "Auto off:"] -font Helv_8 -fill "#7f879a" -width 260 
add_de1_variable "off" 1029 520 -justify left -anchor "nw" -font Helv_8 -text "" -fill "#42465c" -width 260  -textvariable {[setting_steam_max_time_text]} 
add_de1_text "off" 1026 543 -justify right -anchor "ne" -text [translate "Steam temp:"] -font Helv_8 -fill "#7f879a" -width 260 
add_de1_variable "off" 1029 543 -justify left -anchor "nw" -font Helv_8 -text "" -fill "#42465c" -width 260  -textvariable {[setting_steam_temperature_text]} 
add_de1_variable "off" 1026 565 -justify right -anchor "ne" -text "" -font Helv_8 -fill "#7f879a" -width 260  -textvariable {[steam_heater_action_text]} 
add_de1_variable "off" 1029 565 -justify left -anchor "nw" -font Helv_8 -text "" -fill "#42465c" -width 260  -textvariable {[steam_heater_temperature_text]} 

# when someone taps on the steam button
add_de1_button "off" "say [translate {steam}] $::settings(sound_button_in);start_steam" 874 277 1173 636 

##############################################################################################################################################################################################################################################################################
# the ESPRESSO button and translatable text for it

add_de1_text "espresso" 640 484 -text [translate "ESPRESSO"] -font Helv_10_bold -fill "#2d3046" -anchor "center" 
add_de1_variable "espresso" 640 511 -text "" -font Helv_9_bold -fill "#7f879a" -anchor "center" -textvariable {"[translate [de1_substate_text]]"} 

add_de1_text "espresso" 640 529 -justify right -anchor "ne" -text [translate "Elapsed:"] -font Helv_8 -fill "#7f879a" -width 260 
add_de1_variable "espresso" 642 529 -justify left -anchor "nw" -text "" -font Helv_8 -fill "#42465c" -width 260  -textvariable {[pour_timer][translate "s"]} 

add_de1_text "espresso" 640 552 -justify right -anchor "ne" -text [translate "Auto off:"] -font Helv_8 -fill "#7f879a" -width 260 
add_de1_variable "espresso" 642 552 -justify left -anchor "nw" -text "" -font Helv_8  -fill "#42465c" -width 260  -textvariable {[setting_espresso_max_time_text]} 

add_de1_text "espresso" 640 574 -justify right -anchor "ne" -text [translate "Pressure:"] -font Helv_8 -fill "#7f879a" -width 260 
add_de1_variable "espresso" 642 574 -justify left -anchor "nw" -text "" -font Helv_8 -fill "#42465c" -width 260  -textvariable {[pressure_text]} 

add_de1_text "espresso" 640 597 -justify right -anchor "ne" -text [translate "Water temp:"] -font Helv_8 -fill "#7f879a" -width 260 
add_de1_variable "espresso" 642 597 -justify left -anchor "nw" -text "" -font Helv_8 -fill "#42465c" -width 260  -textvariable {[watertemp_text]} 

add_de1_button "espresso" "say [translate {stop}] $::settings(sound_button_in);start_idle" 0 0 1280 720 

#add_btn_screen "espresso" "stop"
#add_de1_action "espresso" "do_espresso"


add_de1_text "off" 640 484 -text [translate "ESPRESSO"] -font Helv_10_bold -fill "#2d3046" -anchor "center" 
add_de1_text "off" 637 520 -justify right -anchor "ne" -text [translate "Auto off:"] -font Helv_8 -fill "#7f879a" -width 260 
add_de1_variable "off" 640 520 -justify left -anchor "nw" -text "" -font Helv_8  -fill "#42465c" -width 260  -textvariable {[setting_espresso_max_time_text]} 

add_de1_text "off" 637 543 -justify right -anchor "ne" -text [translate "Pressure:"] -font Helv_8 -fill "#7f879a" -width 260 
add_de1_variable "off" 640 543 -justify left -anchor "nw" -text "" -font Helv_8 -fill "#42465c" -width 260  -textvariable {[setting_espresso_pressure_text]} 


add_de1_text "off" 637 565 -justify right -anchor "ne" -text [translate "Water temp:"] -font Helv_8 -fill "#7f879a" -width 260 
add_de1_variable "off" 640 565 -justify left -anchor "nw" -text "" -font Helv_8  -fill "#42465c" -width 260  -textvariable {[setting_espresso_temperature_text]} 

add_de1_variable "off" 637 588 -justify right -anchor "ne" -text "" -font Helv_8 -fill "#7f879a" -width 260  -textvariable {[group_head_heater_action_text]} 
add_de1_variable "off" 640 588 -justify left -anchor "nw" -text "" -font Helv_8 -fill "#42465c" -width 260  -textvariable {[group_head_heater_temperature_text]} 

# we spell espresso with two SSs so that it is pronounced like Italians say it
add_de1_button "off" "say [translate {esspresso}] $::settings(sound_button_in);start_espresso" 474 263 803 650 


#add_de1_text "espresso" 637 588 -justify right -anchor "ne" -text [translate "Flow:"] -font Helv_8 -fill "#7f879a" -width 260 
#add_de1_variable "espresso" 640 588 -justify left -anchor "nw" -text "1.12 [translate ml/sec]" -font Helv_8 -text "" -fill "#2d3046" -width 260  -textvariable {[waterflow_text]} 

##############################################################################################################################################################################################################################################################################
# the HOT WATER button and translatable text for it
add_de1_text "water" 255 484 -text [translate "HOT WATER"] -font Helv_10_bold -fill "#2d3046" -anchor "center" 
add_de1_variable "water" 255 511 -text "" -font Helv_9_bold -fill "#73768f" -anchor "center" -textvariable {[translate [de1_substate_text]]} 

add_de1_text "water" 250 529 -justify right -anchor "ne" -text [translate "Elapsed:"] -font Helv_8 -fill "#7f879a" -width 260 
add_de1_variable "water" 252 529 -justify left -anchor "nw" -font Helv_8 -fill "#42465c" -width 260  -text "" -textvariable {[water_timer][translate "s"]} 
add_de1_text "water" 250 552 -justify right -anchor "ne" -text [translate "Auto off:"] -font Helv_8 -fill "#7f879a" -width 260 
add_de1_variable "water" 252 552 -justify left -anchor "nw" -font Helv_8 -fill "#42465c" -width 260  -text "" -textvariable {[setting_water_max_time_text]} 
add_de1_text "water" 250 574 -justify right -anchor "ne" -text [translate "Water temp:"] -font Helv_8 -fill "#7f879a" -width 260 
add_de1_variable "water" 252 574 -justify left -anchor "nw" -font Helv_8 -fill "#42465c" -width 260  -text "" -textvariable {[watertemp_text]} 

add_de1_button "water" "say [translate {stop}] $::settings(sound_button_in);start_idle" 0 0 1280 720 




add_de1_text "off" 255 484 -text [translate "HOT WATER"] -font Helv_10_bold -fill "#2d3046" -anchor "center" 
add_de1_text "off" 250 520 -justify right -anchor "ne" -text [translate "Auto off:"] -font Helv_8 -fill "#7f879a" -width 260 
add_de1_variable "off" 252 520 -justify left -anchor "nw" -font Helv_8 -fill "#42465c" -width 260  -text "" -textvariable {[setting_water_max_time_text]} 
add_de1_text "off" 250 543 -justify right -anchor "ne" -text [translate "Temp:"] -font Helv_8 -fill "#7f879a" -width 260 
add_de1_variable "off" 252 543 -justify left -anchor "nw" -font Helv_8 -fill "#42465c" -width 260  -text "" -textvariable {[setting_water_temperature_text]} 

#add_de1_text "water" 1026 565 -justify right -anchor "ne" -text [translate "Flow:"] -font Helv_8 -fill "#7f879a" -width 260 
#add_de1_variable "water" 1029 565 -justify left -anchor "nw"  -font Helv_8 -fill "#42465c" -width 260  -text "" -textvariable {[waterflow_text]} 
#add_de1_text "water" 1026 588 -justify right -anchor "ne" -text [translate "Total:"] -font Helv_8 -fill "#7f879a" -width 260 
#add_de1_variable "water" 1029 588 -justify left -anchor "nw" -font Helv_8 -fill "#42465c" -width 260  -text "" -textvariable {[watervolume_text]} 
add_de1_button "off" "say [translate {water}] $::settings(sound_button_in);start_water" 105 275 404 637 
#add_btn_screen "water" "stop"
#add_de1_action "water" "start_water"

##############################################################################################################################################################################################################################################################################
# when state change to "off", send the command to the DE1 to go idle
#add_de1_action "off" "stop"

# tapping the power button tells the DE1 to go to sleep, and it will after a few seconds, at which point we display the screen saver
add_de1_button "off" "say [translate {sleep}] $::settings(sound_button_in);start_sleep" 0 0 200 180 

add_de1_button "saver" "say [translate {awake}] $::settings(sound_button_in);start_idle" 0 0 1280 720 

add_de1_text "sleep" 1250 653 -justify right -anchor "ne" -text [translate "Going to sleep"] -font Helv_20_bold -fill "#DDDDDD" 
add_de1_button "sleep" "say [translate {sleep}] $::settings(sound_button_in);start_sleep" 0 0 1280 720 
#add_de1_action "sleep" "do_sleep"

add_de1_action "exit" "app_exit"


# Sleeping cafe photo obtained under creative commons from https://www.flickr.com/photos/curious_e/16300930781/

# turn the screen saver or splash screen off by tapping the page

#add_btn_screen "saver" "off"
#add_btn_screen "splash" "off"

# the SETTINGS button currently exits the app
#add_de1_button "off" "app_exit" 1100 0 1300 180 
#add_de1_action "settings" "do_settings"

