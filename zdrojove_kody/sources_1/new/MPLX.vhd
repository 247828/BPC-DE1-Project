library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL; -- Používá se pro aritmetické operace se signály

entity MPLX is
    Port ( 
        clk : in STD_LOGIC;
        reset : in STD_LOGIC;
        in_A : in STD_LOGIC;
        in_B : in STD_LOGIC;
        in_C : in STD_LOGIC;
        in_D : in STD_LOGIC;
        button : in STD_LOGIC;
        echo : out STD_LOGIC
    );
end MPLX;

architecture Behavioral of MPLX is
    signal sig_select : std_logic_vector(1 downto 0);
    signal button_edge : std_logic := '0';
    signal button_reg : std_logic := '0';
begin
    process(clk)   
    begin
        if rising_edge(clk) then
            -- Reset logika
            if reset = '1' then
                sig_select <= "00";
                button_reg <= '0';
                -- Přidáno: reset button_edge při resetu
                button_edge <= '0';
            else
                -- Detekce náběžné hrany tlačítka
                if button = '1' and button_reg = '0' then
                    button_edge <= '1';
                else   
                    button_edge <= '0';
                end if;
                button_reg <= button;

                -- Změna výběru vstupu pouze na náběžné hraně
                if button_edge = '1' then
                    if sig_select = "11" then
                        sig_select <= "00";
                    else
                        sig_select <= std_logic_vector(unsigned(sig_select) + 1);
                    end if;
                end if;
            end if;      
        end if;
    end process;

    -- Výběr vstupu pro výstup 'echo'
    process(sig_select, in_A, in_B, in_C, in_D)
    begin
        case sig_select is
            when "00" =>
                echo <= in_A;
            when "01" =>
                echo <= in_B;
            when "10" =>
                echo <= in_C; 
            when "11" =>
                echo <= in_D;
            when others =>
                echo <= '0'; -- Bezpečnostní výchozí stav
        end case;
    end process;
   
end Behavioral;
