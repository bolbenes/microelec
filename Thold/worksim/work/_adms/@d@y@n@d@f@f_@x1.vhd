LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

LIBRARY STD;
USE STD.ALL;

ENTITY DYNDFF_X1 IS
  PORT (
    SIGNAL D : INOUT STD_LOGIC;
    SIGNAL CK : INOUT STD_LOGIC;
    SIGNAL Q : INOUT STD_LOGIC;
    SIGNAL VDD : INOUT STD_LOGIC;
    SIGNAL VSS : INOUT STD_LOGIC);
END ENTITY DYNDFF_X1;

