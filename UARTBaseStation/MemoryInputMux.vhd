library IEEE;
use IEEE.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use IEEE.numeric_std.all;

-- write other comments here such as last update

entity MemoryMux is
 generic(
	DEBOUNCE_COUNTER_MAX: integer:= 1
 );
 port (
	clk : in std_logic;
	DataIn: in std_logic_vector(7 downto 0);
	Output_Selector: in std_logic;
	
	DataOut: out std_logic_vector(15 downto 0)
	
 );
end entity;

--Define architecture here
Architecture behavior of MemoryMux is
type mem_registers is array(0 to 15) of std_logic_vector(3 downto 0);
signal mem: mem_registers:=(others=>(others=>'0'));
--signal mem: mem_registers:=("0000","0000","0000","0000","0000","0000","0000","0000","0000","0000","0000","0000","0000","0000","0000","0000");
signal muxInput: std_logic_vector(1 downto 0):= "00";
signal adress:integer;
signal initialized: std_logic:='0';
signal seeMem_out:std_logic_vector(15 downto 0);
signal push_button_debounce_counter_cap: std_logic := '0';
signal push_button_debounce_counter: integer:=0;

begin


interpretInput: process (DataIn, initialized)
begin
if initialized = '0' then
	for I in 0 to 15 loop
		mem(I) <= "0000";
	end loop;
	initialized <= '1';
else
	adress <= to_integer(unsigned(DataIn(7 downto 4)));
	mem(adress) <= "0000";
	mem(adress) <= DataIn(3 downto 0);
end if;
end process;

muxInputScroller: process (Output_Selector)
begin
if clk'event and clk = '1' then
if output_Selector = '1' then
case muxInput is 
	when "00" =>
		muxInput <= "01";
	when "01" =>
		muxInput <= "10";
	when "10" =>
		muxInput <= "00";
	when "11" =>
end case;
end if;
end if;
end process;

--mux_debouncer: process (output_Selector, push_button_debounce_counter)
--begin
--if clk'event and clk = '1' then
--if output_Selector = '1' then
--	push_button_debounce_counter <= push_button_debounce_counter + 1;
--	if push_button_debounce_counter = DEBOUNCE_COUNTER_MAX then
--		push_button_debounce_counter_cap <= '1';
--	end if;
--end if;
--end if;
--end process;+

outputMux: process (muxInput)
begin
DataOut <= mem(3) & mem(2) & mem(1) & mem(0);
case muxInput is 
	when "00" => 
		DataOut(15 downto 12) <= mem(3);
		DataOut(11 downto 8) <= mem(2);
		DataOut(7 downto 4) <= mem(1);
		DataOut(3 downto 0) <= mem(0);
	when "01" => 
		DataOut <= mem(7) & mem(6) & mem(5) & mem(4);
	when "10" => 
		DataOut <= mem(11) & mem(10) & mem(9) & mem(8);
	when "11" =>
end case;
end process;

seeMem: process (mem)
begin 
	seeMem_out <= mem(3) & mem(2) & mem(1) & mem(0);
end process;

end architecture;