library IEEE;
use IEEE.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use IEEE.numeric_std.all;

-- write other comments here such as last update

entity DataRegister is
 port (
	clk : in std_logic;
	DataIn: in std_logic_vector(5 downto 0);
	
	DataOut: out std_logic_vector(15 downto 0):= "0000000000000000"
	
 );
end entity;

--Define architecture here
Architecture behavior of DataRegister is
begin

store_input:process (DataIn)
begin
if clk'event and clk='1' then
	case DataIn(5 downto 4) is
		when "00" =>
			DataOut(3 downto 0) <= DataIn(3 downto 0);
		when "01" =>
			DataOut(7 downto 4) <= DataIn(3 downto 0);
		when "10" =>
			DataOut(11 downto 8) <= DataIn(3 downto 0);
		when "11" =>
			DataOut(15 downto 12) <= DataIn(3 downto 0);
end case;
end if;
end process;

end architecture;