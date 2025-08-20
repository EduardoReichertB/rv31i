library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity pc is
  port (
    i_CLK  : in std_logic; -- clock
	 i_RST  : in std_logic; --reset
    i_Data : in std_logic_vector (31 downto 0); 
    o_PC   : out std_logic_vector (31 downto 0) 
  ); 
end pc; 
  
architecture arch_pc of pc is
begin

process(i_CLK, i_RST) 
begin
    if (i_RST = '1') then           -- Reset assíncrono (fora do bloco de clock)
        o_PC <= (others => '0');    -- PC = 0x00000000
    elsif (rising_edge(i_CLK)) then  -- Operação normal
        o_PC <= i_Data;             -- Próximo valor do PC
    end if;
end process;
  
end arch_pc;