library IEEE;
use IEEE.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

-- 30/8 Added comments to help understand code

entity display is
 port (
	clk : in std_logic;
	number_input:in std_logic_vector(15 downto 0);
	
	led_select_out:out std_logic_vector(3 downto 0):="0001";
	ledsegment_out: out std_logic_vector(6 downto 0);
	dp: out std_logic:= '0'
 );
end entity;

Architecture behavior of display is
signal led_select:std_logic_vector(3 downto 0):="0001";
signal ledsegment:std_logic_vector(6 downto 0);
SIGNAL counter:std_logic_vector (1 downto 0);
sigNAL bcd: std_logic_vector (3 downto 0):="0000";
signal debug_delay: integer := 0;

begin

-- We use this counter to iterate through the 4 7-segment displays.
-- we use the extra debug delay loop to slow down the whole display process slighly, to avoid an related "Ghosting" errors
-- "Ghosting" refers to numbers in one place being shown faintly in the place to their left, because the segments were cycling too quickly.
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

-- This process changes the led_select and the bcd value as the counter changes.
-- led_select is used to select the 7-segment display we will write to, bcd select the number to use from the input stream.
counter_output:process(counter, number_input)
begin
	case counter is 
			when "00" => led_select <= "0001";  bcd <= number_input ( 3 downto 0); 
			when "01" => led_select <= "0010";  bcd <= number_input ( 7 downto 4) ; 
			when "10" => led_select <= "0100";  bcd <= number_input ( 11 downto 8) ;
			when "11" => led_select <= "1000";  bcd <= number_input ( 15 downto 12) ; 
	end case;
end process;


-- This is the 7 seg decoder for the bcd variable. We have extra letters for Voltage, Current, Power, Extra, Low and High.
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
	
-- This process pushes the interior signals to the outputs. The if statemtents determine where to put the decimal place, depending on the current mode of display.
-- If we are currently in the mode that displays a letter for the mode on the left, then we can tell by seeing if the left most character in the input srting is greater than 10
-- This is not a very clean way of doing this - I intned to chnage it soon.
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
	

		 

end architecture;