library IEEE;
use IEEE.std_logic_1164.all;

entity cpu_tb is
end cpu_tb;

architecture Behavior of cpu_tb is

    component CPU is
        port (
            clk : in std_logic;
            input : in std_logic_vector(15 downto 0);
            ready : out std_logic
        );
    end component;
    
    -- Signals
    signal clk, ready : std_logic := '0';
    signal instr : std_logic_vector(15 downto 0) := X"0000";
    
    -- Clock period definitions
    constant clk_period : time := 10 ns;
begin
    uut : CPU port map (
        clk => clk,
        input => instr,
        ready => ready
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
            --"0101000000001010",     -- add r0, r1, r2
            --"0101001000101011"      -- sub r0, r6, r3
            "0100000011001100",     -- li r3, 12
            "0100000000000001",     -- li r0, 1
            "0100000010000100"      -- li r2, 4
        );
    begin
        -- hold reset state for 100 ns.
        wait for 100 ns;  

        wait for clk_period*10;
        
        -- Test
        for i in 0 to 2 loop
            instr <= mem_seg(i);
            wait until ready = '1';
        end loop;
        
        wait;
    end process;
end Behavior;

