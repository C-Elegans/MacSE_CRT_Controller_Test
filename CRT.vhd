LIBRARY IEEE;
use ieee.numeric_std.all;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;

ENTITY CRT is 
	GENERIC(
	--	Horizontal Parameters
		h_pixels	: integer := 704; -- horizontal length
		h_offset	: integer := 14;
		h_sync_len	: integer := 288;
		h_vid_offset	: integer := 192;
		h_vid_length	: integer := 512;

	-- 	Vertical Parameters
		v_pixels	: integer := 370;
		v_offset	: integer := 28;
		v_sync_len	: integer := 4;
		vid_offset	: integer := 28;
		v_vid_len	: integer := 2);

	PORT(
		CLK_IN		: IN STD_LOGIC;
		h_sync		: OUT STD_LOGIC;
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
signal	count:		std_logic_vector(19 downto 0) := X"00000";
signal	outglob:	std_logic;
signal 	outres:		std_logic := '1';
signal	newFrame:	std_logic := '1';

begin

	MaceSeCRT_PLL_inst	: MaceSeCRT_PLL	-- Fix/Update this
port map(
	REFERENCECLK => CLK_IN,
	PLLOUTCORE => dot_clock,
	PLLOUTGLOBAL => outglob,
	RESET => outres);

	-- signal to begin the next frame
	newFrame <= '1' when count = std_logic_vector(to_unsigned(4,count'length))
			else '0';

	h_sync <= '0';
	v_sync <= '0';
	video <= '0';

	process(dot_clock)
	begin
		if (rising_edge(dot_clock)) then
			if(newFrame = '1')then count <= X"00000"; end if;
			count <= count + 1;
		end if;
	end process;
end behavior;
