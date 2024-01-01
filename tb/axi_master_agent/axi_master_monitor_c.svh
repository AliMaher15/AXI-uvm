class axi_master_monitor_c#(DATA_WIDTH = 32) extends uvm_monitor;
    
    `uvm_component_param_utils(axi_master_monitor_c#(DATA_WIDTH))

    // Interface and Config handles
	  virtual axi_master_intf #(DATA_WIDTH)   vif;
	  axi_master_agent_cfg_c  #(DATA_WIDTH)   m_cfg;

    // Analysis Ports
    uvm_analysis_port #(axi_item_c) axi_master_mon_ap;

    axi_item_c     m_item;

    bit [DATA_WIDTH-1:0]    old_data_in = 0;
    bit                     old_send_in = 0;
    bit                     old_tready_in = 0;
    

    // Counstructor
    function new(string name, uvm_component parent);
        super.new(name,parent);
        axi_master_mon_ap = new("axi_master_mon_ap", this);
    endfunction

    //  Function: build_phase
    extern function void build_phase(uvm_phase phase);
    //  Task: run_phase
    extern task run_phase(uvm_phase phase);
    // Task: monitor_run
    extern task monitor_run();
    // Function: cleanup
    extern function void cleanup();

endclass : axi_master_monitor_c


// Function: build_phase
function void axi_master_monitor_c::build_phase(uvm_phase phase);
    // check configuration
    if(!uvm_config_db#(axi_master_agent_cfg_c #(DATA_WIDTH))::get(this, "", "axi_master_agent_cfg_t", m_cfg))
        `uvm_fatal(get_full_name(), "Failed to get agent_cfg from database")

    vif = m_cfg.vif;
endfunction: build_phase


// Task: run_phase
task axi_master_monitor_c::run_phase(uvm_phase phase);
    forever begin
      @(posedge vif.areset_n);

      fork
        monitor_run();
      join_none

      @(negedge vif.areset_n);
      disable fork;
      cleanup();
    end   
endtask: run_phase


// Task: monitor_run
task axi_master_monitor_c::monitor_run();
    forever begin
      m_item = axi_item_c::type_id::create("m_item");

      m_item.delay = 0;
  
      @(posedge vif.aclk);
      while (old_data_in   == vif.data_in &&
             old_send_in   == vif.send_in &&
             old_tready_in == vif.tready_in) begin
              m_item.delay++;
        @(posedge vif.aclk);
      end
      m_item.user_data = vif.data_in;
      m_item.send_master = vif.send_in;
      m_item.tready = vif.tready_in;

      old_data_in = vif.data_in;
      old_send_in = vif.send_in;
      old_tready_in = vif.tready_in;

      // master outputs to slave
      m_item.tdata  = vif.tdata_out;
      m_item.tvalid = vif.tvalid_out;
      m_item.tlast  = vif.tlast_out;

      // master outputs to observe
      m_item.finish = vif.finish_out;
      
      axi_master_mon_ap.write(m_item);
    end
endtask: monitor_run


// Function: cleanup
function void axi_master_monitor_c::cleanup();
  old_data_in = 0;
  old_send_in = 0;
  old_tready_in = 0;

  m_item = axi_item_c::type_id::create("m_item");

  m_item.rst_op = 1;

  axi_master_mon_ap.write(m_item);

endfunction : cleanup