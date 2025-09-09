# Define clock
create_clock -period 10.000 -name clk -waveform {0 5} [get_ports clkin]
set_property -dict {PACKAGE_PIN P17 IOSTANDARD LVCMOS33} [get_ports clkin]

# Define reset
set_property PACKAGE_PIN P15 [get_ports rst]
set_property IOSTANDARD LVCMOS33 [get_ports rst]

# Define confirm
set_property PACKAGE_PIN R15 [get_ports confirm]
set_property IOSTANDARD LVCMOS33 [get_ports confirm]

# Define start_pg
set_property PACKAGE_PIN R17 [get_ports start_pg]
set_property IOSTANDARD LVCMOS33 [get_ports start_pg]

# Define start_pg
set_property PACKAGE_PIN K3 [get_ports kickOff]
set_property IOSTANDARD LVCMOS33 [get_ports kickOff]
# Define input [7:0] (from DIP switches)
set_property PACKAGE_PIN R1 [get_ports {switch[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports {switch[0]}]
set_property PACKAGE_PIN N4 [get_ports {switch[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {switch[1]}]
set_property PACKAGE_PIN M4 [get_ports {switch[2]}]
set_property IOSTANDARD LVCMOS33 [get_ports {switch[2]}]
set_property PACKAGE_PIN R2 [get_ports {switch[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {switch[3]}]
set_property PACKAGE_PIN P2 [get_ports {switch[4]}]
set_property IOSTANDARD LVCMOS33 [get_ports {switch[4]}]
set_property PACKAGE_PIN P3 [get_ports {switch[5]}]
set_property IOSTANDARD LVCMOS33 [get_ports {switch[5]}]
set_property PACKAGE_PIN P4 [get_ports {switch[6]}]
set_property IOSTANDARD LVCMOS33 [get_ports {switch[6]}]
set_property PACKAGE_PIN P5 [get_ports {switch[7]}]
set_property IOSTANDARD LVCMOS33 [get_ports {switch[7]}]

# Define number[2:0] (from DIP switches)
set_property -dict {PACKAGE_PIN R3 IOSTANDARD LVCMOS33} [get_ports {number[2]}]
set_property -dict {PACKAGE_PIN T3 IOSTANDARD LVCMOS33} [get_ports {number[1]}]
set_property -dict {PACKAGE_PIN T5 IOSTANDARD LVCMOS33} [get_ports {number[0]}]

# Define leds[7:0] (to LEDs)
set_property IOSTANDARD LVCMOS33 [get_ports {leds[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports {leds[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {leds[2]}]
set_property IOSTANDARD LVCMOS33 [get_ports {leds[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {leds[4]}]
set_property IOSTANDARD LVCMOS33 [get_ports {leds[5]}]
set_property IOSTANDARD LVCMOS33 [get_ports {leds[6]}]
set_property IOSTANDARD LVCMOS33 [get_ports {leds[7]}]
set_property PACKAGE_PIN K2 [get_ports {leds[0]}]
set_property PACKAGE_PIN J2 [get_ports {leds[1]}]
set_property PACKAGE_PIN J3 [get_ports {leds[2]}]
set_property PACKAGE_PIN H4 [get_ports {leds[3]}]
set_property PACKAGE_PIN J4 [get_ports {leds[4]}]
set_property PACKAGE_PIN G3 [get_ports {leds[5]}]
set_property PACKAGE_PIN G4 [get_ports {leds[6]}]
set_property PACKAGE_PIN F6 [get_ports {leds[7]}]


set_property IOSTANDARD LVCMOS33 [get_ports anode]//从左到右的八个数码管，使能信号控�??
set_property PACKAGE_PIN G2 [get_ports {anode[7]}]
set_property PACKAGE_PIN C2 [get_ports {anode[6]}]
set_property PACKAGE_PIN C1 [get_ports {anode[5]}]
set_property PACKAGE_PIN H1 [get_ports {anode[4]}]
set_property PACKAGE_PIN G1 [get_ports {anode[3]}]
set_property PACKAGE_PIN F1 [get_ports {anode[2]}]
set_property PACKAGE_PIN E1 [get_ports {anode[1]}]
set_property PACKAGE_PIN G6 [get_ports {anode[0]}]


set_property IOSTANDARD LVCMOS33 [get_ports segment2]//左边四个数码�??
set_property PACKAGE_PIN B4 [get_ports {segment2[7]}]
set_property PACKAGE_PIN A4 [get_ports {segment2[6]}]
set_property PACKAGE_PIN A3 [get_ports {segment2[5]}]
set_property PACKAGE_PIN B1 [get_ports {segment2[4]}]
set_property PACKAGE_PIN A1 [get_ports {segment2[3]}]
set_property PACKAGE_PIN B3 [get_ports {segment2[2]}]
set_property PACKAGE_PIN B2 [get_ports {segment2[1]}]
set_property PACKAGE_PIN D5 [get_ports {segment2[0]}]


set_property IOSTANDARD LVCMOS33 [get_ports segment1]
set_property PACKAGE_PIN D4 [get_ports {segment1[7]}]
set_property PACKAGE_PIN E3 [get_ports {segment1[6]}]
set_property PACKAGE_PIN D3 [get_ports {segment1[5]}]
set_property PACKAGE_PIN F4 [get_ports {segment1[4]}]
set_property PACKAGE_PIN F3 [get_ports {segment1[3]}]
set_property PACKAGE_PIN E2 [get_ports {segment1[2]}]
set_property PACKAGE_PIN D2 [get_ports {segment1[1]}]
set_property PACKAGE_PIN H2 [get_ports {segment1[0]}]

set_property IOSTANDARD LVCMOS33 [get_ports {segment1[7]}]
set_property IOSTANDARD LVCMOS33 [get_ports {segment1[6]}]
set_property IOSTANDARD LVCMOS33 [get_ports {segment1[5]}]
set_property IOSTANDARD LVCMOS33 [get_ports {segment1[4]}]
set_property IOSTANDARD LVCMOS33 [get_ports {segment1[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {segment1[2]}]
set_property IOSTANDARD LVCMOS33 [get_ports {segment1[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {segment1[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports {segment2[7]}]
set_property IOSTANDARD LVCMOS33 [get_ports {segment2[6]}]
set_property IOSTANDARD LVCMOS33 [get_ports {segment2[5]}]
set_property IOSTANDARD LVCMOS33 [get_ports {segment2[4]}]
set_property IOSTANDARD LVCMOS33 [get_ports {segment2[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {segment2[2]}]
set_property IOSTANDARD LVCMOS33 [get_ports {segment2[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {segment2[0]}]

set_property IOSTANDARD LVCMOS33 [get_ports clk]
set_property IOSTANDARD LVCMOS33 [get_ports {anode[7]}]
set_property IOSTANDARD LVCMOS33 [get_ports {anode[6]}]
set_property IOSTANDARD LVCMOS33 [get_ports {anode[5]}]
set_property IOSTANDARD LVCMOS33 [get_ports {anode[4]}]
set_property IOSTANDARD LVCMOS33 [get_ports {anode[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {anode[2]}]
set_property IOSTANDARD LVCMOS33 [get_ports {anode[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {anode[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports rst]

set_property -dict {IOSTANDARD LVCMOS33 PACKAGE_PIN T4} [get_ports tx]
set_property -dict {IOSTANDARD LVCMOS33 PACKAGE_PIN N5} [get_ports rx]