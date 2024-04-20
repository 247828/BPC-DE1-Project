library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL; -- Pouívá se pro aritmetické operace se signály

entity mplx is
	port ( 
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
	-- lokální signály
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
				button_edge <= '0';               
			end if;
			if button = '1' and button_reg = '0' then
				button_edge <= '1';
			else   
				button_edge <= '0';               
			end if;
			button_reg <= button;

			if button_edge = '1' then
				if sig_select = "11" then
					sig_select <= "00";
				else
					sig_select <= std_logic_vector(unsigned(sig_select) + 1);
				end if;
			end if;
		end if;
	end process;

	-- Výb?r vstupu pro výstup 'echo'
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
				dev_out <= "000";-- Bezpe?nostní výchozí stav
		end case;
	end process;
end Behavioral;
