package uart_rx_test_pkg ;

    import uvm_pkg::*;
    `include "uvm_macros.svh"

    import uart_rx_item_pkg::*;
    import uart_rx_global_params_pkg::*;
    import uart_rx_usertypes_pkg::*;
    import uart_rx_agent_pkg::*;
    import uart_rx_seq_pkg::*;
    import uart_rx_tb_pkg::*;

    `include "uart_rx_vseq_base.svh"    
    `include "uart_rx_base_test.svh"

    `include "uart_rx_input_test_vseq.svh"
    `include "uart_rx_input_test.svh"

endpackage : uart_rx_test_pkg