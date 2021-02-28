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
    
    -- The registers
    component registers is
        port(
            clk     : in std_logic;
            enable  : in std_logic;
            sel_A   : in std_logic_vector(2 downto 0);
            sel_B   : in std_logic_vector(2 downto 0);
            sel_D   : in std_logic_vector(2 downto 0);
            I_dataA : in std_logic_vector(15 downto 0);
            I_enA   : in std_logic;
            I_dataB : in std_logic_vector(15 downto 0);
            I_enB   : in std_logic;
            I_dataD : in std_logic_vector (15 downto 0);
            I_enD   : in std_logic;
            O_dataD : out std_logic_vector(15 downto 0);
            O_dataA : out std_logic_vector(15 downto 0);
            O_dataB : out std_logic_vector(15 downto 0)
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
    
    -- The register signals
    signal reg_enable : std_logic := '0';
    signal I_dataA, I_dataB, I_dataD : std_logic_vector(15 downto 0) := "0000000000000000";
    signal O_dataA, O_dataB, O_dataD : std_logic_vector(15 downto 0) := "0000000000000000";
    signal I_enA, I_enB, I_enD : std_logic := '0';

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
    
    reg_read_uut : registers port map (
        clk => clk,
        enable => reg_enable,
        sel_A => regA,
        sel_B => regB,
        sel_D => regD,
        I_dataA => I_dataA,
        I_dataB => I_dataB,
        I_dataD => I_dataD,
        O_dataA => O_dataA,
        O_dataB => O_dataB,
        O_dataD => O_dataD,
        I_enA => I_enA,
        I_enB => I_enB,
        I_enD => I_enD
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
    
        -- Our instructions
        type mem is array (0 to 2) of std_logic_vector(15 downto 0);
        variable mem_seg : mem := (
            "0101000000001010",     -- add r0, r1, r2
            "0100000011001100",     -- li r3, 12
            "0101001000101011"      -- sub r0, r6, r3
        );
    begin
        -- hold reset state for 100 ns.
        wait for 100 ns;  

        wait for clk_period*10;
        
        reset <= '1';

        -- Test code here
        reg_enable <= '0';
        reset <= '0';
        
        for i in 0 to 2 loop
            -- Stage 1: Decode
            reg_enable <= '0';
            instr <= mem_seg(i);
            wait until state(1) = '1';
            
            -- Stage 2: Register read
            I_enA <= '0';
            I_enB <= '0';
            I_enD <= '0';
            reg_enable <= '1';
            wait until state(2) = '1';
            
            -- Stage 3: Execute
            if opcode = "0100" then
                I_dataD(0) <= imm(0);
                I_dataD(1) <= imm(1);
                I_dataD(2) <= imm(2);
                I_dataD(3) <= imm(3);
                I_dataD(4) <= imm(4);
                I_dataD(5) <= imm(5);
            end if;
            
            wait until state(3) = '1';
            
            -- Stage 4: Register write
            I_enA <= '1';
            I_enB <= '1';
            I_enD <= '1';
            wait until state(0) = '1';
        end loop;
        
        wait;
        
    end process;
end Behavior;

