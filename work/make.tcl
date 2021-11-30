# Name		:vivado tcl
# Description	:make project and implementation
# Version	:vivado2019.2
# Author	:Lee

 create_project mmm_nlp_90b ./work/mmm_nlp_90b -part xcu200-fsgd2104-2-e
 set_property board_part xilinx.com:au200:part0:1.3 [current_project]
 
 # source files and simulation
 #############################
 # source file
 #############################
 import_files -norecurse /home/ldp/graduate/MMM/src/mmm_nlp_90b.v
 update_compile_order -fileset sources_1
 set_property SOURCE_SET sources_1 [get_filesets sim_1]
 #############################
 # simulation file
 #############################
 import_files -fileset sim_1 -norecurse /home/ldp/graduate/MMM/src/mmm_nlp_90b_tb.v
 update_compile_order -fileset sim_1
 update_compile_order -fileset sim_1
 #############################
 # launch simulation
 #############################
 launch_simulation
