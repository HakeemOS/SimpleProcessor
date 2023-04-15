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
    port (  instr : in std_logic_vector (5 downto 0); 
            reg : in std_logic_vector (3 downto 0); 
            w : in std_logic; 
            clk : in std_logic; 
            ctrlRst : in std_logic; 
            regRst : in std_logic; 
            regOUT : out std_logic_vector (3 downto 0);
            done : out std_logic
    );
end Top_s;

architecture Behavioral of Top_s is

    -- Components -- 
component ALU_s is
    generic (N : integer  := 4);
    port (  a : in std_logic_vector (N-1 downto 0);
            b : in std_logic_vector (N-1 downto 0); 
            ALUop : in std_logic_vector (3 downto 0); 
            q : out std_logic_vector (N-1 downto 0) 
    );
end component; 

component ctrlCCT_s is
    port (  w : in std_logic;
            ir : in std_logic_vector (5 downto 0); 
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

-- signals -- 
signal enR1, enR0, enIN, enOUT, enA, enG : std_logic := '0'; 
signal enIR_s : std_logic := '0'; 
signal sel : std_logic_vector (1 downto 0):= "00"; 
signal ALUop : std_logic_vector (3 downto 0) := "0000";
signal r0OUT, r1OUT, rINOUT, rAOUT, ALUOUT, rGOUT, muxBus, rOUT_OUT : std_logic_vector (3 downto 0) := "0000";
signal done_t : std_logic := '0'; 
signal sig0 : std_logic := '0'; 


begin
    -- Registers -- 
    nBitReg(enIN, regRst, regRst , clk, reg, rINOUT); 
    nBitReg(enR1, regRst, regRst, clk, muxBus, r1OUT); 
    nBitReg(enR0, regRst, regRst, clk, muxBus, r0OUT); 
    nBitReg(enA, regRst, regRst, clk, muxBus, rAOUT); 
    nBitReg(enOUT, regRst, regRst, clk, muxBus, rOUT_OUT); 
    nBitReg(enG, regRst, regRst, clk, ALUOUT, rGOUT); 
        
    -- component maps --
    ALU0 : ALU_s 
        generic map (N => 4)
        port map ( 
            a => rAOUT, 
            b => muxBus, 
            ALUop => ALUop, 
            q => ALUOUT
        ); 

    ctrl0 : ctrlCCT_s 
    port map (
        w => w, 
        ir => instr,
        clk => clk, 
        rst => ctrlRst, 
        enR1 => enR1, 
        enR0 => enR0, 
        enIN => enIN,
        enOUT => enOUT, 
        enA => enA, 
        enG => enG, 
        done => done_t, 
        sel => sel, 
        ALUop => ALUop
    ); 

    -- Mux -- 
    with sel select muxBus <= 
        rINOUT when "00", 
        rGOUT when "01", 
        r0OUT when "10", 
        r1OUT when others; 

    -- Outputs --
    regOUT <= rOUT_OUT; 
    done <= done_t;

end Behavioral;


