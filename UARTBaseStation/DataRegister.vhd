library IEEE;
use IEEE.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use IEEE.numeric_std.all;

-- 30/8 Added comments to help understand code

entity DataRegister is
 port (
	clk : in std_logic;
	DataIn: in std_logic_vector(5 downto 0);
	
	DataOut: out std_logic_vector(15 downto 0):= "0000000000000000"
 );
end entity;

Architecture behavior of DataRegister is
begin

-- This process acts as a pseudo-mux. It reads the imput vector, determines which place it should go into, then writes to that place in the output vector.
-- The first two bits of the vector are used to determine the place in the output vector (11 on the left to 00 in the right)
-- The leftmost number takes up places 15 to 12 in the output vector, the 2nd number takes 11 to 8, and so on.

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