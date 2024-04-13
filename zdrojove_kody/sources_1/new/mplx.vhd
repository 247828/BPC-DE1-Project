library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL; -- Pou��v� se pro aritmetick� operace se sign�ly

entity mplx is
    Port ( 
        clk : in STD_LOGIC;
        reset : in STD_LOGIC;
        in_A : in STD_LOGIC_VECTOR(8 downto 0);
        in_Ad : in STD_LOGIC_VECTOR(2 downto 0);
        in_B : in STD_LOGIC_VECTOR(8 downto 0);
        in_Bd : in STD_LOGIC_VECTOR(2 downto 0);
        in_C : in STD_LOGIC_VECTOR(8 downto 0);
        in_Cd : in STD_LOGIC_VECTOR(2 downto 0);
        in_D : in STD_LOGIC_VECTOR(8 downto 0);
        in_Dd : in STD_LOGIC_VECTOR(2 downto 0);
        button : in STD_LOGIC;
        dis_out : out STD_LOGIC_VECTOR(8 downto 0);
        dev_out : out STD_LOGIC_VECTOR(2 downto 0)
    );
end mplx;

architecture Behavioral of mplx is
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
                -- P�id�no: reset button_edge p�i resetu
                button_edge <= '0';
            else
                -- Detekce n�b�n� hrany tla��tka
                if button = '1' and button_reg = '0' then
                    button_edge <= '1';
                else   
                    button_edge <= '0';
                end if;
                button_reg <= button;

                -- Zm�na v�b�ru vstupu pouze na n�b�n� hran�
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

    -- V�b�r vstupu pro v�stup 'echo'
    process(sig_select, in_A, in_B, in_C, in_D, in_Ad, in_Bd, in_Cd, in_Dd)
    begin
        case sig_select is
            when "00" =>
                dis_out <= in_A;
                dev_out <= in_Ad;
            when "01" =>
                dis_out <= in_B;
                dev_out <= in_Bd;
            when "10" =>
                dis_out <= in_C;
                dev_out <= in_Cd; 
            when "11" =>
                dis_out <= in_D;
                dev_out <= in_Dd;
            when others =>
                dis_out <= "000000000"; 
                dev_out <= "000";-- Bezpe�nostn� v�choz� stav
        end case;
    end process;
   
end Behavioral;