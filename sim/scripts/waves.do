# Clocks
add wave /uart_top_tb_top/rx_clk
add wave /uart_top_tb_top/tx_clk
add wave /uart_top_tb_top/UART_TOP_SYSTEM_IF/res_n

# UART_RX Inputs
add wave -group UART_RX_IN -color Magenta /uart_top_tb_top/UART_RX_IF/s_data_in \
                            /uart_top_tb_top/UART_RX_IF/prescale_in \
                            /uart_top_tb_top/UART_RX_IF/par_en_in \
                            /uart_top_tb_top/UART_RX_IF/par_typ_in
                    
# UART_RX Outputs
add wave -group UART_RX_OUT -color Pink /uart_top_tb_top/UART_RX_IF/p_data_out \
                            /uart_top_tb_top/UART_RX_IF/parity_error_out \
                            /uart_top_tb_top/UART_RX_IF/stop_error_out \
                            /uart_top_tb_top/UART_RX_IF/data_valid_out

# UART_TX Inputs
add wave -group UART_TX_IN -color Magenta /uart_top_tb_top/UART_TX_IF/p_data \
                            /uart_top_tb_top/UART_TX_IF/data_valid \
                            /uart_top_tb_top/UART_TX_IF/par_en \
                            /uart_top_tb_top/UART_TX_IF/par_typ
                    
# UART_TX Outputs
add wave -group UART_TX_OUT -color Pink /uart_top_tb_top/UART_TX_IF/busy \
                            /uart_top_tb_top/UART_TX_IF/tx_out