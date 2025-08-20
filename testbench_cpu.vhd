library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity testbench_cpu is
end testbench_cpu;

architecture teste of testbench_cpu is

component cpu is
port(
  i_Clock : in std_logic;
  i_Reset : in std_logic
);
end component;

signal w_CLK, w_RST : std_logic;

begin

macaco : cpu
port map(
  i_Clock => w_CLK,
  i_Reset => w_RST
);
  
process
begin
    w_RST <= '1';
    w_CLK <= '0';
wait for 5 ns;
    w_CLK <= '1';
wait for 5 ns;
    w_CLK <= '0';
wait for 5 ns;
    w_CLK <= '1';
wait for 5 ns;
    w_RST <= '0';
    w_CLK <= '0';
wait for 5 ns;
	 
    for i in 1 to 100 loop
        w_CLK <= '0';
        wait for 1000 ns;
        w_CLK <= '1';
        wait for 1000 ns;
    end loop;
    wait; 
end process;
end;
