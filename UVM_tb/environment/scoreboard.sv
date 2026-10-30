`include "../interface.sv"
`include "../sequence_item.sv"

class scoreboard#(parameter ADDR_WIDTH = 32, DATA_WIDTH = 32) extends uvm_scoreboard;
  
  `uvm_component_param_utils(scoreboard#(ADDR_WIDTH, DATA_WIDTH))
  
  virtual intf#(ADDR_WIDTH, DATA_WIDTH) vif;
  uvm_analysis_imp #(sequence_item#(ADDR_WIDTH, DATA_WIDTH),
                     scoreboard#(ADDR_WIDTH, DATA_WIDTH)) item_imp;
  
  //golden models
  logic [DATA_WIDTH-1:0] exp_reg_ctrl, exp_reg_status;
  
  function new(string name, uvm_component parent);
    super.new(name, parent);
    item_imp = new("item_imp", this);
    exp_reg_ctrl = '0;
    exp_reg_status = '0;
  endfunction
  
  function void write(sequence_item#(ADDR_WIDTH, DATA_WIDTH) trans);
    logic [ADDR_WIDTH-1:2] word_addr = trans.addr[ADDR_WIDTH-1:2];

    if (trans.kind == 0) begin
      case (word_addr)
        'h0: begin // Write to reg_ctrl with strobe masking
          for (int i = 0; i < DATA_WIDTH/8; i++) begin
            if (trans.strb[i])
              exp_reg_ctrl[i*8 +: 8] = trans.data[i*8 +: 8];
          end
          check_response(trans.resp, typedefs::OKAY, "WRITE reg_ctrl BRESP");
        end
        'h1: begin // reg_status is RO
          check_response(trans.resp, typedefs::OKAY, "WRITE reg_status BRESP");
        end
        default: begin // Unmapped address -> DECERR
          check_response(trans.resp, typedefs::DECERR, "WRITE DECERR");
        end
      endcase
    end 
    else begin // READ Transaction
      case (word_addr)
        'h0: begin
          check_data(trans.data, exp_reg_ctrl, "READ reg_ctrl DATA");
          check_response(trans.resp, typedefs::OKAY, "READ reg_ctrl RRESP");
        end
        'h1: begin
          check_data(trans.data, exp_reg_status, "READ reg_status DATA");
          check_response(trans.resp, typedefs::OKAY, "READ reg_status RRESP");
        end
        default: begin
          check_response(trans.resp, typedefs::DECERR, "READ DECERR");
        end
      endcase
    end
  endfunction

  function void check_response(logic [1:0] actual, 
                               logic [1:0] expected, string name);
    if (actual === expected)
      `uvm_info("SB_PASS", $sformatf("[%s] Response Match: %b", 
                                     name, actual), UVM_LOW)
    else
      `uvm_error("SB_FAIL", $sformatf("[%s] Response Mismatch! Exp: %b, Got: %b",
                                      name, expected, actual))
  endfunction

  function void check_data(logic [DATA_WIDTH-1:0] actual, 
                           logic [DATA_WIDTH-1:0] expected, string name);
    if (actual === expected)
      `uvm_info("SB_PASS", $sformatf("[%s] Data Match: 0x%0h", 
                                     name, actual), UVM_LOW)
    else
      `uvm_error("SB_FAIL", $sformatf("[%s] Data Mismatch! Exp: 0x%0h, Got: 0x%0h",
                                      name, expected, actual))
  endfunction
endclass
  
  
