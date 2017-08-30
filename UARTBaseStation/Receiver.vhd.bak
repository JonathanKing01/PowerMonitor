library IEEE;
use IEEE.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

-- write other comments here such as last update

entity Receiver is
 port (
	clk : in std_logic;
	rx : in std_logic;
--	reset : in std_logic;
   shift_reg_out:out std_logic_vector(7 downto 0)
--	ledsel:out std_logic_vector(3 downto 0):="0000";
--	ledsegment:out std_logic_vector(6 downto 0):="1111110"
	
 );
end entity;
--Define architecture here
Architecture behavior of Receiver is
type usart_states is (idle, start, data, stop);	
signal shift_reg:std_logic_vector(7 downto 0);
signal num_decode:std_logic_vector(3 downto 0);
signal pcount:std_logic_vector(3 downto 0);
signal ncount:std_logic_vector(3 downto 0);
signal data_low , pcount_en, pcount_reset, ncount_en, ncount_reset, shift, start_cap, pcap, ncap, shift_out, reset :std_logic:='0';
--shift_reset
signal CS, NS : usart_states:= idle;


begin

--ledsel <= "0001";
----------------------------
--VHDL code for FSM
----------------------------
--state registers
Synchronous_process: process (reset, clk)
 begin
 if clk'event and clk = '1' then
 --CS <= idle;
 CS <= NS;
 end if;
 end process;
------------------------------------
NextState_logic: process (CS, ncap, pcap, start_cap, data_low, NS )
 begin
 case CS is
	when idle =>
		if data_low = '1' then
			NS <= start;
		else
			NS <= idle;
		end if;
	when start =>
		if start_cap = '1' then 
			NS <= data;
		else
			NS <= start;
		end if;
	when data => 
		if ncap = '1' then
			NS <= stop;
		else
			NS <= data;
		end if;
	when stop =>
		if pcap = '0' then
			NS <= stop;
		else 
			NS <= idle;
		end if;
	end case;
 end process;
-----------------------------------------
Output_logic: process (CS, data_low, ncap, pcap, start_cap)
 begin
 pcount_en <= '0';
 pcount_reset <= '0';
 ncount_en <= '0';
 ncount_reset <= '0';
 shift <= '0';
 shift_out <= '0';
 --shift_reset <= '0';
	case CS is
		when idle =>
			if data_low = '1' then
				ncount_reset <= '1';
				shift_out <= '0';
				--shift_reset <= '1';
			else
				pcount_reset <= '0';
			end if;
		when start =>
			if start_cap = '1' then
				pcount_reset <= '1';
				ncount_reset <= '1';
			else	
				pcount_en <= '1';
			end if;
		when data =>
			if pcap = '0' then
				pcount_en <= '1';
			else
				if ncap = '0' then
					pcount_reset <= '1';
					ncount_en <= '1';
					shift <= '1';
				else
					pcount_reset <= '1';
					shift <= '1';
				end if;
			end if;
		when stop => 
			shift <= '0';
			if pcap = '0' then
				pcount_en <= '1';
				shift_out <= '1';
			end if;
		end case;
 end process;
----------------------------
--VHDL code for datapath
----------------------------
dataListener: process(rx)
begin
if clk'event and clk='1' then
	if rx='1' then
		data_low <= '0';
	else 
		data_low <= '1';
	end if;
end if;
end process;
-----------------
pCounter_process:process(clk,pcount_en,pcount_reset)
begin
  if clk'event and clk = '1' then
	if pcount_reset = '1' then
		pcount <= "0000"; 
	else
		if pcount_en = '1' then 
			pcount <= pcount + 1;
		end if;
	end if;
  end if;
end process;

nCounter_process: process (clk,ncount_en,ncount_reset)
begin
  if clk'event and clk = '1' then
	if ncount_reset = '1' then
		ncount <= "0000";
	else
		if ncount_en = '1' then 
			ncount <= ncount + 1;
		end if;
	end if;
  end if;
end process;

-----------------
startCap_process: process(pcount, start_cap)
begin
if clk'event and clk='1' then
	if pcount = 4 then
		start_cap <= '1';
	else
		start_cap <= '0';
	end if;
end if;
end process;

pCap_process: process(pcount, pcap)
begin
if clk'event and clk='1' then
	if pcount = 14 then
		pCap <= '1';
	else
		pCap <= '0';
	end if;
end if;
end process;

nCap_process: process(ncount, nCap)
begin
if clk'event and clk='1' then
	if ncount = 8 then
		nCap <= '1';
	else
		nCap <= '0';
	end if;
end if;
end process;
------------------
ShiftRegister_process: process( shift, clk, rx)
begin
 if clk'event and clk = '1' then
  if shift='1' then
	shift_reg<=rx & shift_reg(7 downto 1);
  end if;
 end if;
end process;
-----------------

--ShiftRegister_reset_process: process( shift_reg, shift_out)
--begin
--if clk'event and clk = '1' then
-- if shift_reset = '1' then
--		shift_reg <= "00000000";
--	end if;
--end if;
--end process;

ShiftRegister_Output_process: process( clk, shift_reg)
begin
if clk'event and clk = '1' then
	if shift_out = '1' then
		shift_reg_out <= shift_reg;
	end if;
end if;
end process;

--segment7_decoder:process(shift_reg_out)
--begin
--if clk'event and clk='1' then
--	case shift_reg_out(3 downto 0) is
--            when "0000"=> ledsegment <="0111111";  -- '0'
--            when "0001"=> ledsegment <="0110000";  -- '1'
--            when "0010"=> ledsegment <="1011011";  -- '2'
--            when "0011"=> ledsegment <="1111001";  -- '3'
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
--            when others=> ledsegment <="1110001"; -- 'F'
--	end case;
--end if;
--end process;


end architecture;