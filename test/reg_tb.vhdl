library ieee;
use ieee.std_logic_1164.ALL;
use ieee.numeric_std.ALL;
 
entity reg_tb is
end reg_tb;
 
architecture Behavior of reg_tb is 

    -- Declare our component
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
    
    -- Declare the signals
    signal clk : std_logic := '0';
    signal enable : std_logic := '1';
    signal I_enA, I_enB, I_enD : std_logic := '0';
    signal I_dataA, I_dataB, I_dataD : std_logic_vector(15 downto 0) := "0000000000000000";
    signal O_dataA, O_dataB, O_dataD : std_logic_vector(15 downto 0) := "0000000000000000";
    signal sel_A, sel_B, sel_D : std_logic_vector(2 downto 0) := "000";

    -- Clock period definitions
    constant clk_period : time := 10 ns;
begin

    -- Init the UUT (the registers to be tested)
    uut : registers port map (
        clk => clk,
        enable => enable,
        sel_A => sel_A,
        sel_B => sel_B,
        sel_D => sel_D,
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
    begin
        -- hold reset state for 100 ns.
        wait for 100 ns;  

        wait for clk_period*10;

        -- Test code here
        
        -- Set all r0, r1, r2 with 0xAB11, 0xAB22, and 0xAB33
        sel_A <= "000";
        sel_B <= "001";
        sel_D <= "010";
        I_dataA <= X"AB11";
        I_dataB <= X"AB22";
        I_dataD <= X"AB33";
        I_enA <= '1';
        I_enB <= '1';
        I_enD <= '1';
        wait for clk_period;
        
        -- Now, disable all three registers (read-only)
        -- Try a clear to make sure this works
        I_dataA <= X"0000";
        I_dataB <= X"0000";
        I_dataD <= X"0000";
        I_enA <= '0';
        I_enB <= '0';
        I_enD <= '0';
        wait for clk_period;
        
        -- Switch the registers
        sel_A <= "111";
        sel_B <= "110";
        sel_D <= "101";
        wait for clk_period;
        
        -- Now, switch back
        sel_A <= "000";
        sel_B <= "001";
        sel_D <= "010";
        wait for clk_period;
        
        -- Now raise the enable bit for A. This should clear it
        I_enA <= '1';
        wait for clk_period;
        
        -- Now raise for the other two. This should also clear
        I_enB <= '1';
        I_enD <= '1';
        wait for clk_period;

        wait;
    end process;
 
end;

