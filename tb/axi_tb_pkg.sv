package axi_tb_pkg;

    import uvm_pkg::*;
    `include "uvm_macros.svh"
 
    import axi_item_pkg::*;
    import axi_master_agent_pkg::*;
    import axi_slave_agent_pkg::*;
    import axi_global_params_pkg::*;
    import axi_usertypes_pkg::*;

    `include "rst_driver_c.svh"

    `include "axi_checkers/axi_coverage_c.svh"
    `include "axi_checkers/axi_scoreboard_c.svh"
    `include "axi_env_cfg_c.svh"
    `include "axi_vsequencer_c.svh"	
    `include "axi_env_c.svh"    

endpackage : axi_tb_pkg