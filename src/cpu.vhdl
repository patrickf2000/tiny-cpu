library IEEE;
use IEEE.std_logic_1164.all;

entity CPU is
    port (
        clk : in std_logic;
        reset : in std_logic;
        input : in std_logic_vector(96 downto 0);
        ready : out std_logic;
        halt : out std_logic;
        out_ready : out std_logic;
        out_data : out std_logic_vector(15 downto 0)
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
            I_enD                       : in std_logic;
            O_dataD, O_dataB, O_dataA   : out std_logic_vector(15 downto 0)
        );
    end component;
    
    -- The ALU component
    component ALU is
        port (
            clk     : in std_logic;
            enable  : in std_logic;
            opcode  : in std_logic_vector(2 downto 0);
            inputB  : in std_logic_vector(15 downto 0);
            inputA  : in std_logic_vector(15 downto 0);
            output  : out std_logic_vector(15 downto 0)
        );
    end component;
    
    -- Signals
    signal output_data : std_logic_vector(15 downto 0) := X"0000";
    signal current_state : std_logic_vector(3 downto 0) := "0000";
    signal en_decoder : std_logic := '0';
    signal reg_enable : std_logic := '0';
    signal alu_enable : std_logic := '0';
    
    signal instr : std_logic_vector(15 downto 0) := X"0000";
    signal PC : integer := 0;
    
    -- The decoder signals
    signal opcode : std_logic_vector(3 downto 0) := X"0";
    signal funct, regA, regB, regD : std_logic_vector(2 downto 0) := "000";
    signal addr, imm : std_logic_vector(5 downto 0) := "000000";
    
    -- The register signals
    signal I_dataA, I_dataB, I_dataD : std_logic_vector(15 downto 0) := "0000000000000000";
    signal O_dataA, O_dataB, O_dataD : std_logic_vector(15 downto 0) := "0000000000000000";
    signal I_enD : std_logic := '0';
    
    -- ALU signals
    signal alu_dataA, alu_dataB, alu_dataD : std_logic_vector(15 downto 0) := X"0000";
begin
    ctrl : Control port map (clk => clk, reset => reset, state => current_state);
    
    decode : Decoder port map (
        clk => clk,
        enable => en_decoder,
        instr => instr,
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
        I_enD => I_enD
    );
    
    alu_unit : ALU port map (
        clk => clk,
        enable => alu_enable,
        opcode => funct,
        inputB => alu_dataB,
        inputA => alu_dataA,
        output => alu_dataD
    );
    
    process (clk)
    begin
        if rising_edge(clk) then
            if reset = '1' then
                PC <= 0;
                ready <= '1';
                halt <= '0';
            else
                case (current_state) is
                    -- Decode
                    when "0001" =>
                        reg_enable <= '0';
                        I_enD <= '0';
                        ready <= '0';
                        out_ready <= '0';
                        alu_enable <= '0';
                        
                        instr(0) <= input(PC);
                        instr(1) <= input(PC+1);
                        instr(2) <= input(PC+2);
                        instr(3) <= input(PC+3);
                        instr(4) <= input(PC+4);
                        instr(5) <= input(PC+5);
                        instr(6) <= input(PC+6);
                        instr(7) <= input(PC+7);
                        instr(8) <= input(PC+8);
                        instr(9) <= input(PC+9);
                        instr(10) <= input(PC+10);
                        instr(11) <= input(PC+11);
                        instr(12) <= input(PC+12);
                        instr(13) <= input(PC+13);
                        instr(14) <= input(PC+14);
                        instr(15) <= input(PC+15);
                        
                        en_decoder <= '1';
                    
                    -- Register read
                    when "0010" =>
                        reg_enable <= '1';
                        en_decoder <= '0';
                        ready <= '0';
                    
                    -- Execute
                    when "0100" =>
                        reg_enable <= '0';
                        ready <= '0';
                        
                        -- LI
                        if opcode = "0100" then
                            I_dataD(0) <= imm(0);
                            I_dataD(1) <= imm(1);
                            I_dataD(2) <= imm(2);
                            I_dataD(3) <= imm(3);
                            I_dataD(4) <= imm(4);
                            I_dataD(5) <= imm(5);
                            I_enD <= '1';
                            
                        -- ALU
                        elsif opcode = "0101" then
                            alu_dataA <= O_dataA;
                            alu_dataB <= O_dataB;
                            alu_enable <= '1';
                            I_enD <= '1';
                            
                        -- OUT
                        elsif opcode = "0111" then
                            output_data <= O_dataD;
                            out_ready <= '1';
                        end if;
                        
                    -- Register write
                    when "1000" =>
                        if alu_enable = '1' then
                            I_dataD <= alu_dataD;
                        end if;
                        
                        if PC + 16 >= 95 then
                            halt <= '1';
                        else
                            halt <= '0';
                            PC <= PC + 16;
                        end if;
                        
                        alu_enable <= '0';
                        reg_enable <= '1';
                        ready <= '1';
                    
                    -- Error
                    when others =>
                        en_decoder <= '0';
                        out_ready <= '0';
                        ready <= '1';
                    
                end case;
            end if;
        end if;
    end process;
    
    out_data <= output_data;
end Behavior;

