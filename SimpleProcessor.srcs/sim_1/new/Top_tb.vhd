----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/03/2023 11:15:02 AM
-- Design Name: 
-- Module Name: Top_tb - Behavioral
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

entity Top_tb is
--  Port ( );
end Top_tb;

architecture Behavioral of Top_tb is

component Top_s 
    port (  instr : in std_logic_vector (5 downto 0); 
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
signal instr : std_logic_vector (5 downto 0); 
signal reg, regOUT : std_logic_vector (3 downto 0); 

constant clk_period : time := 10ns; 
signal clk_stop : boolean; 

begin

    uut : Top_s 
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
        instr <= "000000"; 
        
        
        wait for 50ns;
        
        w <= '0'; 

        wait for 50ns; 

        instr <= "000100"; 
        w <= '1';
        
        wait for 50ns; 

        w <= '0'; 
        
        wait for 50ns; 

        instr <= "001001"; 
        w <= '1'; 

        wait for 50ns; 

        w <= '0'; 

        wait for 50ns; 

        instr <= "110100"; 
        w <= '1'; 

        wait for 50ns; 

        w <= '0'; 

        wait for 50ns; 

        instr <= "001101"; 
        w <= '1'; 

        wait for 50ns; 

        w <= '0'; 

        wait for 50ns; 
        
        instr <= "101101"; 
        w <= '1'; 

        wait for 50ns; 

        w <= '0'; 

        wait for 50ns; 

        instr <= "111101"; 
        w <= '1'; 

        wait for 50ns; 

        w <= '0'; 

        wait for 50ns; 

        instr <= "100101"; 
        w <= '1'; 

        wait for 50ns; 

        w <= '0';  

        wait for 50ns; 

        instr <= "110101"; 
        w <= '1'; 

        wait for 50ns; 

        w <= '0'; 

        wait for 50ns; 

        instr <= "010101"; 
        w <= '1'; 

        wait for 50ns; 

        w <= '0'; 

        wait; 



    end process ; -- stim

end Behavioral;
