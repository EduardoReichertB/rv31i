library IEEE;	
use IEEE.std_logic_1164.all;
use ieee.numeric_std.all;

entity decodeEnableReg is
port(
  i_EnableWrite : in std_logic_vector(4 downto 0);
  o_EnableReg   : out std_logic_vector(31 downto 0)
 );
 
end entity;
 
architecture arch_decodeEnableReg of decodeEnableReg is
begin
 
o_EnableReg(0)  <= (not i_EnableWrite(0)) and (not i_EnableWrite(1)) and not (i_EnableWrite(2)) and not (i_EnableWrite(3)) and not (i_EnableWrite(4));
o_EnableReg(1)  <= i_EnableWrite(0) and (not i_EnableWrite(1)) and not (i_EnableWrite(2)) and not (i_EnableWrite(3)) and not (i_EnableWrite(4));
o_EnableReg(2)  <= (not i_EnableWrite(0)) and i_EnableWrite(1) and not (i_EnableWrite(2)) and not (i_EnableWrite(3)) and not (i_EnableWrite(4));
o_EnableReg(3)  <= i_EnableWrite(0) and i_EnableWrite(1) and not (i_EnableWrite(2)) and not (i_EnableWrite(3)) and not (i_EnableWrite(4));
o_EnableReg(4)  <= (not i_EnableWrite(0)) and (not i_EnableWrite(1)) and i_EnableWrite(2) and not (i_EnableWrite(3)) and not (i_EnableWrite(4));
o_EnableReg(5)  <= i_EnableWrite(0) and (not i_EnableWrite(1)) and i_EnableWrite(2) and not (i_EnableWrite(3)) and not (i_EnableWrite(4));
o_EnableReg(6)  <= (not i_EnableWrite(0)) and i_EnableWrite(1) and i_EnableWrite(2) and not (i_EnableWrite(3)) and not (i_EnableWrite(4));
o_EnableReg(7)  <= i_EnableWrite(0) and i_EnableWrite(1) and i_EnableWrite(2) and not (i_EnableWrite(3)) and not (i_EnableWrite(4));
o_EnableReg(8)  <= (not i_EnableWrite(0)) and (not i_EnableWrite(1)) and not (i_EnableWrite(2)) and i_EnableWrite(3) and not (i_EnableWrite(4));
o_EnableReg(9)  <= i_EnableWrite(0) and (not i_EnableWrite(1)) and not (i_EnableWrite(2)) and i_EnableWrite(3) and not (i_EnableWrite(4));
o_EnableReg(10) <= (not i_EnableWrite(0)) and i_EnableWrite(1) and not (i_EnableWrite(2)) and i_EnableWrite(3) and not (i_EnableWrite(4));
o_EnableReg(11) <= i_EnableWrite(0) and i_EnableWrite(1) and not (i_EnableWrite(2)) and i_EnableWrite(3) and not (i_EnableWrite(4));
o_EnableReg(12) <= (not i_EnableWrite(0)) and (not i_EnableWrite(1)) and i_EnableWrite(2) and i_EnableWrite(3) and not (i_EnableWrite(4));
o_EnableReg(13) <= i_EnableWrite(0) and (not i_EnableWrite(1)) and i_EnableWrite(2) and i_EnableWrite(3) and not (i_EnableWrite(4));
o_EnableReg(14) <= (not i_EnableWrite(0)) and i_EnableWrite(1) and i_EnableWrite(2) and i_EnableWrite(3) and not (i_EnableWrite(4));
o_EnableReg(15) <= i_EnableWrite(0) and i_EnableWrite(1) and i_EnableWrite(2) and i_EnableWrite(3) and not (i_EnableWrite(4));
o_EnableReg(16) <= (not i_EnableWrite(0)) and (not i_EnableWrite(1)) and not (i_EnableWrite(2)) and not (i_EnableWrite(3)) and i_EnableWrite(4);
o_EnableReg(17) <= i_EnableWrite(0) and (not i_EnableWrite(1)) and not (i_EnableWrite(2)) and not (i_EnableWrite(3)) and i_EnableWrite(4);
o_EnableReg(18) <= (not i_EnableWrite(0)) and i_EnableWrite(1) and not (i_EnableWrite(2)) and not (i_EnableWrite(3)) and i_EnableWrite(4);
o_EnableReg(19) <= i_EnableWrite(0) and i_EnableWrite(1) and not (i_EnableWrite(2)) and not (i_EnableWrite(3)) and i_EnableWrite(4);
o_EnableReg(20) <= (not i_EnableWrite(0)) and (not i_EnableWrite(1)) and i_EnableWrite(2) and not (i_EnableWrite(3)) and i_EnableWrite(4);
o_EnableReg(21) <= i_EnableWrite(0) and (not i_EnableWrite(1)) and i_EnableWrite(2) and not (i_EnableWrite(3)) and i_EnableWrite(4);
o_EnableReg(22) <= (not i_EnableWrite(0)) and i_EnableWrite(1) and i_EnableWrite(2) and not (i_EnableWrite(3)) and i_EnableWrite(4);
o_EnableReg(23) <= i_EnableWrite(0) and i_EnableWrite(1) and i_EnableWrite(2) and not (i_EnableWrite(3)) and i_EnableWrite(4);
o_EnableReg(24) <= (not i_EnableWrite(0)) and (not i_EnableWrite(1)) and not (i_EnableWrite(2)) and i_EnableWrite(3) and i_EnableWrite(4);
o_EnableReg(25) <= i_EnableWrite(0) and (not i_EnableWrite(1)) and not (i_EnableWrite(2)) and i_EnableWrite(3) and i_EnableWrite(4);
o_EnableReg(26) <= (not i_EnableWrite(0)) and i_EnableWrite(1) and not (i_EnableWrite(2)) and i_EnableWrite(3) and i_EnableWrite(4);
o_EnableReg(27) <= i_EnableWrite(0) and i_EnableWrite(1) and not (i_EnableWrite(2)) and i_EnableWrite(3) and i_EnableWrite(4);
o_EnableReg(28) <= (not i_EnableWrite(0)) and (not i_EnableWrite(1)) and i_EnableWrite(2) and i_EnableWrite(3) and i_EnableWrite(4);
o_EnableReg(29) <= i_EnableWrite(0) and (not i_EnableWrite(1)) and i_EnableWrite(2) and i_EnableWrite(3) and i_EnableWrite(4);
o_EnableReg(30) <= (not i_EnableWrite(0)) and i_EnableWrite(1) and i_EnableWrite(2) and i_EnableWrite(3) and i_EnableWrite(4);
o_EnableReg(31) <= i_EnableWrite(0) and i_EnableWrite(1) and i_EnableWrite(2) and i_EnableWrite(3) and i_EnableWrite(4);

end architecture;
 