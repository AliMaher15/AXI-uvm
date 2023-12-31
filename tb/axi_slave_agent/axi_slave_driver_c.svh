class axi_slave_driver_c#(DATA_WIDTH = 32) extends uvm_driver#(axi_item);
    
    `uvm_component_param_utils(axi_slave_driver_c#(DATA_WIDTH))
    
    // Interface and Config handles
	virtual axi_slave_intf     #(DATA_WIDTH)    vif;
	axi_slave_agent_cfg_c      #(DATA_WIDTH)    m_cfg;

    
    event           reset_driver;
    axi_item        m_item;

    // Constructor
    function new(string name, uvm_component parent);
        super.new(name,parent);
    endfunction

    //  Function: build_phase
    extern function void build_phase(uvm_phase phase);
    //  Task: run_phase
    extern task run_phase(uvm_phase phase);
    // Task: run_driver
    extern task run_driver();
    // Function: cleanup
    extern function void cleanup();

endclass : axi_slave_driver_c

function void axi_slave_driver_c::build_phase(uvm_phase phase);
    // check configuration
    if(!uvm_config_db#(axi_slave_agent_cfg_c #(DATA_WIDTH))::get(this, "", "axi_slave_agent_cfg_t", m_cfg))
        `uvm_fatal(get_full_name(), "Failed to get agent_cfg from database")

    vif = m_cfg.vif;
endfunction: build_phase

task axi_slave_driver_c::run_phase(uvm_phase phase);

    forever begin
        @(posedge vif.reset_n);

        fork
            run_driver();
        join_none
        @(reset_driver);
        disable fork;
        cleanup();
    end
endtask: run_phase



task axi_slave_driver_c::run_driver();
    forever begin
        seq_item_port.get_next_item(m_item);
        //`uvm_info(get_full_name(), "\nrecieved item from seq", UVM_HIGH)
        //m_item.print();
        while (m_item.delay > 0) begin
            @(posedge vif.clk);
            m_item.delay--;
        end

        @(posedge vif.clk);
       

        seq_item_port.item_done();
    end
endtask : run_driver


function void axi_slave_driver_c::cleanup();
    //m_item.delete();
endfunction : cleanup