library verilog;
use verilog.vl_types.all;
entity fakequidditch_vlg_check_tst is
    port(
        blue            : in     vl_logic_vector(7 downto 0);
        green           : in     vl_logic_vector(7 downto 0);
        hor_sync        : in     vl_logic;
        red             : in     vl_logic_vector(7 downto 0);
        ver_sync        : in     vl_logic;
        sampler_rx      : in     vl_logic
    );
end fakequidditch_vlg_check_tst;
