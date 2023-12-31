interface axi_master_intf #(DATA_WIDTH = 32)
                      (
                        input aclk,
                        input areset_n
                      );

// Interface Inputs to axi_master
logic    [DATA_WIDTH-1:0]    data_in;
logic                        send_in;
logic                        tready_in; // from slave
// axi_master outputs to interface
logic                        tvalid_out; // to slave
logic                        tlast_out; // to slave
logic                        finish_out;
logic    [DATA_WIDTH-1:0]    tdata_out; // to slave


//********* MACROS FUNCTIONS ***********//
`define axi_m_assert_clk(arg) \
  assert property (@(posedge CLK) disable iff (!RST) arg);

/* Handles case of rst_n going to zero
ap_async_rst: assert property(@(negedge rst_n) 1'b1 |=>  @(posedge clk) ptr==0 && cnt==0);
// Handles case of powerup, when clk goes live 
// changed the |-> to |=>
ap_sync_rst: assert property(@(posedge clk) !rst_n |=>  ptr==0 && cnt==0);*/
`define axi_m_assert_async_rst(arg) \
  assert property (@(negedge RST) 1'b1 |=> @(posedge CLK) arg);
    
endinterface : axi_master_intf