library verilog;
use verilog.vl_types.all;
entity FullBaseStation_vlg_sample_tst is
    port(
        clk             : in     vl_logic;
        PB0             : in     vl_logic;
        PB1             : in     vl_logic;
        sampler_tx      : out    vl_logic
    );
end FullBaseStation_vlg_sample_tst;
