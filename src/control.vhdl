library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity Control is
    port (
        clk : in std_logic;
        reset : in std_logic;
        state : out std_logic_vector(3 downto 0)
    );
end Control;

-- Our pipeline works like this:
-- 1) Decode
-- 2) Register read
-- 3) Execution
-- 4) Register write
--
architecture Behavior of Control is
    signal current_state : std_logic_vector(3 downto 0) := "0001";
begin
    process (clk)
    begin
        if rising_edge(clk) then
            if reset = '1' then
                current_state <= "0001";
            else
                case current_state is
                    when "0001" => current_state <= "0010";     -- Decode -> register read
                    when "0010" => current_state <= "0100";     -- Register read -> Execution
                    when "0100" => current_state <= "1000";     -- Execution -> Register write
                    when others => current_state <= "0001";     -- Register write -> decode
                end case;
            end if;
        end if;
    end process;
    
    state <= current_state;
end Behavior;
