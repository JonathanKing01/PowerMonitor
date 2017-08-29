library IEEE;
use IEEE.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use IEEE.numeric_std.all;

-- write other comments here such as last update

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

--Define architecture here
Architecture behavior of InputMux is
begin

store_input:process (DataIn)
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