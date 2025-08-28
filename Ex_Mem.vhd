library IEEE;	
use IEEE.std_logic_1164.all;
use ieee.numeric_std.all;

entity Ex_Mem is
port(
   i_CLK        : in std_logic;
	i_RST        : in std_logic;
	i_Mem_To_Reg : in std_logic;
	i_Branch     : in std_logic;
	i_Jump       : in std_logic;
	i_Reg_Write  : in std_logic;
	i_MemWrite   : in std_logic;
	i_addr_mais4 : in std_logic_vector(31 downto 0);
	i_Zero       : in std_logic;
	i_Ula_Result : in std_logic_vector(31 downto 0);
	i_RD2        : in std_logic_vector(31 downto 0);
	i_Reg_Dst    : in std_logic_vector(4 downto 0);
	i_funct3     : in std_logic;
	o_Mem_To_Reg : out std_logic;
	o_Branch     : out std_logic;
	o_Jump       : out std_logic;
	o_Reg_Write  : out std_logic;
	o_MemWrite   : out std_logic;
	o_addr_mais4 : out std_logic_vector(31 downto 0);
	o_Zero       : out std_logic;
	o_Ula_Result : out std_logic_vector(31 downto 0);
	o_RD2        : out std_logic_vector(31 downto 0);
	o_Reg_Dst    : out std_logic_vector(4 downto 0);
	o_funct3     : out std_logic
);
end entity;

architecture ex_mem_arch of Ex_Mem is

component registrador_1bit
  port (
    i_CLK     : in std_logic; -- clock
	 i_RST     : in std_logic;
    i_D       : in std_logic; 
    o_S       : out std_logic 
  ); 
end component; 

component registrador is
  port (
    i_CLK     : in std_logic; -- clock
	 i_RST     : in std_logic;
	 i_Enable  : in std_logic;
	 i_Escrever: in std_logic; 
    i_D       : in std_logic_vector (31 downto 0); 
    o_S       : out std_logic_vector (31 downto 0) 
  ); 
end component; 

begin

REG_Mem_To_Reg : registrador_1bit
port map(
	i_CLK => i_CLK,
	i_RST => i_RST,
	i_D   => i_Mem_to_Reg,
	o_S   => o_Mem_to_Reg
);

REG_Branch : registrador_1bit
port map(
	i_CLK => i_CLK,
	i_RST => i_RST,
	i_D   => i_Branch,
	o_S   => o_Branch
);

REG_Jump : registrador_1bit
port map(
	i_CLK => i_CLK,
	i_RST => i_RST,
	i_D   => i_Jump,
	o_S   => o_Jump
);

REG_Reg_Write : registrador_1bit
port map(
	i_CLK => i_CLK,
	i_RST => i_RST,
	i_D   => i_Reg_Write,
	o_S   => o_Reg_Write
);

REG_MemWrite : registrador_1bit
port map(
	i_CLK => i_CLK,
	i_RST => i_RST,
	i_D   => i_MemWrite,
	o_S   => o_MemWrite
);

REG_addr_mais4 : registrador
port map(
	i_CLK      => i_CLK,
	i_RST      => i_RST,	
	i_D        => i_addr_mais4,		
	i_Enable   => '1',
	i_Escrever => '1',
	o_S        => o_addr_mais4
);

REG_Zero : registrador_1bit
port map(
	i_CLK => i_CLK,
	i_RST => i_RST,
	i_D   => i_Zero,
	o_S   => o_Zero
);

REG_Resultado_de_Ula : registrador
port map(
	i_CLK      => i_CLK,
	i_RST      => i_RST,	
	i_D        => i_Ula_Result,		
	i_Enable   => '1',
	i_Escrever => '1',
	o_S        => o_Ula_Result
);

REG_RD2 : registrador
port map(
	i_CLK      => i_CLK,
	i_RST      => i_RST,	
	i_D        => i_RD2,		
	i_Enable   => '1',
	i_Escrever => '1',
	o_S        => o_RD2
);

gen_Reg_Destino : for i in 0 to 4 generate
  REG_Reg_Destino: registrador_1bit
  port map(
    i_CLK      => i_CLK,
	 i_RST      => i_RST,
    i_D        => i_Reg_Dst(i),
    o_S        => o_Reg_Dst(i)
  );
end generate gen_Reg_Destino; 

REG_funct3 : registrador_1bit
port map(
	i_CLK => i_CLK,
	i_RST => i_RST,
	i_D   => i_funct3,
	o_S   => o_funct3
);
  
end architecture;
