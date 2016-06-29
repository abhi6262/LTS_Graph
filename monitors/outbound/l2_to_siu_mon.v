/*

Monitor written by : Debjit Pal
Email ID: dpal2@illinois.edu
Institute: Univerisity of Illinois at Urbana-Champaign

*/

module l2_to_siu_mon();

reg enabled;
initial begin
    enabled = 1'b1;
    if ($test$plusargs("l2_to_siu_mon_disable"))
    begin
        enabled = 1'b0;
    end
end

/* From L2 to SIU monitoring OUTBOUND Messages */

wire iol2clk = `SII.iol2clk; // `SII.iol2clk and `SIO.iol2clk are same

/* Signals required to know L2 has dispatched the read */

wire [31:0] sii_l2t7_req = `SII.sii_l2t7_req;
wire [31:0] sii_l2t6_req = `SII.sii_l2t6_req;
wire [31:0] sii_l2t5_req = `SII.sii_l2t5_req;
wire [31:0] sii_l2t4_req = `SII.sii_l2t4_req;
wire [31:0] sii_l2t3_req = `SII.sii_l2t3_req;
wire [31:0] sii_l2t2_req = `SII.sii_l2t2_req;
wire [31:0] sii_l2t1_req = `SII.sii_l2t1_req;
wire [31:0] sii_l2t0_req = `SII.sii_l2t7_req;

wire l2t7_sii_iq_dequeue = `SII.l2t7_sii_iq_dequeue;
wire l2t6_sii_iq_dequeue = `SII.l2t6_sii_iq_dequeue;
wire l2t5_sii_iq_dequeue = `SII.l2t5_sii_iq_dequeue;
wire l2t4_sii_iq_dequeue = `SII.l2t4_sii_iq_dequeue;
wire l2t3_sii_iq_dequeue = `SII.l2t3_sii_iq_dequeue;
wire l2t2_sii_iq_dequeue = `SII.l2t2_sii_iq_dequeue;
wire l2t1_sii_iq_dequeue = `SII.l2t1_sii_iq_dequeue;
wire l2t0_sii_iq_dequeue = `SII.l2t0_sii_iq_dequeue;

/* Signals needed for Read response from L2 to SIU */ 

wire l2b7_sio_ctag_vld = `SIO.l2b7_sio_ctag_vld;
wire l2b6_sio_ctag_vld = `SIO.l2b6_sio_ctag_vld;
wire l2b5_sio_ctag_vld = `SIO.l2b5_sio_ctag_vld;
wire l2b4_sio_ctag_vld = `SIO.l2b4_sio_ctag_vld;
wire l2b3_sio_ctag_vld = `SIO.l2b3_sio_ctag_vld;
wire l2b2_sio_ctag_vld = `SIO.l2b2_sio_ctag_vld;
wire l2b1_sio_ctag_vld = `SIO.l2b1_sio_ctag_vld;
wire l2b0_sio_ctag_vld = `SIO.l2b0_sio_ctag_vld;

wire [31:0] l2b7_sio_data = `SIO.l2b7_sio_data;
wire [31:0] l2b6_sio_data = `SIO.l2b6_sio_data;
wire [31:0] l2b5_sio_data = `SIO.l2b5_sio_data;
wire [31:0] l2b4_sio_data = `SIO.l2b4_sio_data;
wire [31:0] l2b3_sio_data = `SIO.l2b3_sio_data;
wire [31:0] l2b2_sio_data = `SIO.l2b2_sio_data;
wire [31:0] l2b1_sio_data = `SIO.l2b1_sio_data;
wire [31:0] l2b0_sio_data = `SIO.l2b0_sio_data;

wire [1:0] l2b7_sio_parity = `SIO.l2b7_sio_parity;
wire [1:0] l2b6_sio_parity = `SIO.l2b6_sio_parity;
wire [1:0] l2b5_sio_parity = `SIO.l2b5_sio_parity;
wire [1:0] l2b4_sio_parity = `SIO.l2b4_sio_parity;
wire [1:0] l2b3_sio_parity = `SIO.l2b3_sio_parity;
wire [1:0] l2b2_sio_parity = `SIO.l2b2_sio_parity;
wire [1:0] l2b1_sio_parity = `SIO.l2b1_sio_parity;
wire [1:0] l2b0_sio_parity = `SIO.l2b0_sio_parity;

wire l2b7_sio_ue_err = `SIO.l2b7_sio_ue_err;
wire l2b6_sio_ue_err = `SIO.l2b6_sio_ue_err;
wire l2b5_sio_ue_err = `SIO.l2b5_sio_ue_err;
wire l2b4_sio_ue_err = `SIO.l2b4_sio_ue_err;
wire l2b3_sio_ue_err = `SIO.l2b3_sio_ue_err;
wire l2b2_sio_ue_err = `SIO.l2b2_sio_ue_err;
wire l2b1_sio_ue_err = `SIO.l2b1_sio_ue_err;
wire l2b0_sio_ue_err = `SIO.l2b0_sio_ue_err;


always @(posedge (iol2clk && enabled))
begin
    if(l2b7_sio_ue_err)
        `PR_ALWAYS("l2_to_siu_mon", `ALWAYS, "Uncorrectable error in L2_SIO_UE_ERR Bank = 7 l2b7_sio_ctag_vld = %b", l2b7_sio_ue_err);
end

always @(posedge (iol2clk && enabled))
begin
    if(l2b6_sio_ue_err)
        `PR_ALWAYS("l2_to_siu_mon", `ALWAYS, "Uncorrectable error in L2_SIO_UE_ERR Bank = 6 l2b6_sio_ctag_vld = %b", l2b6_sio_ue_err);
end

always @(posedge (iol2clk && enabled))
begin
    if(l2b5_sio_ue_err)
        `PR_ALWAYS("l2_to_siu_mon", `ALWAYS, "Uncorrectable error in L2_SIO_UE_ERR Bank = 5 l2b5_sio_ctag_vld = %b", l2b5_sio_ue_err);
end

always @(posedge (iol2clk && enabled))
begin
    if(l2b4_sio_ue_err)
        `PR_ALWAYS("l2_to_siu_mon", `ALWAYS, "Uncorrectable error in L2_SIO_UE_ERR Bank = 4 l2b4_sio_ctag_vld = %b", l2b4_sio_ue_err);
end

always @(posedge (iol2clk && enabled))
begin
    if(l2b3_sio_ue_err)
        `PR_ALWAYS("l2_to_siu_mon", `ALWAYS, "Uncorrectable error in L2_SIO_UE_ERR Bank = 3 l2b3_sio_ctag_vld = %b", l2b3_sio_ue_err);
end

always @(posedge (iol2clk && enabled))
begin
    if(l2b2_sio_ue_err)
        `PR_ALWAYS("l2_to_siu_mon", `ALWAYS, "Uncorrectable error in L2_SIO_UE_ERR Bank = 2 l2b2_sio_ctag_vld = %b", l2b2_sio_ue_err);
end

always @(posedge (iol2clk && enabled))
begin
    if(l2b1_sio_ue_err)
        `PR_ALWAYS("l2_to_siu_mon", `ALWAYS, "Uncorrectable error in L2_SIO_UE_ERR Bank = 1 l2b1_sio_ctag_vld = %b", l2b1_sio_ue_err);
end

always @(posedge (iol2clk && enabled))
begin
    if(l2b0_sio_ue_err)
        `PR_ALWAYS("l2_to_siu_mon", `ALWAYS, "Uncorrectable error in L2_SIO_UE_ERR Bank = 0 l2b0_sio_ctag_vld = %b", l2b0_sio_ue_err);
end



endmodule
