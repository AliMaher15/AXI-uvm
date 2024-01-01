class axi_test_c extends  axi_base_test_c;
    `uvm_component_utils(axi_test_c)
    
   // Constructor
   function new(string name, uvm_component parent);
      super.new(name,parent);
   endfunction : new

   // Task: run_phase
   extern task run_phase(uvm_phase phase);
  
  endclass : axi_test_c


// Task: run_phase
task axi_test_c::run_phase(uvm_phase phase);

  //vseq_class_name        vseq_handle          = seq_class_name     ::type_id       ::create("vseq_handle");
  axi_test_vseq_c          m_axi_test_vseq = axi_test_vseq_c::type_id::create("m_axi_test_vseq");
  set_seqs(m_axi_test_vseq);
    
  phase.raise_objection(this);

  super.run_phase(phase); 
  
    `uvm_info(get_full_name(),"Starting test", UVM_LOW)

    `uvm_info(get_full_name(),"Executing axi_test_vseq_c", UVM_LOW)      
  m_axi_test_vseq.start(m_axi_env.m_vseqr) ;        
    `uvm_info(get_full_name(), "axi_test_vseq_c complete", UVM_LOW) 
    #400ns

    `uvm_info(get_full_name(),"Ending test", UVM_LOW)
  
  phase.drop_objection(this);
  
endtask : run_phase