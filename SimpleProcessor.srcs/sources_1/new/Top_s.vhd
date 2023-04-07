----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/03/2023 09:14:53 AM
-- Design Name: 
-- Module Name: Top_s - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
library myLib; 
use myLib.paraPcr_p.all; 

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Top_s is
    port (  instr : in std_logic_vector (4 downto 0); 
            regIN : in std_logic_vector (3 downto 0); 
            wIN : in std_logic; 
            clkIN : in std_logic; 
            ctrlRst : in std_logic; 
            regRst : in std_logic; 
            regOUT : out std_logic_vector (3 downto 0);
            doneOUT : out std_logic
    );
end Top_s;

architecture Behavioral of Top_s is

-- Components --

component ctrlCCT_s is
    port (  w : in std_logic;
            ir : in std_logic_vector (4 downto 0); 
            clk : in std_logic; 
            rst : in std_logic; 
            enR1 : out std_logic; 
            enR0 : out std_logic; 
            enIN : out std_logic; 
            enOUT : out std_logic; 
            enA : out std_logic; 
            enG : out  std_logic; 
            done : out std_logic; 
            sel : out std_logic_vector (1 downto 0); 
            ALUop : out std_logic_vector (3 downto 0)
    );
end component; 

component ALU_s is
    generic (N : integer  := 4);
    port (  a : in std_logic_vector (N-1 downto 0);
            b : in std_logic_vector (N-1 downto 0); 
            ALUop : in std_logic_vector (3 downto 0); 
            q : out std_logic_vector (N-1 downto 0) 
    );
end component; 
-- signals --

signal enR1_s, enR0_s, enIN_s, enOUT_s, enA_s, enG_s : std_logic := '0'; 
signal sel_s : std_logic_vector (1 downto 0):= "00"; 
signal ALUop_s : std_logic_vector (3 downto 0) := "0000";
signal r0OUT, r1OUT, rINOUT, rAOUT, ALUOUT, rGOUT, muxBus, rOUT_OUT : std_logic_vector (3 downto 0) := "0000";
signal done_t : std_logic := '0'; 

signal sig0 : std_logic := '0'; 

begin
    -- Registers --
    nBitReg(enIN_s, sig0, regRst , clkIN, regIN, rINOUT); 
    nBitReg(enR1_s, sig0, regRst, clkIN, muxBus, r1OUT); 
    nBitReg(enR0_s, sig0, regRst, clkIN, muxBus, r0OUT); 
    nBitReg(enA_s, sig0, regRst, clkIN, muxBus, rAOUT); 
    nBitReg(enOUT_s, sig0, regRst, clkIN, muxBus, rOUT_OUT); 
    nBitReg(enG_s, sig0, regRst, clkIN, ALUOUT, rGOUT); 
    
    -- component maps --
    ctrlCCT0 : ctrlCCT_s 
    port map (
        w => wIN, 
        ir => instr,
        clk => clkIN, 
        rst => ctrlRst, 
        enR1 => enR1_s, 
        enR0 => enR0_s, 
        enIN => enIN_s,
        enOUT => enOUT_s, 
        enA => enA_s, 
        enG => enG_s, 
        done => done_t, 
        sel => sel_s, 
        ALUop => ALUop_s
    ); 

    ALU0 : ALU_s 
        generic map (N => 4)
        port map ( 
            a => rAOUT, 
            b => muxBus, 
            ALUop => ALUop_s, 
            q => ALUOUT
        ); 

    -- Mux -- 
    with sel_s select muxBus <= 
        rINOUT when "00", 
        rGOUT when "01", 
        r0OUT when "10", 
        r1OUT when others; 

    -- Outputs --
    regOUT <= rOUT_OUT; 
    doneOUT <= done_t; 

end Behavioral;
