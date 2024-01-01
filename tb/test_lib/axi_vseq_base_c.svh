class axi_vseq_base_c extends  uvm_sequence#(uvm_sequence_item);
    `uvm_object_utils(axi_vseq_base_c)
    `uvm_declare_p_sequencer(axi_vsequencer_c)

    axi_env_cfg_c      m_cfg;
  
  
    function new(string name = "");
      super.new(name);
    endfunction : new
  
    
    virtual task body();
        m_cfg = p_sequencer.m_cfg ;
        if(m_cfg == null) begin
            `uvm_fatal(get_full_name(), "env_config is null")
        end
    endtask : body

    function void seq_set_cfg(axi_base_seq_c seq_);
        seq_.m_cfg = m_cfg;
    endfunction
   
  
  endclass : axi_vseq_base_c