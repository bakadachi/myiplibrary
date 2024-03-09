module Ck2CkFifo # (
  DATA_W    = pa_Ck2CkFifo::DATA_W,                         //
  FIFO_SIZE = pa_Ck2CkFifo::FIFO_SIZE                       //
) (
  input logic                 ckSlow,                       // Clock Slow
  input logic                 ckFast,                       // Clock Fast 
  output logic                reqCkSlow,                    //
  output logic                reqCkFast,                    //
  input logic                 arstSlow,                     // 
  input logic                 arstFast,                     //
  // Slow synchronized IO
  input logic                 pop,                          //
  output logic                empty,                        //
  output logic                ready,                        //
  output logic [DATA_W-1:0]   dataOut,                      //
  // Fast synchronized IO
  input logic [DATA_W-1:0]    dataIn,                       //
  input logic                 push,                         //
  output logic                full,                         //
  // Debug IF
  pa_Ck2CkFifo::ty_Ck2CkFifoStates status                   //
);

localparam FIFO_ADDR_W = clog2(FIFO_SIZE);
  logic [IFO_ADDR_W-1:0]              firstIn,              // Was first in, increments by 1 when data popped.
  logic [IFO_ADDR_W-1:0]              pointer,              // Where the data is stored next, increments by 1 when data pushed.
  logic [FIFO_W-1:0][DATA_W-1:0]      fifo_rg,              // Fifo register
  logic [DATA_W-1:0]                  dataOut_int           //

  pa_Ck2CkFifo::ty_Ck2CkFifoStates currStCk2CkFifo;
  pa_Ck2CkFifo::ty_Ck2CkFifoStates nextStCk2CkFifo;

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
      pa_Ck2CkFifo::EMPTY:
      pa_Ck2CkFifo::PUSH:
      pa_Ck2CkFifo::IDLE:
      pa_Ck2CkFifo::POP:
      pa_Ck2CkFifo::FULL:   
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
        pa_Ck2CkFifo::EMPTY:
        pa_Ck2CkFifo::PUSH:
        pa_Ck2CkFifo::IDLE:
        pa_Ck2CkFifo::POP:
        pa_Ck2CkFifo::FULL:   
      default:
      end
    end

endmodule