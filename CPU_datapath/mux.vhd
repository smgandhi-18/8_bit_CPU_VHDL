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
--THIS IS A 4x1 MUX that selects between the four inputs as shown in the lab manual.
-----------------------------

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY mux4 IS
    PORT( in0      : IN STD_LOGIC_VECTOR(7 DOWNTO 0)
        ; in1      : IN STD_LOGIC_VECTOR(7 DOWNTO 0)
        ; in2      : IN STD_LOGIC_VECTOR(7 DOWNTO 0)
        ; in3      : IN STD_LOGIC_VECTOR(7 DOWNTO 0)
        ; mux_sel  : IN STD_LOGIC_VECTOR(1 DOWNTO 0)
        ; mux_out  : OUT STD_LOGIC_VECTOR(7 DOWNTO 0)
        );
END mux4;

ARCHITECTURE Dataflow OF mux4 IS
BEGIN
    WITH mux_sel SELECT
        mux_out <= in0 WHEN "00",
                   in1 WHEN "01",
                   in2 WHEN "10",
                   in3 WHEN "11",
       (OTHERS => '0') WHEN OTHERS;
END Dataflow;
