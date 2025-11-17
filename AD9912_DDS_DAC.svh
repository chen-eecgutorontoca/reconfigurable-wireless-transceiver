
module AD9912_DDS_DAC(
    input logic clk,
    input logic rst_n,
    input logic [47:0] FTW,     //48bit Frequency Turning Word
    output logic tx_dds_SCLK,
    output logic tx_dds_SDIO,
    input logic tx_dds_SDO,
    output logic tx_dds_CSB
);


//SCLK generation
always_ff @(posedge clk or negedge rst_n)begin

end


//

//FSM
typedef enum logic []{

}





endmodule