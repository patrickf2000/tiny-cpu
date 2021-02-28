library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity decoder_tb is
end decoder_tb;

architecture Behavior of decoder_tb is

    -- Declare the component
    component decoder is
        port (
            clk     : in std_logic;                         -- The clock
            enable  : in std_logic;                         -- The enable bit
            instr   : in std_logic_vector(15 downto 0);     -- The input data to decode
            opcode  : out std_logic_vector(3 downto 0);     -- The opcode
            funct   : out std_logic_vector(2 downto 0);     -- The function code (for ALU and branch)
            regA    : out std_logic_vector(2 downto 0);     -- Source reg1
            regB    : out std_logic_vector(2 downto 0);     -- Source reg2
            regD    : out std_logic_vector(2 downto 0);     -- Destination register
            addr    : out std_logic_vector(5 downto 0);     -- Memory address
            imm     : out std_logic_vector(5 downto 0)      -- Immediate
        );
    end component;

    -- Declare the signals
    signal clk : std_logic := '0';
    signal enable : std_logic := '1';
    signal instr : std_logic_vector(15 downto 0) := X"0000";
    signal opcode : std_logic_vector(3 downto 0) := X"0";
    signal funct, regA, regB, regD : std_logic_vector(2 downto 0) := "000";
    signal addr, imm : std_logic_vector(5 downto 0) := "000000";
    
    -- Clock period definitions
    constant clk_period : time := 10 ns;
begin

    -- Setup the component
    uut : decoder port map (
        clk => clk,
        enable => enable,
        instr => instr,
        opcode => opcode,
        funct => funct,
        regA => regA,
        regB => regB,
        regD => regD,
        addr => addr,
        imm => imm
    );
    
    -- Clock process definitions
    I_clk_process : process
    begin
        clk <= '0';
        wait for clk_period/2;
        clk <= '1';
        wait for clk_period/2;
    end process;
 
    -- Test process
    stim_proc: process
    begin
        -- hold reset state for 100 ns.
        wait for 100 ns;  

        wait for clk_period*10;

        -- Test code here
        
        -- add r0, r1, r2
        -- Encoding: 0101 000 000 001 010
        instr <= "0101000000001010";
        wait for clk_period;
        
        assert opcode = "0101"  report "Test 1 failed-> opcode" severity error;
        assert funct = "000"    report "Test 1 failed-> funct" severity error;
        assert regD = "000"     report "Test 1 failed-> regD" severity error;
        assert regB = "001"     report "Test 1 failed-> regB" severity error;
        assert regA = "010"     report "Test 1 failed-> regA" severity error;
        
        -- sub r0, r6, r1
        -- Encoding: 0101 001 000 101 001
        instr <= "0101001000101001";
        wait for clk_period;
        
        assert opcode = "0101"  report "Test 2 failed-> opcode" severity error;
        assert funct = "001"    report "Test 2 failed-> funct" severity error;
        assert regD = "000"     report "Test 2 failed-> regD" severity error;
        assert regB = "101"     report "Test 2 failed-> regB" severity error;
        assert regA = "001"     report "Test 2 failed-> regA" severity error;
        
        -- li r3, 12
        -- Encoding 0100 000 011 001100
        instr <= "0100000011001100";
        wait for clk_period;
        
        assert opcode = "0100"  report "Test 3 failed-> opcode" severity error;
        assert funct = "000"    report "Test 3 failed-> funct" severity error;
        assert regD = "011"     report "Test 3 failed-> regD" severity error;
        assert imm = "001100"   report "Test 3 failed-> imm" severity error;
        
        wait;
        
    end process;
end Behavior;

