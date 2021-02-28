library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity registers is
    port(
        clk     : in std_logic;                           -- Clock
        enable  : in std_logic;                           -- The enable bit
        sel_A   : in std_logic_vector(2 downto 0);        -- Source 1
        sel_B   : in std_logic_vector(2 downto 0);        -- Source 2
        sel_D   : in std_logic_vector(2 downto 0);        -- The destination register
        I_dataA : in std_logic_vector(15 downto 0);       -- Data input for source 1 (reg A)
        I_enA   : in std_logic;                           -- Enable writing to A
        I_dataB : in std_logic_vector(15 downto 0);       -- Data input for source 2 (reg B)
        I_enB   : in std_logic;                           -- Enable writing to B
        I_dataD : in std_logic_vector (15 downto 0);      -- Data input for destination
        I_enD   : in std_logic;                           -- Enable writing to register D
        O_dataD : out std_logic_vector(15 downto 0);      -- The data in the destination register (reg D)
        O_dataA : out std_logic_vector(15 downto 0);      -- The data in register A
        O_dataB : out std_logic_vector(15 downto 0)       -- The data in register B
    );
end registers;

architecture Behavior of registers is
    type register_file is array (0 to 7) of std_logic_vector(15 downto 0);
    signal regs : register_file := (others => "0000000000000000");
begin
    process (clk)
    begin
        if enable = '1' then
            O_dataA <= regs(to_integer(unsigned(sel_A)));
            O_dataB <= regs(to_integer(unsigned(sel_B)));
            O_dataD <= regs(to_integer(unsigned(sel_D)));
            
            -- If enabled, write to register A
            if I_enA = '1' then
                regs(to_integer(unsigned(sel_A))) <= I_dataA;
            end if;
            
            -- If enabled, write to register B
            if I_enB = '1' then
                regs(to_integer(unsigned(sel_B))) <= I_dataB;
            end if;
            
            -- If enabled, write to register D
            if I_enD = '1' then
                regs(to_integer(unsigned(sel_D))) <= I_dataD;
            end if;
        end if;
    end process;
end Behavior;
