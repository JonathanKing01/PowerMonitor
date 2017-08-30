library IEEE;
use IEEE.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

-- 30/8 Added comments to help understand code

entity Receiver is
 port (
	clk : in std_logic;
	rx : in std_logic;
   shift_reg_out:out std_logic_vector(7 downto 0)
	
 );
end entity;

Architecture behavior of Receiver is
type usart_states is (idle, start, data, stop);	
signal shift_reg:std_logic_vector(7 downto 0);
signal num_decode:std_logic_vector(3 downto 0);
signal pcount:std_logic_vector(3 downto 0);
signal ncount:std_logic_vector(3 downto 0);
signal data_low , pcount_en, pcount_reset, ncount_en, ncount_reset, shift, start_cap, pcap, ncap, shift_out:std_logic:='0';
signal CS, NS : usart_states:= idle;


begin

----------------------------
--VHDL code for FSM
----------------------------

-- continuously cycle state registers
Synchronous_process: process (clk)
 begin
	if clk'event and clk = '1' then
		CS <= NS;
	end if;
 end process;
------------------------------------

-- Logic for looking at the current state and current inputs, and moving into the correct next state
NextState_logic: process (CS, ncap, pcap, start_cap, data_low)
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

-- Logic for checking the current state and the current inputs, and outputting the correct signals to the datapath.
Output_logic: process (CS, data_low, ncap, pcap, start_cap)
 begin
 
 -- Reset all enable/reset signals
 pcount_en <= '0';
 pcount_reset <= '0';
 ncount_en <= '0';
 ncount_reset <= '0';
 shift <= '0';
 shift_out <= '0';
 
	case CS is
		when idle =>
			if data_low = '1' then
				ncount_reset <= '1';
				shift_out <= '0';
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

-----------------Listeners-----------------

-- We need to know when the data is low on a rising clock edge, so we can move into the start state
dataListener: process(clk)
begin
if clk'event and clk='1' then
	if rx='1' then
		data_low <= '0';
	else
		data_low <= '1';
	end if;
end if;
end process;

-----------------Counters-----------------

-- This counter is here to count the numbers of clock cycles passed. 
-- If the reset signal is set, it resets to 0, otherwise it continuouly counts upwards
-- Max count ever will be 15, so we only need a 4 bit vector.
pCounter_process:process(clk,pcount_en,pcount_reset)
begin
  if clk'event and clk = '1' then
		if pcount_en = '1' then 
			pcount <= pcount + 1;
		end if;
  end if;
  if pcount_reset = '1' then
		pcount <= "0001"; 
  end if;
end process;

-- This counter is here to count the numbers of bits we have recieved in a frame. 
-- If the reset signal is set, it resets to 0, otherwise it continuouly counts upwards
-- Max count ever will be 8, so we only need a 3 bit vector.
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

-----------------Comparators-----------------

-- Process for counting up to 7 clock counts when the start bit is recieved. 
-- start_cap is the signal for this event, so we set it to zero until we reach 7 on the counter.
startCap_process: process(pcount, clk)
begin
	if clk'event and clk='1' then
		if pcount = "0111" then
			start_cap <= '1';
		else
			start_cap <= '0';
		end if;
	end if;
end process;

-- Process for counting up to 15 clock counts to track our progress from one data bit to the next. 
-- pCap is the signal for this event, so we set it to zero until we reach 15 on the counter.
pCap_process: process(pcount, clk)
begin
	if clk'event and clk='1' then
		if pcount = 15 then
			pCap <= '1';
		else
			pCap <= '0';
		end if;
	end if;
end process;

-- Process for counting up to 8 bits recieved, so that we know where the frame ends. 
-- nCap is the signal for this event, so we set it to zero until we reach 7 on the counter.
nCap_process: process(ncount, clk)
begin
	if clk'event and clk='1' then
		if ncount = 8 then
			nCap <= '1';
		else
			nCap <= '0';
		end if;
	end if;
end process;

------------------Registers-----------------

-- This process read the current data bit value when called (1 or 0), and stores it.
-- We also need to shift the exiting shift register content over by 1 so make room for the new bit.
ShiftRegister_process: process( shift, clk, rx)
begin
	if clk'event and clk = '1' then
		if shift='1' then
			shift_reg<=rx & shift_reg(7 downto 1);
		end if;
	end if;
end process;

-- We need to shift the new frame to the output only once we have received the whole frame.
-- (If we just push them in as they arrive we will be sending half-received/half-overwitten output to our memory registers... this is not good)
ShiftRegister_Output_process: process( clk, shift_out)
begin
	if shift_out = '1' then
		shift_reg_out <= shift_reg;
	end if;
end process;

end architecture;