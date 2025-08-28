library ieee;
use ieee.std_logic_1164.all;

entity registrador_1bit is
    port (
        i_CLK   : in  std_logic;
        i_RST   : in  std_logic;
        i_D     : in  std_logic;
        o_S     : out std_logic
    );
end entity registrador_1bit;

architecture behavioral of registrador_1bit is
begin
    process(i_CLK, i_RST)
    begin
        if i_RST = '1' then
            o_S <= '0';
        elsif rising_edge(i_CLK) then
            o_S <= i_D;
        end if;
    end process;
end architecture behavioral;