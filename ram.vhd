library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity data_memory is
    generic (
        DATA_WIDTH : natural := 32;  -- 32 bits para RISC-V
        ADDR_WIDTH : natural := 10   -- 2^10 endereços = 1KB (1024 palavras de 32 bits)
    );
    port (
        clk      : in std_logic;
        addr     : in std_logic_vector(31 downto 0);  -- Endereço byte-addressable
        data_in  : in std_logic_vector(DATA_WIDTH-1 downto 0);
        we       : in std_logic;  -- Write Enable
        data_out : out std_logic_vector(DATA_WIDTH-1 downto 0)
    );
end entity;

architecture rtl of data_memory is
    -- Definições de tipos
    subtype word_t is std_logic_vector(DATA_WIDTH-1 downto 0);
    type memory_t is array(0 to 2**ADDR_WIDTH-1) of word_t;

    -- Memória RAM
    signal ram : memory_t := (others => (others => '0'));

    -- Endereço alinhado à palavra (word-aligned)
    signal word_addr : natural range 0 to 2**ADDR_WIDTH-1;

begin
    -- Conversão de endereço byte-addressable para word-addressable
    -- Descartamos os 2 bits menos significativos (pois 32 bits = 4 bytes)
    word_addr <= to_integer(unsigned(addr(ADDR_WIDTH+1 downto 2)));

    -- Processo de escrita/leitura sincronizada
    process(clk)
    begin
            if we = '1' then
                if word_addr < 2**ADDR_WIDTH then
                    ram(word_addr) <= data_in;
                else
                    report "Endere�o de escrita fora dos limites" severity warning;
                end if;
            end if;
    end process;

    -- Leitura ass�ncrona (combinacional)
    data_out <= ram(word_addr) when word_addr < 2**ADDR_WIDTH else 
               (others => '0');
end rtl;
