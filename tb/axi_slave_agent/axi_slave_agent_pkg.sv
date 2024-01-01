package axi_slave_agent_pkg;

    //uvm pakage and macros
    import uvm_pkg::*;
    `include "uvm_macros.svh"
    import axi_global_params_pkg::*;

    import axi_item_pkg::*;

    `include "axi_slave_agent_cfg_c.svh"
    `include "axi_slave_monitor_c.svh"
    `include "axi_slave_agent_seqr_c.svh"
    `include "axi_slave_driver_c.svh"
    `include "axi_slave_agent_c.svh"
  
  
  endpackage : axi_slave_agent_pkg