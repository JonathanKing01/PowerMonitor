library verilog;
use verilog.vl_types.all;
entity mux_test is
    port(
        DataOut         : out    vl_logic_vector(15 downto 0);
        clk             : in     vl_logic;
        OutputSelector  : in     vl_logic;
        DataIn          : in     vl_logic_vector(7 downto 0)
    );
end mux_test;
