`ifndef TB_PARAMS_PGS_SV
`define TB_PARAMS_PGS_SV
  package tb_params_pkg;
    parameter int ADDR_WIDTH = 32;
    parameter int DATA_WIDTH = 32;
    typedef enum logic [1:0] { OKAY, EXOKAY, SLVERR, DECERR} resp;
  endpackage
`endif
