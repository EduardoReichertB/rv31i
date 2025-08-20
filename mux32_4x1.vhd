library IEEE;	
use IEEE.std_logic_1164.all;
use ieee.numeric_std.all;

entity mux32_4x1 is   

port (
 i_SEL  : in std_logic_vector (1 downto 0);
 i_A    : in std_logic_vector (31 downto 0);
 i_B    : in std_logic_vector (31 downto 0);
 i_C    : in std_logic_vector (31 downto 0);
 i_D    : in std_logic_vector (31 downto 0);
 o_S    : out std_logic_vector (31 downto 0)
);

end mux32_4x1;
---------------------------------------------
architecture arch_mux4x1 of mux32_4x1 is 
begin

  gen_mux32_4x1 : for i in 0 to 31 generate
  begin
    o_S(i) <= (i_A(i) and (not i_SEL(0)) and (not i_SEL(1))) or
	           (i_B(i) and i_SEL(0) and (not i_SEL(1))) or
	           (i_C(i) and (not i_SEL(0)) and i_SEL(1))or
				  (i_D(i) and i_SEL(0) and i_SEL(1));
  end generate gen_mux32_4x1;

end arch_mux4x1;