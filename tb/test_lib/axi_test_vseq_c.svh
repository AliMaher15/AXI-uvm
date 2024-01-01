class axi_test_vseq_c extends axi_vseq_base_c ;

    `uvm_object_utils(axi_test_vseq_c)
  
    axi_seq_c     axi_slave_seq_h;
    axi_seq_c     axi_master_seq_h;
  
    // Constructor
    function new(string name = "");
      super.new(name);
    endfunction : new

    // Task: body
    extern task body();
  
  endclass : axi_test_vseq_c

// Task: body
task axi_test_vseq_c::body();

  axi_slave_seq_h = axi_seq_c::type_id::create("axi_slave_seq_h") ;
  seq_set_cfg(axi_slave_seq_h);
  axi_master_seq_h = axi_seq_c::type_id::create("axi_master_seq_h") ;
  seq_set_cfg(axi_master_seq_h);
  // start
  super.body();
  fork
    repeat(10) begin
      `uvm_info(get_full_name(), "Executing sequence", UVM_HIGH)
      axi_master_seq_h.start(p_sequencer.m_axi_master_agent_seqr);
      //#2us;
      `uvm_info(get_full_name(), "Sequence complete", UVM_HIGH)
    end
    repeat(10) begin
      `uvm_info(get_full_name(), "Executing sequence", UVM_HIGH)
      axi_slave_seq_h.start(p_sequencer.m_axi_slave_agent_seqr);
      //#2us;
      `uvm_info(get_full_name(), "Sequence complete", UVM_HIGH)
    end
  join
endtask : body