library verilog;
use verilog.vl_types.all;
entity team2_controller is
    generic(
        float           : integer := 0;
        up              : integer := 1;
        down            : integer := 2
    );
    port(
        clk             : in     vl_logic;
        team2_vu_button : in     vl_logic;
        team2_vd_button : in     vl_logic;
        team2_ver_pos   : out    vl_logic_vector(9 downto 0)
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of float : constant is 1;
    attribute mti_svvh_generic_type of up : constant is 1;
    attribute mti_svvh_generic_type of down : constant is 1;
end team2_controller;
