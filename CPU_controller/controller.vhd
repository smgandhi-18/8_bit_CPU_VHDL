----------------------------------------------------------------------------------
-- Company: Department of Electrical and Computer Engineering, University of Alberta
-- Engineer: Shyama Gandhi and Bruce Cockburn
-- Create Date: 10/29/2020 07:18:24 PM
-- Updated Date: 01/11/2021
-- Design Name: CONTROLLER FOR THE CPU
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
-- The controller implements the states for each instructions and asserts appropriate control signals for the datapath during every state.
-- For detailed information on the opcodes and instructions to be executed, refer the lab manual.
-----------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY controller IS
    PORT( clock          : IN STD_LOGIC
        ; reset          : IN STD_LOGIC
        ; enter          : IN STD_LOGIC
        ; mux_sel        : OUT STD_LOGIC_VECTOR(1 DOWNTO 0)
        ; immediate_data : BUFFER STD_LOGIC_VECTOR(7 DOWNTO 0)
        ; acc_write      : OUT STD_LOGIC
        ; rf_address     : OUT STD_LOGIC_VECTOR(2 DOWNTO 0)
        ; rf_write       : OUT STD_LOGIC
        ; alu_sel        : OUT STD_LOGIC_VECTOR(2 DOWNTO 0)
        ; output_enable  : OUT STD_LOGIC
        ; zero_flag      : IN STD_LOGIC
        ; positive_flag  : IN STD_LOGIC
        ; PC_out         : OUT STD_LOGIC_VECTOR(4 DOWNTO 0)
        ; OPCODE_output  : OUT STD_LOGIC_VECTOR(3 DOWNTO 0)
        ; bits_rotate    : OUT STD_LOGIC_VECTOR(1 DOWNTO 0)
        ; done           : OUT STD_LOGIC
        );
END controller;

ARCHITECTURE Behavioral OF controller IS

    TYPE state_type IS ( STATE_FETCH
                       , STATE_DECODE
                       , STATE_INA
                       , STATE_LDI
                       , STATE_LDA
                       , STATE_STA
                       , STATE_ADD
                       , STATE_SUB
                       , STATE_ROTL
                       , STATE_ROTR
                       , STATE_INC
                       , STATE_DEC
                       , STATE_NAND
                       , STATE_OUTA
                       , STATE_JMPZ
                       , STATE_HALT
                       );

    SIGNAL state     : state_type;
    SIGNAL IR        : STD_LOGIC_VECTOR(7 DOWNTO 0); -- instruction register
    SIGNAL PC        : INTEGER RANGE 0 TO 31        := 0; -- program counter

    -- Instructions and their opcodes (pre-decided)
    CONSTANT OPCODE_INA  : STD_LOGIC_VECTOR(3 DOWNTO 0) := "0001";
    CONSTANT OPCODE_LDI  : STD_LOGIC_VECTOR(3 DOWNTO 0) := "0010";
    CONSTANT OPCODE_LDA  : STD_LOGIC_VECTOR(3 DOWNTO 0) := "0011";    
    CONSTANT OPCODE_STA  : STD_LOGIC_VECTOR(3 DOWNTO 0) := "0100";
    CONSTANT OPCODE_ADD  : STD_LOGIC_VECTOR(3 DOWNTO 0) := "0101";
    CONSTANT OPCODE_SUB  : STD_LOGIC_VECTOR(3 DOWNTO 0) := "0110";
    CONSTANT OPCODE_ROTL : STD_LOGIC_VECTOR(3 DOWNTO 0) := "0111";
    CONSTANT OPCODE_ROTR : STD_LOGIC_VECTOR(3 DOWNTO 0) := "1000";
    CONSTANT OPCODE_INC  : STD_LOGIC_VECTOR(3 DOWNTO 0) := "1001";
    CONSTANT OPCODE_DEC  : STD_LOGIC_VECTOR(3 DOWNTO 0) := "1010";
    CONSTANT OPCODE_NAND : STD_LOGIC_VECTOR(3 DOWNTO 0) := "1011";
    -- CONSTANT OPCODE_XXXX : STD_LOGIC_VECTOR(3 DOWNTO 0) := "1100"; -- left for implementation
    CONSTANT OPCODE_JMPZ : STD_LOGIC_VECTOR(3 DOWNTO 0) := "1101";
    CONSTANT OPCODE_OUTA : STD_LOGIC_VECTOR(3 DOWNTO 0) := "1110";
    CONSTANT OPCODE_HALT : STD_LOGIC_VECTOR(3 DOWNTO 0) := "1111";


    -- program memory that will store the instructions sequentially from part 1 and part 2 test program
    TYPE PM_BLOCK IS ARRAY(0 TO 33) OF STD_LOGIC_VECTOR(7 DOWNTO 0);
    
BEGIN

    --opcode is kept up-to-date
    OPCODE_output <= IR(7 DOWNTO 4);
    
    PROCESS (clock, reset)
        -- "PM" is the program memory that holds the instructions to be executed by the CPU 
        VARIABLE PM     : PM_BLOCK;

        -- To STATE_DECODE the 4 MSBs from the PC content
        VARIABLE OPCODE : STD_LOGIC_VECTOR(3 DOWNTO 0);
        
        

    BEGIN
        IF (reset = '1') THEN -- RESET initializes all the control signals to 0.
            PC             <= 0;
            IR             <= (OTHERS => '0');
            PC_out         <= std_logic_vector(to_unsigned(PC, PC_out'length));
            mux_sel        <= "00";
            immediate_data <= (OTHERS => '0');
            acc_write      <= '0';
            rf_address     <= "000";
            rf_write       <= '0';
            alu_sel        <= "000";
            output_enable  <= '0';
            done           <= '0';
            bits_rotate    <= "00";
            state          <= STATE_FETCH;
            
            -- Test program from manual
            PM(0) := "00010000"; -- INA
            PM(1) := "01000000"; -- STA r[0]
            PM(2) := "00110000"; -- LDA r[0]
            PM(3) := "10100000"; -- DEC
            PM(4) := "01000000"; -- STA r[0]
            PM(5) := "11100000"; -- OUT A
            PM(6) := "11010000"; -- JMPZ x0C
            PM(7) := "00001100"; -- x0C  
            PM(8) := "00100000"; -- LDI x00
            PM(9) := "00000000"; -- 00
            PM(10):= "11010000"; -- jmpz x02
            PM(11):= "00000010"; -- x02
            PM(12):= "00100000"; -- LDI x0F
            PM(13):= "00001111"; -- x0F
            PM(14):= "01000000"; -- STA r[0]
            PM(15):= "00100000"; -- LDI xAA
            PM(16):= "10101010"; -- xAA
            PM(17):= "10110000"; -- NAND A, R[0]
            PM(18):= "11100000"; -- OUTA
            PM(19):= "10010000"; -- INC
            PM(20):= "01000000"; -- STA R[0]
            PM(21):= "00100000"; -- LDI x0F 
            PM(22):= "00001111"; -- x0F
            PM(23):= "01010000"; -- ADD R[0]
            PM(24):= "11100000"; -- OUTA
            PM(25):= "11110000"; -- HALT

        ELSIF RISING_EDGE(clock) THEN
            CASE state IS

                WHEN STATE_FETCH => -- FETCH instruction
                    PC_out         <= std_logic_vector(to_unsigned(PC, PC_out'length));
                    mux_sel        <= "00";
                    immediate_data <= (OTHERS => '0');
                    acc_write      <= '0';
                    rf_address     <= "000";
                    rf_write       <= '0';
                    alu_sel        <= "000";
                    done           <= '0';
                                    
                    IF (enter = '1') THEN
                        PC     <= PC + 1;
                        IR     <= PM(PC);
                        output_enable  <= '0';
                        state  <= STATE_DECODE;
                    ELSE
                        state  <= STATE_FETCH;
                    END IF;

                WHEN STATE_DECODE => -- DECODE instruction

                    OPCODE := IR(7 DOWNTO 4);

                    CASE OPCODE IS
                        WHEN OPCODE_INA  => state <= STATE_INA;
                        WHEN OPCODE_LDI  => state <= STATE_LDI;
                        WHEN OPCODE_LDA  => state <= STATE_LDA;
                        WHEN OPCODE_STA  => state <= STATE_STA;
                        WHEN OPCODE_ADD  => state <= STATE_ADD;
                        WHEN OPCODE_SUB  => state <= STATE_SUB;
                        WHEN OPCODE_ROTL => state <= STATE_ROTL;
                        WHEN OPCODE_ROTR => state <= STATE_ROTR;
                        WHEN OPCODE_INC  => state <= STATE_INC;
                        WHEN OPCODE_DEC  => state <= STATE_DEC;
                        WHEN OPCODE_NAND => state <= STATE_NAND;
                        WHEN OPCODE_JMPZ => state <= STATE_JMPZ;
                        WHEN OPCODE_OUTA => state <= STATE_OUTA;
                        WHEN OPCODE_HALT => state <= STATE_HALT;
                        WHEN OTHERS      => state <= STATE_HALT;
                    END CASE;

                    mux_sel        <= "00";
                    immediate_data <= PM(PC); --pre-fetching immediate data
                    acc_write      <= '0';
                    rf_address     <= IR(2 DOWNTO 0); --decode pre-emptively sets up the register file
                    rf_write       <= '0';
                    alu_sel        <= "000";
                    output_enable  <= '0';
                    done           <= '0';
                    bits_rotate    <= IR(1 DOWNTO 0);

                WHEN STATE_INA => -- INA exceute
                    mux_sel        <= "11";
                    immediate_data <= (OTHERS => '0');
                    acc_write      <= '1';
                    rf_address     <= "000";
                    rf_write       <= '0';
                    alu_sel        <= "000";
                    output_enable  <= '0';
                    done           <= '0';
                    state          <= STATE_FETCH;
                
                WHEN STATE_LDI => -- LDI exceute
                    mux_sel        <= "10";
                    immediate_data <= PM(PC);
                    acc_write      <= '1';
                    rf_address     <= "000";
                    rf_write       <= '0';
                    alu_sel        <= "000";
                    output_enable  <= '0';
                    done           <= '0';
                    PC             <= PC + 1;
                    state          <= STATE_FETCH;

                WHEN STATE_LDA => -- LDA exceute
                    mux_sel        <= "01";
                    immediate_data <= (OTHERS => '0');
                    acc_write      <= '1';
                    rf_address     <= IR(2 DOWNTO 0);
                    rf_write       <= '0';
                    alu_sel        <= "000";
                    output_enable  <= '0';
                    done           <= '0';
                    state          <= STATE_FETCH;

                WHEN STATE_STA => -- STA exceute
                    mux_sel        <= "00";
                    immediate_data <= (OTHERS => '0');
                    acc_write      <= '0';
                    rf_address     <= IR(2 DOWNTO 0);
                    rf_write       <= '1';
                    alu_sel        <= "000";
                    output_enable  <= '0';
                    done           <= '0';
                    state          <= STATE_FETCH;
            
                WHEN STATE_ADD => -- ADD exceute
                    mux_sel        <= "00";
                    immediate_data <= (OTHERS => '0');
                    acc_write      <= '0';
                    rf_address     <= IR(2 DOWNTO 0);
                    rf_write       <= '0';
                    alu_sel        <= "100";
                    output_enable  <= '0';
                    done           <= '0';
                    state          <= STATE_FETCH;

                WHEN STATE_SUB => -- SUB exceute
                    mux_sel        <= "00";
                    immediate_data <= (OTHERS => '0');
                    acc_write      <= '0';
                    rf_address     <= IR(2 DOWNTO 0);
                    rf_write       <= '0';
                    alu_sel        <= "101";
                    output_enable  <= '0';
                    done           <= '0';
                    state          <= STATE_FETCH;
                
                WHEN STATE_ROTL => -- ROTL exceute
                    mux_sel        <= "00";
                    immediate_data <= (OTHERS => '0');
                    acc_write      <= '0';
                    rf_address     <= "000";
                    rf_write       <= '0';
                    alu_sel        <= "010";
                    output_enable  <= '0';
                    done           <= '0';
                    state          <= STATE_FETCH;
                
                WHEN STATE_ROTR => -- ROTR exceute
                    mux_sel        <= "00";
                    immediate_data <= (OTHERS => '0');
                    acc_write      <= '0';
                    rf_address     <= "000";
                    rf_write       <= '0';
                    alu_sel        <= "011";
                    output_enable  <= '0';
                    done           <= '0';
                    state          <= STATE_FETCH;

                WHEN STATE_INC =>
                    mux_sel        <= "00";
                    immediate_data <= (OTHERS => '0');
                    acc_write      <= '1';
                    rf_address     <= "000";
                    rf_write       <= '0';
                    alu_sel        <= "110";
                    output_enable  <= '0';
                    done           <= '0';
                    state          <= STATE_FETCH;
                
                WHEN STATE_DEC =>
                    mux_sel        <= "00";
                    immediate_data <= (OTHERS => '0');
                    acc_write      <= '1';
                    rf_address     <= "000";
                    rf_write       <= '0';
                    alu_sel        <= "111";
                    output_enable  <= '0';
                    done           <= '0';
                    state          <= STATE_FETCH;

                WHEN STATE_NAND =>
                    mux_sel        <= "00";
                    immediate_data <= (OTHERS => '0');
                    acc_write      <= '0';
                    rf_address     <= IR(2 DOWNTO 0);
                    rf_write       <= '0';
                    alu_sel        <= "001";
                    output_enable  <= '0';
                    done           <= '0';
                    state          <= STATE_FETCH;
            
                WHEN STATE_JMPZ => -- JMPZ exceute
                    mux_sel        <= "10";
                    immediate_data <= PM(PC);
                    acc_write      <= '0';
                    rf_address     <= "000";
                    rf_write       <= '0';
                    alu_sel        <= "000";
                    output_enable  <= '0';
                    done           <= '0';
                    state          <= STATE_FETCH;
                    --Zero check
                    IF (zero_flag = '1') THEN
                        PC <= to_integer(unsigned(immediate_data(4 DOWNTO 0)));
                    ELSE
                        PC <= PC + 1;
                    END IF;

                WHEN STATE_OUTA => -- OUTA exceute
                    mux_sel        <= "00";
                    immediate_data <= (OTHERS => '0');
                    acc_write      <= '0';
                    rf_address     <= "000";
                    rf_write       <= '0';
                    alu_sel        <= "000";
                    output_enable  <= '1';
                    done           <= '0';
                    state          <= STATE_FETCH;

                WHEN STATE_HALT => -- HALT execute
                    mux_sel        <= "00";
                    immediate_data <= (OTHERS => '0');
                    acc_write      <= '0';
                    rf_address     <= "000";
                    rf_write       <= '0';
                    alu_sel        <= "000";
                    output_enable  <= '1';
                    done           <= '1';
                    state          <= STATE_HALT;

                WHEN OTHERS =>
                    mux_sel        <= "00";
                    immediate_data <= (OTHERS => '0');
                    acc_write      <= '0';
                    rf_address     <= "000";
                    rf_write       <= '0';
                    alu_sel        <= "000";
                    output_enable  <= '1';
                    done           <= '1';
                    state          <= STATE_HALT;

            END CASE;
        END IF;
    END PROCESS;
    
END Behavioral;
