----------------------------------------------------------------------------------
-- Company: Department of Electrical and Computer Engineering, University of Alberta
-- Engineer: Shyama Gandhi 
-- Create Date: 10/29/2020 07:18:24 PM
-- Description: CPU LAB 3 - ECE 410 (2021)
-- Revision:
-- Revision 0.01 - File Created by Shyama Gandhi (October 3, 2020)
-- Revision 1.01 - File Modified by Raju Machupalli (October 31, 2021)
-- Revision 2.01 - File Modified by Shyama Gandhi (November 2, 2021)
-- Revision 3.01 - File Modified by Shyama Gandhi (October 25, 2022)
-- Revision 4.01 - File Modified by Antonio Andara (October 31, 2023)

-- Additional Comments:
-- 
-- License : CC0 1.0 Universal (Provide credits to the author)

----------------------------------------------------------------------------------

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY cpu_core_tb IS
END cpu_core_tb;

ARCHITECTURE behavior OF cpu_core_tb IS

    SIGNAL clock          : STD_LOGIC := '0';
    SIGNAL reset          : STD_LOGIC := '0';
    SIGNAL user_input     : STD_LOGIC_VECTOR(7 DOWNTO 0);
    SIGNAL OPCODE_output  : STD_LOGIC_VECTOR(3 DOWNTO 0);
    SIGNAL PC_output      : STD_LOGIC_VECTOR(4 DOWNTO 0);
    SIGNAL CPU_output     : STD_LOGIC_VECTOR(7 DOWNTO 0);
    SIGNAL enter          : STD_LOGIC;
    SIGNAL done           : STD_LOGIC;

    -- Clock period definitions
    CONSTANT clock_period : TIME := 8 ns;

BEGIN

    -- Instantiate the Unit Under Test (UUT)
    UUT : ENTITY WORK.cpu_core(Structural)
        PORT MAP( clock         => clock
                , reset         => reset
                , enter         => enter
                , user_input    => user_input
                , CPU_output    => CPU_output
                , PC_output     => PC_output
                , OPCODE_output => OPCODE_output
                , done          => done
                );

    -- Clock process definition
    clock_process : PROCESS
    BEGIN
        clock <= '0';
        WAIT FOR clock_period/2;
        clock <= '1';
        WAIT FOR clock_period/2;
    END PROCESS;

    -- Stimulus process
    stim_proc : PROCESS
    BEGIN

        --*********************************
        -- provide the required input stimulus here for the design under test
        reset <= '1';
        WAIT FOR 4ns;
        reset <= '0';
        WAIT FOR 4ns;
        user_input <= "00010000";
        enter      <= '1';
        -----------------------------------

        WAIT;
    END PROCESS;

END behavior;
