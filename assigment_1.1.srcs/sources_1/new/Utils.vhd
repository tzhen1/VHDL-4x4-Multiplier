package Utils is
        function Convert (N,L: NATURAL) return BIT_VECTOR;
        function Convert (B: BIT_VECTOR) return NATURAL;
end Utils;
package body Utils is
        function Convert (N,L: NATURAL) return BIT_VECTOR is
                variable T:BIT_VECTOR(L-1 downto 0);
                variable V:NATURAL:= N;
                begin for i in T'RIGHT to T'LEFT loop
                        T(i) := BIT'VAL(V mod 2); V:= V/2;
                end loop; return T;
        end;
        function Convert (B: BIT_VECTOR) return NATURAL is
            variable T:BIT_VECTOR(B'LENGTH-1 downto 0) := B;
            variable V:NATURAL:= 0;
            begin for i in T'RIGHT to T'LEFT loop
                    if T(i) = '1' then V:= V + (2**i); end if;
                    end loop; return V;
            end;
end Utils;
