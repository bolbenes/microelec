LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

LIBRARY STD;
USE STD.ALL;

ENTITY conso_dyn_bd IS
  GENERIC (
   slew_lower_threshold_pct :   real :=  3.000000e-01;
   slew_upper_threshold_pct :   real :=  7.000000e-01;
   input_threshold_pct :   real :=  5.000000e-01;
   output_threshold_pct :   real :=  5.000000e-01 );
  PORT (
    SIGNAL din1 : IN real;
    SIGNAL din2 : IN real;
    SIGNAL tt_val : IN real;
    SIGNAL start_tick : IN STD_LOGIC;
    SIGNAL stop_tick : IN STD_LOGIC;
    SIGNAL capa_charge_val : IN real;
    SIGNAL internal_energy : OUT real;
    SIGNAL fin_test : IN STD_LOGIC);
END ENTITY conso_dyn_bd;

