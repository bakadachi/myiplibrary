// Terasic De0 CYCLONEIII
module IORING # (
) (
  // Inputs
  input logic                 CKA50,                        // CLK4
  input logic                 CKB50,                        // CLK9
  input logic                 CKAGPIO0,                     // AB12
  input logic                 CKBGPIO0,                     // AA12
  input logic                 CKAGPIO1,                     // AB11
  input logic                 CKBGPIO1,                     // AA11
  input logic                 CKPS2KB                       // P22
  input logic                 CKPS2MS                       // R21
  input logic                 PS2KBDAT,                     // P21
  input logic                 PS2MSDAT,                     // R22
  input logic [2:0]           BUTTON,                       // F1  , G3  , H2 [74HC245]
  input logic [9:0]           SW                            // D2  , E4  , E3  , H7  , J7  , G5  , G4  , H6, H5, J6
  input logic                 TXD                           // U21 [ADM3202]
  input logic                 CTS                           // V21 [ADM3202]
  input logic                 SDWP,                         // W20 active low
  // Outputs
  output logic                SDCK,                         // Y21
  output logic [9:0]          LEDG,                         // B1  , B2  , C2  , C1  , E1  , F2  , H1  , J3, J2, J1
  output logic [7:0]          HEX0,                         // D12 , F13 , F12 , G12 , H13 , H12 , F11 , E11
  output logic [7:0]          HEX1,                         // B15 , A15 , E14 , B14 , A14 , C13 , B13 , A13
  output logic [7:0]          HEX2,                         // A18 , F14 , B17 , A17 , E15 , B16 , A16 , D15
  output logic [7:0]          HEX3,                         // G16 , G15 , D19 , C19 , B19 , A19 , F15 , B18
  output logic [3:0]          VGAR,                         // H21 , H20 , H17 , H19
  output logic [3:0]          VGAG,                         // J21 , K17 , J17 , H22
  output logic [3:0]          VGAB,                         // K18 , J22 , K21 , K22
  output logic                VGAH                          // L21
  output logic                VGAV,                         // L22
  output logic                RXD,                          // U22 [ADM3202]
  output logic                RTS,                          // V22 [ADM3202]
  // Bidirectional
  inout logic                 SDCMD,                        // Y22
  inout logic                 SDDAT0,                       // AA22
  inout logic                 SDDAT3,                       // W21
  inout logic [31:0]          GPIO0,                        // tl;dw 
  inout logic [31:0]          GPIO1,                        // tl;dw 
  // SDRAM_IF
  output logic [12:0]         DRAM_ADDR,
  inout  logic [15:0]         DRAM_DQ,
  output logic                DRAM_BA_0,
  output logic                DRAM_BA_1,
  output logic                DRAM_LDQM,
  output logic                DRAM_UDQM,
  output logic                DRAM_WE_N,
  output logic                DRAM_CAS_N,
  output logic                DRAM_RAS_N,
  output logic                DRAM_CAS_N,
  output logic                DRAM_CLK,
  output logic                DRAM_CKE,
  // FLASH_IF
  output logic [12:0]         FL_ADDR,
  inout  logic [15:0]         FL_DQ,
  output logic                FL_DQ_AM1,
  output logic                FL_WE_N,
  output logic                FL_RST_N,
  output logic                FL_WP_N,
  output logic                FL_RY,
  output logic                FL_CE_N,
  output logic                FL_OE_N,
  output logic                FL_BYTE_N,
);

logic SdCmdIn;
logic SdCmdOut;
logic SdCmdEn;
logic SdDat0In;
logic SdDat0Out;
logic SdDat0En;
logic SdDat3In;
logic SdDat3Out;
logic SdDat3En;
logic [31:0] Gpio0In;
logic [31:0] Gpio0Out;
logic [31:0] Gpio0En;
logic [31:0] Gpio1In;
logic [31:0] Gpio1Out;
logic [31:0] Gpio1En;
logic [15:0] DramDatIn;
logic [15:0] DramDatOut;
logic        DramDatEn;

// inout assignment for SD_CMD
assign SDCMD    = SdCmdEn ? SdCmdOut  : 'z;
assign SdCmdIn  = SDCMD;

// inout assignment for SD_DATA0
assign SDDAT0   = SdCmdEn  ? SdDat0Out : 'z;
assign SdDat0In = SDDAT0;

// inout assignment for SD_DATA3
assign SDDAT3   = SdCmdEn  ? SdDat3Out : 'z;
assign SdDat3In = SDDAT3;

// inout assignment for SDRAM
assign DRAM_DQ = DramDatEn ? DramDatOut : 'z;
assign DramDatIn = DRAM_DQ;

// inout assignments for GPIO
genvar i;
generate
for (i=0 i<31; i=i+1) begin
  assign GPIO0 = Gpio0En[i] ? Gpio0Out[i] : 'z;
  assign GPIO1 = Gpio1En[i] ? Gpio1Out[i] : 'z;
end
endgenerate


endmodule