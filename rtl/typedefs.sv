package typedefs;

typedef enum logic [1:0] {
  SW_IDLE, SW_WRITE, SW_RESP 
} sub_w_state;

typedef enum logic {
  SR_IDLE, SR_RESP
} sub_r_state;

typedef enum logic [1:0] {
  OKAY, EXOKAY, SLVERR, DECERR
} resp;


endpackage: typedefs

