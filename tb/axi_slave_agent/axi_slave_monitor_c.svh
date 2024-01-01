class axi_slave_monitor_c#(DATA_WIDTH = 32) extends uvm_monitor;
    
    `uvm_component_param_utils(axi_slave_monitor_c#(DATA_WIDTH))

    // Interface and Config handles
	  virtual axi_slave_intf #(DATA_WIDTH)   vif;
	  axi_slave_agent_cfg_c  #(DATA_WIDTH)   m_cfg;

    // Analysis Ports
    uvm_analysis_port #(axi_item_c) axi_slave_mon_ap;

    axi_item_c     m_item;

    bit [DATA_WIDTH-1:0]    old_ready_in = 0;
    bit                     old_tvalid_in = 0;
    bit                     old_tlast_in = 0;
    bit                     old_tdata_in = 0;
    

    // Counstructor
    function new(string name, uvm_component parent);
        super.new(name,parent);
        axi_slave_mon_ap = new("axi_slave_mon_ap", this);
    endfunction

    //  Function: build_phase
    extern function void build_phase(uvm_phase phase);
    //  Task: run_phase
    extern task run_phase(uvm_phase phase);
    // Task: monitor_run
    extern task monitor_run();
    // Function: cleanup
    extern function void cleanup();

endclass : axi_slave_monitor_c



function void axi_slave_monitor_c::build_phase(uvm_phase phase);
    // check configuration
    if(!uvm_config_db#(axi_slave_agent_cfg_c #(DATA_WIDTH))::get(this, "", "axi_slave_agent_cfg_t", m_cfg))
        `uvm_fatal(get_full_name(), "Failed to get agent_cfg from database")

    vif = m_cfg.vif;
endfunction: build_phase



task axi_slave_monitor_c::run_phase(uvm_phase phase);
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



task axi_slave_monitor_c::monitor_run();
    forever begin
      m_item = axi_item_c::type_id::create("m_item");
  
      m_item.delay = 0;
  
      @(posedge vif.aclk);
      while (old_ready_in   == vif.ready_in &&
             old_tvalid_in  == vif.tvalid_in &&
             old_tlast_in   == vif.tlast_in &&
             old_tdata_in   == vif.tdata_in) begin
        m_item.delay++;
        @(posedge vif.aclk);
      end

      // user app
      m_item.slave_user_ready = vif.ready_in;

      old_ready_in   = vif.ready_in;
      old_tvalid_in  = vif.tvalid_in;
      old_tlast_in   = vif.tlast_in; 
      old_tdata_in   = vif.tdata_in;  

      // master inputs to slave
      m_item.tvalid  = vif.tvalid_in;
      m_item.tlast = vif.tlast_in;
      m_item.tdata  = vif.tdata_in;

      // slave ready to master
      m_item.tready  = vif.tready_out;

      // slave outputs to observe
      m_item.finish = vif.finish_out;

      // slave data out to user app
      m_item.user_data = vif.data_out;
      
      axi_slave_mon_ap.write(m_item);
      
    end
endtask: monitor_run



function void axi_slave_monitor_c::cleanup();
  old_ready_in = 0;
  old_tvalid_in = 0;
  old_tlast_in = 0;
  old_tdata_in = 0;

  m_item = axi_item_c::type_id::create("m_item");

  m_item.rst_op = 1;
  
  axi_slave_mon_ap.write(m_item);

endfunction : cleanup