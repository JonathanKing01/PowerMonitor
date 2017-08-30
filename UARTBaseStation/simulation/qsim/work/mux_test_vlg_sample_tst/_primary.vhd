library verilog;
use verilog.vl_types.all;
entity mux_test_vlg_sample_tst is
    port(
        clk             : in     vl_logic;
        DataIn          : in     vl_logic_vector(7 downto 0);
        OutputSelector  : in     vl_logic;
        sampler_tx      : out    vl_logic
    );
end mux_test_vlg_sample_tst;
