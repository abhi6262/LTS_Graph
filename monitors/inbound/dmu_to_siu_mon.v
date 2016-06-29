/*


Monitor written by : Debjit Pal
Email ID: dpal2@illinois.edu
Institute: Univerisity of Illinois at Urbana-Champaign

*/

module dmu_to_siu_mon();

reg enabled;
initial begin
    enabled = 1'b1;
    if ($test$plusargs("dmu_to_siu_mon_disable"))
    begin
        enabled = 1'b0;
    end
end

/* From Fire-DMU to SII monitoring INBOUND Messages */

wire iol2clk = `SII.iol2clk;
wire dmu_sii_hdr_vld = `SII.dmu_sii_hdr_vld;
wire dmu_sii_reqbypass = `SII.dmu_sii_reqbypass;
wire dmu_sii_datareq = `SII.dmu_sii_datareq;
wire dmu_sii_datareq16 = `SII.dmu_sii_datareq16;
wire sii_dmu_wrack_vld = `SII.sii_dmu_wrack_vld;
wire [3:0] sii_dmu_wrack_tag = `SII.sii_dmu_wrack_tag;
wire [127:0] dmu_sii_data = `SII.dmu_sii_data;
wire [7:0] dmu_sii_parity = `SII.dmu_sii_parity;
wire [15:0] dmu_sii_be = `SII.dmu_sii_be;

always @(posedge (iol2clk && enabled))
begin
    if(dmu_sii_hdr_vld)
        `PR_ALWAYS("dmu_to_siu_mon", `ALWAYS, "DMU_SII_HDR_VLD niu_sii_hdr_vld = %b", dmu_sii_hdr_vld);
end

endmodule
