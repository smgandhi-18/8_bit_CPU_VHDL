----------------------------------------------------------------------------------
-- Company: Department of Electrical and Computer Engineering, University of Alberta
-- Engineer: Shyama Gandhi
-- Create Date: 10/29/2020 07:18:24 PM
-- Module Name: cpu - structural(datapath)
-- Description: CPU_LAB 3 - ECE 410 (2021)
-- Revision:
-- Revision 0.01 - File Created by Shyama Gandhi (October 3, 2020)
-- Revision 2.01 - File Modified by Shyama Gandhi (November 2, 2021)
-- Revision 3.01 - File Modified by Antonio Andara (October 31, 2023)
-- Additional Comments:

-- License : CC0 1.0 Universal (Provide credits to the author)

--*********************************************************************************
-- When the enable line is asserted, the output from the accumulator will be stored in the buffer.
-- The value stored in the output buffer will the output of this CPU. 
-----------------------------

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY tri_state_buffer IS
    PORT( output_enable : IN STD_LOGIC
        ; buffer_input  : IN STD_LOGIC_VECTOR(7 DOWNTO 0)
        ; buffer_output : OUT STD_LOGIC_VECTOR(7 DOWNTO 0)
        );
END tri_state_buffer;

ARCHITECTURE Behavioral OF tri_state_buffer IS
BEGIN

    PROCESS (output_enable, buffer_input)
    BEGIN
        IF (output_enable = '1') THEN
            buffer_output <= buffer_input;
        ELSE
            buffer_output <= (OTHERS => 'Z'); -- set output to high impendance state
        END IF;
    END PROCESS;

END Behavioral;
