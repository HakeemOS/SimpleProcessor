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
end ctrlCCT_s;

architecture Behavioral of ctrlCCT_s is

type states is (s0, s1, s2_1, s2_2, s3_1, s3_2, s4_1, s4_2, s5_1, s5_2, s6_1, s6_2, s7_1,
                s7_2, s8_1, s8_2, s9_1, s9_2, s10_1, s10_2, s11, s12, s13, s14); 
signal stt : states := s0;  
signal enIR, enX, start : std_logic;   
signal enIN_t, enR1_t, enR0_t, enA_t, enG_t, enOUT_t, done_t : std_logic;  
signal ALUop_t : std_logic_vector (3 downto 0); 
signal sel_t : std_logic_vector (1 downto 0); 
signal f : std_logic_vector (3 downto 0); 
signal r : std_logic_vector (1 downto 0); 
signal ir_q : std_logic_vector (5 downto 0); 

signal sig0 : std_logic := '0'; 

begin
    nBitReg(enIR, sig0, sig0, clk, ir, ir_q); 
    f <= ir_q (5 downto 2); 
    r <= ir_q (1 downto 0); 
    
    trns : process( stt, clk, w, f, start, enX, rst )
    begin
        if (rst = '1') then
            stt <= s0; 
        elsif (rising_edge(clk)) then
            case( stt ) is
                when s0 =>
                    if ( start = '1' ) then
                        stt <= s1; 
                    else
                        stt <= s0; 
                    end if ;
                when s1 =>
                    case( f ) is
                        when "0011" => stt <= s2_1; 
                        when "0100" => stt <= s3_1;
                        when "0101" => stt <= s4_1;
                        when "0110" => stt <= s5_1;
                        when "0111" => stt <= s6_1;
                        when "1000" => stt <= s7_1;
                        when "1001" => stt <= s8_1;
                        when "1010" => stt <= s9_1;
                        when "1011" => stt <= s10_1;
                        when "1100" => stt <= s11;
                        when "1101" => stt <= s12; 
                        when "1110" => stt <= s13;
                        when others => stt <= s14; 
                    end case ;
                when s2_1 => stt <= s2_2;
                when s2_2 => stt <= s14; 
                when s3_1 => stt <= s3_2; 
                when s3_2 => stt <= s14; 
                when s4_1 => stt <= s4_2; 
                when s4_2 => stt <= s14; 
                when s5_1 => stt <= s5_2; 
                when s5_2 => stt <= s14;
                when s6_1 => stt <= s6_2; 
                when s6_2 => stt <= s14; 
                when s7_1 => stt <= s7_2; 
                when s7_2 => stt <= s14; 
                when s8_1 => stt <= s8_2; 
                when s8_2 => stt <= s14; 
                when s9_1 => stt <= s9_2; 
                when s9_2 => stt <= s14; 
                when s10_1 => stt <= s10_2; 
                when s10_2 => stt <= s14; 
                when s11 => stt <= s14; 
                when s12 => stt <= s14;     
                when s13 => stt <= s14; 
                when others => 
                    if ( w = '0') then
                        stt <= s0;
                    else
                        stt <= s14;     
                    end if ;
            end case ;  
        end if ;
    end process ; -- trns

    output : process( stt, clk, sel_t, enA_t, enG_t, enOUT_t, enIN_t, f, r, w, start, ALUop_t, done_t )
    begin
        -- defaults --
        enIR <= '0'; 
        enIN_t <= '0'; 
        enX <= '0'; 
        sel_t <= "00"; 
        enA_t <= '0';
        enG_t <= '0'; 
        enOUT_t <= '0';  
        ALUop_t <= "0000";  
        done_t <= '0';  
        start <= '0'; 


        case( stt ) is
        
            when s0 =>
                if (w = '1') then
                    enIR <= '1';
                    start <= '1'; 
                end if ;  
            when s1 =>
                case( f ) is
                    when "0000" => enIN_t <= '1'; 
                    when "0001" => 
                        sel_t <= "00"; 
                        enX <= '1';    
                    when "0010" => 
                        sel_t <= '1'&r(1);
                        enX <= '1'; 
                    when "1100" => 
                        sel_t <= '1'&r(0);
                        ALUop_t <= "1001";
                        enG_t <= '1'; 
                    when "1101" => 
                        sel_t <= '1'&r(0);
                        ALUop_t <= "0100"; 
                        enG_t <= '1'; 
                    when "1110" => 
                        sel_t <= '1'&r(0);
                        ALUop_t <= "0101"; 
                        enG_t <= '1'; 
                    when "1111" => 
                        sel_t <= '1'&r(0);
                        enOUT_t <= '1'; 
                    when others =>
                        sel_t <= '1'&r(0);
                        enA_t <= '1';
                end case ;        
            when s2_1 =>                -- add Rx, Ry
                sel_t <= '1'&r(1);
                enG_t <= '1';
                ALUop_t <= "0110"; 
            when s2_2 =>                
                sel_t <= "01"; 
                enX <= '1';             
            when s3_1 =>                -- add Rx, IN
                sel_t <= "00"; 
                enG_t <= '1'; 
                ALUop_t <= "0110"; 
            when s3_2 =>
                sel_t <= "01"; 
                enX <= '1'; 
            when s4_1 =>                -- sub Rx, Ry
                sel_t <= '1'&r(1); 
                enG_t <= '1'; 
                ALUop_t <= "0111"; 
            when s4_2 =>
                sel_t <= "01"; 
                enX <= '1'; 
            when s5_1 =>                -- sub Rx, IN 
                sel_t <= "00"; 
                enG_t <= '1'; 
                ALUop_t <= "0111"; 
            when s5_2 =>
                sel_t <= "01"; 
                enX <= '1'; 
            when s6_1 =>                -- and Rx, Ry
                sel_t <= '1'&r(1); 
                enG_t <= '1'; 
                ALUop_t <= "1010"; 
            when s6_2 =>
                sel_t <= "01"; 
                enX <= '1'; 
            when s7_1 =>                -- nand Rx, Ry 
                sel_t <= '1'&r(1); 
                enG_t <= '1'; 
                ALUop_t <= "1100"; 
            when s7_2 =>
                sel_t <= "01"; 
                enX <= '1'; 
            when s8_1 =>                -- or Rx, Ry
                sel_t <= '1'&r(1); 
                enG_t <= '1'; 
                ALUop_t <= "1011"; 
            when s8_2 =>
                sel_t <= "01"; 
                enX <= '1'; 
            when s9_1 =>                -- xor Rx, Ry 
                sel_t <= '1'&r(1); 
                enG_t <= '1'; 
                ALUop_t <= "1110"; 
            when s9_2 =>
                sel_t <= "01"; 
                enX <= '1'; 
            when s10_1 =>               -- xnor Rx, Ry
                sel_t <= '1'&r(1); 
                enG_t <= '1'; 
                ALUop_t <= "1111"; 
            when s10_2 =>
                sel_t <= "01"; 
                enX <= '1'; 
            when s11 =>                 -- not Rx 
                sel_t <= "01"; 
                enX <= '1'; 
            when s12 =>                  -- inc Rx 
                sel_t <= "01"; 
                enX <= '1'; 
            when s13 =>                  -- dec Rx 
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

    enIN <= enIN_t; 
    sel <= sel_t; 
    enA <= enA_t;
    enG <= enG_t; 
    enOUT <= enOUT_t;  
    ALUop <= ALUop_t;  
    done <= done_t;  
    enR0 <= enR0_t; 
    enR1 <= enR1_t;


end Behavioral;
