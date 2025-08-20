library IEEE;
use IEEE.std_logic_1164.all;
use ieee.numeric_std.all;

entity muxPC_control is
port(
  i_Entrada : in std_logic_vector(3 downto 0);
  --i_Entrada(3) => JUMP do controle
  --i_Entrada(2) => BRANCH do controle
  --i_Entrada(1) => bit (12) da instrução (FUNCT3 usado para diferenciar BEQ do BNE)
    --0 -> BEQ; 1 -> BNE
  --i_Entrada(0) => Zero flag
  o_Desvio : out std_logic
);
end entity;

architecture arch_muxPC_control of muxPC_control is
begin
    --FEITO COM UMA TABELA VERDADE NO CADERNO
    o_Desvio <= (
	              (i_Entrada(3)) or
					  (i_Entrada(2) and not i_Entrada(1) and i_Entrada(0)) or
					  (i_Entrada(2) and i_Entrada(1) and not i_Entrada(0))
	              );

end architecture;