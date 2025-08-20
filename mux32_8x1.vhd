library IEEE;	
use IEEE.std_logic_1164.all;
use ieee.numeric_std.all;

entity mux32_8x1 is   

port (
 i_SEL  : in std_logic_vector (2 downto 0);
 i_A    : in std_logic_vector (31 downto 0);  --ADD 
 i_B    : in std_logic_vector (31 downto 0);  --SUB
 i_C    : in std_logic_vector (31 downto 0);  --AND
 i_D    : in std_logic_vector (31 downto 0);  --OR
 i_E    : in std_logic_vector (31 downto 0);  --XOR
 i_F    : in std_logic_vector (31 downto 0);  --SLT
 i_G    : in std_logic_vector (31 downto 0);  --
 i_H    : in std_logic_vector (31 downto 0);  --
 o_S    : out std_logic_vector (31 downto 0)
);

end mux32_8x1;
---------------------------------------------
architecture arch_mux8x1 of mux32_8x1 is 
begin

  gen_mux32_8x1 : for i in 0 to 31 generate
  begin
    o_S(i) <= (
	           (i_A(i) and (not i_SEL(0)) and (not i_SEL(1)) and (not i_SEL(2))) or --000 ADD
	           (i_B(i) and i_SEL(0) and (not i_SEL(1)) and (not i_SEL(2))) or       --001 SUB
	           (i_C(i) and (not i_SEL(0)) and i_SEL(1) and (not i_SEL(2))) or       --010 AND
				  (i_D(i) and i_SEL(0) and i_SEL(1) and (not i_SEL(2))) or             --011 OR
				  (i_E(i) and (not i_SEL(0)) and (not i_SEL(1)) and i_SEL(2)) or       --100 XOR
				  (i_F(i) and i_SEL(0) and (not i_SEL(1)) and i_SEL(2)) or             --101 SLT
				  (i_G(i) and i_SEL(0) and i_SEL(1) and (not i_SEL(2))) or             --110 SLL
				  (i_H(i) and i_SEL(0) and i_SEL(1) and i_SEL(2))                      --111 SRL
				  );
  end generate gen_mux32_8x1;

end arch_mux8x1;
