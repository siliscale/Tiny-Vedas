
slides:
	cd docs/lecture_1 && npx @marp-team/marp-cli slides.md -o slides.pdf --allow-local-files &
	cd docs/lecture_2 && npx @marp-team/marp-cli slides.md -o slides.pdf --allow-local-files &
	cd docs/lecture_3 && npx @marp-team/marp-cli slides.md -o slides.pdf --allow-local-files &
	cd docs/lecture_4 && npx @marp-team/marp-cli slides.md -o slides.pdf --allow-local-files &
	cd docs/lecture_5 && npx @marp-team/marp-cli slides.md -o slides.pdf --allow-local-files &
	cd docs/lecture_6 && npx @marp-team/marp-cli slides.md -o slides.pdf --allow-local-files &
	cd docs/lecture_7 && npx @marp-team/marp-cli slides.md -o slides.pdf --allow-local-files &
	cd docs/lecture_8 && npx @marp-team/marp-cli slides.md -o slides.pdf --allow-local-files &
	cd docs/lecture_9 && npx @marp-team/marp-cli slides.md -o slides.pdf --allow-local-files &
	cd docs/lecture_10 && npx @marp-team/marp-cli slides.md -o slides.pdf --allow-local-files &
core_top_sim:
	@verilator --cc --trace --trace-structs --build --timing --top-module core_top_tb --exe dv/verilator/core_top_tb.cpp -f rtl/core_top.flist -Irtl/include -DICCM_INIT_FILE="\"\"" -DRESET_VECTOR=\'h80000000
	@make -j -C obj_dir -f Vcore_top_tb.mk Vcore_top_tb
	./obj_dir/Vcore_top_tb

lsu_sim:
	xvlog -sv rtl/include/global.svh rtl/include/types.svh rtl/exu/lsu.sv dv/sv/lsu_tb.sv rtl/lib/beh_lib.sv 
	xelab -top lsu_tb -snapshot sim --debug wave
	xsim sim --runall

decodes:
	python3 tools/dec_table_gen.py rtl/idu/decode

clean:
	rm -rf obj_dir
	rm -rf x*
	rm -rf *.log
	rm -rf *.vcd
	rm -rf *.zip
	rm -rf *.wdb
	rm -rf .Xil
	rm -rf work
