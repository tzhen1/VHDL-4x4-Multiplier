entity Register8 is
        port (D : in BIT_VECTOR(7 downto 0);
        Clk, Clr: in BIT ;
        Q : out BIT_VECTOR(7 downto 0));
end;
architecture Structure of Register8 is
        component DFFClr
                port (Clr, Clk, D : in BIT;
                         Q, QB : out BIT);
        end component;
        begin
                STAGES: for i in 7 downto 0 generate
                FF: DFFClr port map (Clr, Clk, D(i),
                 Q(i), open);
                end generate;
end;