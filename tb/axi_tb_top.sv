`timescale 1ns/1ps

module axi_tb_top();

import uvm_pkg::*;
`include "uvm_macros.svh"
import axi_global_params_pkg::*;
import axi_usertypes_pkg::*;
import axi_tb_pkg::*;
import axi_seq_pkg::*;
import axi_test_pkg::*;

bit clk;

//************** INTERFACES INSTANTS ****************//
rst_intf rst_i ();

axi_master_intf #(.DATA_WIDTH(DATA_WIDTH)) AXI_MASTER_IF (.aclk(clk), .areset_n(rst_i.res_n));
axi_slave_intf  #(.DATA_WIDTH(DATA_WIDTH)) AXI_SLAVE_IF  (.aclk(clk), .areset_n(rst_i.res_n));
//***************************************************//

//**************** DUT INSTANTS *********************//
axis_m #(.DATA_WIDTH(DATA_WIDTH) 
         )
axi_m_dut (
     .aclk(clk),
     .areset_n(rst_i.res_n),

     .data(AXI_MASTER_IF.data_in),
     .send(AXI_MASTER_IF.send_in),

     .tready(AXI_MASTER_IF.tready_in), 
     .tvalid(AXI_MASTER_IF.tvalid_out),
     .tlast(AXI_MASTER_IF.tlast_out),
     .tdata(AXI_MASTER_IF.tdata_out),

     .finish(AXI_MASTER_IF.finish_out)
     );

axis_s #(.DATA_WIDTH(DATA_WIDTH) 
         )
axi_s_dut (
    .aclk(clk),
    .areset_n(rst_i.res_n),

    .data(AXI_SLAVE_IF.data_out),
    .ready(AXI_SLAVE_IF.ready_in),

    .tready(AXI_SLAVE_IF.tready_out),
    .tvalid(AXI_SLAVE_IF.tvalid_in),
    .tlast(AXI_SLAVE_IF.tlast_in),
    .tdata(AXI_SLAVE_IF.tdata_in),

    .finish(AXI_SLAVE_IF.finish_out)
     );
//***************************************************//

//************** ASSERTIONS MODULE ******************//
// inside interfaces
//***************************************************// 

//***************** START TEST **********************//
// pass the interfaces handles then run the test
initial begin
    //            interface type                access hierarch    instance name
    uvm_resource_db#(virtual rst_intf)::set("rst_intf", "rst_i", rst_i);

    uvm_config_db#(virtual axi_master_intf#(.DATA_WIDTH(DATA_WIDTH)))::set(null, "uvm_test_top", "AXI_MASTER_IF", AXI_MASTER_IF);
    uvm_config_db#(virtual axi_slave_intf #(.DATA_WIDTH(DATA_WIDTH)))::set(null, "uvm_test_top", "AXI_SLAVE_IF" , AXI_SLAVE_IF);

    run_test();
end
//***************************************************// 

//***************** CLOCK ***************************//
initial begin
    clk = 1;
    forever begin  
        #(CLK_PERIOD/2);  clk = ~clk;
    end
end
//***************************************************// 

endmodule : axi_tb_top