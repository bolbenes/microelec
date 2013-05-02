library ieee;
use ieee.std_logic_1164.all;

use ieee.upf.all;

entity DYNDFF_X1 is
  PORT (
    signal D : INOUT std_logic;
    signal CK : INOUT std_logic;
    signal Q : INOUT std_logic;
    signal VDD : INOUT std_logic;
    signal VSS : INOUT std_logic);
end entity DYNDFF_X1;

