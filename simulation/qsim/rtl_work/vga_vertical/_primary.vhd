library verilog;
use verilog.vl_types.all;
entity vga_vertical is
    port(
        clk             : in     vl_logic;
        next_line       : in     vl_logic;
        current_line    : out    vl_logic_vector(9 downto 0)
    );
end vga_vertical;
