library verilog;
use verilog.vl_types.all;
entity Receiver_test is
    port(
        output          : out    vl_logic_vector(7 downto 0);
        clk             : in     vl_logic;
        rx              : in     vl_logic
    );
end Receiver_test;
