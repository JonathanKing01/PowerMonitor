library verilog;
use verilog.vl_types.all;
entity FullBaseStation is
    port(
        led_dp          : out    vl_logic;
        clk             : in     vl_logic;
        PB0             : in     vl_logic;
        PB1             : in     vl_logic;
        Input           : in     vl_logic_vector(7 downto 0);
        Current_register: out    vl_logic_vector(15 downto 0);
        ledsegment      : out    vl_logic_vector(6 downto 0);
        ledsel          : out    vl_logic_vector(3 downto 0)
    );
end FullBaseStation;
