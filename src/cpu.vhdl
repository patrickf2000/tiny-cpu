library IEEE;
use IEEE.std_logic_1164.all;

entity CPU is
    port (
        clk : in std_logic;
        input : in std_logic_vector(15 downto 0);
        ready : out std_logic
    );
end CPU;

architecture Behavior of CPU is
    
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
            clk                 : in std_logic;
            enable              : in std_logic;
            instr               : in std_logic_vector(15 downto 0);
            opcode              : out std_logic_vector(3 downto 0);
            funct               : out std_logic_vector(2 downto 0);
            regD, regB, regA    : out std_logic_vector(2 downto 0);
            addr, imm           : out std_logic_vector(5 downto 0)
        );
    end component;
    
    -- The registers
    component registers is
        port(
            clk                         : in std_logic;
            enable                      : in std_logic;
            sel_D, sel_B, sel_A         : in std_logic_vector(2 downto 0);
            I_dataD, I_dataB, I_dataA   : in std_logic_vector(15 downto 0);
            I_enD, I_enB, I_enA         : in std_logic;
            O_dataD, O_dataB, O_dataA   : out std_logic_vector(15 downto 0)
        );
    end component;
    
    -- Signals
    signal current_state : std_logic_vector(3 downto 0) := "0000";
    signal en_decoder : std_logic := '0';
    signal reg_enable : std_logic := '0';
    
    -- The decoder signals
    signal instr : std_logic_vector(15 downto 0) := X"0000";
    signal opcode : std_logic_vector(3 downto 0) := X"0";
    signal funct, regA, regB, regD : std_logic_vector(2 downto 0) := "000";
    signal addr, imm : std_logic_vector(5 downto 0) := "000000";
    
    -- The register signals
    signal I_dataA, I_dataB, I_dataD : std_logic_vector(15 downto 0) := "0000000000000000";
    signal O_dataA, O_dataB, O_dataD : std_logic_vector(15 downto 0) := "0000000000000000";
    signal I_enA, I_enB, I_enD : std_logic := '0';
begin
    ctrl : Control port map (clk => clk, reset => '0', state => current_state);
    
    decode : Decoder port map (
        clk => clk,
        enable => en_decoder,
        instr => input,
        opcode => opcode,
        funct => funct,
        regD => regD,
        regB => regB,
        regA => regA,
        addr => addr,
        imm => imm
    );
    
    regs : Registers port map (
        clk => clk,
        enable => reg_enable,
        sel_D => regD,
        sel_B => regB,
        sel_A => regA,
        I_dataD => I_dataD,
        I_dataB => I_dataB,
        I_dataA => I_dataA,
        O_dataD => O_dataD,
        O_dataB => O_dataB,
        O_dataA => O_dataA,
        I_enD => I_enD,
        I_enB => I_enB,
        I_enA => I_enA
    );
    
    process (clk)
    begin
        case (current_state) is
            -- Decode
            when "0001" =>
                reg_enable <= '0';
                I_enD <= '0';
                en_decoder <= '1';
                ready <= '0';
            
            -- Register read
            when "0010" =>
                reg_enable <= '1';
                en_decoder <= '0';
                ready <= '0';
            
            -- Execute
            when "0100" =>
                reg_enable <= '0';
                ready <= '0';
                
                if opcode = "0100" then
                    I_dataD(0) <= imm(0);
                    I_dataD(1) <= imm(1);
                    I_dataD(2) <= imm(2);
                    I_dataD(3) <= imm(3);
                    I_dataD(4) <= imm(4);
                    I_dataD(5) <= imm(5);
                    I_enD <= '1';
                end if;
                
            -- Register write
            when "1000" =>
                reg_enable <= '1';
                ready <= '1';
            
            -- Error
            when others =>
                en_decoder <= '0';
                ready <= '1';
            
        end case;
    end process;
end Behavior;

