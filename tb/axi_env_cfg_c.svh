class axi_env_cfg_c extends uvm_object;

    `uvm_object_utils(axi_env_cfg_c);

    //  Variables
    // rand bit flag = 0;
    //  Constraints

    // agents configurations
    axi_master_agent_cfg_t  m_axi_master_agent_cfg;
    axi_slave_agent_cfg_t   m_axi_slave_agent_cfg;

    //  Constructor: new
    function new(string name = "");
        super.new(name);
    endfunction: new
    
endclass: axi_env_cfg_c