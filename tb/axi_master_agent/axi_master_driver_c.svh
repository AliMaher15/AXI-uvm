class axi_master_driver_c#(DATA_WIDTH = 32) extends uvm_driver#(axi_item_c);
    
    `uvm_component_param_utils(axi_master_driver_c#(DATA_WIDTH))
    
    // Interface and Config handles
	virtual axi_master_intf     #(DATA_WIDTH)    vif;
	axi_master_agent_cfg_c      #(DATA_WIDTH)    m_cfg;

    
    event           reset_driver;
    axi_item_c      m_item;

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
    // Task : reset_phase
    extern task reset_phase(uvm_phase phase);

endclass : axi_master_driver_c

function void axi_master_driver_c::build_phase(uvm_phase phase);
    // check configuration
    if(!uvm_config_db#(axi_master_agent_cfg_c #(DATA_WIDTH))::get(this, "", "axi_master_agent_cfg_t", m_cfg))
        `uvm_fatal(get_full_name(), "Failed to get agent_cfg from database")

    vif = m_cfg.vif;
endfunction: build_phase



task axi_master_driver_c::reset_phase(uvm_phase phase);
    vif.data_in   <= 'h00;
    vif.send_in   <= 0;
    vif.tready_in <= 0;
endtask: reset_phase



task axi_master_driver_c::run_phase(uvm_phase phase);

    forever begin
        @(posedge vif.areset_n);

        fork
            run_driver();
        join_none
        @(reset_driver);
        disable fork;
        cleanup();
    end
endtask: run_phase


// Task: run_driver
// inputs are: 
//             data:   randomize the data that the master will send to slave
//             send:   the user tell the master to start sending the data on the bus
//             tready: act as the slave to tell the master that you are ready to recieve
task axi_master_driver_c::run_driver();
    forever begin
        seq_item_port.get_next_item(m_item);
        //`uvm_info(get_full_name(), "\nrecieved item from seq", UVM_HIGH)
        //m_item.print();
        while (m_item.delay > 0) begin
            @(posedge vif.aclk);
            m_item.delay--;
        end
        @(posedge vif.aclk);
        // user order
        vif.data_in <= m_item.user_data;   
        vif.send_in <= m_item.send_master;
        // slave response
        vif.tready_in <= m_item.tready; 

        @(posedge vif.aclk);

        vif.send_in <= 0;

        seq_item_port.item_done();
    end
endtask : run_driver


function void axi_master_driver_c::cleanup();
    vif.data_in   <= 'h00;
    vif.send_in   <= 0;
    vif.tready_in <= 0;
endfunction : cleanup