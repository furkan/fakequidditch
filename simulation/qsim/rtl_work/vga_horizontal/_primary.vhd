library verilog;
use verilog.vl_types.all;
entity vga_horizontal is
    port(
        clk             : in     vl_logic;
        next_line       : out    vl_logic;
        current_pixel   : out    vl_logic_vector(9 downto 0)
    );
end vga_horizontal;
