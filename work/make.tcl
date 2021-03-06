# Name		:vivado tcl
# Description	:make project and implementation
# Version	:vivado2019.2
# Author	:Lee

 create_project mmm_nlp_90b ./work/mmm_nlp_90b -part xcu200-fsgd2104-2-e
 set_property board_part xilinx.com:au200:part0:1.3 [current_project]
 # xcu200-fsgd2104-2-e
 # source files and simulation
 #############################
 # source file
 #############################
 import_files -norecurse ../src/mmm_mod_pow/mmm_mod_pow.v
 # import_files -norecurse ../src/exp1.v
 #import_files -norecurse ../src/karatsuba_256b.v
 #import_files -norecurse ../src/karatsuba_90b.v
 # import_files -norecurse ../src/addroundconstant.v
 # import_files -norecurse ../src/mmm_mod_add.v
  import_files -norecurse ../src/mmm_nlp_256b/mmm_nlp_256b.v
  import_files -norecurse ../src/mmm_nlp_90b/mmm_nlp_90b_pip.v
  import_files -norecurse ../src/mmm_nlp_256b/mmm_nlp_shift_reg.v
 # import_files -norecurse ../src/mmm_r2mm.v
 # import_files -norecurse ../src/mmp/mmp_iddmm_pe.v
 # import_files -norecurse ../src/mmp/mmp_iddmm_addend.v
 # import_files -norecurse ../src/mmp/mmp_iddmm_addfirst.v
 # import_files -norecurse ../src/mmp/mmp_iddmm_mul128.v
 # import_files -norecurse ../src/mmp/mmp_iddmm_shift.v
 # import_files -norecurse ../src/mmp/mult.v
 # import_files -norecurse ../src/mmp/simple_p12adder256_3_2.v
 update_compile_order -fileset sources_1
 set_property SOURCE_SET sources_1 [get_filesets sim_1]
 #############################
 # simulation file
 #############################
 import_files -fileset sim_1 -norecurse ../tb/mmm_mod_pow_tb.v
 #import_files -fileset sim_1 -norecurse ../tb/mmm_nlp_256b_3way_tb.v
 # import_files -fileset sim_1 -norecurse ../tb/karatsuba_256b_tb.v
 #import_files -fileset sim_1 -norecurse ../tb/addroundconstant_tb.v
 #import_files -fileset sim_1 -norecurse ../tb/mmm_mod_add_tb.v
 #import_files -fileset sim_1 -norecurse ../src/mmm_nlp_shift_reg.v

 update_compile_order -fileset sim_1
 update_compile_order -fileset sim_1
 #############################
 # launch simulation
 #############################
 launch_simulation
 #############################
 # open gui
 #############################
 start_gui
 open_project ./work/mmm_nlp_90b.xpr
