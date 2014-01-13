#!/bin/bash 
export XILINX=/opt/Xilinx/13.1/ISE_DS/ISE/
export PLATFORM=lin64
export PATH=$PATH:${XILINX}/bin/${PLATFORM}
export LD_LIBRARY_PATH=${XILINX}/lib/${PLATFORM}
export FSM_TOOL=/srv/autolab/qfsm2hdl
export FSMD_TOOL=/srv/autolab/fsmconv

#create the TCL script which runs the test
#this, incidentally
echo "put security_token $1" > sim.tcl
echo "run 100 us" >> sim.tcl
echo "quit" >> sim.tcl

#convert all present schematic files to VHDL
for i in *.sch
do
	if [ -f "$i" ]; then 
			sch2vhdl -suppress "$i"
	fi
done

#convert all present fsm files to vhdl
for i in *.fsmd *.fsm
do
    if [ -f "$i" ]
    then
	    ${FSMD_TOOL} "$i" > "$i.vhd"
	
	    if [ $? -ne 0 ]; then
			cat "$i.vhd"
			exit $last_error
	    fi
    fi
done

#Create a project file from all of the present VHDL and verilog files.
echo "" > testbench.prj
for i in *.vhd
do
    if [ -f "$i" ]
    then
        echo "vhdl work $i" >> testbench.prj
    fi
done

for i in *.v
do
    if [ -f "$i" ]
    then
        echo "verilog work $i" >> testbench.prj
    fi
done

cat testbench.prj

#parse all present VHDL files into a "virtual project"
vhpcomp --prj testbench.prj 2>&1

#and create a simulation executable (capable of running test scripts)
fuse --prj testbench.prj testbench -o uut 2>&1

#and run the testbench
./uut -tclbatch sim.tcl 2>&1
