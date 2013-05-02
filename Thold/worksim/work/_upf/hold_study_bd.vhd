library ieee;
use ieee.std_logic_1164.all;

use ieee.upf.all;

entity hold_study_bd is
  generic (
   slew_lower_threshold_pct :   real :=  3.000000e-01;
   slew_upper_threshold_pct :   real :=  7.000000e-01;
   input_threshold_pct :   real :=  5.000000e-01;
   output_threshold_pct :   real :=  5.000000e-01 );
  PORT (
    signal din : IN std_logic;
    signal clk : IN std_logic;
    signal capa_charge_val : IN std_logic;
    signal tt_val_clk : IN std_logic;
    signal tt_val_d : IN std_logic;
    signal clk_rise_time : OUT std_logic;
    signal d_fall_time : OUT std_logic;
    signal dout : INOUT std_logic;
    signal fin_test : IN std_logic);
end entity hold_study_bd;

