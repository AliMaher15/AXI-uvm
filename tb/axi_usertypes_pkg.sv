package axi_usertypes_pkg;

    import axi_global_params_pkg::*;
    import axi_master_agent_pkg::*;
    import axi_slave_agent_pkg::*;

    typedef axi_master_agent_cfg_c #(.DATA_WIDTH(DATA_WIDTH)) axi_master_agent_cfg_t;
    typedef axi_master_agent_c     #(.DATA_WIDTH(DATA_WIDTH)) axi_master_agent_t;

    typedef axi_slave_agent_cfg_c  #(.DATA_WIDTH(DATA_WIDTH)) axi_slave_agent_cfg_t;
    typedef axi_slave_agent_c      #(.DATA_WIDTH(DATA_WIDTH)) axi_slave_agent_t;

    typedef virtual axi_master_intf#(.DATA_WIDTH(DATA_WIDTH)) axi_master_if_t;
    typedef virtual axi_slave_intf #(.DATA_WIDTH(DATA_WIDTH)) axi_slave_if_t;
    
endpackage: axi_usertypes_pkg