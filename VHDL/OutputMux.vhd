library IEEE;
use IEEE.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use IEEE.numeric_std.all;

-- write other comments here such as last update

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

--Define architecture here
Architecture behavior of OutputMux is
signal Output_select: std_logic_vector(2 downto 0):="001";
signal change_output: std_logic:= '0';
signal Output_style: std_logic:='1';
signal change_style: std_logic:= '0';

signal polling_counter: integer:= 0;
signal style_counter: integer:= 0;

signal CS, NS, CS1, NS1, PB, PB1: std_logic:= '0';


begin

PB <= not PB_lact;
PB1 <= not PB1_lact;

------------------------------------------------------------

--			Debouncers

------------------------------------------------------------
PBdebouncer:process (Output_select, PB, polling_counter)
begin
	if clk'event and clk = '1' then
	
	change_output <= '0';
	
	CS <= NS;
	NS <= PB;
	
	if (CS = NS) and CS = '1' then 
		polling_counter <= polling_counter + 1;
	else
		polling_counter <= 0;
	end if;
	
	if polling_counter = 100000	then
		change_output <= '1';
		polling_counter <= 0;
	end if;
	
	end if;
end process;

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


output_changer:process (change_output, Output_select)
begin
if clk'event and clk='1' then
	if change_output = '1' then
		if output_select = "010" then
			output_select <= "000";
		else
			output_select <= output_select + 1; 
		end if;
	end if;
end if;
end process;

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

store_input:process (DataInVoltage, DataInCurrent, DataInPower, DataInExtra, Output_select, output_style)
begin
if clk'event and clk='1' then
	
	if output_style = '1' then
		case Output_select is
		when "000" =>
			DataOut(15 downto 12) <= "1010";
			DataOut(11 downto 0) <= DataInVoltage(15 downto 4);
		when "001" =>
			DataOut(15 downto 12) <= "1011";
			DataOut(11 downto 0) <= DataInCurrent(15 downto 4);
		when "010" =>
			DataOut(15 downto 12) <= "1100";
			DataOut(11 downto 0) <= DataInPower(15 downto 4);
		when "011" =>
			DataOut(15 downto 12) <= "1101"; 
			DataOut(11 downto 0) <= DataInExtra(15 downto 4);
		when others => 
			DataOut(15 downto 12) <= "1011";
			DataOut(11 downto 0) <= DataInCurrent(15 downto 4);
		end case;
	else
	case Output_select is
		when "000" =>
			DataOut <= DataInVoltage;
		when "001" =>
			DataOut <= DataInCurrent;
		when "010" =>
			DataOut <= DataInPower;
		when "011" =>
			DataOut <= DataInExtra;
		when others => 
			DataOut <= DataInCurrent;
	end case;
	end if;
end if;
end process;

end architecture;
