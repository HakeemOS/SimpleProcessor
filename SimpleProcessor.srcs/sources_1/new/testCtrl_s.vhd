----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/03/2023 02:23:56 PM
-- Design Name: 
-- Module Name: testCtrl_s - Behavioral
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

entity testCtrl_s is
    port (  instr : in std_logic_vector (4 downto 0); 
            regIN : in std_logic_vector (3 downto 0); 
            wIN : in std_logic; 
            clkIN : in std_logic; 
            ctrlRst : in std_logic; 
            regRst : in std_logic; 
            regOUT : out std_logic_vector (3 downto 0);
            doneOUT : out std_logic
    );
end testCtrl_s;

architecture Behavioral of testCtrl_s is

component ctrlCCT_s is
    port (  w : in std_logic;
            ir : in std_logic_vector (4 downto 0); 
            clk : in std_logic; 
            rst : in std_logic; 
            enR1 : out std_logic; 
            enR0 : out std_logic; 
            enIN : out std_logic; 
            enOUT : out std_logic; 
            enIR : out std_logic; 
            enA : out std_logic; 
            enG : out  std_logic; 
            done : out std_logic; 
            sel : out std_logic_vector (1 downto 0); 
            ALUop : out std_logic_vector (3 downto 0)
    );
end component; 

component nBitReg_s is
    generic (N : integer  := 4); 
    port (  en : in std_logic;
            sclr : in std_logic;
            aclr : in std_logic; 
            clk : in std_logic;
            a : in std_logic_vector (N-1 downto 0);
            q : out std_logic_vector (N-1 downto 0);
            qPCR : out std_logic_vector (N-1 downto 0)
    );
end component;

signal enR1_s, enR0_s, enIN_s, enOUT_s, enA_s, enG_s : std_logic := '0'; 
signal enIR_s : std_logic := '0'; 
signal sel_s : std_logic_vector (1 downto 0):= "00"; 
signal ALUop_s : std_logic_vector (3 downto 0) := "0000";
signal r0OUT, r1OUT, rINOUT, rAOUT, ALUOUT, rGOUT, muxBus, rOUT_OUT : std_logic_vector (3 downto 0) := "0000";
signal done_t : std_logic := '0'; 
signal sig0 : std_logic := '0'; 
signal ir_q : std_logic_vector (4 downto 0) := "00000"; 


begin
    
    --proc1 : process( enIR_s, clkIN, instr, ir_q )
    --begin
    --    nBitReg(enIR_s, sig0, sig0, clkIN, instr, ir_q);
    --end process ; -- proc1

    Reg0 : nBitReg_s 
        generic map (N => 5)
        port map (
            en => enIR_s, 
            sclr => sig0, 
            aclr => sig0, 
            clk => clkIN, 
            a => instr, 
            q => ir_q
        ); 

    ctrl0 : ctrlCCT_s 
    port map (
        w => wIN, 
        ir => ir_q,
        clk => clkIN, 
        rst => ctrlRst, 
        enR1 => enR1_s, 
        enR0 => enR0_s, 
        enIN => enIN_s,
        enOUT => enOUT_s, 
        enA => enA_s, 
        enG => enG_s, 
        enIR => enIR_s,  
        done => done_t, 
        sel => sel_s, 
        ALUop => ALUop_s
    ); 

    doneOUT <= done_t; 


     



end Behavioral;
