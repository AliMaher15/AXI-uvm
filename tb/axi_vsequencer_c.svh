class axi_vsequencer_c extends uvm_sequencer;

    // register in factory
    `uvm_component_utils(axi_vsequencer_c)

    // contains the following sequencers
    axi_master_agent_seqr_c   m_axi_master_agent_seqr;
    axi_slave_agent_seqr_c    m_axi_slave_agent_seqr;
    // env config
    axi_env_cfg_c             m_cfg;
    
    function new(string name, uvm_component parent);
        super.new(name, parent);  
    endfunction

    function void build_phase(uvm_phase phase);
        if(!uvm_config_db #(axi_env_cfg_c)::get(this, "","m_axi_env_cfg", m_cfg))
       `uvm_fatal(get_full_name(), "Failed to get axi_env_cfg from database")
    endfunction: build_phase
    

endclass : axi_vsequencer_c