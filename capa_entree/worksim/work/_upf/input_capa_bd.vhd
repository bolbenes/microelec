library ieee;
use ieee.std_logic_1164.all;

use ieee.upf.all;

entity input_capa_bd is
  generic (
   slew_lower_threshold_pct :   real :=  3.000000e-01;
   slew_upper_threshold_pct :   real :=  7.000000e-01;
   input_threshold_pct :   real :=  5.000000e-01;
   output_threshold_pct :   real :=  5.000000e-01 );
  PORT (
    signal din : IN std_logic;
    signal din_cst : IN std_logic;
    signal tt_val : IN std_logic;
    signal capa_charge_val : IN std_logic;
    signal capa_test_val : IN std_logic;
    signal circuit_propagation_time : OUT std_logic;
    signal test_propagation_time : OUT std_logic;
    signal fin_test : IN std_logic);
end entity input_capa_bd;

