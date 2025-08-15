flops_sim:
	@verilator -Wall --cc --trace --timing ./dv/sv/flops_tb.sv ./rtl/d_ff.sv ./rtl/d_ff_sync_reset.sv ./rtl/d_ff_sync_reset_en.sv --top-module flops_tb --exe ./dv/verilator/flops_tb.cpp 2>&1 > /dev/null
	@make -j -C obj_dir -f Vflops_tb.mk Vflops_tb 2>&1 > /dev/null
	./obj_dir/Vflops_tb

registers_sim:
	@verilator -Wall --cc --trace --timing ./dv/sv/registers_tb.sv ./rtl/register.sv ./rtl/register_sync_reset.sv ./rtl/register_sync_reset_en.sv --top-module registers_tb --exe ./dv/verilator/registers_tb.cpp 2>&1 > /dev/null
	@make -j -C obj_dir -f Vregisters_tb.mk Vregisters_tb 2>&1 > /dev/null
	./obj_dir/Vregisters_tb

memory_sim:
	@verilator -Wall --cc --trace --timing ./dv/sv/memory_tb.sv ./rtl/memory.sv --top-module memory_tb --exe ./dv/verilator/memory_tb.cpp 2>&1 > /dev/null
	@make -j -C obj_dir -f Vmemory_tb.mk Vmemory_tb 2>&1 > /dev/null
	./obj_dir/Vmemory_tb

register_file_sim:
	@verilator -Wall --cc --trace --timing ./dv/sv/register_file_tb.sv ./rtl/register_file.sv --top-module register_file_tb --exe ./dv/verilator/register_file_tb.cpp 2>&1 > /dev/null
	@make -j -C obj_dir -f Vregister_file_tb.mk Vregister_file_tb 2>&1 > /dev/null
	./obj_dir/Vregister_file_tb



all: flops_sim registers_sim memory_sim register_file_sim

clean:
	rm -rf obj_dir
	rm -f and_gate.vcd