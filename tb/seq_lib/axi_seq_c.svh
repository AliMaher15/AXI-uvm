class axi_seq_c extends axi_base_seq_c;
    `uvm_object_utils(axi_seq_c);

    axi_item_c m_item;

    //  Constructor: new
    function new(string name = "");
        super.new(name);
    endfunction: new

    extern virtual task body();
    
endclass: axi_seq_c


task axi_seq_c::body();
    m_item = axi_item_c::type_id::create("m_item");
    //communicate with driver
    start_item(m_item);
    // randomize
    Randomize_axi_master_item: assert (m_item.randomize() with {});
    finish_item(m_item);
endtask