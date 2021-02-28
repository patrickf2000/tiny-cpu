library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

-- Define how the decoder looks
entity Decoder is
    port (
        clk     : in std_logic;                         -- The clock
        instr   : in std_logic_vector(15 downto 0);     -- The input data to decode
        opcode  : out std_logic_vector(3 downto 0);     -- The opcode
        funct   : out std_logic_vector(2 downto 0);     -- The function code (for ALU and branch)
        regA    : out std_logic_vector(2 downto 0);     -- Source reg1
        regB    : out std_logic_vector(2 downto 0);     -- Source reg2
        regD    : out std_logic_vector(2 downto 0);     -- Destination register
        addr    : out std_logic_vector(5 downto 0);     -- Memory address
        imm     : out std_logic_vector(5 downto 0)      -- Immediate
    );
end Decoder;

-- Define how the decoder works
architecture Behavior of Decoder is

begin
    process (clk)
    begin
        -- These will always be present
        opcode <= instr(15 downto 12);
        funct <= instr(11 downto 9);
        regD <= instr(8 downto 6);
        
        -- All this may or may not be present, depending on the instruction
        regB <= instr(5 downto 3);
        regA <= instr(2 downto 0);
        addr <= instr(5 downto 0);
        imm <= instr(5 downto 0);
    end process;
end Behavior;
