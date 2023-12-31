class uart_rx_base_test extends  uvm_test;
  
    `uvm_component_utils(uart_rx_base_test)
  
    rst_drv_c m_rst_drv;
    
    uart_rx_agent_cfg_t  m_uart_rx_agent_cfg;
    virtual uart_rx_if_t uart_rx_if;
  
    uart_rx_env_cfg m_uart_rx_env_cfg;
    uart_rx_env     m_uart_rx_env;
    
  
    function new(string name, uvm_component parent);
      super.new(name,parent);
    endfunction : new
  
  
    virtual function void build_phase(uvm_phase phase);
  
      m_uart_rx_env_cfg = uart_rx_env_cfg::type_id::create ("m_uart_rx_env_cfg");
      m_uart_rx_agent_cfg = uart_rx_agent_cfg_t::type_id::create("m_uart_rx_agent_cfg") ;
  
      if(!uvm_config_db #(uart_rx_if_t)::get(this, "","UART_RX_IF",  m_uart_rx_agent_cfg.vif))
      `uvm_fatal(get_full_name(), "Failed to get uart_rx_agent_cfg")
  
      m_uart_rx_agent_cfg.active=UVM_ACTIVE ;

      m_uart_rx_env_cfg.m_uart_rx_agent_cfg=m_uart_rx_agent_cfg;
  
      uvm_config_db #(uart_rx_env_cfg)::set(this, "*", "m_uart_rx_env_cfg", m_uart_rx_env_cfg);
  
      m_uart_rx_env = uart_rx_env::type_id::create("m_uart_rx_env",this);


      m_rst_drv = rst_drv_c::type_id::create("m_rst_drv", this);
      uvm_config_db#(string)::set(this, "m_rst_drv", "intf_name", "rst_i");
      m_rst_drv.randomize();
    endfunction : build_phase



    virtual task configure_phase(uvm_phase phase);
      phase.raise_objection(this);
      #(100ns);
      phase.drop_objection(this);
    endtask : configure_phase
  

  
    virtual function void set_seqs(uart_rx_vseq_base seq);
      seq.m_cfg = m_uart_rx_env_cfg;
    endfunction
  


    // Print Testbench structure and factory contents
    virtual function void start_of_simulation_phase(uvm_phase phase);
      super.start_of_simulation_phase(phase);
      if (uvm_report_enabled(UVM_MEDIUM)) begin
        this.print();
        factory.print();
      end
    endfunction : start_of_simulation_phase
  
  
endclass : uart_rx_base_test