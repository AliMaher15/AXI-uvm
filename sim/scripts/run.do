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
vopt axi_tb_top -o top_opt -debugdb  +acc +cover=sbecf

#***************************************************#
# Simulation of a Test
#***************************************************#

#********************************** 1. Input TEST ***********************************#
transcript file log/axi_test_c.log
vsim top_opt -c -assertdebug -debugDB -fsmdebug -coverage +UVM_TESTNAME=axi_test_c
set NoQuitOnFinish 1
onbreak {resume}
log /* -r
run -all
coverage attribute -name TESTNAME -value axi_test_c
coverage save coverage/axi_test_c.ucdb

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
vcover merge  coverage/axi_cov.ucdb \
              coverage/axi_test_c.ucdb   
              
              
vcover report coverage/axi_cov.ucdb -cvg -details -output coverage/fun_coverage.txt
vcover report coverage/axi_cov.ucdb -details -assert  -output coverage/assertions.txt
vcover report coverage/axi_cov.ucdb  -output coverage/code_coverage.txt

#quit -sim