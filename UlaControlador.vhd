library IEEE;	
use IEEE.std_logic_1164.all;
use ieee.numeric_std.all;

entity UlaControlador is
port(
  i_Endereco : in std_logic_vector(5 downto 0);
  --i_Endereco(5) => AluOP(1)
  --i_Endereco(4) => AluOP(0)
  --i_Endereco(3) => funct7, bit 30 da instrução
  --i_Endereco(2) => funct3, bit 14 da instrução
  --i_Endereco(1) => funct3, bit 13 da instrução
  --i_Endereco(0) => funct3, bit 12 da instrução
  o_Operacao : out std_logic_vector(2 downto 0)
);
end entity;

architecture arch_UlaControlador of UlaControlador is
begin

--FEITO COM UMA TABELA VERDADE NO CADERNO
o_Operacao(0) <= (
                  (not i_Endereco(5) and i_Endereco(4) and not i_Endereco(2) and not i_Endereco(1) and not i_Endereco(0)) or
						(not i_Endereco(5) and i_Endereco(4) and not i_Endereco(2) and not i_Endereco(1) and i_Endereco(0)) or
						(i_Endereco(5) and not i_Endereco(4) and i_Endereco(3) and not i_Endereco(2) and not i_Endereco(1) and not i_Endereco(0)) or
						(i_Endereco(5) and i_Endereco(4) and not i_Endereco(3) and i_Endereco(2) and i_Endereco(1) and i_Endereco(0)) or
						(i_Endereco(5) and not i_Endereco(4) and not i_Endereco(3) and not i_Endereco(2) and i_Endereco(1) and not i_Endereco(0))
					  );
						
o_Operacao(1) <= (
                  (i_Endereco(5) and not i_Endereco(4) and not i_Endereco(3) and i_Endereco(2) and i_Endereco(1) and i_Endereco(0)) or
						(i_Endereco(5) and not i_Endereco(4) and not i_Endereco(3) and i_Endereco(2) and i_Endereco(1) and not i_Endereco(0)) or
						(i_Endereco(5) and i_Endereco(4) and not i_Endereco(3) and i_Endereco(2) and i_Endereco(1) and i_Endereco(0)) or
					   (i_Endereco(5) and i_Endereco(4) and not i_Endereco(3) and i_Endereco(2) and i_Endereco(1) and not i_Endereco(0))
                 );
					  
o_Operacao(2) <=(
                 (i_Endereco(5) and i_Endereco(4) and not i_Endereco(3) and i_Endereco(2) and not i_Endereco(1) and not i_Endereco(0)) or
					  (i_Endereco(5) and not i_Endereco(4) and not i_Endereco(3) and not i_Endereco(2) and i_Endereco(1) and not i_Endereco(0))
					 );

end architecture;