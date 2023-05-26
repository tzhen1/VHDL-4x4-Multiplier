entity Full_Adder is
    generic (TS : TIME := 0.11 ns; --timing, TS i/p to SUM
             TC : TIME := 0.1 ns); -- TC i/p to Cout
    port (X, Y, Cin: in BIT;
          Cout, Sum: out BIT);
end Full_Adder;
architecture Behave of Full_Adder is
begin
Sum <= X xor Y xor Cin after TS;
Cout <= (X and Y) or (X and Cin) or (Y and Cin)
after TC;
end;