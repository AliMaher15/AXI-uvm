class axi_master_agent_c#(DATA_WIDTH = 32) extends uvm_agent;

    `uvm_component_param_utils(axi_master_agent_c#(DATA_WIDTH))

    // Agent Components
    axi_master_agent_cfg_c   #(DATA_WIDTH)     m_cfg;
    axi_master_driver_c      #(DATA_WIDTH)     m_driver;
    axi_master_monitor_c     #(DATA_WIDTH)     m_monitor;
    axi_master_agent_seqr_c                    m_seqr;

    // Agent Analysis Ports
    uvm_analysis_port #(axi_item_c)              axi_master_ap;
    
    function new(string name, uvm_component parent);
        super.new(name,parent);
        axi_master_ap  = new("axi_master_ap", this);
    endfunction : new

    //  Function: build_phase
    extern function void build_phase(uvm_phase phase);
    //  Function: connect_phase
    extern function void connect_phase(uvm_phase phase);
    //  Task: pre_reset_phase
    extern virtual task pre_reset_phase(uvm_phase phase);
    
endclass : axi_master_agent_c


//  Task: pre_reset_phase
task axi_master_agent_c::pre_reset_phase(uvm_phase phase);
    if (m_seqr && m_driver) begin
        m_seqr.stop_sequences();
        ->m_driver.reset_driver;
    end
endtask : pre_reset_phase


//  Function: build_phase
function void axi_master_agent_c::build_phase(uvm_phase phase);
    // check configuration
    if(!uvm_config_db#(axi_master_agent_cfg_c #(DATA_WIDTH))::get(this, "", "axi_master_agent_cfg_t", m_cfg))
        `uvm_fatal(get_full_name(), "Failed to get agent_cfg from database")

    m_monitor       = axi_master_monitor_c#(DATA_WIDTH)::type_id::create("m_monitor",this);
    m_monitor.m_cfg = m_cfg;

    if (m_cfg.active == UVM_ACTIVE) begin
        m_seqr         = axi_master_agent_seqr_c         ::type_id::create("m_seqr", this);
        m_driver       = axi_master_driver_c#(DATA_WIDTH)::type_id::create("m_driver",this);
        m_driver.m_cfg = m_cfg;
    end
    
endfunction: build_phase


//  Function: connect_phase
function void axi_master_agent_c::connect_phase(uvm_phase phase);
    super.connect_phase(phase);

    m_monitor.axi_master_mon_ap.connect(axi_master_ap);

    if (m_cfg.active == UVM_ACTIVE) begin
        m_driver.seq_item_port.connect(m_seqr.seq_item_export);
    end
    
endfunction: connect_phase
