/*

Monitor written by : Debjit Pal
Email ID: dpal2@illinois.edu
Institute: Univerisity of Illinois at Urbana-Champaign

*/

module siu_to_l2_mon();

reg enabled;
initial begin
    enabled = 1'b1;
    if($test$plusargs("siu_to_l2_mon_disable"))
    begin
        enabled = 1'b0;
    end
end

/* From SII to L2 monitoring INBOUND Messages */

wire iol2clk = `SII.iol2clk;

wire [31:0] sii_l2t0_req = `SII.sii_l2t0_req;
wire [31:0] sii_l2t1_req = `SII.sii_l2t1_req;
wire [31:0] sii_l2t2_req = `SII.sii_l2t2_req;
wire [31:0] sii_l2t3_req = `SII.sii_l2t3_req;
wire [31:0] sii_l2t4_req = `SII.sii_l2t4_req;
wire [31:0] sii_l2t5_req = `SII.sii_l2t5_req;
wire [31:0] sii_l2t6_req = `SII.sii_l2t6_req;
wire [31:0] sii_l2t7_req = `SII.sii_l2t7_req;

wire sii_l2t0_req_vld = `SII.sii_l2t0_req_vld;
wire sii_l2t1_req_vld = `SII.sii_l2t1_req_vld;
wire sii_l2t2_req_vld = `SII.sii_l2t2_req_vld;
wire sii_l2t3_req_vld = `SII.sii_l2t3_req_vld;
wire sii_l2t4_req_vld = `SII.sii_l2t4_req_vld;
wire sii_l2t5_req_vld = `SII.sii_l2t5_req_vld;
wire sii_l2t6_req_vld = `SII.sii_l2t6_req_vld;
wire sii_l2t7_req_vld = `SII.sii_l2t7_req_vld;

wire l2t0_sii_iq_dequeue = `SII.l2t0_sii_iq_dequeue;
wire l2t1_sii_iq_dequeue = `SII.l2t1_sii_iq_dequeue;
wire l2t2_sii_iq_dequeue = `SII.l2t2_sii_iq_dequeue;
wire l2t3_sii_iq_dequeue = `SII.l2t3_sii_iq_dequeue;
wire l2t4_sii_iq_dequeue = `SII.l2t4_sii_iq_dequeue;
wire l2t5_sii_iq_dequeue = `SII.l2t5_sii_iq_dequeue;
wire l2t6_sii_iq_dequeue = `SII.l2t6_sii_iq_dequeue;
wire l2t7_sii_iq_dequeue = `SII.l2t7_sii_iq_dequeue;


always @(posedge (iol2clk && enabled))
begin
    if(sii_l2t0_req_vld)
        `PR_ALWAYS("siu_to_l2_mon", `ALWAYS, "SII_L2T_REQ_VLD T = 0, sii_l2t0_req_vld = %b", sii_l2t0_req_vld);
end

always @(posedge (iol2clk && enabled))
begin
    if(sii_l2t1_req_vld)
        `PR_ALWAYS("siu_to_l2_mon", `ALWAYS, "SII_L2T_REQ_VLD T = 1, sii_l2t1_req_vld = %b", sii_l2t1_req_vld);
end

always @(posedge (iol2clk && enabled))
begin
    if(sii_l2t2_req_vld)
        `PR_ALWAYS("siu_to_l2_mon", `ALWAYS, "SII_L2T_REQ_VLD T = 2, sii_l2t2_req_vld = %b", sii_l2t2_req_vld);
end

always @(posedge (iol2clk && enabled))
begin
    if(sii_l2t3_req_vld)
        `PR_ALWAYS("siu_to_l2_mon", `ALWAYS, "SII_L2T_REQ_VLD T = 3, sii_l2t3_req_vld = %b", sii_l2t3_req_vld);
end

always @(posedge (iol2clk && enabled))
begin
    if(sii_l2t4_req_vld)
        `PR_ALWAYS("siu_to_l2_mon", `ALWAYS, "SII_L2T_REQ_VLD T = 4, sii_l2t4_req_vld = %b", sii_l2t4_req_vld);
end

always @(posedge (iol2clk && enabled))
begin
    if(sii_l2t5_req_vld)
        `PR_ALWAYS("siu_to_l2_mon", `ALWAYS, "SII_L2T_REQ_VLD T = 5, sii_l2t5_req_vld = %b", sii_l2t5_req_vld);
end

always @(posedge (iol2clk && enabled))
begin
    if(sii_l2t6_req_vld)
        `PR_ALWAYS("siu_to_l2_mon", `ALWAYS, "SII_L2T_REQ_VLD T = 6, sii_l2t6_req_vld = %b", sii_l2t6_req_vld);
end

always @(posedge (iol2clk && enabled))
begin
    if(sii_l2t7_req_vld)
        `PR_ALWAYS("siu_to_l2_mon", `ALWAYS, "SII_L2T_REQ_VLD T = 7, sii_l2t7_req_vld = %b", sii_l2t7_req_vld);
end


endmodule
