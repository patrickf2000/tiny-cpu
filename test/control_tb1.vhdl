library IEEE;
use IEEE.std_logic_1164.all;

entity control_tb1 is
end control_tb1;

architecture Behavior of control_tb1 is

    -- Declare the control component
    component Control is
        port (
            clk : in std_logic;
            reset : in std_logic;
            state : out std_logic_vector(3 downto 0)
        );
    end component;
    
    -- Declare the decoder component
    -- Declare the component
    component decoder is
        port (
            clk     : in std_logic;
            enable  : in std_logic;
            instr   : in std_logic_vector(15 downto 0);
            opcode  : out std_logic_vector(3 downto 0);
            funct   : out std_logic_vector(2 downto 0);
            regA    : out std_logic_vector(2 downto 0);
            regB    : out std_logic_vector(2 downto 0);
            regD    : out std_logic_vector(2 downto 0);
            addr    : out std_logic_vector(5 downto 0);
            imm     : out std_logic_vector(5 downto 0)
        );
    end component;

    -- The signals
    signal clk, reset : std_logic := '0';
    signal state : std_logic_vector(3 downto 0) := "0000";
    
    -- The decoder signals
    signal instr : std_logic_vector(15 downto 0) := X"0000";
    signal opcode : std_logic_vector(3 downto 0) := X"0";
    signal funct, regA, regB, regD : std_logic_vector(2 downto 0) := "000";
    signal addr, imm : std_logic_vector(5 downto 0) := "000000";

    -- Clock period definitions
    constant clk_period : time := 10 ns;
begin

    uut : Control port map (
        clk => clk,
        reset => reset,
        state => state
    );
    
    decoder_uut : Decoder port map (
        clk => clk,
        enable => state(0),
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
        
        reset <= '1';

        -- Test code here
        reset <= '0';
        instr <= "0101000000001010";
        wait until state(0) = '1';
        
        instr <= "0100000011001100";
        wait until state(0) = '1';
        
        instr <= "0101001000101001";
        wait until state(0) = '1';
        
        wait;
        
    end process;
end Behavior;

