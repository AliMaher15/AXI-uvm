interface axi_slave_intf #(DATA_WIDTH = 32)
                      (
                        input aclk,
                        input areset_n
                      );

// Interface Inputs to axi_slave
logic                       ready_in; // user app is ready to accept data, no slave can receive a data
logic                       tvalid_in; // from master
logic                       tlast_in; // from master
logic [DATA_WIDTH-1:0]      tdata_in; // from master
// axi_slave outputs to interface
logic                       finish_out; // transaction is completed  
logic                       tready_out; // to master
logic [DATA_WIDTH-1:0]      data_out;    // data that axis slave will receive


//********* MACROS FUNCTIONS ***********//
`define axi_s_assert_clk(arg) \
  assert property (@(posedge CLK) disable iff (!RST) arg);

/* Handles case of rst_n going to zero
ap_async_rst: assert property(@(negedge rst_n) 1'b1 |=>  @(posedge clk) ptr==0 && cnt==0);
// Handles case of powerup, when clk goes live 
// changed the |-> to |=>
ap_sync_rst: assert property(@(posedge clk) !rst_n |=>  ptr==0 && cnt==0);*/
`define axi_s_assert_async_rst(arg) \
  assert property (@(negedge RST) 1'b1 |=> @(posedge CLK) arg);
    
endinterface : axi_slave_intf