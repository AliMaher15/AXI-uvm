class axi_scoreboard_c extends uvm_scoreboard;
    `uvm_component_utils(axi_scoreboard_c);

    `uvm_analysis_imp_decl(_axi_m_out)
    uvm_analysis_imp_axi_m_out #(axi_item, axi_scoreboard_c) axi_m_out_imp;
    `uvm_analysis_imp_decl(_axi_m_in)
    uvm_analysis_imp_axi_m_in #(axi_item, axi_scoreboard_c) axi_m_in_imp;

    `uvm_analysis_imp_decl(_axi_s_out)
    uvm_analysis_imp_axi_s_out #(axi_item, axi_scoreboard_c) axi_s_out_imp;
    `uvm_analysis_imp_decl(_axi_s_in)
    uvm_analysis_imp_axi_s_in #(axi_item, axi_scoreboard_c) axi_s_in_imp;

    protected int master_outputs_count = 0;
    protected int master_data_error_count = 0;

    protected int slave_outputs_count = 0;
    protected int slave_data_error_count = 0;

    axi_item m_item_in_queue [$];
    axi_item m_item_out_queue [$];

    axi_item s_item_in_queue [$];
    axi_item s_item_out_queue [$];

    //  Constructor: new
    function new(string name, uvm_component parent);
        super.new(name, parent);

        axi_m_out_imp = new("axi_m_out_imp",this);
        axi_m_in_imp  = new("axi_m_in_imp",this);

        axi_s_out_imp = new("axi_s_out_imp",this);
        axi_s_in_imp  = new("axi_s_in_imp",this);
    endfunction: new

    // Subscriber Implimintation Functions
    extern function void write_axi_m_out(input axi_item item);
    extern function void write_axi_m_in (input axi_item item);
    extern function void write_axi_s_out(input axi_item item);
    extern function void write_axi_s_in (input axi_item item);
    // Function: run_phase
    extern task run_phase(uvm_phase phase);
    // Function: comparator
    extern function void comparator(input axi_item item);
    // Function: check_phase
    extern function void check_phase(uvm_phase phase);
    // Function: report_phase
    extern function void report_phase(uvm_phase phase);
    
endclass: axi_scoreboard_c


function void axi_scoreboard_c::write_axi_m_out(input axi_item item);
    if (item.rst_op)
        item_in_queue.delete();
    else
        item_out_queue.push_front(item);
endfunction : write_axi_m_out



function void axi_scoreboard_c::write_axi_m_in(input axi_item item);
    if (item.rst_op)
        item_out_queue.delete();
    else
    item_in_queue.push_front(item);
endfunction : write_axi_m_in



task axi_scoreboard_c::run_phase(uvm_phase phase);
    super.run_phase(phase);
    forever begin
        // variables
        uart_rx_item item_input;
        uart_rx_item item_output;
        uart_rx_item item = new();
        // only start processing if there is an item written
        wait(item_in_queue.size() != 0); // using wait to prevent infinite loop
        // extract the item from the queue
        item_input = item_in_queue.pop_back();
        wait(item_out_queue.size() != 0);
        item_output = item_out_queue.pop_back();
        //*******************************//
        // GROUP THEM INTO ONE ITEM     //
        item.s_data_in           = item_input.s_data_in;
        item.par_en_in           = item_input.par_en_in;
        item.par_typ_in          = item_input.par_typ_in;
        item.insert_parity_error = item_input.insert_parity_error;
        item.insert_stop_error   = item_input.insert_stop_error;
        item.data_valid_out      = item_output.data_valid_out;
        item.parity_error_out    = item_output.parity_error_out;
        item.stop_error_out      = item_output.stop_error_out;
        item.p_data_out          = item_output.p_data_out;
        comparator(item);
    end
endtask: run_phase



function void axi_scoreboard_c::comparator(input axi_item item);
    bit parity_expected = 0;
    outputs_count++;
    `uvm_info(get_full_name(), $sformatf("\nOUTPUT#%d :", outputs_count), UVM_LOW)
    item.print();

    if (item.insert_parity_error) begin
        if (!item.parity_error_out) begin // should be high
            parity_error_count++;
            `uvm_error(get_full_name(), $sformatf("\nParity error at OUTPUT#%d : expected = %d, result = %d", outputs_count, 1, item.parity_error_out))
        end
    end else if(item.insert_stop_error) begin
        if (!item.stop_error_out) begin // should be high
            stop_error_count++;
            `uvm_error(get_full_name(), $sformatf("\nStop error at OUTPUT#%d : expected = %d, result = %d", outputs_count, 1, item.stop_error_out))
        end
    end else begin // now the p_data should be correct
        if (item.s_data_in != item.p_data_out) begin
            data_error_count++;
            `uvm_error(get_full_name(), $sformatf("\nData error at OUTPUT#%d : expected = %b, result = %b", outputs_count, item.s_data_in, item.p_data_out))
        end
    end
endfunction: comparator


function void axi_scoreboard_c::check_phase(uvm_phase phase);
    super.check_phase(phase); 
endfunction: check_phase


function void axi_scoreboard_c::report_phase(uvm_phase phase);
    super.report_phase(phase);
    `uvm_info(get_full_name(),$sformatf("outputs_count %0d", outputs_count), UVM_LOW)
    `uvm_info(get_full_name(),$sformatf("data_error_count %0d", data_error_count), UVM_LOW)
endfunction: report_phase

