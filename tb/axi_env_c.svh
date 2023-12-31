class axi_env_c extends uvm_env;

    // register in factory 
    `uvm_component_utils(axi_env_c)

//********** Declare Handles **********//    
    axi_vsequencer_c       m_vseqr;
    axi_env_cfg_c          m_cfg;
    axi_master_agent_t     m_axi_master_agent;
    axi_slave_agent_t      m_axi_slave_agent;
    axi_scoreboard_c       m_scoreboard;
    axi_coverage_c         m_coverage;
    
    function new(string name, uvm_component parent);
        super.new(name,parent);
    endfunction : new

    // Class Methods
    extern function void build_phase(uvm_phase phase);
    extern function void connect_phase(uvm_phase phase);

endclass : axi_env_c

function void axi_env_c::build_phase(uvm_phase phase);

    // check configuration
    if(!uvm_config_db#(axi_env_cfg)::get(this, "", "m_axi_env_cfg", m_cfg))
        `uvm_fatal(get_full_name(), "Failed to get env_cfg from database")

    // path configuration to agents
    uvm_config_db#(axi_master_agent_t)::set(this, "m_axi_master_agent*", "axi_master_agent_cfg_t",   m_cfg.m_axi_master_agent_cfg);
    uvm_config_db#(axi_slave_agent_t) ::set(this, "m_axi_slave_agent*",  "axi_slave_agent_cfg_t",    m_cfg.m_axi_slave_agent_cfg);
    
    // create objects
    m_axi_master_agent     = axi_master_agent_t::type_id::create("m_axi_master_agent",this);
    m_axi_slave_agent      = axi_slave_agent_t ::type_id::create("m_axi_slave_agent",this);
    m_vseqr                = axi_vsequencer    ::type_id::create("m_vseqr",this);
    m_scoreboard           = axi_scoreboard    ::type_id::create("m_scoreboard",this);
    m_coverage             = axi_coverage      ::type_id::create("m_coverage",this);
  
endfunction: build_phase


function void axi_env_c::connect_phase(uvm_phase phase);
    super.connect_phase(phase);

    // connect the virtual sequencer with the agent sequencer
    m_vseqr.m_axi_master_agent_seqr = m_axi_master_agent.m_seqr;
    m_vseqr.m_axi_slave_agent_seqr  = m_axi_slave_agent.m_seqr;

    // Connect Coverage
    m_axi_master_agent.axi_input_ap.connect(m_coverage.analysis_export);
    m_axi_master_agent.axi_input_ap.connect(m_coverage.analysis_export);
    
    // Connect Scoreboard
    m_axi_agent.axi_input_ap.connect(m_scoreboard.axi_in_imp);
    m_axi_agent.axi_output_ap.connect(m_scoreboard.axi_out_imp);
    m_axi_agent.axi_input_ap.connect(m_scoreboard.axi_in_imp);
    m_axi_agent.axi_output_ap.connect(m_scoreboard.axi_out_imp);
    
endfunction: connect_phase
