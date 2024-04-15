
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity seven_seg_disp_drv is
    port ( 
        in_data0 : in STD_LOGIC_VECTOR (3 downto 0);
        in_data1 : in STD_LOGIC_VECTOR (3 downto 0);
        in_data2 : in STD_LOGIC_VECTOR (3 downto 0);
        in_data3 : in STD_LOGIC_VECTOR (3 downto 0);
        in_data4 : in STD_LOGIC_VECTOR (3 downto 0);
        in_data5 : in STD_LOGIC_VECTOR (3 downto 0);
        in_data6 : in STD_LOGIC_VECTOR (3 downto 0);
        in_data7 : in STD_LOGIC_VECTOR (3 downto 0);
        in_dp : in STD_LOGIC_VECTOR (7 downto 0);
        seg : out STD_LOGIC_VECTOR (6 downto 0);
        dp : out STD_LOGIC;
        an : out STD_LOGIC_VECTOR (7 downto 0);
        clk : in STD_LOGIC;
        rst : in STD_LOGIC
    );
end seven_seg_disp_drv;

architecture Behavioral of seven_seg_disp_drv is
    -- lokálne sigály
    signal sig_count_pulse : STD_LOGIC;
    signal sig_chosen_in_data : STD_LOGIC_VECTOR (3 downto 0);  
    signal sig_count : INTEGER range 0 to 7;
    -- deklaracia komponentov 
    component clock_enable
        generic (
            PERIOD : integer
        );
        port ( 
            clk     : in STD_LOGIC;
            rst     : in STD_LOGIC;
            pulse   : out STD_LOGIC
        );
    end component;
    
    component bin2seg
        port (
            clear   : in STD_LOGIC;
            bin     : in STD_LOGIC_VECTOR (3 downto 0);
            seg     : out STD_LOGIC_VECTOR (6 downto 0));
    end component;
    begin
        count_pulse : clock_enable
            generic map (
                PERIOD => 5 -- 50 ns pre simulaciu, 100000 pre realitu
            )
            port map (
            clk     => clk,
            rst     => rst,
            pulse   => sig_count_pulse
            );

        display : bin2seg
            port map (
                clear => rst,
                bin => sig_chosen_in_data,
                seg => seg
            );
        --
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
        --
        choose_out : process(clk, rst) is
            begin
                if (rising_edge(clk)) then
                    if (rst = '1') then
                        sig_chosen_in_data  <= in_data0;
                        dp                  <= in_dp(0);
                        an                  <= "11111111";
                    else
                        case sig_count is
                            when 0 =>
                                sig_chosen_in_data  <= in_data0;
                                dp                  <= in_dp(0);
                                an                  <= "11111110";
                            when 1 =>
                                sig_chosen_in_data  <= in_data1;
                                dp                  <= in_dp(1);
                                an                  <= "11111101";
                            when 2 =>
                                sig_chosen_in_data  <= in_data2;
                                dp                  <= in_dp(2);
                                an                  <= "11111011";
                            when 3 =>
                                sig_chosen_in_data  <= in_data3;
                                dp                  <= in_dp(3);
                                an                  <= "11110111";
                            when 4 =>
                                sig_chosen_in_data  <= in_data4;
                                dp                  <= in_dp(4);
                                an                  <= "11101111";
                            when 5 =>
                                sig_chosen_in_data  <= in_data5;
                                dp                  <= in_dp(5);
                                an                  <= "11011111";
                            when 6 =>
                                sig_chosen_in_data  <= in_data6;
                                dp                  <= in_dp(6);
                                an                  <= "10111111";
                            when others =>
                                sig_chosen_in_data  <= in_data7;
                                dp                  <= in_dp(7);
                                an                  <= "01111111";                               
                        end case;
                    end if;
                end if;
        end process;
        
end Behavioral;
