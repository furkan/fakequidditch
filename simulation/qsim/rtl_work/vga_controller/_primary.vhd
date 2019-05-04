library verilog;
use verilog.vl_types.all;
entity vga_controller is
    port(
        current_line    : in     vl_logic_vector(9 downto 0);
        current_pixel   : in     vl_logic_vector(9 downto 0);
        team1_ver_pos   : in     vl_logic_vector(9 downto 0);
        team2_ver_pos   : in     vl_logic_vector(9 downto 0);
        hor_sync        : out    vl_logic;
        ver_sync        : out    vl_logic;
        red             : out    vl_logic_vector(7 downto 0);
        green           : out    vl_logic_vector(7 downto 0);
        blue            : out    vl_logic_vector(7 downto 0)
    );
end vga_controller;
