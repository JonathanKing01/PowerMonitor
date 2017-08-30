library verilog;
use verilog.vl_types.all;
entity mux_test_vlg_check_tst is
    port(
        DataOut         : in     vl_logic_vector(15 downto 0);
        sampler_rx      : in     vl_logic
    );
end mux_test_vlg_check_tst;
