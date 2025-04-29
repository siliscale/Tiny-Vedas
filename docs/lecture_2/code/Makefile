and_gate_sim:
	@verilator -Wall --cc --trace --timing ./dv/sv/and_gate_tb.sv ./rtl/and_gate.sv --top-module and_gate_tb --exe ./dv/verilator/and_gate.cpp 2>&1 > /dev/null
	@make -j -C obj_dir -f Vand_gate_tb.mk Vand_gate_tb 2>&1 > /dev/null
	./obj_dir/Vand_gate_tb

or_gate_sim:
	@verilator -Wall --cc --trace --timing ./dv/sv/or_gate_tb.sv ./rtl/or_gate.sv --top-module or_gate_tb --exe ./dv/verilator/or_gate.cpp 2>&1 > /dev/null
	@make -j -C obj_dir -f Vor_gate_tb.mk Vor_gate_tb 2>&1 > /dev/null
	./obj_dir/Vor_gate_tb

xor_gate_sim:
	@verilator -Wall --cc --trace --timing ./dv/sv/xor_gate_tb.sv ./rtl/xor_gate.sv --top-module xor_gate_tb --exe ./dv/verilator/xor_gate.cpp 2>&1 > /dev/null
	@make -j -C obj_dir -f Vxor_gate_tb.mk Vxor_gate_tb 2>&1 > /dev/null
	./obj_dir/Vxor_gate_tb

not_gate_sim:
	@verilator -Wall --cc --trace --timing ./dv/sv/not_gate_tb.sv ./rtl/not_gate.sv --top-module not_gate_tb --exe ./dv/verilator/not_gate.cpp 2>&1 > /dev/null
	@make -j -C obj_dir -f Vnot_gate_tb.mk Vnot_gate_tb 2>&1 > /dev/null
	./obj_dir/Vnot_gate_tb

rs_sim:
	@verilator -Wall --cc --trace --timing ./dv/sv/rs_tb.sv ./rtl/rls.sv ./rtl/ras.sv --top-module rs_tb --exe ./dv/verilator/rs.cpp 2>&1 > /dev/null
	@make -j -C obj_dir -f Vrs_tb.mk Vrs_tb 2>&1 > /dev/null
	./obj_dir/Vrs_tb

lls_sim:
	@verilator -Wall --cc --trace --timing ./dv/sv/lls_tb.sv ./rtl/lls.sv --top-module lls_tb --exe ./dv/verilator/lls.cpp 2>&1 > /dev/null	
	@make -j -C obj_dir -f Vlls_tb.mk Vlls_tb 2>&1 > /dev/null
	./obj_dir/Vlls_tb

alu_sim:
	@verilator -Wall --cc --trace --timing ./dv/sv/alu_tb.sv ./rtl/alu.sv --top-module alu_tb --exe ./dv/verilator/alu.cpp 2>&1 > /dev/null
	@make -j -C obj_dir -f Valu_tb.mk Valu_tb 2>&1 > /dev/null
	./obj_dir/Valu_tb

full_adder_sim:
	@verilator -Wall --cc --trace --timing ./dv/sv/full_adder_tb.sv ./rtl/full_adder.sv ./rtl/half_adder.sv --top-module full_adder_tb --exe ./dv/verilator/full_adder.cpp 2>&1 > /dev/null
	@make -j -C obj_dir -f Vfull_adder_tb.mk Vfull_adder_tb 2>&1 > /dev/null
	./obj_dir/Vfull_adder_tb

half_adder_sim:
	@verilator -Wall --cc --trace --timing ./dv/sv/half_adder_tb.sv ./rtl/half_adder.sv --top-module half_adder_tb --exe ./dv/verilator/half_adder.cpp 2>&1 > /dev/null
	@make -j -C obj_dir -f Vhalf_adder_tb.mk Vhalf_adder_tb 2>&1 > /dev/null
	./obj_dir/Vhalf_adder_tb

bitwise_ops_sim:
	@verilator -Wall --cc --trace --timing ./dv/sv/bitwise_ops_tb.sv ./rtl/bitwise_ops.sv --top-module bitwise_ops_tb --exe ./dv/verilator/bitwise_ops.cpp 2>&1 > /dev/null
	@make -j -C obj_dir -f Vbitwise_ops_tb.mk Vbitwise_ops_tb 2>&1 > /dev/null
	./obj_dir/Vbitwise_ops_tb

adder_4bit_sim:
	@verilator -Wall --cc --trace --timing ./dv/sv/adder_4bit_tb.sv ./rtl/adder_4bit.sv ./rtl/full_adder.sv ./rtl/half_adder.sv ./rtl/adder_4bit_conv_unsign.sv ./rtl/adder_4bit_conv_signed.sv --top-module adder_4bit_tb --exe ./dv/verilator/adder_4bit.cpp 2>&1 > /dev/null
	@make -j -C obj_dir -f Vadder_4bit_tb.mk Vadder_4bit_tb 2>&1 > /dev/null
	./obj_dir/Vadder_4bit_tb


all: and_gate_sim or_gate_sim xor_gate_sim not_gate_sim rs_sim lls_sim alu_sim full_adder_sim half_adder_sim bitwise_ops_sim adder_4bit_sim

clean:
	rm -rf obj_dir
	rm -f and_gate.vcd