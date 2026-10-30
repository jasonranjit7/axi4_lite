`include "../agent/agent.sv"
`include "scoreboard.sv"
class environment#(parameter ADDR_WIDTH=32, DATA_WIDTH=32)  extends uvm_env;
  `uvm_component_utils(environment)
  
  agent ag;
  scoreboard#(ADDR_WIDTH, DATA_WIDTH) scb;
  
  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction
  
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    ag = agent::type_id::create("ag", this);
    scb = scoreboard#(ADDR_WIDTH, DATA_WIDTH)::type_id::create("scb", this);
  endfunction
  
  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    ag.mon.item_collected_port.connect(scb.item_imp);
  endfunction
endclass
  
