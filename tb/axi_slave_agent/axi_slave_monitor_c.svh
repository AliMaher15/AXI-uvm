class axi_slave_monitor_c#(DATA_WIDTH = 32) extends uvm_monitor;
    
    `uvm_component_param_utils(axi_slave_monitor_c#(DATA_WIDTH))

    // Interface and Config handles
	  virtual axi_slave_intf #(DATA_WIDTH)   vif;
	  axi_slave_agent_cfg_c  #(DATA_WIDTH)   m_cfg;

    // Analysis Ports
    uvm_analysis_port #(axi_item) input_ap;
    uvm_analysis_port #(axi_item) output_ap;

    axi_item     m_in_item;
    axi_item     m_out_item;
    

    // Counstructor
    function new(string name, uvm_component parent);
        super.new(name,parent);
    endfunction

    //  Function: build_phase
    extern function void build_phase(uvm_phase phase);
    //  Task: run_phase
    extern task run_phase(uvm_phase phase);
    // Task: input_monitor_run
    extern task input_monitor_run();
    // Task: output_monitor_run
    extern task output_monitor_run();
    // Function: cleanup
    extern function void cleanup();

endclass : axi_slave_monitor_c

function void axi_slave_monitor_c::build_phase(uvm_phase phase);
    // check configuration
    if(!uvm_config_db#(axi_slave_agent_cfg_c #(DATA_WIDTH))::get(this, "", "axi_slave_agent_cfg_t", m_cfg))
        `uvm_fatal(get_full_name(), "Failed to get agent_cfg from database")

    vif = m_cfg.vif;
    input_ap = new("input_ap", this);
    output_ap = new("output_ap", this);
endfunction: build_phase

task axi_slave_monitor_c::run_phase(uvm_phase phase);
    forever begin
      @(posedge vif.reset_n);

      fork
        input_monitor_run();
        output_monitor_run();
      join_none

      @(negedge vif.reset_n);
      disable fork;
      cleanup();
    end   
endtask: run_phase


task axi_slave_monitor_c::input_monitor_run();
    forever begin
      m_in_item = axi_item::type_id::create("m_in_item");
  
      @(posedge vif.clk);
      
    end
endtask: input_monitor_run


task axi_slave_monitor_c::output_monitor_run();
    forever begin
      m_out_item = axi_item::type_id::create("m_out_item");
  
      @(posedge vif.clk);
      
    end
endtask: output_monitor_run


function void axi_slave_monitor_c::cleanup();
  m_in_item = axi_item::type_id::create("m_in_item");
  m_out_item = axi_item::type_id::create("m_out_item");

  m_in_item.rst_op = 1;
  m_out_item.rst_op = 1;

  input_ap.write(m_in_item);
  output_ap.write(m_out_item);

endfunction : cleanup