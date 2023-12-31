class axi_item_c extends uvm_sequence_item;

    // Variables
    bit rst_op;

    rand bit [DATA_WIDTH-1:0] tdata;
    rand bit tlast;
    
    rand int delay;


    // automatic copy, compare and the default functions..
    `uvm_object_utils_begin(axi_item_c)
        `uvm_field_int(tdata              , UVM_DEFAULT | UVM_BIN)
        `uvm_field_int(tlast              , UVM_DEFAULT | UVM_BIN)
        `uvm_field_int(rst_op             , UVM_DEFAULT | UVM_BIN)     
        `uvm_field_int(delay              , UVM_DEFAULT | UVM_DEC)   
    `uvm_object_utils_end

    // Constraints
    //  Constraint: 
    //  Constraint: delay_range_cnst
    extern constraint delay_range_cnst;
    

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
constraint axi_item_c::delay_range_cnst {
    delay inside {[0:10]};
}




/*----------------------------------------------------------------------------*/
/*  Functions                                                                 */
/*----------------------------------------------------------------------------*/

