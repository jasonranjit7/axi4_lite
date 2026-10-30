`include "tb_params_pkg.sv"
import tb_params_pkg::*;
`include "sequence_item.sv"
`include "driver.sv"
`include "monitor.sv"


typedef uvm_sequencer #(sequence_item#(ADDR_WIDTH, DATA_WIDTH)) sequencer;

class agent extends uvm_agent;
  
  `uvm_component_utils(agent)
  
  sequencer seqr;
  driver#(ADDR_WIDTH, DATA_WIDTH) drv;
  monitor#(ADDR_WIDTH, DATA_WIDTH) mon;
  
  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction
  
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    
    if(get_is_active() == UVM_ACTIVE) begin
      seqr = sequencer::type_id::create("seqr", this);
      drv = driver#(ADDR_WIDTH, DATA_WIDTH)::type_id::create("drv", this);
    end
    
    mon = monitor#(ADDR_WIDTH, DATA_WIDTH)::type_id::create("mon", this);
  endfunction
  
  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    if(get_is_active() == UVM_ACTIVE) begin
      drv.seq_item_port.connect(seqr.seq_item_export);
    end
  endfunction
endclass
