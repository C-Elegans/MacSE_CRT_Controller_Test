LIBRARY IEEE;
use ieee.numeric_std.all;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;

ENTITY CRT is 
	GENERIC(
	--	Horizontal Parameters
		h_pixels	: integer := 704; -- horizontal length
		param_quick_num	: integer := 22;
		h_offset	: integer := 14;
		h_sync_len	: integer := 288;
		h_vid_offset	: integer := 192;
		h_vid_after_length	: integer := 110;

	-- 	Vertical Parameters
		v_pixels	: integer := 370;
		v_offset	: integer := 28;
		v_sync_len	: integer := 4;
		vid_offset	: integer := 28;
		v_vid_len	: integer := 2;

	--	Video Parameters
		total_dots	: integer := 260480);

	PORT(
		CLK_IN		: IN STD_LOGIC;
		h_sync		: OUT STD_LOGIC := '1';
		v_sync		: OUT STD_LOGIC;
		video		: OUT STD_LOGIC);
END CRT;

ARCHITECTURE behavior of CRT IS
component MaceSeCRT_PLL	-- fix/update this name

port(
	REFERENCECLK: in std_logic;
	RESET: in std_logic;
	PLLOUTCORE: out std_logic;
	PLLOUTGLOBAL: out std_logic);
end component;

signal	dot_clock:	std_logic;
signal	count:		std_logic_vector(19 downto 0) := X"00001";
signal	count_quick_test:	std_logic_vector(19 downto 0) := X"00001";
signal	outglob:	std_logic;
signal 	outres:		std_logic := '1';
signal	newFrame:	std_logic := '1';

signal  V_COUNT:	std_logic_vector(15 downto 0) := x"0001";
signal  H_COUNT:	std_logic_vector(15 downto 0) := x"0001";

begin

	MaceSeCRT_PLL_inst	: MaceSeCRT_PLL	-- Fix/Update this
port map(
	REFERENCECLK => CLK_IN,
	PLLOUTCORE => dot_clock,
	PLLOUTGLOBAL => outglob,
	RESET => outres);

	-- signal to begin the next frame
	newFrame	<= '1' when count = std_logic_vector(to_unsigned(8,count'length))
				else '0';

	h_sync		<= '0' when (H_COUNT <= (h_vid_offset + h_vid_after_length) and H_COUNT >= (h_offset+1))
				else '1';

--	video	 <= '1' when count_quick_test = param_quick_num+1
--			else '0';

	video		<= CLK_IN;

	v_sync		<= '0' when (V_COUNT >= x"1" and V_COUNT <= vid_offset)	
				else '1';

	--h_sync <= '0';
	--v_sync <= '0';
	--video <= '0';

	process(dot_clock)
	begin
		if (rising_edge(dot_clock)) then
			count_quick_test <= count_quick_test + 1;

			if(count < total_dots)
			then count <= count + 1;
			else 
			count <= X"00001";
			V_COUNT <= x"0001";
			end if;

			if(H_COUNT < h_pixels)	-- we've scanned 704 horizontal dots -- 02c0
			then H_COUNT <= H_COUNT + 1;
			else 
			H_COUNT <= x"0001";
				if(count < 260480)
				then V_COUNT <= V_COUNT + 1;
				end if;
			end if;

			--if(H_COUNT = x"1")	-- less than 193
			--then h_sync <= '1';
			--else h_sync <= '0';
			--end if;
		end if;
	end process;
end behavior;
