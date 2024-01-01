class axi_slave_agent_seqr_c extends uvm_sequencer #(axi_item_c);

    `uvm_component_utils(axi_slave_agent_seqr_c)
    
    function new(string name, uvm_component parent);
        super.new(name,parent);
    endfunction

endclass : axi_slave_agent_seqr_c