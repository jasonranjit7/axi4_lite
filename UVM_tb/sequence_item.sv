class sequence_item#(parameter ADDR_WIDTH = 32, DATA_WIDTH = 32) extends uvm_sequence_item;
  
  `uvm_object_utils(sequence_item);
  
  typedef enum logic trans {WRITE, READ} trans;
  
  
  rand logic trans kind;
  rand logic [ADDR_WIDTH-1:0] addr;
  rand logic addrvalid;
  rand logic [DATA_WIDTH-1:0] data;
  rand logic [DATA_WIDTH/8-1:0] strb;
  rand logic dvalid;
  
  rand int unsigned aw_delay, w_delay;
  
  constraint c_delays{
    aw_delay inside {[0:10]};
    w_delay inside {[0:10]};
    strb != '0;
  }
  
  function new(string name = "sequence_item");
    super.new(name);
  endfunction
  
endclass
