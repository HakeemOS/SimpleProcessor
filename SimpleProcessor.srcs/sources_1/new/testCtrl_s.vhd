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
            reg : in std_logic_vector (3 downto 0); 
            w : in std_logic; 
            clk : in std_logic; 
            ctrlRst : in std_logic; 
            regRst : in std_logic; 
            regOUT : out std_logic_vector (3 downto 0);
            done : out std_logic
    );
end testCtrl_s;

architecture Behavioral of testCtrl_s is

-- Components --
component ALU_s is
    generic (N : integer  := 4);
    port (  a : in std_logic_vector (N-1 downto 0);
            b : in std_logic_vector (N-1 downto 0); 
            ALUop : in std_logic_vector (3 downto 0); 
            q : out std_logic_vector (N-1 downto 0) 
    );
end component; 

-- signals --
type states is (s0, s1, s2_1, s2_2, s3_1, s3_2, s4_1, s4_2, s5, s6); 
signal stt : states := s0;  
signal ir : std_logic_vector (4 downto 0) := "00000";  
signal enR1, enR0, enIN, enOUT, enX, enA, enG, enIR, start : std_logic := '0'; 
signal sel : std_logic_vector (1 downto 0):= "00"; 
signal ALUop_t : std_logic_vector (3 downto 0) := "0000";
signal r0OUT, r1OUT, rINOUT, rAOUT, ALUOUT, rGOUT, muxBus, rOUT_OUT : std_logic_vector (3 downto 0) := "0000";
signal done_t : std_logic := '0'; 
signal f : std_logic_vector (2 downto 0) := "000"; 
signal r : std_logic_vector (1 downto 0):= "00";

signal sig0 : std_logic := '0'; 

begin
    -- Registers --
    nBitReg(enIR, sig0, regRst, clk, instr, ir);
    nBitReg(enIN, sig0, regRst , clk, reg, rINOUT); 
    nBitReg(enR1, sig0, regRst, clk, muxBus, r1OUT); 
    nBitReg(enR0, sig0, regRst, clk, muxBus, r0OUT); 
    nBitReg(enA, sig0, regRst, clk, muxBus, rAOUT); 
    nBitReg(enOUT, sig0, regRst, clk, muxBus, rOUT_OUT); 
    nBitReg(enG, sig0, regRst, clk, ALUOUT, rGOUT); 
  
    -- Opcode and RegIndex -- 
    f <= ir (4 downto 2); 
    r <= ir (1 downto 0);  
 
    
    -- component maps --
    ALU0 : ALU_s 
        generic map (N => 4)
        port map ( 
            a => rAOUT, 
            b => muxBus, 
            ALUop => ALUop_t, 
            q => ALUOUT
        ); 

    -- Mux -- 
    with sel select muxBus <= 
        rINOUT when "00", 
        rGOUT when "01", 
        r0OUT when "10", 
        r1OUT when others; 

    -- FSM --
    trns : process( stt, clk, w, f, enX, start, ctrlRst )
    begin
        if (ctrlRst = '1') then
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

    output : process( stt, clk, sel, enA, enG, enOUT, enIN, f, r, w, start,  ALUop_t, done_t )
    begin
        -- defaults --
        enIR <= '0'; 
        enIN <= '0'; 
        enX <= '0'; 
        sel <= "00"; 
        enA <= '0';
        enG <= '0'; 
        enOUT <= '0';  
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
                    when "000" => enIN <= '1'; 
                    when "001" => 
                        sel <= "00"; 
                        enX <= '1';    
                    when "010" => 
                        sel <= '1'&r(1);
                        enX <= '1'; 
                    when "110" => 
                        sel <= '1'&r(0);
                        ALUop_t <= "0100"; 
                        enG <= '1'; 
                    when "111" => 
                        sel <= '1'&r(0);
                        enOUT <= '1'; 
                    when others =>
                        sel <= '1'&r(0);
                        enA <= '1';
                end case ;        
            when s2_1 =>
                sel <= '1'&r(1);
                enG <= '1';
                ALUop_t <= "0110"; 
            when s2_2 =>
                sel <= "01"; 
                enX <= '1'; 
            when s3_1 =>
                sel <= "00"; 
                enG <= '1'; 
                ALUop_t <= "0110"; 
            when s3_2 =>
                sel <= "01"; 
                enX <= '1'; 
            when s4_1 =>
                sel <= '1'&r(1); 
                enG <= '1'; 
                ALUop_t <= "1111"; 
            when s4_2 =>
                sel <= "01"; 
                enX <= '1'; 
            when s5 => 
                sel <= "01"; 
                enX <= '1'; 
            when others => done_t <= '1';         
        end case ;


    end process ; -- OUT

    decoder : process( enR0, enR1, r, enX )
    begin
        enR0 <= '0'; 
        enR1 <= '0'; 
        if (enX = '1') then
            if (r(0) = '0') then
                enR0 <= '1'; 
            else
                enR1 <= '1'; 
            end if ;
        end if ;
    end process ; -- decoder 



    -- Outputs --
    regOUT <= rOUT_OUT; 
    done <= done_t; 

    end Behavioral;
