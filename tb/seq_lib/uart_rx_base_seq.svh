class uart_rx_base_seq extends  uvm_sequence #(uvm_sequence_item);

    `uvm_object_utils(uart_rx_base_seq)
  
    uart_rx_env_cfg m_cfg;
  
  
    function new(string name = "");
      super.new(name);
    endfunction : new
  
    task body();
      if(m_cfg == null) begin
        `uvm_fatal(get_full_name(), "env_config is null")
      end
    endtask : body
  
  
  endclass : uart_rx_base_seq
  
  
  