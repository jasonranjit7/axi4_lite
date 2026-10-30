class read_write_sequence#(parameter ADDR_WIDTH=32, DATA_WIDTH=32) extends
  uvm_sequence#(sequence_item#(ADDR_WIDTH, DATA_WIDTH));
  
  `uvm_object_param_utils(read_write_sequence#(ADDR_WIDTH, DATA_WIDTH))
  
  function new(string name = "read_write_sequence");
    super.new(name);
  endfunction
  
  task body();
    sequence_item#(ADDR_WIDTH, DATA_WIDTH) item;
    
    item = sequence_item#(ADDR_WIDTH, DATA_WIDTH)::type_id::create("item");
    start_item(item);
    if(!item.randomize() with {
      kind == 0;//write
      addr == '0;
      aw_delay ==0;
      w_delay inside {[1:5]};
    }) `uvm_fatal("SEQ", "failed randomization")
      finish_item(item);
    
    item = sequence_item#(ADDR_WIDTH, DATA_WIDTH)::type_id::create("item");
    start_item(item);
    if(!item.randomize() with {
      kind == 0;//write
      addr == '0;
      data!=0;
      w_delay ==0;
      aw_delay inside {[1:5]};
    }) `uvm_fatal("SEQ", "failed randomization")
      finish_item(item);
    
    // Read back reg_ctrl
    item = sequence_item#(ADDR_WIDTH, DATA_WIDTH)::type_id::create("item");
    start_item(item);
    if (!item.randomize() with {
      kind == 1; // READ
      addr == '0;
    }) `uvm_fatal("SEQ", "failed randomization")
    finish_item(item);
    
  endtask
endclass
