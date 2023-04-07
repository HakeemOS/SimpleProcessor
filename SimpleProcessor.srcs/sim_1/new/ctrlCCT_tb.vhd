----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/02/2023 04:22:36 PM
-- Design Name: 
-- Module Name: ctrlCCT_tb - Behavioral
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

entity ctrlCCT_tb is
--  Port ( );
end ctrlCCT_tb;

architecture Behavioral of ctrlCCT_tb is

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

signal w, clk, rst, enR1, enR0, enIN, enOUT, enA, enG, done : std_logic; 
signal sel : std_logic_vector (1 downto 0); 
signal ir : std_logic_vector (4 downto 0); 
signal ALUop : std_logic_vector (3 downto 0); 

constant clk_period : time := 20ns; 
signal clk_stop : boolean; 

begin
    uut : ctrlCCT_s 
    port map (
        w => w, 
        ir => ir, 
        clk => clk, 
        rst => rst, 
        enR1 => enR1,
        enR0 => enR0,
        enIN => enIN, 
        enOUT => enOUT, 
        enA => enA,  
        enG => enG,  
        done => done, 
        sel => sel, 
        ALUop => ALUop
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
        rst <= '0'; 
        w <= '0'; 
        ir <= "00000"; 

        wait for 50ns; 

        w <= '1'; 

        wait for 100ns; 

        ir <= "01110"; 

        wait for 100ns; 

        w <= '0'; 

        wait for 100ns; 

        w <= '1'; 

        wait for 20ns; 

        ir <= "10110"; 

        wait for 80ns; 

        w <= '0'; 

        wait for 20ns; 

        w <= '1'; 

        wait for 20ns; 

        w <= '0'; 

        wait; 

    end process ; -- stim

end Behavioral;
