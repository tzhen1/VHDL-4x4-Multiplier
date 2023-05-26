entity Adder8 is
    port (A, B: in BIT_VECTOR(7 downto 0);
    Cin: in BIT; 
    Cout: out BIT;
    Sum: out BIT_VECTOR(7 downto 0));
end Adder8;
architecture Structure of Adder8 is
component Full_Adder
port (X, Y, Cin: in BIT; 
      Cout, Sum: out BIT);
end component;
    signal C: BIT_VECTOR(7 downto 0);
    begin
    Stages: for i in 7 downto 0 generate -- uses 7 full adders
    LowBit: if i = 0 generate
    FA:Full_Adder port map
         (A(0),B(0),Cin,C(0),Sum(0));
    end generate;
    OtherBits: if i /= 0 generate
    FA:Full_Adder port map
         (A(i),B(i),C(i-1),C(i),Sum(i));
    end generate;
end generate;
Cout <= C(7);
end;