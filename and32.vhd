library IEEE;	
use IEEE.std_logic_1164.all;
use ieee.numeric_std.all;

entity and32 is   

port (
 i_A    : in std_logic_vector (31 downto 0);
 i_B    : in std_logic_vector (31 downto 0); 
 o_S    : out std_logic_vector (31 downto 0)
);

end and32;
---------------------------------------------
architecture arch_and of and32 is 
begin

  gen_and32 : for i in 0 to 31 generate
  begin
    o_S(i) <= i_A(i) and i_B(i);
  end generate gen_and32;

end arch_and;