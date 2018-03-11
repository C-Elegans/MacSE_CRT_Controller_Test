LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;

entity top_tb is
end entity top_tb;

architecture behavior of top_tb is 

signal h_sync_top	:	std_logic;
signal v_sync_top	:	std_logic;
signal video_top	:	std_logic;
signal reference_clock	:	std_logic;

component CRT
port(
	CLK_IN		: IN STD_LOGIC;
	h_sync		: OUT STD_LOGIC;
	v_sync		: OUT STD_LOGIC;
	video		: OUT STD_LOGIC);
end component;

signal reset : std_logic;
begin
	-- drive CRT with clock here during simulation
	CRT_INST: CRT
	port map(
		CLK_IN => reference_clock,
		h_sync => h_sync_top,
		v_sync => v_sync_top,
		video  => video_top);
	
    process
        begin

        -- generate clock
          reference_clock <= '0', '1' after 64 ns;
          wait for 128 ns;
         end process; 
         -- following statement executes only once
reset <= '1', '0' after 75 ns;
end architecture behavior;
    								  
