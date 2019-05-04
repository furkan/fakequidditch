library verilog;
use verilog.vl_types.all;
entity fakequidditch is
    port(
        clk             : in     vl_logic;
        team1_vu_button : in     vl_logic;
        team1_vd_button : in     vl_logic;
        team2_vu_button : in     vl_logic;
        team2_vd_button : in     vl_logic;
        red             : out    vl_logic_vector(7 downto 0);
        green           : out    vl_logic_vector(7 downto 0);
        blue            : out    vl_logic_vector(7 downto 0);
        hor_sync        : out    vl_logic;
        ver_sync        : out    vl_logic
    );
end fakequidditch;
