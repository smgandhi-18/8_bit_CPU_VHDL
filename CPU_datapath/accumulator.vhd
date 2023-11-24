----------------------------------------------------------------------------------
-- Company: Department of Electrical and Computer Engineering, University of Alberta
-- Engineer: Shyama Gandhi
-- Create Date: 10/29/2020 07:18:24 PM
-- Module Name: cpu - structural(datapath)
-- Description:  CPU LAB 3 - ECE 410 
-- Revision:
-- Revision 0.01 - File Created by Shyama Gandhi (October 3, 2020)
-- Revision 1.01 - File Modified by Raju Machupalli (October 31, 2021)
-- Revision 2.01 - File Modified by Shyama Gandhi (November 2, 2021)
-- Revision 3.01 - File Modified by Shyama Gandhi (October 25, 2022)
-- Revision 4.01 - File Modified by Antonio Andara (October 31, 2023)
-- Additional Comments:
-- License : CC0 1.0 Universal (Provide credits to the author)

-- Additional Comments: in order to write to the accumulator acc_write
-- must be set to high, writing of the accumulator only occurs during
-- the rising edge of the clock
--*********************************************************************************
-- 8-bit accumulator register as shown in the datapath of lab manual
-----------------------------

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY accumulator IS
PORT( clock     : IN STD_LOGIC
	; reset     : IN STD_LOGIC 
	; acc_write : IN STD_LOGIC  
	; acc_in    : IN STD_LOGIC_VECTOR (7 DOWNTO 0)
	; acc_out   : OUT STD_LOGIC_VECTOR (7 DOWNTO 0)
	);

END accumulator;

ARCHITECTURE Behavioral OF accumulator IS

BEGIN

	PROCESS (clock, reset, acc_write, acc_in)
	BEGIN
	-- asynchronous reset of the accumulator
		IF reset = '1' THEN
			acc_out <= (OTHERS => '0');
		ELSIF rising_edge(clock) AND acc_write = '1' THEN
			acc_out <= acc_in;
		END IF;
	END PROCESS;
	
END Behavioral;
