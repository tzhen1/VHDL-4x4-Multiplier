library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
USE ieee.numeric_std.ALL;

entity Mult16 is -- 8x8
port (
        A, B: in BIT_VECTOR(7 downto 0); -- multiplier and multiplicand, each 8 bits
        Start, CLK, Reset: in BIT;
        Result: out BIT_VECTOR(15 downto 0); -- of 8x8, result 16 bit
        Done: out BIT); 
end Mult16;

architecture Structure of Mult16 is use work.Mult_Components.all; -- component declaration
    signal SRA1,SRB, ADDout, MUXout, REGout: BIT_VECTOR(15 downto 0); -- i/p, 8x8, 16 bits, 7 
    signal Zero, Init, Shift, Add, Low: BIT := '0'; 
    signal High: BIT := '1';
    signal F, OFL, OFL2, REGclr: BIT;
    
    -- wiring signals for results after multiplication 
    signal s0: BIT_VECTOR(7 downto 0); signal s1: BIT_VECTOR(7 downto 0); 
    signal s2: BIT_VECTOR(7 downto 0); signal s3: BIT_VECTOR(7 downto 0);
    signal s4: BIT_VECTOR(7 downto 0); signal s5: BIT_VECTOR(8 downto 0);
    signal s6: BIT_VECTOR(11 downto 0); signal s7: BIT_VECTOR(11 downto 0);
    signal s8: BIT_VECTOR(11 downto 0); signal s9: BIT_VECTOR(11 downto 0);
    signal s10: BIT_VECTOR(15 downto 4);
    signal out_Done0: BIT; signal out_Done1: BIT; signal out_Done2: BIT; signal out_Done3: BIT;
    signal all_Done: BIT_VECTOR(3 downto 0);
    
begin
    REGclr <= Init or Reset; 
    --Result <= REGout; -- result 16 bit
    -- use 4 4x4 multipliers, multiplies in blocks, then use 3 adders to add up results
    
    -- first 3 bits (LHS) of a and b
    M44_0 : Mult8 port map
        (CLK=>CLK,Reset=>Reset,Start=>Start,A=>A(3 downto 0),B=>B(3 downto 0),Result=>s0,Done=>out_Done0); -- put result into signal s0 to wire
    
    M44_1 : Mult8 port map
        (CLK=>CLK,Reset=>Reset,Start=>Start,A=>A(7 downto 4),B=>B(3 downto 0),Result=>s1,Done=>out_Done1); -- put done in a signal, for mult16 done
    
    M44_2 : Mult8 port map
        (CLK=>CLK,Reset=>Reset,Start=>Start,A=>A(3 downto 0),B=>B(7 downto 4),Result=>s2,Done=>out_Done2); 
        
    M44_3 : Mult8 port map
        (CLK=>CLK,Reset=>Reset,Start=>Start,A=>A(7 downto 4),B=>B(7 downto 4),Result=>s3,Done=>out_Done3); 
      
    --Done as an array    
    all_Done(0) <= out_Done0; all_Done(1) <= out_Done1;     
    all_Done(2) <= out_Done2; all_Done(3) <= out_Done3;    
    Done <= all_Done(0) and all_Done(1) and all_Done(2)and all_Done(3); -- done after each mult
    --Done <= '1';
    
    Result(3 downto 0) <= s0(3 downto 0); -- first 3 results, q0 to q3
    
    s4<=("0000" & s0(7 downto 4)); -- signal 0000 with 1st multiplier o/p, 0's make up the 8 bit, 7 to 4 = 4 
    
    -- add up partial products from multiplier 1 (s4) and multiplier 2, s1
    A0 : Adder8 port map
        (A=>s1,B=>s4,Cin=>Low,Cout=>s5(8),Sum=>s5(7 downto 0)); --(8), c = Cout, s = Sum

    s6<=("0000" & s2(7 downto 0));
    s7<=(s3(7 downto 0) & "0000");
    
    -- o/p from 3rd mult and 4th mult, need 4 0's for 12 bits
    A1 : Adder12 port map
        (A=>s6(11 downto 0),B=>s7,Cin=>Low,Cout=>OFL,Sum=>s8(11 downto 0));
        
    s9<=("0000" & s5(7 downto 0));
    
    -- take 12 bit, and 8-bit (needs 4 0's)
    A2 : Adder12 port map
        (A=>s9,B=>s8,Cin=>Low,Cout=>OFL2,Sum=>s10); -- s10
    
    Result(15 downto 4) <= s10(15 downto 4); -- final results q15 to q4
    
end;