class uart_rx_input_test_vseq extends uart_rx_vseq_base ;

    `uvm_object_utils(uart_rx_input_test_vseq)
  
    uart_rx_input_seq urx_in_seq_h ;
  
    function new(string name = "");
      super.new(name);
    endfunction : new
  
    task body();
  
      urx_in_seq_h=uart_rx_input_seq::type_id::create("urx_in_seq_h") ;
      seq_set_cfg(urx_in_seq_h);
     // start
      super.body();
        repeat(50) begin
          `uvm_info("uart_rx_input_test_vseq", "Executing sequence", UVM_HIGH)
            urx_in_seq_h.start(p_sequencer.m_uart_rx_agent_seqr);
          //#2us;
          `uvm_info("uart_rx_input_test_vseq", "Sequence complete", UVM_HIGH)
        end
    endtask : body
  
  endclass : uart_rx_input_test_vseq