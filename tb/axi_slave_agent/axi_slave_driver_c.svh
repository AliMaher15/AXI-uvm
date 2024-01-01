class axi_slave_driver_c#(DATA_WIDTH = 32) extends uvm_driver#(axi_item_c);
    
    `uvm_component_param_utils(axi_slave_driver_c#(DATA_WIDTH))
    
    // Interface and Config handles
	virtual axi_slave_intf     #(DATA_WIDTH)    vif;
	axi_slave_agent_cfg_c      #(DATA_WIDTH)    m_cfg;

    
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

endclass : axi_slave_driver_c

function void axi_slave_driver_c::build_phase(uvm_phase phase);
    // check configuration
    if(!uvm_config_db#(axi_slave_agent_cfg_c #(DATA_WIDTH))::get(this, "", "axi_slave_agent_cfg_t", m_cfg))
        `uvm_fatal(get_full_name(), "Failed to get agent_cfg from database")

    vif = m_cfg.vif;
endfunction: build_phase


task axi_slave_driver_c::reset_phase(uvm_phase phase);
    vif.ready_in  <= 0;
    vif.tvalid_in <= 0;
    vif.tlast_in  <= 0;
    vif.tdata_in  <= 0;
endtask: reset_phase


task axi_slave_driver_c::run_phase(uvm_phase phase);

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
//             ready:   user app tell the slave it is ready to recieve the data
//             tvalid:  send from master that tdata is valid
//             tlast:   from master indicate some kind of packet management
//             tdata:   from master, randomize and send
task axi_slave_driver_c::run_driver();
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
        vif.ready_in <= m_item.slave_user_ready;   
        vif.tvalid_in <= m_item.tvalid;
        // Master
        vif.tlast_in <= m_item.tlast; 
        vif.tdata_in <= m_item.tdata;

        seq_item_port.item_done();
    end
endtask : run_driver


function void axi_slave_driver_c::cleanup();
    vif.ready_in  <= 0;
    vif.tvalid_in <= 0;
    vif.tlast_in  <= 0;
    vif.tdata_in  <= 0;
endfunction : cleanup