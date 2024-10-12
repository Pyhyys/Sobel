###################################################################

# Created by write_sdc on Wed Nov 22 02:06:39 2023

###################################################################
set sdc_version 2.1

set_units -time ns -resistance kOhm -capacitance pF -voltage V -current mA
set_operating_conditions -max ss_typical_max_0p81v_125c -max_library           \
sc9_cln40g_base_rvt_ss_typical_max_0p81v_125c\
                         -min ff_typical_min_0p99v_m40c -min_library           \
sc9_cln40g_base_rvt_ff_typical_min_0p99v_m40c
set_wire_load_mode top
set_wire_load_model -name Zero -library                                        \
sc9_cln40g_base_rvt_ss_typical_max_0p81v_125c
set_ideal_network [get_ports clk]
create_clock [get_ports clk]  -period 3.2  -waveform {0 1.6}
set_input_delay -clock clk  0  [get_ports {in[7]}]
set_input_delay -clock clk  0  [get_ports {in[6]}]
set_input_delay -clock clk  0  [get_ports {in[5]}]
set_input_delay -clock clk  0  [get_ports {in[4]}]
set_input_delay -clock clk  0  [get_ports {in[3]}]
set_input_delay -clock clk  0  [get_ports {in[2]}]
set_input_delay -clock clk  0  [get_ports {in[1]}]
set_input_delay -clock clk  0  [get_ports {in[0]}]
set_input_delay -clock clk  0  [get_ports start]
set_input_delay -clock clk  0  [get_ports rst]
set_output_delay -clock clk  0  [get_ports {Gxout[7]}]
set_output_delay -clock clk  0  [get_ports {Gxout[6]}]
set_output_delay -clock clk  0  [get_ports {Gxout[5]}]
set_output_delay -clock clk  0  [get_ports {Gxout[4]}]
set_output_delay -clock clk  0  [get_ports {Gxout[3]}]
set_output_delay -clock clk  0  [get_ports {Gxout[2]}]
set_output_delay -clock clk  0  [get_ports {Gxout[1]}]
set_output_delay -clock clk  0  [get_ports {Gxout[0]}]
set_output_delay -clock clk  0  [get_ports {Gyout[7]}]
set_output_delay -clock clk  0  [get_ports {Gyout[6]}]
set_output_delay -clock clk  0  [get_ports {Gyout[5]}]
set_output_delay -clock clk  0  [get_ports {Gyout[4]}]
set_output_delay -clock clk  0  [get_ports {Gyout[3]}]
set_output_delay -clock clk  0  [get_ports {Gyout[2]}]
set_output_delay -clock clk  0  [get_ports {Gyout[1]}]
set_output_delay -clock clk  0  [get_ports {Gyout[0]}]
