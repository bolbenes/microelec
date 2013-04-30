library ieee;
use ieee.std_logic_1164.all;

use ieee.upf.all;

entity conso_dyn_bd is
  generic (
   slew_lower_threshold_pct :   real :=  3.000000e-01;
   slew_upper_threshold_pct :   real :=  7.000000e-01;
   input_threshold_pct :   real :=  5.000000e-01;
   output_threshold_pct :   real :=  5.000000e-01 );
  PORT (
    signal din1 : IN std_logic;
    signal din2 : IN std_logic;
    signal tt_val : IN std_logic;
    signal start_tick : IN std_logic;
    signal stop_tick : IN std_logic;
    signal capa_charge_val : IN std_logic;
    signal internal_energy : OUT std_logic;
    signal fin_test : IN std_logic);
end entity conso_dyn_bd;

