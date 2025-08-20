library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity registrador is
  port (
    i_CLK     : in std_logic; -- clock
	 i_RST     : in std_logic;
	 i_Enable  : in std_logic;
	 i_Escrever: in std_logic; 
    i_D       : in std_logic_vector (31 downto 0); 
    o_S       : out std_logic_vector (31 downto 0) 
  ); 
end registrador; 
  
architecture arch_registrador of registrador is
begin

  process(i_CLK, i_RST) 
  begin
  
  if(i_RST = '1')then
  
    o_S <= (others => '0');    -- PC = 0x00000000
	 
	 elsif (rising_edge(i_CLK)) then
      if(i_Enable = '1') then
		  if(i_Escrever = '1') then
		  
		    o_S <= i_D;
			 
		  end if;
		end if;
    end if;
	 
  end process;
  
end arch_registrador;