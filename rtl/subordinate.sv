`include "../typedefs.sv"

module subordinate #(
  parameter int ADDR_WIDTH = 32,
  parameter int DATA_WIDTH = 32
)(
  input  logic ACLK,
  input  logic ARESETN,
  
  // Write address channel
  input  logic [ADDR_WIDTH-1:0] AWADDR,
  input  logic AWVALID,
  output logic AWREADY,
  
  // Write data channel
  input  logic [DATA_WIDTH-1:0] WDATA,
  input  logic [DATA_WIDTH/8-1:0] WSTRB,
  input  logic WVALID,
  output logic WREADY,
  
  // Write response channel
  output logic [1:0] BRESP,
  output logic BVALID,
  input  logic BREADY,
  
  // Read address channel
  input  logic [ADDR_WIDTH-1:0] ARADDR,
  input  logic ARVALID,
  output logic ARREADY,
  
  // Read data channel
  output logic [DATA_WIDTH-1:0] RDATA,
  output logic [1:0] RRESP,
  output logic RVALID,
  input  logic RREADY
);
  
  import typedefs::*;
  
  //typedef
  sub_w_state wstate;
  sub_r_state rstate;
  
  logic aw_done, w_done;
  
  logic [ADDR_WIDTH-1:0] awaddr_q;
  
  //for verilator linting
  logic unused_bits;
  assign unused_bits = |{ARADDR[1:0], awaddr_q[1:0]};
  
  logic [DATA_WIDTH-1:0] wdata_q;
  logic [DATA_WIDTH/8-1:0] wstrb_q;
  
  logic [DATA_WIDTH-1:0] reg_ctrl, reg_status;
  assign reg_status = '0;
  
  assign AWREADY = wstate==SW_IDLE && !aw_done;
  assign WREADY = wstate==SW_IDLE && !w_done;
  
  //write
  always_ff@(posedge ACLK or negedge ARESETN) begin
    if(!ARESETN) begin
      wstate <= SW_IDLE;
      aw_done <= 0;
      w_done <= 0;
      BVALID <= 0;
      BRESP <= OKAY;
      reg_ctrl <= '0;
    end
    else begin
      if(AWREADY && AWVALID) begin
        aw_done <= 1;
        awaddr_q <= AWADDR;
      end
      if(WREADY && WVALID) begin
        w_done <= 1;
        wdata_q <= WDATA;
        wstrb_q <= WSTRB;
      end
      
      case(wstate)
        SW_IDLE: begin
          if((aw_done ||(AWREADY && AWVALID)) && (w_done || (WREADY && WVALID)))
            wstate <= SW_WRITE;
        end
        SW_WRITE: begin
          case(awaddr_q[ADDR_WIDTH-1:2])
          	'h0: begin
              for(int i=0; i<DATA_WIDTH/8; i++)
                if(wstrb_q[i])
                  reg_ctrl[i*8+:8] <= wdata_q[i*8+:8];
              BRESP <= OKAY;
            end
            'h1: BRESP <= OKAY;
            default: BRESP <= DECERR;
          endcase
          BVALID <= 1;
          wstate <= SW_RESP; 
        end
        SW_RESP: begin
          if(BVALID && BREADY) begin
            BVALID <= 0;
            aw_done <= 0;
            w_done <= 0;
            wstate <= SW_IDLE;
          end
        end
        default: wstate <= SW_IDLE;
      endcase
    end
  end  
  
  assign ARREADY = rstate==SR_IDLE;
  
  //read
  always_ff@(posedge ACLK or negedge ARESETN) begin
    if(!ARESETN) begin
      rstate <= SR_IDLE;
      RVALID <= 0;
      RRESP <= OKAY;
      RDATA <=0;
    end
    else begin
      case(rstate)
        SR_IDLE: begin
          if (ARREADY && ARVALID) begin
            case (ARADDR[ADDR_WIDTH-1:2])
              'h0: begin
                RDATA <= reg_ctrl;
                RRESP <= OKAY;
              end
              'h1: begin
                RDATA <= reg_status;
                RRESP <= OKAY;
              end
              default: begin
                RDATA <= '0;
                RRESP <= DECERR;
              end
            endcase

            RVALID <= 1'b1;
            rstate <= SR_RESP;
          end
        end
        SR_RESP: begin
          if(RVALID && RREADY) begin
            RVALID <= 0;
            rstate <= SR_IDLE;
          end
        end
      endcase
    end
  end
  
  
  
endmodule
