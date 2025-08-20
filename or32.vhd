library IEEE;	
use IEEE.std_logic_1164.all;
use ieee.numeric_std.all;

entity or32 is   

port (
 i_A    : in std_logic_vector (31 downto 0);
 i_B    : in std_logic_vector (31 downto 0); 
 o_S    : out std_logic_vector (31 downto 0)
);

end or32;
---------------------------------------------
architecture arch_or of or32 is 
begin

  gen_or32 : for i in 0 to 31 generate
  begin
    o_S(i) <= i_A(i) or i_B(i);
  end generate gen_or32;

end arch_or;