class axi_item_c extends uvm_sequence_item;

    // Variables
    bit rst_op;

    rand bit [DATA_WIDTH-1:0] tdata;
    rand bit [DATA_WIDTH-1:0] user_data;
    rand bit tlast;
    rand bit tready;
    rand bit tvalid;
    rand int delay;

    rand bit send_master;

    bit finish;

    rand bit slave_user_ready;


    // automatic copy, compare and the default functions..
    `uvm_object_utils_begin(axi_item_c)
        `uvm_field_int(send_master        , UVM_DEFAULT | UVM_BIN)
        `uvm_field_int(tdata              , UVM_DEFAULT | UVM_BIN)
        `uvm_field_int(user_data          , UVM_DEFAULT | UVM_BIN)
        `uvm_field_int(tready             , UVM_DEFAULT | UVM_BIN)
        `uvm_field_int(tvalid             , UVM_DEFAULT | UVM_BIN)
        `uvm_field_int(tlast              , UVM_DEFAULT | UVM_BIN)
        `uvm_field_int(rst_op             , UVM_DEFAULT | UVM_BIN)     
        `uvm_field_int(finish             , UVM_DEFAULT | UVM_BIN)
        `uvm_field_int(slave_user_ready   , UVM_DEFAULT | UVM_BIN)  
        `uvm_field_int(delay              , UVM_DEFAULT | UVM_DEC)   
    `uvm_object_utils_end

    // Constraints
    //  Constraint: rst_cnstr
    extern constraint rst_cnstr;
    //  Constraint: delay_range_cnstr
    extern constraint delay_range_cnstr;
    //  Constraint: tready_probability_cnstr
    extern constraint tready_probability_cnstr;
    //  Constraint: tlast_probability_cnstr
    extern constraint tlast_probability_cnstr;
    //  Constraint: tvalid_probability_cnstr
    extern constraint tvalid_probability_cnstr;
    //  Constraint: send_master_probability_cnstr
    extern constraint send_master_probability_cnstr;
    //  Constraint: slave_user_ready_probability_cnstr
    extern constraint slave_user_ready_probability_cnstr;
    

    //  Group: Functions

    //  Constructor: new
    function new(string name = "");
        super.new(name);
    endfunction: new

    //  Function: do_copy
    // extern function void do_copy(uvm_object rhs);
    //  Function: do_compare
    // extern function bit do_compare(uvm_object rhs, uvm_comparer comparer);
    //  Function: convert2string
    // extern function string convert2string();
    //  Function: do_print
    // extern function void do_print(uvm_printer printer);
    //  Function: do_record
    // extern function void do_record(uvm_recorder recorder);
    //  Function: do_pack
    // extern function void do_pack();
    //  Function: do_unpack
    // extern function void do_unpack();
    
endclass: axi_item_c


/*----------------------------------------------------------------------------*/
/*  Constraints                                                               */
/*----------------------------------------------------------------------------*/
// Constraint: rst_cnstr
constraint axi_item_c::rst_cnstr {
    rst_op == 0;
}

//  Constraint: delay_range_cnstr
constraint axi_item_c::delay_range_cnstr {
    delay inside {[0:10]};
}

//  Constraint: tready_probability_cnstr
constraint axi_item_c::tready_probability_cnstr {
    tready dist {1 := 4, 0 := 1};
}

//  Constraint: tlast_probability_cnstr
constraint axi_item_c::tlast_probability_cnstr {
    tlast dist {1 := 1, 0 := 4};
}

//  Constraint: tvalid_probability_cnstr
constraint axi_item_c::tvalid_probability_cnstr {
    tvalid dist {1 := 4, 0 := 1};
}

//  Constraint: send_master_probability_cnstr
constraint axi_item_c::send_master_probability_cnstr {
    send_master dist {1 := 4, 0 := 1};
}

//  Constraint: slave_user_ready_probability_cnstr
constraint axi_item_c::slave_user_ready_probability_cnstr {
    slave_user_ready dist {1 := 4, 0 := 1};
}

/*----------------------------------------------------------------------------*/
/*  Functions                                                                 */
/*----------------------------------------------------------------------------*/

