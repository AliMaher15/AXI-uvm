class axi_base_test_c extends  uvm_test;
  
    `uvm_component_utils(axi_base_test_c)
  
    rst_driver_c          m_rst_drv;
    
    axi_master_agent_cfg_t       m_axi_master_agent_cfg;
    axi_slave_agent_cfg_t        m_axi_slave_agent_cfg;
  
    axi_env_cfg_c      m_axi_env_cfg;
    axi_env_c          m_axi_env;
    
  
    // Constructor
    function new(string name, uvm_component parent);
      super.new(name,parent);
    endfunction : new

    // Function: build_phase
    extern virtual function void build_phase(uvm_phase phase);
    // Task:     configure_phase
    extern virtual task configure_phase(uvm_phase phase);
    // Function: set_seqs
    extern virtual function void set_seqs(axi_vseq_base_c seq);
    // Function: start_of_simulation_phase
    extern virtual function void start_of_simulation_phase(uvm_phase phase);

    
  
  
endclass : axi_base_test_c


// Function: build_phase
function void axi_base_test_c::build_phase(uvm_phase phase);
  
  m_axi_env_cfg          = axi_env_cfg_c         ::type_id::create("m_axi_env_cfg");
  m_axi_master_agent_cfg = axi_master_agent_cfg_t::type_id::create("m_axi_master_agent_cfg");
  m_axi_slave_agent_cfg  = axi_slave_agent_cfg_t ::type_id::create("m_axi_slave_agent_cfg");


  if(!uvm_config_db #(axi_master_if_t)::get(this, "","AXI_MASTER_IF",  m_axi_master_agent_cfg.vif))
  `uvm_fatal(get_full_name(), "Failed to get axi_master_agent_cfg")

  if(!uvm_config_db #(axi_slave_if_t)::get(this, "","AXI_SLAVE_IF",  m_axi_slave_agent_cfg.vif))
  `uvm_fatal(get_full_name(), "Failed to get axi_master_agent_cfg")


  m_axi_master_agent_cfg.active  = UVM_ACTIVE;
  m_axi_slave_agent_cfg .active  = UVM_ACTIVE;

  m_axi_env_cfg.m_axi_master_agent_cfg = m_axi_master_agent_cfg;
  m_axi_env_cfg.m_axi_slave_agent_cfg  = m_axi_slave_agent_cfg;


  uvm_config_db #(axi_env_cfg_c)::set(this, "*", "m_axi_env_cfg", m_axi_env_cfg);

  m_axi_env = axi_env_c::type_id::create("m_axi_env",this);

  m_rst_drv = rst_driver_c::type_id::create("m_rst_drv", this);
  uvm_config_db#(string)::set(this, "m_rst_drv", "intf_name", "rst_i");
  m_rst_drv.randomize();
endfunction : build_phase


// Task:     configure_phase
task axi_base_test_c::configure_phase(uvm_phase phase);
  phase.raise_objection(this);
  #(100ns);
  phase.drop_objection(this);
endtask : configure_phase


// Function: set_seqs
function void axi_base_test_c::set_seqs(axi_vseq_base_c seq);
  seq.m_cfg = m_axi_env_cfg;
endfunction


// Function: start_of_simulation_phase
// Print Testbench structure and factory contents
function void axi_base_test_c::start_of_simulation_phase(uvm_phase phase);
  super.start_of_simulation_phase(phase);
  if (uvm_report_enabled(UVM_MEDIUM)) begin
    this.print();
    factory.print();
  end
endfunction : start_of_simulation_phase