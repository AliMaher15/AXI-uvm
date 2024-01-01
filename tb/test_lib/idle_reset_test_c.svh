class idle_reset_test_c extends axi_base_test_c;
    `uvm_component_utils(idle_reset_test_c)
 
    // field: run_count
    // The number of times the test has run so far
    int run_count;
    
    function new(string name="idle_reset", uvm_component parent=null);
       super.new(name, parent);
    endfunction : new
 
    virtual function void phase_ready_to_end(uvm_phase phase);
       super.phase_ready_to_end(phase);
       if(phase.get_imp() == uvm_shutdown_phase::get()) begin
 
      if(run_count == 0) begin
         `uvm_info("test", "Hitting Reset!!!", UVM_NONE)
             phase.jump(uvm_pre_reset_phase::get());
             run_count++;
      end
       end
    endfunction : phase_ready_to_end
 endclass : idle_reset_test_c