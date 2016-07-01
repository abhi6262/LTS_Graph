/*

Monitor written by : Debjit Pal
Email ID: dpal2@illinois.edu
Institute: Univerisity of Illinois at Urbana-Champaign

Modified by: Abhishek Sharma
Email ID: sharma53@illinois.edu
*/


/* Define the modules */

`define L2T0 `CPU.l2t0
`define L2T1 `CPU.l2t1
`define L2T2 `CPU.l2t2
`define L2T3 `CPU.l2t3
`define L2T4 `CPU.l2t4
`define L2T5 `CPU.l2t5
`define L2T6 `CPU.l2t6
`define L2T7 `CPU.l2t7

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
wire sii_l2t7_req_vld = `L2T7.sii_l2t_req_vld;
wire sii_l2t6_req_vld = `L2T6.sii_l2t_req_vld;
wire sii_l2t5_req_vld = `L2T5.sii_l2t_req_vld;
wire sii_l2t4_req_vld = `L2T4.sii_l2t_req_vld;
wire sii_l2t3_req_vld = `L2T3.sii_l2t_req_vld;
wire sii_l2t2_req_vld = `L2T2.sii_l2t_req_vld;
wire sii_l2t1_req_vld = `L2T1.sii_l2t_req_vld;
wire sii_l2t0_req_vld = `L2T0.sii_l2t_req_vld;

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


/* Section 6.5.1.1 Manual Vol 1 */

/* Detecting Uncorrectable Error in the Data Word from L2 */
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



/* Accumulating the Read Request Packet */
always @(posedge (iol2clk && enabled))
begin
    if(sii_l2t0_req_vld)
    begin
        `PR_ALWAYS("l2_to_siu_mon", `ALWAYS, "SIU TO L2T0 Read Request Initiated sii_l2t0_req_vld = %b", sii_l2t0_req_vld);
        repeat (4) @(posedge iol2clk)
        begin
            `PR_INFO("l2_to_siu_mon", `INFO, "SIU TO L2T0 Read Request Packet with Dummy Cycles = %x", sii_l2t0_req);
        end
        //if(##[2:$] l2t0_sii_iq_dequeue)
        //    `PR_INFO("l2_to_siu_mon", `INFO, "L2T0 Dispatching Read");
    end
end

always @(posedge (iol2clk && enabled))
begin
    if(sii_l2t1_req_vld)
    begin
        `PR_ALWAYS("l2_to_siu_mon", `ALWAYS, "SIU TO L2T1 Read Request Initiated sii_l2t1_req_vld = %b", sii_l2t1_req_vld);
        repeat (4) @(posedge iol2clk)
        begin
            `PR_INFO("l2_to_siu_mon", `INFO, "SIU TO L2T1 Read Request Packet with Dummy Cycles = %x", sii_l2t1_req);
        end
        //if(##[2:$] l2t1_sii_iq_dequeue)
        //    `PR_INFO("l2_to_siu_mon", `INFO, "L2T1 Dispatching Read");
    end
end

always @(posedge (iol2clk && enabled))
begin
    if(sii_l2t2_req_vld)
    begin
        `PR_ALWAYS("l2_to_siu_mon", `ALWAYS, "SIU TO L2T2 Read Request Initiated sii_l2t2_req_vld = %b", sii_l2t2_req_vld);
        repeat (4) @(posedge iol2clk)
        begin
            `PR_INFO("l2_to_siu_mon", `INFO, "SIU TO L2T2 Read Request Packet with Dummy Cycles = %x", sii_l2t2_req);
        end
        //if(##[2:$] l2t2_sii_iq_dequeue)
        //    `PR_INFO("l2_to_siu_mon", `INFO, "L2T2 Dispatching Read");
    end
end

always @(posedge (iol2clk && enabled))
begin
    if(sii_l2t3_req_vld)
    begin
        `PR_ALWAYS("l2_to_siu_mon", `ALWAYS, "SIU TO L2T3 Read Request Initiated sii_l2t3_req_vld = %b", sii_l2t3_req_vld);
        repeat (4) @(posedge iol2clk)
        begin
            `PR_INFO("l2_to_siu_mon", `INFO, "SIU TO L2T3 Read Request Packet with Dummy Cycles = %x", sii_l2t3_req);
        end
        //if(##[2:$] l2t3_sii_iq_dequeue)
        //    `PR_INFO("l2_to_siu_mon", `INFO, "L2T3 Dispatching Read");
    end
end

always @(posedge (iol2clk && enabled))
begin
    if(sii_l2t4_req_vld)
    begin
        `PR_ALWAYS("l2_to_siu_mon", `ALWAYS, "SIU TO L2T4 Read Request Initiated sii_l2t4_req_vld = %b", sii_l2t4_req_vld);
        repeat (4) @(posedge iol2clk)
        begin
            `PR_INFO("l2_to_siu_mon", `INFO, "SIU TO L2T4 Read Request Packet with Dummy Cycles = %x", sii_l2t4_req);
        end
        //if(##[2:$] l2t4_sii_iq_dequeue)
        //    `PR_INFO("l2_to_siu_mon", `INFO, "L2T4 Dispatching Read");
    end
end

always @(posedge (iol2clk && enabled))
begin
    if(sii_l2t5_req_vld)
    begin
        `PR_ALWAYS("l2_to_siu_mon", `ALWAYS, "SIU TO L2T5 Read Request Initiated sii_l2t5_req_vld = %b", sii_l2t5_req_vld);
        repeat (4) @(posedge iol2clk)
        begin
            `PR_INFO("l2_to_siu_mon", `INFO, "SIU TO L2T5 Read Request Packet with Dummy Cycles = %x", sii_l2t5_req);
        end
        //if(##[2:$] l2t5_sii_iq_dequeue)
        //    `PR_INFO("l2_to_siu_mon", `INFO, "L2T5 Dispatching Read");
    end
end

always @(posedge (iol2clk && enabled))
begin
    if(sii_l2t6_req_vld)
    begin
        `PR_ALWAYS("l2_to_siu_mon", `ALWAYS, "SIU TO L2T6 Read Request Initiated sii_l2t6_req_vld = %b", sii_l2t6_req_vld);
        repeat (4) @(posedge iol2clk)
        begin
            `PR_INFO("l2_to_siu_mon", `INFO, "SIU TO L2T6 Read Request Packet with Dummy Cycles = %x", sii_l2t6_req);
        end
        //if(##[2:$] l2t6_sii_iq_dequeue)
        //    `PR_INFO("l2_to_siu_mon", `INFO, "L2T6 Dispatching Read");
    end
end

always @(posedge (iol2clk && enabled))
begin
    if(sii_l2t7_req_vld)
    begin
        `PR_ALWAYS("l2_to_siu_mon", `ALWAYS, "SIU TO L2T7 Read Request Initiated sii_l2t7_req_vld = %b", sii_l2t7_req_vld);
        repeat (4) @(posedge iol2clk)
        begin
            `PR_INFO("l2_to_siu_mon", `INFO, "SIU TO L2T7 Read Request Packet with Dummy Cycles = %x", sii_l2t7_req);
        end
        //if(##[2:$] l2t7_sii_iq_dequeue)
        //    `PR_INFO("l2_to_siu_mon", `INFO, "L2T7 Dispatching Read");
    end
end



/* Read Response From L2 to SIU */
always @(posedge(iol2clk && enabled))
begin
    if(l2b0_sio_ctag_vld)
    begin
        `PR_ALWAYS("l2_to_siu_mon", `ALWAYS, "Read Reasponse from L2B0 Started l2b0_sio_ctag_vld = %b", l2b0_sio_ctag_vld);
        repeat (17) @(posedge iol2clk)
        begin
            `PR_INFO("l2_to_siu_mon", `INFO, "L2B0 TO SIU Read Response Header and Read Data = %x", l2b0_sio_data);
            `PR_INFO("l2_to_siu_mon", `INFO, "L2B0 TO SIU Read Data Parity = %x", l2b0_sio_parity);
        end
    end
end

always @(posedge(iol2clk && enabled))
begin
    if(l2b1_sio_ctag_vld)
    begin
        `PR_ALWAYS("l2_to_siu_mon", `ALWAYS, "Read Reasponse from L2B1 Started l2b1_sio_ctag_vld = %b", l2b1_sio_ctag_vld);
        repeat (17) @(posedge iol2clk)
        begin
            `PR_INFO("l2_to_siu_mon", `INFO, "L2B1 TO SIU Read Response Header and Read Data = %x", l2b1_sio_data);
            `PR_INFO("l2_to_siu_mon", `INFO, "L2B1 TO SIU Read Data Parity = %x", l2b1_sio_parity);
        end
    end
end

always @(posedge(iol2clk && enabled))
begin
    if(l2b2_sio_ctag_vld)
    begin
        `PR_ALWAYS("l2_to_siu_mon", `ALWAYS, "Read Reasponse from L2B2 Started l2b2_sio_ctag_vld = %b", l2b2_sio_ctag_vld);
        repeat (17) @(posedge iol2clk)
        begin
            `PR_INFO("l2_to_siu_mon", `INFO, "L2B2 TO SIU Read Response Header and Read Data = %x", l2b2_sio_data);
            `PR_INFO("l2_to_siu_mon", `INFO, "L2B2 TO SIU Read Data Parity = %x", l2b2_sio_parity);
        end
    end
end

always @(posedge(iol2clk && enabled))
begin
    if(l2b3_sio_ctag_vld)
    begin
        `PR_ALWAYS("l2_to_siu_mon", `ALWAYS, "Read Reasponse from L2B3 Started l2b3_sio_ctag_vld = %b", l2b3_sio_ctag_vld);
        repeat (17) @(posedge iol2clk)
        begin
            `PR_INFO("l2_to_siu_mon", `INFO, "L2B3 TO SIU Read Response Header and Read Data = %x", l2b3_sio_data);
            `PR_INFO("l2_to_siu_mon", `INFO, "L2B3 TO SIU Read Data Parity = %x", l2b3_sio_parity);
        end
    end
end

always @(posedge(iol2clk && enabled))
begin
    if(l2b4_sio_ctag_vld)
    begin
        `PR_ALWAYS("l2_to_siu_mon", `ALWAYS, "Read Reasponse from L2B4 Started l2b4_sio_ctag_vld = %b", l2b4_sio_ctag_vld);
        repeat (17) @(posedge iol2clk)
        begin
            `PR_INFO("l2_to_siu_mon", `INFO, "L2B4 TO SIU Read Response Header and Read Data = %x", l2b4_sio_data);
            `PR_INFO("l2_to_siu_mon", `INFO, "L2B4 TO SIU Read Data Parity = %x", l2b4_sio_parity);
        end
    end
end

always @(posedge(iol2clk && enabled))
begin
    if(l2b5_sio_ctag_vld)
    begin
        `PR_ALWAYS("l2_to_siu_mon", `ALWAYS, "Read Reasponse from L2B5 Started l2b5_sio_ctag_vld = %b", l2b5_sio_ctag_vld);
        repeat (17) @(posedge iol2clk)
        begin
            `PR_INFO("l2_to_siu_mon", `INFO, "L2B5 TO SIU Read Response Header and Read Data = %x", l2b5_sio_data);
            `PR_INFO("l2_to_siu_mon", `INFO, "L2B5 TO SIU Read Data Parity = %x", l2b5_sio_parity);
        end
    end
end

always @(posedge(iol2clk && enabled))
begin
    if(l2b6_sio_ctag_vld)
    begin
        `PR_ALWAYS("l2_to_siu_mon", `ALWAYS, "Read Reasponse from L2B6 Started l2b6_sio_ctag_vld = %b", l2b6_sio_ctag_vld);
        repeat (17) @(posedge iol2clk)
        begin
            `PR_INFO("l2_to_siu_mon", `INFO, "L2B6 TO SIU Read Response Header and Read Data = %x", l2b6_sio_data);
            `PR_INFO("l2_to_siu_mon", `INFO, "L2B6 TO SIU Read Data Parity = %x", l2b6_sio_parity);
        end
    end
end

always @(posedge(iol2clk && enabled))
begin
    if(l2b7_sio_ctag_vld)
    begin
        `PR_ALWAYS("l2_to_siu_mon", `ALWAYS, "Read Reasponse from L2B7 Started l2b7_sio_ctag_vld = %b", l2b7_sio_ctag_vld);
        repeat (17) @(posedge iol2clk)
        begin
            `PR_INFO("l2_to_siu_mon", `INFO, "L2B7 TO SIU Read Response Header and Read Data = %x", l2b7_sio_data);
            `PR_INFO("l2_to_siu_mon", `INFO, "L2B7 TO SIU Read Data Parity = %x", l2b7_sio_parity);
        end
    end
end


endmodule
