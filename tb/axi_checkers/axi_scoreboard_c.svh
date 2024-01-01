class axi_scoreboard_c extends uvm_scoreboard;
    `uvm_component_utils(axi_scoreboard_c);

    `uvm_analysis_imp_decl(_axi_m)
    uvm_analysis_imp_axi_m #(axi_item_c, axi_scoreboard_c) axi_m_imp;

    `uvm_analysis_imp_decl(_axi_s)
    uvm_analysis_imp_axi_s #(axi_item_c, axi_scoreboard_c) axi_s_imp;


    protected int master_outputs_count = 0;
    protected int master_data_error_count = 0;

    protected int slave_outputs_count = 0;
    protected int slave_data_error_count = 0;

    axi_item_c     m_axi_m_item_q [$];
    axi_item_c     m_axi_s_item_q [$];

    //  Constructor: new
    function new(string name, uvm_component parent);
        super.new(name, parent);

        axi_m_imp = new("axi_m_imp",this);
        axi_s_imp  = new("axi_s_imp",this);
    endfunction: new

    // Subscriber Implimintation Functions
    extern function void write_axi_m(input axi_item_c item);
    extern function void write_axi_s(input axi_item_c item);
    // Function: comparator
    extern function void axi_master_comparator();
    extern function void axi_slave_comparator();
    // Function: check_phase
    extern function void check_phase(uvm_phase phase);
    // Function: report_phase
    extern function void report_phase(uvm_phase phase);
    
endclass: axi_scoreboard_c



function void axi_scoreboard_c::write_axi_m(input axi_item_c item);
    if (item.rst_op)
        m_axi_m_item_q.delete();
    else begin
        m_axi_m_item_q.push_front(item);
        axi_master_comparator();
    end 
endfunction : write_axi_m


function void axi_scoreboard_c::write_axi_s(input axi_item_c item);
    if (item.rst_op)
        m_axi_s_item_q.delete();
    else begin
        m_axi_s_item_q.push_front(item);
        axi_slave_comparator();
    end 
endfunction : write_axi_s



function void axi_scoreboard_c::axi_master_comparator();
    axi_item_c   m_item;
    // extract the item from the queue
    m_item = m_axi_m_item_q.pop_back();
    //*******************************//
    /*if (m_item.send_master) begin
        master_outputs_count++;
        if (m_item.tdata != m_item.user_data) begin
            `uvm_error(get_full_name(),$sformatf("DATA_ERROR at O/P: %d, user_data=%d, tdata=%d ",
                                                master_outputs_count, m_item.user_data, m_item.tdata))
            master_data_error_count++;
        end
    end*/
endfunction: axi_master_comparator


function void axi_scoreboard_c::axi_slave_comparator();
    axi_item_c   m_item;
    // extract the item from the queue
    m_item = m_axi_s_item_q.pop_back();
    //*******************************//
    /*if (m_item.send_master) begin
        slave_outputs_count++;
        if (m_item.tdata != m_item.user_data) begin
            `uvm_error(get_full_name(),$sformatf("DATA_ERROR at O/P: %d, user_data=%d, tdata=%d ",
                                                slave_outputs_count, m_item.user_data, m_item.tdata))
            slave_data_error_count++;
        end
    end*/
endfunction: axi_slave_comparator


function void axi_scoreboard_c::check_phase(uvm_phase phase);
    super.check_phase(phase); 
endfunction: check_phase


function void axi_scoreboard_c::report_phase(uvm_phase phase);
    super.report_phase(phase);
    `uvm_info(get_full_name(),$sformatf("master_outputs_count %0d", master_outputs_count), UVM_LOW)
    `uvm_info(get_full_name(),$sformatf("master_data_error_count %0d", master_data_error_count), UVM_LOW)
    `uvm_info(get_full_name(),$sformatf("slave_outputs_count %0d", slave_outputs_count), UVM_LOW)
    `uvm_info(get_full_name(),$sformatf("slave_data_error_count %0d", slave_data_error_count), UVM_LOW)
endfunction: report_phase

