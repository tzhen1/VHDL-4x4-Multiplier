library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
USE ieee.numeric_std.ALL;

entity Mult8 is
port (
        A, B: in BIT_VECTOR(3 downto 0); 
        Start, CLK, Reset: in BIT;
        Result: out BIT_VECTOR(7 downto 0); 
        Done: out BIT); 
end Mult8;

architecture Structure of Mult8 is use work.Mult_Components.all;
    signal SRA1,SRB, ADDout, MUXout, REGout: BIT_VECTOR(7 downto 0); -- rename SRA1
    signal Zero, Init, Shift, Add, Low: BIT := '0'; 
    signal High: BIT := '1';
    signal F, OFL, REGclr: BIT;
begin
    REGclr <= Init or Reset; Result <= REGout;
    SR1 : ShiftN port map
        (CLK=>CLK,CLR=>Reset,LD=>Init,SH=>Shift,DIR=>Low ,D=>A,Q=>SRA1); -- rename SRA as its keyword to SRA1
    SR2 : ShiftN port map
        (CLK=>CLK,CLR=>Reset,LD=>Init,SH=>Shift,DIR=>High,D=>B,Q=>SRB);
    Z1 : AllZero port map
        (X=>SRA1,F=>Zero);
    A1 : Adder8 port map
        (A=>SRB,B=>REGout,Cin=>Low,Cout=>OFL,Sum=>ADDout);
    M1 : Mux8 port map
        (A=>ADDout,B=>REGout,Sel=>Add,Y=>MUXout);
    R1 : Register8 port map
        (D=>MUXout,Q=>REGout,Clk=>CLK,Clr=>REGclr);
    F1 : SM_1 port map
        (Start,CLK,SRA1(0),Zero,Reset,Init,Shift,Add,Done); 
end;