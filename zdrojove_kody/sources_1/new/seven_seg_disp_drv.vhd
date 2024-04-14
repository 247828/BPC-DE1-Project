
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity seven_seg_disp_drv is
    port ( 
        clk                 : in STD_LOGIC; -- hodiny
        rst                 : in STD_LOGIC; -- synchronny reset aktivny v urovni HIGH
        -- vstupne udaje: binarke cislo, pozicie desatinnych bodiek a viditelnost segmentov
        in_data0            : in STD_LOGIC_VECTOR (3 downto 0);
        in_data1            : in STD_LOGIC_VECTOR (3 downto 0);
        in_data2            : in STD_LOGIC_VECTOR (3 downto 0);
        in_data3            : in STD_LOGIC_VECTOR (3 downto 0);
        in_data4            : in STD_LOGIC_VECTOR (3 downto 0);
        in_data5            : in STD_LOGIC_VECTOR (3 downto 0);
        in_data6            : in STD_LOGIC_VECTOR (3 downto 0);
        in_data7            : in STD_LOGIC_VECTOR (3 downto 0);
        in_dp               : in STD_LOGIC_VECTOR (7 downto 0);
        in_visible_digits   : in STD_LOGIC_VECTOR(7 downto 0);
        -- vystup pre sedem segmentove displeje dosky Nexys A7-50T
        seg                 : out STD_LOGIC_VECTOR (6 downto 0);
        dp                  : out STD_LOGIC;
        an                  : out STD_LOGIC_VECTOR (7 downto 0)   
    );
end seven_seg_disp_drv;

architecture Behavioral of seven_seg_disp_drv is
    -- lokálne sigály
    signal sig_count_pulse : STD_LOGIC;
    signal sig_chosen_in_data : STD_LOGIC_VECTOR (3 downto 0);  
    signal sig_count : INTEGER range 0 to 7;

    begin

        count_pulse : entity work.clock_enable
            generic map (
                PERIOD => 100000 -- 5 - 50 ns pre simulaciu, 100000 - 1 ms pre realitu
            )
            port map (
            clk     => clk,
            rst     => rst,
            pulse   => sig_count_pulse
            );
        display : entity work.bin2seg
        
            port map (
                clear => rst,
                bin => sig_chosen_in_data,
                seg => seg
            );
        -- Procesy
        -- Pocitadlo s pricitanim po urcitej dobre
        count : process(clk, rst) is
            begin
                if (rising_edge(clk)) then
                    if (rst = '1') then
                        sig_count <= 0;
                    elsif (sig_count_pulse = '1' and sig_count = 7) then
                        sig_count <= 0;
                    elsif (sig_count_pulse = '1') then
                        sig_count <= sig_count + 1;
                    end if;
                end if;
        end process;
        -- Vyber konkretneho segmentu a zobrazenie jeho udaju
        choose_seg : process(clk, rst) is
            begin
                if (rising_edge(clk)) then
                    if (rst = '1') then
                        sig_chosen_in_data  <= in_data0;
                        dp <= in_dp(0);
                        an <= "11111111";
                    else
                        case sig_count is
                            when 0 =>
                                sig_chosen_in_data  <= in_data0;
                                dp <= in_dp(0);
                                if (in_visible_digits(0) = '0') then -- ak ma byt pozicia vypnuta
                                    an <= "11111111"; -- tak vypni
                                else 
                                    an <= "11111110"; -- inak zobraz
                                end if;
                            when 1 =>
                                sig_chosen_in_data  <= in_data1;
                                dp <= in_dp(1);
                                if (in_visible_digits(1) = '0') then
                                    an <= "11111111";
                                else
                                    an <= "11111101";
                                end if;
                            when 2 =>
                                sig_chosen_in_data  <= in_data2;
                                dp <= in_dp(2);
                                if (in_visible_digits(2) = '0') then
                                    an <= "11111111";
                                else
                                    an <= "11111011";
                                end if;
                            when 3 =>
                                sig_chosen_in_data  <= in_data3;
                                dp <= in_dp(3);
                                if (in_visible_digits(3) = '0') then
                                    an <= "11111111";
                                else
                                    an <= "11110111";
                                end if;
                            when 4 =>
                                sig_chosen_in_data  <= in_data4;
                                dp <= in_dp(4);
                                if (in_visible_digits(4) = '0') then
                                    an <= "11111111";
                                else
                                    an <= "11101111";
                                end if;
                            when 5 =>
                                sig_chosen_in_data  <= in_data5;
                                dp <= in_dp(5); 
                                if (in_visible_digits(5) = '0') then
                                    an <= "11111111";
                                else
                                    an <= "11011111";
                                end if;
                            when 6 =>
                                sig_chosen_in_data  <= in_data6;
                                dp <= in_dp(6);
                                if (in_visible_digits(6) = '0') then
                                    an <= "11111111";
                                else
                                    an <= "10111111";
                                end if;
                            when others =>
                                sig_chosen_in_data  <= in_data7;
                                dp <= in_dp(7);
                                if (in_visible_digits(7) = '0') then
                                    an <= "11111111";
                                else
                                    an <= "01111111";
                                end if;                               
                        end case;
                    end if;
                end if;
        end process;
end Behavioral;