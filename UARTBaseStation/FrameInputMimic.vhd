library IEEE;
use IEEE.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use IEEE.numeric_std.all;

-- write other comments here such as last update

entity FrameInputMimic is
 port (
	clk : in std_logic;
	DataOut: out std_logic:='0'
 );
end entity;

--Define architecture here
Architecture behavior of FrameInputMimic is
signal counter:integer:=0;
signal change:std_logic:='0';
begin

clockTick: process (clk)
begin
	if clk'event and clk='1' then
		counter <= counter + 1;
		if counter = 15 then
			counter <= 0;
			if change = '1' then 
				change <= '0';
			else
				change <='1';
			end if;
		end if;
	end if;
end process;

inputShifter: process (clk, change)
begin
	if clk'event and clk='0' then
		if change = '1' then
			DataOut <= '1';
		else
			DataOut <= '0';
		end if;
	end if;
end process;

end architecture;