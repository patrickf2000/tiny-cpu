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
            reset : in std_logic;
            input : in std_logic_vector(96 downto 0);
            ready : out std_logic;
            halt : out std_logic;
            out_ready : out std_logic;
            out_data : out std_logic_vector(15 downto 0)
        );
    end component;
    
    -- Signals
    signal clk, reset, ready, halt, out_ready : std_logic := '0';
    signal out_data : std_logic_vector(15 downto 0) := X"0000";
    signal instr : std_logic_vector(96 downto 0) :=
        X"0000" & X"0000" & X"0000" & X"0000" & X"0000" & X"0000" & "0";
    
    -- Clock period definitions
    constant clk_period : time := 10 ns;
begin
    uut : CPU port map (
        clk => clk,
        reset => reset,
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
        variable mem_seg : std_logic_vector(96 downto 0) :=
            "0"
            & "0111" & "000" & "010" & "000000"           -- out r2
            & "0101" & "001" & "010" & "000" & "011"      -- sub r2, r0, r3
            & "0111" & "000" & "010" & "000000"           -- out r2
            & "0101" & "000" & "010" & "000" & "011"      -- add r2, r0, r3
            & "0100" & "000" & "000" & "000001"           -- li r0, 1
            & "0100" & "000" & "011" & "001100"           -- li r3, 12
        ;
        
        variable ln : Line;
        variable out_num : integer;
    begin
        -- hold reset state for 100 ns.
        wait for 100 ns;
        wait for clk_period;
        reset <= '1';
        wait until ready = '1';
        reset <= '0';
        
        instr <= mem_seg;
        
        while halt = '0' loop
            wait until out_ready = '1';
            out_num := conv_integer(out_data);
            
            write(ln, String'("--> "));
            write(ln, to_bitvector(out_data));
            write(ln, String'(" | "));
            write(ln, out_num);
            writeline(output, ln);
        end loop;
        
        wait;
    end process;
end Behavior;

