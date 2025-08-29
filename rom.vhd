library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity rom is
    generic (
        DATA_WIDTH : natural := 32;
        ADDR_WIDTH : natural := 8  -- 2^8 instruções = 256 instruções
    );
    port (
        clk      : in  std_logic;
        addr_in  : in  std_logic_vector(31 downto 0);
        q        : out std_logic_vector(DATA_WIDTH-1 downto 0)
    );
end entity;

architecture rtl of rom is
    -- Definições de tipos
    subtype word_t is std_logic_vector(DATA_WIDTH-1 downto 0);
    type memory_t is array(2**ADDR_WIDTH-1 downto 0) of word_t;

    -- Inicialização com instruções addi para s0 até s4
    function init_rom return memory_t is 
        variable tmp : memory_t := (others => (others => '0'));
    begin 
        -- addi s0, zero, 1
        tmp(0)  := "00000000000100000000010000010011";
        

        tmp(1)  := "00000000001000000000010010010011";
        

        tmp(2)  := "00000000001100000000010100010011";
        

        tmp(3)  := "00000000010000000000010110010011";
        

        tmp(4)  := "00000000010100000000011000010011";
        
        -- Preenche o resto da memória com zeros
        for addr_pos in 5 to 2**ADDR_WIDTH-1 loop
            tmp(addr_pos) := (others => '0');
        end loop;
        return tmp;
    end init_rom;

    -- Memória interna
    signal rom : memory_t := init_rom;

    -- Endereço alinhado à palavra de 32 bits
    signal word_addr : natural range 0 to 2**ADDR_WIDTH-1;

begin
    -- Converter o addr_in de bytes para índice de instrução
    word_addr <= to_integer(unsigned(addr_in(ADDR_WIDTH+1 downto 2)));

    -- Leitura assincrona
    q <= rom(word_addr);

end rtl;
