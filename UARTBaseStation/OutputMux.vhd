library IEEE;
use IEEE.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use IEEE.numeric_std.all;

-- 30/8 Added comments to help understand code

entity OutputMux is
 port (
	clk : in std_logic;
	PB_lact: in std_logic:= '0';
	PB1_lact: in std_logic:='0';
	
	DataInVoltage: in std_logic_vector(15 downto 0);
	DataInCurrent: in std_logic_vector(15 downto 0);
	DataInPower: in std_logic_vector(15 downto 0);
	DataInExtra: in std_logic_vector(15 downto 0);
	
	DataOut: out std_logic_vector(15 downto 0):="0000000000000000"
 );
end entity;

Architecture behavior of OutputMux is
signal Output_select: std_logic_vector(1 downto 0):="01";
signal change_output: std_logic:= '0';
signal Output_style: std_logic:='1';
signal change_style: std_logic:= '0';

signal polling_counter: integer:= 0;
signal style_counter: integer:= 0;

signal CS, NS, CS1, NS1, PB, PB1: std_logic:= '0';


begin

-- Buttons on the CPLD are low-active, so I chose to invert their inputs for ease of use.
PB <= not PB_lact;
PB1 <= not PB1_lact;

------------------------------------------------------------

--			Debouncers

------------------------------------------------------------

PBdebouncer:process (Output_select, PB, polling_counter)
begin
	if clk'event and clk = '1' then
	
		change_output <= '0';
		
		-- These two variables store the last two clock tick's values of the button PB
		CS <= NS;
		NS <= PB;
		
		-- If the last two clock tick's values for PB are both 1, there appears to be a stable press, so we enble the counter.
		if (CS = NS) and CS = '1' then 
			polling_counter <= polling_counter + 1;
		else		-- If the two values differ, it means the button is bouncing, so we reset the counter
			polling_counter <= 0;
		end if;
		
		-- If the counter reaches a set value (100000), it will register the button press.
		if polling_counter = 100000	then
			change_output <= '1';
			polling_counter <= 0;
		end if;
	
	
	-- This code has the potential unwanted behavior of cycling continuously if the button is held down. For now we are keeping it that way, but we are aware it is there.
	end if;
end process;

-- This debouncer is the same as the one above, but set the "style" variable instead. This determines if we are sending 3 numbers with a identification letter, or just 4 numbers
PB1debouncer:process (PB1, style_counter)
begin
	if clk'event and clk = '1' then
	
		change_style <= '0';
		
		CS1 <= NS1;
		NS1 <= PB1;
		
		if (CS1 = NS1) and CS1 = '1' then 
			style_counter <= style_counter + 1;
		else
			style_counter <= 0;
		end if;
		
		if style_counter = 100000	then
			change_style <= '1';
			style_counter <= 0;
		end if;
		
	end if;
end process;

------------------------------------------------------------

--			Button responses (Datapath)

------------------------------------------------------------

-- This cycles the output across each of the four inputs when a button press is detected.
-- The conditional does not allow access to the 4th register yet, as we do not yet have anything to store there.
output_changer:process (change_output, Output_select)
begin
	if clk'event and clk='1' then
		if change_output = '1' then
			if output_select = "10" then
				output_select <= "00";
			else
				output_select <= output_select + 1; 
			end if;
		end if;
	end if;
end process;

--This cycles the output style variable (used below), when the style button is pressed.
style_changer:process (change_style, Output_select)
begin
	if clk'event and clk='1' then
		if change_style = '1' then
			if output_style = '1' then
				output_style <= '0';
			else
				output_style <= '1'; 
			end if;
		end if;
	end if;
end process;


------------------------------------------------------------

--			Output to display

------------------------------------------------------------


-- Here we are using a mux to decide which output to send to the display. 
-- The if statement determines which style we are sending.
-- If we are sending the style with a parameter character, we first hardcode the values that correspond tot he correct letters 
-- in the 7seg decoder into the left most place on the output vector.
-- We then take the three most significant places, and place them in the remaining three places in the output vector.
store_input:process (DataInVoltage, DataInCurrent, DataInPower, DataInExtra, Output_select, output_style)
begin
	if clk'event and clk='1' then
		if output_style = '1' then
			case Output_select is
				when "00" =>
					DataOut(15 downto 12) <= "1010";
					DataOut(11 downto 0) <= DataInVoltage(15 downto 4);
				when "01" =>
					DataOut(15 downto 12) <= "1011";
					DataOut(11 downto 0) <= DataInCurrent(15 downto 4);
				when "10" =>
					DataOut(15 downto 12) <= "1100";
					DataOut(11 downto 0) <= DataInPower(15 downto 4);
				when "11" =>
					DataOut(15 downto 12) <= "1101"; 
					DataOut(11 downto 0) <= DataInExtra(15 downto 4);
			end case;
		else
			case Output_select is
				when "00" =>
					DataOut <= DataInVoltage;
				when "01" =>
					DataOut <= DataInCurrent;
				when "10" =>
					DataOut <= DataInPower;
				when "11" =>
					DataOut <= DataInExtra;
			end case;
		end if;
	end if;
end process;

end architecture;