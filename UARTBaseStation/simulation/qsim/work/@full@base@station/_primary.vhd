library verilog;
use verilog.vl_types.all;
entity FullBaseStation is
    port(
        ledsegment      : out    vl_logic_vector(6 downto 0);
        clk             : in     vl_logic;
        PB0             : in     vl_logic;
        PB1             : in     vl_logic;
        rx              : in     vl_logic;
        ledsel          : out    vl_logic_vector(3 downto 0)
    );
end FullBaseStation;
