library verilog;
use verilog.vl_types.all;
entity clock_divider is
    port(
        clk_in          : in     vl_logic;
        division        : in     vl_logic_vector(25 downto 0);
        clk_out         : out    vl_logic
    );
end clock_divider;
