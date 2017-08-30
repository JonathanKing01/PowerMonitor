library verilog;
use verilog.vl_types.all;
entity FullBaseStation_vlg_check_tst is
    port(
        Current_register: in     vl_logic_vector(15 downto 0);
        led_dp          : in     vl_logic;
        ledsegment      : in     vl_logic_vector(6 downto 0);
        ledsel          : in     vl_logic_vector(3 downto 0);
        sampler_rx      : in     vl_logic
    );
end FullBaseStation_vlg_check_tst;
