`include "tb_params_pkg.sv"
import tb_params_pkg::*;
class test extends base_test;
  `uvm_component_utils(test)
  

  
  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction
  
  task run_phase(uvm_phase phase);
    read_write_sequence seq = read_write_sequence#(ADDR_WIDTH, DATA_WIDTH)::type_id::create("seq");
    
    phase.raise_objection(this);
    
    seq.start(env.ag.seqr);
    #100ns;
    phase.drop_objection(this);
  endtask
endclass
