# Clocks
add wave /axi_tb_top/clk
add wave /axi_tb_top/rst_i/res_n

# AXI MASTER Inputs
add wave -group AXI_M_IN -color Magenta /axi_tb_top/AXI_MASTER_IF/data_in \
                            /axi_tb_top/AXI_MASTER_IF/send_in \
                            /axi_tb_top/AXI_MASTER_IF/tready_in
                    
# AXI MASTER Outputs
add wave -group AXI_M_OUT -color Pink /axi_tb_top/AXI_MASTER_IF/tvalid_out \
                            /axi_tb_top/AXI_MASTER_IF/tlast_out \
                            /axi_tb_top/AXI_MASTER_IF/tdata_out \
                            /axi_tb_top/AXI_MASTER_IF/finish_out

# AXI SLAVE Inputs
add wave -group AXI_S_IN -color Magenta /axi_tb_top/AXI_SLAVE_IF/ready_in \
                            /axi_tb_top/AXI_SLAVE_IF/tvalid_in \
                            /axi_tb_top/AXI_SLAVE_IF/tlast_in \
                            /axi_tb_top/AXI_SLAVE_IF/tdata_in
                    
# AXI SLAVE Outputs
add wave -group AXI_S_OUT -color Pink /axi_tb_top/AXI_SLAVE_IF/tready_out \
                            /axi_tb_top/AXI_SLAVE_IF/data_out \
                            /axi_tb_top/AXI_SLAVE_IF/finish_out