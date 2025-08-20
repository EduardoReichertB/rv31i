library IEEE;	
use IEEE.std_logic_1164.all;
use ieee.numeric_std.all;

entity xor32 is   

port (
 i_A    : in std_logic_vector (31 downto 0);
 i_B    : in std_logic_vector (31 downto 0); 
 o_S    : out std_logic_vector (31 downto 0)
);

end xor32;
---------------------------------------------
architecture arch_xor of xor32 is 
begin

  gen_xor32 : for i in 0 to 31 generate
  begin
    o_S(i) <= i_A(i) xor i_B(i);
  end generate gen_xor32;

end arch_xor;