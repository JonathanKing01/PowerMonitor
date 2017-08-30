#************************************************************
# THIS IS A WIZARD-GENERATED FILE.                           
#
# Version 13.0.0 Build 156 04/24/2013 SJ Full Version
#
#************************************************************

# Copyright (C) 1991-2013 Altera Corporation
# Your use of Altera Corporation's design tools, logic functions 
# and other software and tools, and its AMPP partner logic 
# functions, and any output files from any of the foregoing 
# (including device programming or simulation files), and any 
# associated documentation or information are expressly subject 
# to the terms and conditions of the Altera Program License 
# Subscription Agreement, Altera MegaCore Function License 
# Agreement, or other applicable license agreement, including, 
# without limitation, that your use is for the sole purpose of 
# programming logic devices manufactured by Altera and sold by 
# Altera or its authorized distributors.  Please refer to the 
# applicable agreement for further details.



# Clock constraints

create_clock -name "clk" -period 5.000ns [get_ports {clk}]


# Automatically constrain PLL and other generated clocks
derive_pll_clocks -create_base_clocks

# Automatically calculate clock uncertainty to jitter and other effects.
#derive_clock_uncertainty
# Not supported for family MAX V

# tsu/th constraints

set_input_delay -clock "clk" -max 3ns [get_ports {clk}] 
set_input_delay -clock "clk" -min 5.000ns [get_ports {clk}] 


# tco constraints

set_output_delay -clock "clk" -max -5ns [get_ports {ledsel[0]}] 
set_output_delay -clock "clk" -min -5.000ns [get_ports {ledsel[0]}] 


# tpd constraints

set_max_delay 5.000ns -from [get_ports {rx}] -to [get_ports {ledsel[0]}]


