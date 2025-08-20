library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity slt32 is 
port(
    i_A          : in std_logic_vector(31 downto 0);
    i_B          : in std_logic_vector(31 downto 0);
    o_S          : out std_logic_vector(31 downto 0)
);
end slt32;

architecture arch_signed of slt32 is 
begin

    process(i_A, i_B)
    begin
        if signed(i_A) < signed(i_B) then
            o_S <= "00000000000000000000000000000001";
        else
            o_S <= "00000000000000000000000000000000";
        end if;
    end process;

end arch_signed;
