----------------------------------------------------------------------------------
-- Filename : clock_divider.vhdl
-- Author   : Shyama Gandhi 
-- Date     : 25 October, 2023
-- Purpose  : Clock divider implementation.
--            This VHDL code implements a clock divider, a fundamental component used for dividing the input clock signal into a slower output clock signal. 
--            The purpose of this clock divider is to enable synchronization and timing adjustments in digital circuits. 
--            It takes two generic parameters, the input clock frequency (freq_in) and the desired output clock frequency (freq_out), and dynamically adjusts the output signal to achieve the specified frequency division.     
-- 
-- Dependencies: [List any external dependencies or prerequisites]
-- 
-- Revision:
--   Revision 0.01 - File Created
-- Additional Comments:
--   [Include any additional comments or notes about the code]

-- MIT License
-- Copyright (c) 2023, Shyama Gandhi
-- Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
-- The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity clock_divider is
    generic (
        freq_in  : positive := 125_000_000;  -- Input clock frequency in Hz
        freq_out : positive := 1_000         -- Output clock frequency in Hz
    );
    port (
        clock     : in STD_LOGIC;   -- Input clock signal
        clock_div : out STD_LOGIC   -- Output clock signal
    );
end entity clock_divider;

architecture Behavioral of clock_divider is
    signal count : positive range 1 to freq_in / (2 * freq_out) := 1;
    signal clock_signal : STD_LOGIC := '0';

begin
    clock_div <= clock_signal;

    process(clock)
    begin
        if rising_edge(clock) then
            if count = freq_in / (2 * freq_out) then
                count <= 1;
                clock_signal <= not clock_signal;
            else
                count <= count + 1;
            end if;
        end if;
    end process;
end architecture Behavioral;