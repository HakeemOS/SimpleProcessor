----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/30/2023 06:16:16 PM
-- Design Name: 
-- Module Name: ALU_tb - Behavioral
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

entity ALU_tb is
--  Port ( );
end ALU_tb;

architecture Behavioral of ALU_tb is

    component ALU_s is
        port (  a : in std_logic_vector (3 downto 0);
                b : in std_logic_vector (3 downto 0); 
                ALUop : in std_logic_vector (3 downto 0); 
                q : out std_logic_vector (3 downto 0) 
        );
    end component; 

    signal a, b, ALUop, q : std_logic_vector (3 downto 0); 

begin
    uut : ALU_s
    port map (
        a => a, 
        b => b, 
        ALUop => ALUop, 
        q => q
    ); 

    proc1 : process 
    begin
        a <= "0011";
        b <= "0010"; 
        ALUop <= "0000"; 

        wait for 50ns; 

        ALUop <= "0001"; 

        wait for 50ns; 

        ALUop <= "0010"; 

        wait for 50ns; 

        ALUop <= "0011"; 

        wait for 50ns; 

        ALUop <= "0100"; 

        wait for 50ns; 

        ALUop <= "0101";

        wait for 50ns; 

        ALUop <= "0110";

        wait for 50ns; 

        ALUop <= "0111";
        
        wait for 50ns; 

        ALUop <= "1000"; 

        wait for 50ns; 

        ALUop <= "1001"; 

        wait for 50ns; 

        ALUop <= "1010"; 

        wait for 50ns; 

        ALUop <= "1011"; 

        wait for 50ns; 

        ALUop <= "1100"; 

        wait for 50ns; 

        ALUop <= "1101";

        wait for 50ns; 

        ALUop <= "1110";

        wait for 50ns; 

        ALUop <= "1111";

        wait; 


    end process ; -- proc1


end Behavioral;
