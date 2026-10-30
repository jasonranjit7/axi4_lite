`include "environment/environment.sv"
`include "sequence.sv"
class base_test #(parameter ADDR_WIDTH = 32, DATA_WIDTH = 32) extends uvm_test;
  `uvm_component_utils(base_test)

  environment #(ADDR_WIDTH, DATA_WIDTH) env;

  function new(string name = "base_test", uvm_component parent = null); 
    super.new(name, parent); 
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    env = environment#(ADDR_WIDTH, DATA_WIDTH)::type_id::create("env", this);
  endfunction

  task run_phase(uvm_phase phase);
    read_write_sequence seq = read_write_sequence#(ADDR_WIDTH, DATA_WIDTH)::type_id::create("seq");
    phase.raise_objection(this);
    seq.start(env.ag.seqr);
    #100ns;
    phase.drop_objection(this);
  endtask
endclass
