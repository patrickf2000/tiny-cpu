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
    
    -- Signals
    signal current_state : std_logic_vector(3 downto 0) := "0000";
    signal en_decoder : std_logic := '1';
    
    -- The decoder signals
    signal instr : std_logic_vector(15 downto 0) := X"0000";
    signal opcode : std_logic_vector(3 downto 0) := X"0";
    signal funct, regA, regB, regD : std_logic_vector(2 downto 0) := "000";
    signal addr, imm : std_logic_vector(5 downto 0) := "000000";
begin
    ctrl : Control port map (clk => clk, reset => '0', state => current_state);
    
    decode : Decoder port map(
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
    
    process (clk)
    begin
        case (current_state) is
            -- Decode
            when "0001" =>
                en_decoder <= '1';
                ready <= '0';
            
            -- Register read
            when "0010" =>
                en_decoder <= '0';
                ready <= '0';
            
            -- Execute
            when "0100" =>
                ready <= '0';
                
            -- Register write
            when "1000" =>
                ready <= '1';
            
            -- Error
            when others =>
                en_decoder <= '0';
                ready <= '1';
            
        end case;
    end process;
end Behavior;

