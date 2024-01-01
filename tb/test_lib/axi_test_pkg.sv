package axi_test_pkg ;

    import uvm_pkg::*;
    `include "uvm_macros.svh"

    import axi_item_pkg::*;
    import axi_global_params_pkg::*;
    import axi_usertypes_pkg::*;
    import axi_master_agent_pkg::*;
    import axi_slave_agent_pkg::*;
    import axi_seq_pkg::*;
    import axi_tb_pkg::*;

    `include "axi_vseq_base_c.svh"    
    `include "axi_base_test_c.svh"

    `include "axi_test_vseq_c.svh"
    `include "axi_test_c.svh"

    `include "idle_reset_test_c.svh"
    `include "active_reset_test_c.svh"

endpackage : axi_test_pkg