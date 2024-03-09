package pa_Ck2CkFifo

localparam uint DATA_W = 8;                                 //
localparam uint FIFO_SIZE = 4;                              //

typedef enum logic[2:0] {  
  EMPTY = 3'd1,
  PUSH  = 3'd2,
  IDLE  = 3'd3,
  POP   = 3'd4,
  FULL  = 3'd5
} ty_Ck2CkFifoStates;
  
endpackage