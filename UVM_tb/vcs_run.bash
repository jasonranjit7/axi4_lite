# 1. Compile with -full64 to match system architecture
vcs -full64 -sverilog -timescale=1ns/1ns -ntb_opts uvm-1.2 -cm line+cond+fsm+tgl+branch+assert design.sv testbench.sv -o simv

# 2. Run simulation to generate the .vdb coverage directory
./simv -cm line+cond+fsm+tgl+branch+assert

# 3. Generate the text report
urg -dir simv.vdb -format text -report text_report

# 4. Output the coverage summary
cat text_report/dashboard.txt
