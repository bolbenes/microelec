LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

LIBRARY STD;
USE STD.ALL;

ENTITY hold_study_bd IS
  GENERIC (
   slew_lower_threshold_pct :   real :=  3.000000e-01;
   slew_upper_threshold_pct :   real :=  7.000000e-01;
   input_threshold_pct :   real :=  5.000000e-01;
   output_threshold_pct :   real :=  5.000000e-01 );
  PORT (
    SIGNAL din : IN STD_LOGIC;
    SIGNAL clk : IN STD_LOGIC;
    SIGNAL capa_charge_val : IN real;
    SIGNAL tt_val_clk : IN real;
    SIGNAL tt_val_d : IN real;
    SIGNAL clk_rise_time : OUT real;
    SIGNAL d_fall_time : OUT real;
    SIGNAL dout : INOUT STD_LOGIC;
    SIGNAL fin_test : IN STD_LOGIC);
END ENTITY hold_study_bd;

