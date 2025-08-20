library IEEE;	
use IEEE.std_logic_1164.all;
use ieee.numeric_std.all;

entity verifica_Zero is
port(
  i_Result : in std_logic_vector(31 downto 0);
  o_Zero   : out std_logic
);
end entity;

architecture arch_verifica of verifica_Zero is
begin

o_Zero <= not (i_Result(0) or i_Result(1) or i_Result(2) or i_Result(3) or i_Result(4) or i_Result(5) or i_Result(6) or
               i_Result(7) or i_Result(8) or i_Result(9) or i_Result(10) or i_Result(11) or i_Result(12) or
					i_Result(13) or i_Result(14) or i_Result(15) or i_Result(16) or i_Result(17) or i_Result(18) or
					i_Result(19) or i_Result(20) or i_Result(21) or i_Result(22) or i_Result(23) or i_Result(24) or
					i_Result(25) or i_Result(26) or i_Result(27) or i_Result(28) or i_Result(29) or i_Result(30) or
					i_Result(31)
				  );
end architecture;