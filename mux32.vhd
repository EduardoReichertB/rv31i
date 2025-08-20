library IEEE;	
use IEEE.std_logic_1164.all;
use ieee.numeric_std.all;

entity mux32 is   

port (
 i_SEL  : in std_logic; --Entrada
 i_A    : in std_logic_vector (31 downto 0);
 i_B    : in std_logic_vector (31 downto 0); 
 o_S    : out std_logic_vector (31 downto 0)
);

end mux32;
---------------------------------------------
architecture arch_mux of mux32 is 
begin

  gen_mux32 : for i in 0 to 31 generate
  begin
    o_S(i) <= (i_A(i) and not i_SEL) or (i_B(i) and i_SEL);
  end generate gen_mux32;

end arch_mux;