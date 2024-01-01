class axi_base_seq_c extends  uvm_sequence #(uvm_sequence_item);

    `uvm_object_utils(axi_base_seq_c)
  
    axi_env_cfg_c     m_cfg;
  
  
    function new(string name = "");
      super.new(name);
    endfunction : new
  
    task body();
      if(m_cfg == null) begin
        `uvm_fatal(get_full_name(), "env_config is null")
      end
    endtask : body
  
  
  endclass : axi_base_seq_c
  
  
  