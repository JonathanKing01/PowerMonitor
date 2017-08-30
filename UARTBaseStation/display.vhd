library IEEE;
use IEEE.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

-- write other comments here such as last update

entity display is
 port (
	clk : in std_logic;
	number_input:in std_logic_vector(15 downto 0);
	
	led_select_out:out std_logic_vector(3 downto 0):="0001";
	ledsegment_out: out std_logic_vector(6 downto 0);
	dp: out std_logic:= '0'
 );
end entity;
--Define architecture here
Architecture behavior of display is
signal led_select:std_logic_vector(3 downto 0):="0001";
signal ledsegment:std_logic_vector(6 downto 0);
SIGNAL counter:std_logic_vector (1 downto 0);
sigNAL bcd: std_logic_vector (3 downto 0):="0000";

signal debug_delay: integer := 0;
begin

counter_output:process(counter, number_input)
begin
	case counter is 
			when "00" => led_select <= "0001";  bcd <= number_input ( 3 downto 0); 
			when "01" => led_select <= "0010";  bcd <= number_input ( 7 downto 4) ; 
			when "10" => led_select <= "0100";  bcd <= number_input ( 11 downto 8) ;
			when "11" => led_select <= "1000";  bcd <= number_input ( 15 downto 12) ; 
	end case;
end process;

bcd_cycler:process ( bcd )
begin
	case bcd is
            when "0000"=> ledsegment <="0111111";  -- '0'
            when "0001"=> ledsegment <="0110000";  -- '1'
            when "0010"=> ledsegment <="1011011";  -- '2'
            when "0011"=> ledsegment <="1001111";  -- '3'
            when "0100"=> ledsegment <="1100110";  -- '4' 
            when "0101"=> ledsegment <="1101101";  -- '5' 
            when "0110"=> ledsegment <="1111101";  -- '6'
            when "0111"=> ledsegment <="0000111";  -- '7'
            when "1000"=> ledsegment <="1111111";  -- '8'
            when "1001"=> ledsegment <="1100111";  -- '9'
            when "1010"=> ledsegment <="0111110";  -- 'V'
            when "1011"=> ledsegment <="0111001";  -- 'C'
            when "1100"=> ledsegment <="1110011";  -- 'P'
            when "1101"=> ledsegment <="1111001";  -- 'E'
            when "1110"=> ledsegment <="0111000";  -- 'L'
            when others=> ledsegment <="1110110"; -- 'H'
	end case;
end process;
	
set_outputs: process (clk, led_select, ledsegment)
begin
	if clk'event and clk = '1' then
		led_select_out <= led_select;
		ledsegment_out <= ledsegment;
		if led_select = "0100" and number_input(15 downto 12) < 10 then
			dp <= '1';
		elsif led_select = "0010" and number_input(15 downto 12) > 9 then
			dp <= '1';
		else
			dp <= '0';
		end if;
	end if;
end process;	
	

		 
counter_process:process(clk)
begin
if clk'event and clk='1' then
if debug_delay = 10 then 
	if counter = "11" then 
		counter <= "00"; 
	else 
		counter <= counter + 1; 
	end if;
	debug_delay <= 0;
else
	debug_delay <= debug_delay + 1;
end if;
end if;
end process;
	
	
	
--segment7_units_decoder:process(number_input)
--
--begin
--if clk'event and clk='1' then
--	-- Cycle through each of the 4 segment displays and output the corresponding number in the input sting. 
--	-- If statements are used to avoid concurrent assignments of variables, which was causing errors
--	
--	if led_select = "1000" then
--	led_select_out <= "1000";
--	led_select <= "0100";
--	ledsegment <="0000000";
--	case number_input(3 downto 0) is
--            when "0000"=> ledsegment <="0111111";  -- '0'
--            when "0001"=> ledsegment <="0110000";  -- '1'
--            when "0010"=> ledsegment <="1011011";  -- '2'
--            when "0011"=> ledsegment <="1001111";  -- '3'
--            when "0100"=> ledsegment <="1100110";  -- '4' 
--            when "0101"=> ledsegment <="1101101";  -- '5'
--            when "0110"=> ledsegment <="1111101";  -- '6'
--            when "0111"=> ledsegment <="0000111";  -- '7'
--            when "1000"=> ledsegment <="1111111";  -- '8'
--            when "1001"=> ledsegment <="1100111";  -- '9'
--            when "1010"=> ledsegment <="1110111";  -- 'A'
--            when "1011"=> ledsegment <="1111100";  -- 'b'
--            when "1100"=> ledsegment <="0111001";  -- 'C'
--            when "1101"=> ledsegment <="1011110";  -- 'd'
--            when "1110"=> ledsegment <="1111001";  -- 'E'
--            when others=> ledsegment <="0111111"; -- '0'
--	end case;
--	ledsegment_out <= ledsegment;
--	
--	elsif led_select = "0100" then
--	led_select_out <= "0100";
--	led_select <= "0010";
--	ledsegment <="0000000";
--	case number_input(7 downto 4) is
--            when "0000"=> ledsegment <="0111111";  -- '0'
--            when "0001"=> ledsegment <="0110000";  -- '1'
--            when "0010"=> ledsegment <="1011011";  -- '2'
--            when "0011"=> ledsegment <="1001111";  -- '3'
--            when "0100"=> ledsegment <="1100110";  -- '4' 
--            when "0101"=> ledsegment <="1101101";  -- '5'
--            when "0110"=> ledsegment <="1111101";  -- '6'
--            when "0111"=> ledsegment <="0000111";  -- '7'
--            when "1000"=> ledsegment <="1111111";  -- '8'
--            when "1001"=> ledsegment <="1100111";  -- '9'
--            when "1010"=> ledsegment <="1110111";  -- 'A'
--            when "1011"=> ledsegment <="1111100";  -- 'b'
--            when "1100"=> ledsegment <="0111001";  -- 'C'
--            when "1101"=> ledsegment <="1011110";  -- 'd'
--            when "1110"=> ledsegment <="1111001";  -- 'E'
--            when others=> ledsegment <="0111111"; -- '0'
--	end case;
--	ledsegment_out <= ledsegment;
--	
--	elsif led_select = "0010"  then
--	led_select_out <= "0010";
--	led_select <= "0001";
--	ledsegment <="0000000";
--	case number_input(11 downto 8) is
--            when "0000"=> ledsegment <="0111111";  -- '0'
--            when "0001"=> ledsegment <="0110000";  -- '1'
--            when "0010"=> ledsegment <="1011011";  -- '2'
--            when "0011"=> ledsegment <="1001111";  -- '3'
--            when "0100"=> ledsegment <="1100110";  -- '4' 
--            when "0101"=> ledsegment <="1101101";  -- '5'
--            when "0110"=> ledsegment <="1111101";  -- '6'
--            when "0111"=> ledsegment <="0000111";  -- '7'
--            when "1000"=> ledsegment <="1111111";  -- '8'
--				
--            when "1001"=> ledsegment <="1100111";  -- '9'
--            when "1010"=> ledsegment <="1110111";  -- 'A'
--            when "1011"=> ledsegment <="1111100";  -- 'b'
--            when "1100"=> ledsegment <="0111001";  -- 'C'
--            when "1101"=> ledsegment <="1011110";  -- 'd'
--            when "1110"=> ledsegment <="1111001";  -- 'E'
--            when others=> ledsegment <="0111111"; -- '0'
--	end case;
--	ledsegment_out <= ledsegment;
--	
--	elsif led_select = "0001" then
--	led_select_out <= "0001";
--	led_select <= "1000";
--	ledsegment <="0000000";
--	case number_input(15 downto 12) is
--            when "0000"=> ledsegment <="0111111";  -- '0'
--            when "0001"=> ledsegment <="0110000";  -- '1'
--            when "0010"=> ledsegment <="1011011";  -- '2'
--            when "0011"=> ledsegment <="1001111";  -- '3'
--            when "0100"=> ledsegment <="1100110";  -- '4' 
--            when "0101"=> ledsegment <="1101101";  -- '5'
--            when "0110"=> ledsegment <="1111101";  -- '6'
--            when "0111"=> ledsegment <="0000111";  -- '7'
--            when "1000"=> ledsegment <="1111111";  -- '8'
--            when "1001"=> ledsegment <="1100111";  -- '9'
--            when "1010"=> ledsegment <="1110111";  -- 'A'
--            when "1011"=> ledsegment <="1111100";  -- 'b'
--            when "1100"=> ledsegment <="0111001";  -- 'C'
--            when "1101"=> ledsegment <="1011110";  -- 'd'
--            when "1110"=> ledsegment <="1111001";  -- 'E'
--            when others=> ledsegment <="0111111"; -- '0'
--	end case;
--	ledsegment_out <= ledsegment;
--	end if;
--end if;
--end process;
end architecture;