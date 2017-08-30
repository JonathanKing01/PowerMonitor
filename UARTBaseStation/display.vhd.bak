library IEEE;
use IEEE.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

-- write other comments here such as last update

entity segment_display is
 port (
	clk : in std_logic;
	number_input:in std_logic_vector(15 downto 0);
	
	led_select_out:out std_logic_vector(3 downto 0):="0001";
	COUnter_out:out std_logic_vector(1 downto 0):="00";
	ledsegment_out: out std_logic_vector(6 downto 0)
 );
end entity;
--Define architecture here
Architecture behavior of segment_display is
signal led_select:std_logic_vector(3 downto 0):="0001";
signal ledsegment:std_logic_vector(6 downto 0);
SIGNAL counter:std_logic_vector (1 downto 0);
sigNAL bcd: std_logic_vector (3 downto 0):="0000";
begin

led_select_out <= "0001" when counter = "00" else
				  "0010" when counter = "01" else
				  "0100" when counter = "10" else
				  "1000" when counter = "11";
				  
bcd <= number_input ( 3 downto 0)  when counter = "00" else
		 number_input ( 7 downto 4)  when counter = "01" else
		 number_input ( 11 downto 8)  when counter = "10" else
		 number_input ( 15 downto 12)  when counter = "11";
		 
		 
counter_process:process(clk)
begin
	if counter = "11" then 
		counter <= "00"; 
	else 
		counter <= counter + 1; 
	end if;
	COUnter_out <= counter;
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
            when "1010"=> ledsegment <="1110111";  -- 'A'
            when "1011"=> ledsegment <="1111100";  -- 'b'
            when "1100"=> ledsegment <="0111001";  -- 'C'
            when "1101"=> ledsegment <="1011110";  -- 'd'
            when "1110"=> ledsegment <="1111001";  -- 'E'
            when others=> ledsegment <="0111111"; -- '0'
	end case;
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