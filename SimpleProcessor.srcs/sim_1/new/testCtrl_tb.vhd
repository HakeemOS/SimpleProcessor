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

-- Uncomment the followg library declaration if using
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
            reg : in std_logic_vector (3 downto 0); 
            w : in std_logic; 
            clk : in std_logic; 
            ctrlRst : in std_logic;  
            regRst : in std_logic; 
            regOUT : out std_logic_vector (3 downto 0);
            done: out std_logic
    ); 
end component; 

signal w, clk, ctrlRst, regRst, done : std_logic; 
signal instr : std_logic_vector (4 downto 0); 
signal reg, regOUT : std_logic_vector (3 downto 0); 

constant clk_period : time := 10ns; 
signal clk_stop : boolean; 

begin

    uut : testCtrl_s
    port map (
        instr => instr, 
        reg => reg, 
        w => w, 
        clk => clk, 
        ctrlRst => ctrlRst, 
        regRst => regRst, 
        regOUT => regOUT, 
        done => done
    ); 

    clkproc : process 
    begin
        clk <= '1';  
        wait for clk_period/2; 
        clk <= '0'; 
        wait for clk_period/2; 
    end process ; -- clkproc

    stim : process
    begin
        ctrlRst <= '1'; 
        regRst <= '0'; 
        w <= '0'; 
        reg <= "0110"; 

        wait for 50ns; 

        ctrlRst <= '0'; 

        wait for 50 ns; 

        w <= '1'; 
        instr <= "00000"; 
        
        
        wait for 50ns;
        
        w <= '0'; 

        wait for 50ns; 

        instr <= "00100"; 
        w <= '1';
        
        wait for 50ns; 

        w <= '0'; 
        
        wait for 50ns; 

        instr <= "01001"; 
        w <= '1'; 

        wait for 50ns; 

        w <= '0'; 

        wait for 50ns; 

        instr <= "11000"; 
        w <= '1'; 

        wait for 50ns; 

        w <= '0'; 

        wait for 50ns; 

        instr <= "01101"; 
        w <= '1'; 

        wait for 50ns; 

        w <= '0'; 

        wait for 50ns; 
        
        instr <= "10101"; 
        w <= '1'; 

        wait for 50ns; 

        w <= '0'; 

        wait for 50ns; 

        instr <= "11101"; 
        w <= '1'; 

        wait for 50ns; 

        w <= '0'; 

        wait; 
    end process ; -- stim


end Behavioral;
