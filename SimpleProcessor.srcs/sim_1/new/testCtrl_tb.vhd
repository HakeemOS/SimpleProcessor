----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/03/2023 02:29:57 PM
-- Design Name: 
-- Module Name: testCtrl_tb - Behavioral
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity testCtrl_tb is
--  Port ( );
end testCtrl_tb;

architecture Behavioral of testCtrl_tb is

component testCtrl_s 
    port (  instr : in std_logic_vector (4 downto 0); 
            regIN : in std_logic_vector (3 downto 0); 
            wIN : in std_logic; 
            clkIN : in std_logic; 
            ctrlRst : in std_logic;  
            regRst : in std_logic; 
            regOUT : out std_logic_vector (3 downto 0);
            doneOUT: out std_logic
    ); 
end component; 

signal wIN, clkIN, ctrlRst, regRst, doneOUT : std_logic; 
signal instr : std_logic_vector (4 downto 0); 
signal regIN, regOUT : std_logic_vector (3 downto 0); 

constant clk_period : time := 10ns; 
signal clk_stop : boolean; 

begin

    uut : testCtrl_s
    port map (
        instr => instr, 
        regIN => regIN, 
        wIN => wIN, 
        clkIN => clkIN, 
        ctrlRst => ctrlRst, 
        regRst => regRst, 
        regOUT => regOUT, 
        doneOUT => doneOUT
    ); 

    clkproc : process 
    begin
        clkIN <= '1';  
        wait for clk_period/2; 
        clkIN <= '0'; 
        wait for clk_period/2; 
    end process ; -- clkproc

    stim : process
    begin
        ctrlRst <= '1'; 
        regRst <= '0'; 
        wIN <= '0';  

        wait for 50ns; 

        ctrlRst <= '0'; 

        wait for 50 ns; 

        wIN <= '1'; 
        instr <= "00000"; 
        regIN <= "0110"; 
        
        wait for 50ns;
        
        wIN <= '0'; 

        wait for 50ns; 

        instr <= "00100"; 
        wIN <= '1';
        
        wait for 50ns; 

        wIN <= '0'; 
        
        wait for 50ns; 

        instr <= "01001"; 
        wIN <= '1'; 

        wait for 50ns; 

        wIN <= '0'; 

        wait for 50ns; 

        instr <= "11000"; 
        wIN <= '1'; 

        wait for 50ns; 

        wIN <= '0'; 

        wait for 50ns; 

        instr <= "10001"; 
        wIN <= '1'; 

        wait for 50ns; 

        wIN <= '0'; 

        wait for 50ns; 
        
        instr <= "10101"; 
        wIN <= '1'; 

        wait for 50ns; 

        wIN <= '0'; 

        wait for 50ns; 

        instr <= "11100"; 
        wIN <= '1'; 

        wait for 50ns; 

        wIN <= '0'; 

        wait; 



    end process ; -- stim


end Behavioral;
