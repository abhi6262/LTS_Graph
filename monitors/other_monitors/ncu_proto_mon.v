/*

Monitor written by : Debjit Pal
Email ID: dpal2@illinois.edu
Institute: Univerisity of Illinois at Urbana-Champaign

*/

module ncu_proto_mon();

reg enabled;
initial begin
    enabled = 1'b1;
    if ($test$plusargs("ncu_proto_mon_disable"))
    begin
        enabled = 1'b0;
    end
end

/* Common clock for all NCU Protocol monitoring */

wire iol2clk = `NCU.iol2clk;

/* From NCU to DMU PIO Interface */

wire [63:0] ncu_dmu_pio_data = `NCU.ncu_dmu_pio_data;
wire ncu_dmu_pio_hdr_vld = `NCU.ncu_dmu_pio_hdr_vld;
wire dmu_ncu_wrack_vld = `NCU.dmu_ncu_wrack_vld;
wire [3:0] dmu_ncu_wrack_tag = `NCU.dmu_ncu_wrack_tag;
wire ncu_dmu_mmu_addr_vld = `NCU.ncu_dmu_mmu_addr_vld;


/* From NCU to DMU Mondo Interface */

wire [5:0] ncu_dmu_mondo_id = `NCU.ncu_dmu_mondo_id;
wire ncu_dmu_mondo_ack = `NCU.ncu_dmu_mondo_ack;
wire ncu_dmu_mondo_nack = `NCU.ncu_dmu_mondo_nack;

/* From NCU to MCU Downstream Monitoring (4 MCUs) */

wire ncu_mcu0_vld = `NCU.ncu_mcu0_vld; 
wire [3:0] ncu_mcu0_data = `NCU.ncu_mcu0_data;
wire mcu0_ncu_stall = `NCU.mcu0_ncu_stall;

wire ncu_mcu1_vld = `NCU.ncu_mcu1_vld; 
wire [3:0] ncu_mcu1_data = `NCU.ncu_mcu1_data;
wire mcu1_ncu_stall = `NCU.mcu1_ncu_stall;

wire ncu_mcu2_vld = `NCU.ncu_mcu2_vld; 
wire [3:0] ncu_mcu2_data = `NCU.ncu_mcu2_data;
wire mcu2_ncu_stall = `NCU.mcu2_ncu_stall;

wire ncu_mcu3_vld = `NCU.ncu_mcu3_vld; 
wire [3:0] ncu_mcu3_data = `NCU.ncu_mcu3_data;
wire mcu3_ncu_stall = `NCU.mcu3_ncu_stall;

/* From MCU to NCU Upstream (4 MCUs) */

wire mcu0_ncu_vld = `NCU.mcu0_ncu_vld;
wire [3:0] mcu0_ncu_data = `NCU.mcu0_ncu_data;
wire ncu_mcu0_stall = `NCU.ncu_mcu0_stall;

wire mcu1_ncu_vld = `NCU.mcu1_ncu_vld;
wire [3:0] mcu1_ncu_data = `NCU.mcu1_ncu_data;
wire ncu_mcu1_stall = `NCU.ncu_mcu1_stall;

wire mcu2_ncu_vld = `NCU.mcu2_ncu_vld;
wire [3:0] mcu2_ncu_data = `NCU.mcu2_ncu_data;
wire ncu_mcu2_stall = `NCU.ncu_mcu2_stall;

wire mcu3_ncu_vld = `NCU.mcu3_ncu_vld;
wire [3:0] mcu3_ncu_data = `NCU.mcu3_ncu_data;
wire ncu_mcu3_stall = `NCU.ncu_mcu3_stall;


always @(posedge (iol2clk && enabled))
begin
    if (ncu_dmu_pio_hdr_vld)
        `PR_ALWAYS("ncu_proto_mon", `ALWAYS, "PIO Header Valid from NCU to DMU ncu_dmu_pio_hdr_vld = %b", ncu_dmu_pio_hdr_vld);
end

always @(posedge (iol2clk && enabled))
begin
    if (ncu_dmu_mondo_ack)
    begin
        `PR_ALWAYS("ncu_proto_mon", `ALWAYS, "NCU sending Mondo Packet acknowledge (ack) to DMU for Mondo ID = %x", ncu_dmu_mondo_id);
    end
end

always @(posedge (iol2clk && enabled))
begin
    if (ncu_dmu_mondo_nack)
    begin
        `PR_ALWAYS("ncu_proto_mon", `ALWAYS, "NCU sending Mondo Packet Nacknowledge (nack) to DMU for Mondo ID = %x", ncu_dmu_mondo_id);
    end
end

endmodule
