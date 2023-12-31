#***************************************************#
# Clean Work Library
#***************************************************#
if [file exists "work"] {vdel -all}
vlib work

#***************************************************#
# Start a new Transcript File
#***************************************************#
transcript file log/RUN_LOG.log
# better make one for each test

#***************************************************#
# Compile RTL and TB files
#***************************************************#
vlog -f scripts/dut.f
vlog -f scripts/tb.f

#***************************************************#
# Optimizing Design with vopt
#***************************************************#
vopt uart_top_tb_top -o top_opt -debugdb  +acc +cover=sbecf

#***************************************************#
# Simulation of a Test
#***************************************************#

#********************************** 1. Input TEST ***********************************#
transcript file log/uart_top_simple_test.log
vsim top_opt -c -assertdebug -debugDB -fsmdebug -coverage +UVM_TESTNAME=uart_top_simple_test
set NoQuitOnFinish 1
onbreak {resume}
log /* -r
run -all
coverage attribute -name TESTNAME -value uart_top_simple_test
coverage save coverage/uart_top_simple_test.ucdb

#***************************************************#
# Close the Transcript file
#***************************************************#
transcript file ()

#***************************************************#
# draw the dut pins in waveforms
#***************************************************#
do waves.do

#***************************************************#
# save the coverage in text files
#***************************************************#
vcover merge  coverage/uart.ucdb \
              coverage/uart_top_simple_test.ucdb   
              
              
vcover report coverage/uart.ucdb -cvg -details -output coverage/fun_coverage.txt
vcover report coverage/uart.ucdb -details -assert  -output coverage/assertions.txt
vcover report coverage/uart.ucdb  -output coverage/code_coverage.txt


#add schematic -full sim:/uart_top_tb_top/dut
#quit -sim