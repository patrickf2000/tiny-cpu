library IEEE;
use IEEE.std_logic_1164.all;

entity control_tb1 is
end control_tb1;

architecture Behavior of control_tb1 is

    -- Declare the component
    component Control is
        port (
            clk : in std_logic;
            reset : in std_logic;
            state : out std_logic_vector(3 downto 0)
        );
    end component;

    -- The signals
    signal clk, reset : std_logic := '0';
    signal state : std_logic_vector(3 downto 0) := "0000";

    -- Clock period definitions
    constant clk_period : time := 10 ns;
begin

    uut : Control port map (
        clk => clk,
        reset => reset,
        state => state
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
        wait for clk_period;
        wait for clk_period;
        wait for clk_period;
        wait for clk_period;
        
    end process;
end Behavior;
