library IEEE;
use IEEE.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use IEEE.numeric_std.all;

-- 30/8 Added comments to help understand code

entity InputMux is
 port (
	clk : in std_logic;
	DataIn: in std_logic_vector(7 downto 0);
	
	DataOutVoltage: out std_logic_vector(5 downto 0):= "000000";
	DataOutCurrent: out std_logic_vector(5 downto 0):= "000000";
	DataOutPower: out std_logic_vector(5 downto 0):= "000000";
	DataOutExtra: out std_logic_vector(5 downto 0):= "000000"
	
 );
end entity;

Architecture behavior of InputMux is
begin

-- This process is a mux that pushes the current frame to the appropriate register.
-- The case uses the first two bits becase that is where we have stored the info for the parameter type
-- The mux only sends out the last 6 values as the first two bits are not used beyond this point.

store_input:process (clk)
begin
	if clk'event and clk='1' then
		case DataIn(7 downto 6) is
			when "00" =>
				DataOutVoltage <= DataIn(5 downto 0);
			when "01" =>
				DataOutCurrent <= DataIn(5 downto 0);
			when "10" =>
				DataOutPower <= DataIn(5 downto 0);
			when "11" =>
				DataOutExtra <= DataIn(5 downto 0);
		end case;
	end if;
end process;

end architecture;