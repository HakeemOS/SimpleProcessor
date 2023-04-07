----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/30/2023 06:45:05 PM
-- Design Name: 
-- Module Name: ctrlCCT_s - Behavioral
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

entity ctrlCCT_s is
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
end ctrlCCT_s;

architecture Behavioral of ctrlCCT_s is

type states is (s0, s1, s2_1, s2_2, s3_1, s3_2, s4_1, s4_2, s5, s6); 
signal stt : states := s0;  
signal enIR_t, enX : std_logic;   
signal enIN_t, enR1_t, enR0_t, enA_t, enG_t, enOUT_t, done_t : std_logic;  
signal ALUop_t : std_logic_vector (3 downto 0); 
signal sel_t : std_logic_vector (1 downto 0); 
signal f : std_logic_vector (2 downto 0); 
signal r : std_logic_vector (1 downto 0); 
--signal ir_q : std_logic_vector (4 downto 0); 

signal sig0 : std_logic := '0'; 
begin
    proc1 : process( clk, ir, f, r, enIN_t, sel_t, enA_t, enG_t, enOUT_t, enG_t,
                        ALUop_t, done_t, enR0_t, enR1_t, enIR_t )
    begin
        --nBitReg(enIR, sig0, sig0, clk, ir, ir_q); 
        --f <= ir_q (4 downto 2); 
        --r <= ir_q (1 downto 0); 
        f <= ir (4 downto 2); 
        r <= ir (1 downto 0); 
        enR1 <= enR1_t;
        enR0 <= enR0_t; 
        enIN <= enIN_t; 
        enOUT <= enOUT_t;  
        enIR <= enIR_t;
        enA <= enA_t;
        enG <= enG_t;
        done <= done_t;  
        sel <= sel_t; 
        ALUop <= ALUop_t;  


    end process ; -- proc1
    
    trns : process( stt, clk, w, f, enX, rst )
    begin
        if (rst = '1') then
            stt <= s0; 
        elsif (rising_edge(clk)) then
            case( stt ) is
                when s0 =>
                    if ( w = '1' ) then
                        stt <= s1; 
                    else
                        stt <= s0; 
                    end if ;
                when s1 =>
                    case( f ) is
                        when "011" => stt <= s2_1; 
                        when "100" => stt <= s3_1;
                        when "101" => stt <= s4_1; 
                        when "110" => stt <= s5; 
                        when others => stt <= s6; 
                    end case ;
                when s2_1 => stt <= s2_2;
                when s2_2 => stt <= s6; 
                when s3_1 => stt <= s3_2; 
                when s3_2 => stt <= s6; 
                when s4_1 => stt <= s4_2; 
                when s4_2 => stt <= s6; 
                when s5 => stt <= s6; 
                when others => 
                    if ( w = '0') then
                        stt <= s0;
                    else
                        stt <= s6;     
                    end if ;
            end case ;  
        end if ;
    end process ; -- trns

    output : process( stt, clk, sel_t, enA_t, enG_t, enOUT_t, enIN_t, f, r, w, ALUop_t, done_t )
    begin
        -- defaults --
        enIR_t <= '0'; 
        enIN_t <= '0'; 
        enX <= '0'; 
        sel_t <= "00"; 
        enA_t <= '0';
        enG_t <= '0'; 
        enOUT_t <= '0';  
        enIN_t <= '0';  
        ALUop_t <= "0000";  
        done_t <= '0';  


        case( stt ) is
        
            when s0 =>
                if (w = '1') then
                    enIR_t <= '1';
                end if ;  
            when s1 =>
                case( f ) is
                    when "000" => enIN_t <= '1'; 
                    when "001" => 
                        sel_t <= "00"; 
                        enX <= '1';    
                    when "010" => 
                        sel_t <= '1'&r(1);
                        enX <= '1'; 
                    when "110" => 
                        sel_t <= '1'&r(0);
                        ALUop_t <= "0100"; 
                        enG_t <= '1'; 
                    when "111" => 
                        sel_t <= '1'&r(0);
                        enOUT_t <= '1'; 
                    when others =>
                        sel_t <= '1'&r(0);
                        enA_t <= '1';
                end case ;        
            when s2_1 =>
                sel_t <= '1'&r(1);
                enG_t <= '1';
                ALUop_t <= "0110"; 
            when s2_2 =>
                sel_t <= "01"; 
                enX <= '1'; 
            when s3_1 =>
                sel_t <= "00"; 
                enG_t <= '1'; 
                ALUop_t <= "0110"; 
            when s3_2 =>
                sel_t <= "01"; 
                enX <= '1'; 
            when s4_1 =>
                sel_t <= '1'&r(1); 
                enG_t <= '1'; 
                ALUop_t <= "1111"; 
            when s4_2 =>
                sel_t <= "01"; 
                enX <= '1'; 
            when s5 => 
                sel_t <= "01"; 
                enX <= '1'; 
            when others => done_t <= '1';         
        end case ;


    end process ; -- OUT

    decoder : process( enR0_t, enR1_t, r, enX )
    begin
        enR0_t <= '0'; 
        enR1_t <= '0'; 
        if (enX = '1') then
            if (r(0) = '0') then
                enR0_t <= '1'; 
            else
                enR1_t <= '1'; 
            end if ;
        end if ;
    end process ; -- decoder

    --enIN <= enIN_t; 
    --sel <= sel_t; 
    --enA <= enA_t;
    --enG <= enG_t; 
    --enOUT <= enOUT_t;  
    --ALUop <= ALUop_t;  
    --done <= done_t;  
    --enR0 <= enR0_t; 
    --enR1 <= enR1_t;


end Behavioral;
