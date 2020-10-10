@echo off
set xv_path=E:\\Vivado\\Vivado\\2015.4\\bin
call %xv_path%/xsim reg_file_test_behav -key {Behavioral:sim_1:Functional:reg_file_test} -tclbatch reg_file_test.tcl -view E:/Vivado/homework/project_11_reg_file/reg_file_test_behav.wcfg -log simulate.log
if "%errorlevel%"=="0" goto SUCCESS
if "%errorlevel%"=="1" goto END
:END
exit 1
:SUCCESS
exit 0
