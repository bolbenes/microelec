LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

LIBRARY STD;
USE STD.ALL;

ENTITY input_capa_bd IS
  GENERIC (
   slew_lower_threshold_pct :   real :=  3.000000e-01;
   slew_upper_threshold_pct :   real :=  7.000000e-01;
   input_threshold_pct :   real :=  5.000000e-01;
   output_threshold_pct :   real :=  5.000000e-01 );
  PORT (
    SIGNAL din : IN real;
    SIGNAL din_cst : IN real;
    SIGNAL tt_val : IN real;
    SIGNAL capa_charge_val : IN real;
    SIGNAL capa_test_val : IN real;
    SIGNAL circuit_propagation_time : OUT real;
    SIGNAL test_propagation_time : OUT real;
    SIGNAL fin_test : IN STD_LOGIC);
END ENTITY input_capa_bd;

