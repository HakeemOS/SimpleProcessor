----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/30/2023 08:14:31 AM
-- Design Name: 
-- Module Name: ALU_s - Behavioral
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
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity ALU_s is
    generic (N : integer  := 4);
    port (  a : in std_logic_vector (N-1 downto 0);
            b : in std_logic_vector (N-1 downto 0); 
            ALUop : in std_logic_vector (3 downto 0); 
            q : out std_logic_vector (N-1 downto 0) 
    );
end ALU_s;

architecture Behavioral of ALU_s is
signal qTemp : std_logic_vector (N-1 downto 0); 
begin
    proc1 : process( a, b, ALUop )
    begin
        case ALUop is
            -- arithmetic 
            when "0000" => qTemp <= a; 
            when "0001" => qTemp <= std_logic_vector (unsigned (a) + 1); 
            when "0010" => qTemp <= std_logic_vector (unsigned (a) - 1); 
            when "0011" => qTemp <= b; 
            when "0100" => qTemp <= std_logic_vector (unsigned (b) + 1); 
            when "0101" => qTemp <= std_logic_vector (unsigned (b) - 1); 
            when "0110" => qTemp <= std_logic_vector (unsigned (a) + unsigned (b)); 
            when "0111" => qTemp <= std_logic_vector (unsigned (a) - unsigned (b));
            -- logic 
            when "1000" => qTemp <= not a; 
            when "1001" => qTemp <= not b; 
            when "1010" => qTemp <= a and b; 
            when "1011" => qTemp <= a or b; 
            when "1100" => qTemp <= a nand b; 
            when "1101" => qTemp <= a nor b; 
            when "1110" => qTemp <= a xor b; 
            when others => qTemp <= a xnor b; 
        end case ;
    end process ; -- proc1

    q <= qTemp; 

end Behavioral;
