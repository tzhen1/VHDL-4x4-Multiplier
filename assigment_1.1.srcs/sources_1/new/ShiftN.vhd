entity ShiftN is
        generic (TCQ : TIME := 0.3 ns;
                TLQ : TIME := 0.5 ns;
                TSQ : TIME := 0.7 ns);
        port(CLK, CLR, LD, SH, DIR: in BIT;
                D: in BIT_VECTOR;
                Q: out BIT_VECTOR);
        begin assert (D'LENGTH <= Q'LENGTH)
             report "D wider than output Q"
severity Failure;
end ShiftN;
architecture Behave of ShiftN is
        begin Shift: process (CLR, CLK)
        subtype InB is NATURAL range D'LENGTH-1
                       downto 0;
        subtype OutB is NATURAL range Q'LENGTH-1
                       downto 0;
        variable St: BIT_VECTOR(OutB);
        begin
                if CLR = '1' then
                        St := (others => '0');
                        Q <= St after TCQ;
                elsif CLK'EVENT and CLK='1' then
                        if LD = '1' then
                                St := (others =>
                                '0');
                                St(InB) := D;
                                Q <= St after TLQ;
                        elsif SH = '1' then
                                case DIR is
                                when '0' => St := '0'
                        & St(St'LEFT downto 1);
                                 when '1' => St :=
                        St(St'LEFT-1 downto 0) & '0';
                                end case;
                                Q <= St after TSQ;
                        end if;
                end if;
        end process;
end;