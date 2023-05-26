entity DFFClr is
    generic(TRQ : TIME := 2 ns;
            TCQ : TIME := 2 ns);
    port (CLR, CLK, D : in BIT;
            Q, QB : out BIT);
end;
architecture Behave of DFFClr is
signal Qi : BIT;

begin QB <= not Qi; Q <= Qi;
process (CLR, CLK) begin
        if CLR = '1' then Qi <= '0' after TRQ; --after 2ns, if clear toggled, reset Qi
        elsif CLK'EVENT and CLK = '1'
                 then Qi <= D after TCQ; --send data through to Qi, when clk on + event happens
        end if;
end process;

end;