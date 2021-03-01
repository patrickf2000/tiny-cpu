library IEEE;
use IEEE.std_logic_1164.all;

entity CPU is
    port (
        clk : in std_logic;
        instr : in std_logic_vector(15 downto 0);
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
    
    -- Signals
    signal current_state : std_logic_vector(3 downto 0) := "0000";
begin
    ctrl : Control port map (clk => clk, reset => '0', state => current_state);
    
    process (clk)
    begin
        case (current_state) is
            -- Decode
            when "0001" =>
                ready <= '0';
            
            -- Register read
            when "0010" =>
                ready <= '0';
            
            -- Execute
            when "0100" =>
                ready <= '0';
                
            -- Register write
            when "1000" =>
                ready <= '1';
            
            -- Error
            when others => ready <= '1';
        end case;
    end process;
end Behavior;

