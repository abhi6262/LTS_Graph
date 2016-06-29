/*

Monitor written by : Debjit Pal
Email ID: dpal2@illinois.edu
Institute: Univerisity of Illinois at Urbana-Champaign

*/

module niu_to_siu_mon();

reg enabled;
initial begin
    enabled = 1'b1;
    if ($test$plusargs("niu_to_siu_mon_disable"))
    begin
        enabled = 1'b0;
    end
end

wire l2t0_sii_iq_dequeue = `SII.l2t0_sii_iq_dequeue;
/* From NIU to SII monitoring INBOUND Messages */

wire iol2clk = `SII.iol2clk;
wire niu_sii_hdr_vld = `SII.niu_sii_hdr_vld;
wire niu_sii_reqbypass = `SII.niu_sii_reqbypass;
wire niu_sii_datareq = `SII.niu_sii_datareq;
wire niu_sii_datareq16 = `SII.niu_sii_datareq16;
wire sii_niu_oqdq = `SII.sii_niu_oqdq;
wire [127:0] niu_sii_data = `SII.niu_sii_data;
wire [7:0] niu_sii_parity = `SII.niu_sii_parity;
wire [15:0] niu_sii_be = `SII.niu_sii_be;

always @(posedge (iol2clk && enabled))
begin
    if(niu_sii_hdr_vld)
        `PR_ALWAYS("niu_to_siu_mon", `ALWAYS, "NIU_SII_HDR_VLD niu_sii_hdr_vld = %b", niu_sii_hdr_vld);
end

endmodule
