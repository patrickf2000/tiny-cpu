library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_signed.all;
use std.textio.all;

entity cpu_tb is
end cpu_tb;

architecture Behavior of cpu_tb is

    component CPU is
        port (
            clk : in std_logic;
            input : in std_logic_vector(15 downto 0);
            ready : out std_logic;
            out_ready : out std_logic;
            out_data : out std_logic_vector(15 downto 0)
        );
    end component;
    
    -- Signals
    signal clk, ready, out_ready : std_logic := '0';
    signal instr, out_data : std_logic_vector(15 downto 0) := X"0000";
    
    -- Clock period definitions
    constant clk_period : time := 10 ns;
begin
    uut : CPU port map (
        clk => clk,
        input => instr,
        ready => ready,
        out_ready => out_ready,
        out_data => out_data
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
        type mem is array (0 to 5) of std_logic_vector(15 downto 0);
        variable mem_seg : mem := (
            --"0101001000101011"      -- sub r0, r6, r3
            "0100" & "000" & "011" & "001100",          -- li r3, 12
            "0100" & "000" & "000" & "000001",          -- li r0, 1
            "0101" & "000" & "010" & "000" & "011",     -- add r2, r0, r3
            "0111" & "000" & "010" & "000000",          -- out r2
            "0101" & "001" & "010" & "000" & "011",     -- sub r2, r0, r3
            "0111" & "000" & "010" & "000000"           -- out r2
        );
        
        variable ln : Line;
        variable out_num : integer;
    begin
        -- hold reset state for 100 ns.
        wait for 100 ns;
        wait for clk_period;
        wait until ready = '1';

        --wait for clk_period*10;
        
        -- Test
        for i in 0 to 5 loop
            instr <= mem_seg(i);
            
            wait until ready = '1';
            
            if out_ready = '1' then
                out_num := conv_integer(out_data);
                
                write(ln, String'("--> "));
                write(ln, to_bitvector(out_data));
                write(ln, String'(" | "));
                write(ln, out_num);
                writeline(output, ln);
            end if;
        end loop;
        
        wait;
    end process;
end Behavior;

