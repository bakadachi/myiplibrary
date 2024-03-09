module asTest_Ck2CkFifo # (
  DATA_W = 8,
  FIFO_SIZE   = 4
  FIFO_ADDR_W = clog2(FIFO_SIZE),
) (
  input logic                                ckSlow,        //
  input logic                                ckFast,        //
  input logic                                arstSlow,      //
  input logic                                arstFast,      //
  input logic [DATA_W-1:0]                   dataIn,        // ckFast
  input logic                                push,          // ckFast
  input logic                                pop,           // ckSlow 
  output logic                               empty,         // ckSlow gf
  output logic [DATA_W-1:0]                  dataOut,       // ckSlow gf
  output logic                               full,          // ckFast gf
  output logic                               reqCkSlow,     // clock request for ckSlow
  output logic                               reqCkFast,     // clock request for ckFast
  output ty_Ck2CkFifoStates                  ck2CkSt        // debug if
);

  logic [FIFO_SIZE-1:0]                firstIn ;
  logic [FIFO_SIZE-1:0]                pointer ;
  logic [FIFO_ADDR_W-1:0][DATA_W-1:0]  fifo_rg ;
  logic [DATA_W-1:0]                   nextOut ;
  logic                                popRdy  ;            // To be synced data

  ty_Ck2CkFifoStates currStCk2CkFifo;
  ty_Ck2CkFifoStates nextStCk2CkFifo;

  always_ff(posedge ckFast, posedge arstFast)
    begin : la_nextState
      if(arstFast)begin : la_NexOpTransition
        currStCk2CkFifo <= 8'h0;
        nextStCk2CkFifo <= 8'h0; 
      end else if(currStCk2CkFifo != nextStCk2CkFifo) begin
        currStCk2CkFifo <= nextStCk2CkFifo;
      end
    end
  

  // This selects operation
  always_comb begin : la_NextStateDecoder
    nextStCk2CkFifo = currStCk2CkFifo;
    case(nextStCk2CkFifo)
      default:
    endcase
  end

  always_ff(posedge ckFast, posedge arts)
    begin
      if(arstFast)begin : la_OutputDecoder
      end else if(currStCk2CkFifo != nextStCk2CkFifo)begin
      case(nextStCk2CkFifo)
        default:
      end
    end

endmodule