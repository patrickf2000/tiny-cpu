library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity ALU is
    port (
        clk     : in std_logic;                        -- Clock
        enable  : in std_logic;                        -- Enable the ALU
        opcode  : in std_logic_vector(2 downto 0);     -- ALU opcode
        inputB  : in std_logic_vector(15 downto 0);    -- Operand 1
        inputA  : in std_logic_vector(15 downto 0);    -- Operand 2
        output  : out std_logic_vector(15 downto 0)    -- Output
    );
end ALU;

architecture Behavior of ALU is
begin
    process (clk, enable)
    begin
        if enable = '1' then
            case opcode is
                when "000" => output <= std_logic_vector(unsigned(inputA) + unsigned(inputB));
                
                when "001" => output <= std_logic_vector(unsigned(inputA) - unsigned(inputB));
                
                when others => output <= X"00FF";
            end case;
        end if;
    end process;
end Behavior;

