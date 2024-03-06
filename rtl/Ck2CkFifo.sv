module Ck2CkFifo # (
  DATA_W = 8,
  FIFO_W = 16
) (
  input logic                 ckSlow,                       // Clock Slow
  input logic                 ckFast,                       // Clock Fast      
  input logic                 arstSlow,                     // 
  input logic                 arstFast,                     //
  // Slow synchronized IO
  input logic [DATA_W-1:0]    dataIn,
  input logic                 pop,
  output logic                empty,
  // Fast synchronized IO
  input logic [DATA_W-1:0]    push,
  output logic                full,
  // Debug IF

);

  logic [FIFO_W-1:0]              pointer,
  logic [FIFO_W-1:0][DATA_W-1:0]  fifo_rg,

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

  always_ff(posedge ckFast, posedge arstFast)
    begin : la_Counter
      if(arstFast)begin

      end else if(counterEna == 1)begin

      end
    end

endmodule