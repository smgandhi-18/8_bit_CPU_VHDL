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

--*********************************************************************************
-- Total eights operations can be performed using 3 select lines of this ALU.
-- The select line codes have been given to you in the lab manual.
-- In future, this alu is scalable to say, 16 operations using 4 select lines.
-----------------------------

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY alu IS
    PORT( alu_sel     : IN STD_LOGIC_VECTOR(2 DOWNTO 0)
        ; input_a     : IN STD_LOGIC_VECTOR(7 DOWNTO 0)
        ; input_b     : IN STD_LOGIC_VECTOR(7 DOWNTO 0)
        ; bits_rotate : IN STD_LOGIC_VECTOR(1 DOWNTO 0)
        ;alu_out     : OUT STD_LOGIC_VECTOR (7 DOWNTO 0)
        );
END alu;

ARCHITECTURE Dataflow OF alu IS
BEGIN

    WITH alu_sel SELECT
        alu_out <= input_a WHEN "000",
        input_a NAND input_b WHEN "001",
        STD_LOGIC_VECTOR(rotate_left(unsigned(input_a), to_integer(unsigned(bits_rotate)))) WHEN "010",
        STD_LOGIC_VECTOR(rotate_right(unsigned(input_a), to_integer(unsigned(bits_rotate)))) WHEN "011",
        STD_LOGIC_VECTOR(signed(input_a) + signed(input_b)) WHEN "100",
        STD_LOGIC_VECTOR(signed(input_a) - signed(input_b)) WHEN "101",
        STD_LOGIC_VECTOR(signed(input_a) + 1) WHEN "110",
        STD_LOGIC_VECTOR(signed(input_a) - 1) WHEN "111",
        (OTHERS => '0') WHEN OTHERS;

END Dataflow;
