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
    else
        `PR_INFO("siu_to_l2_mon", `INFO, "siu_to_l2_mon ENABLED");
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

/* wib_dequeue is only used for SIU to L2 WRI (Write Invalidate). Its not used in Read Response and WR8 Section 6.5.1.1 Manual Vol 1  */
wire l2t0_sii_wib_dequeue = `SII.l2t0_sii_wib_dequeue;
wire l2t1_sii_wib_dequeue = `SII.l2t1_sii_wib_dequeue;
wire l2t2_sii_wib_dequeue = `SII.l2t2_sii_wib_dequeue;
wire l2t3_sii_wib_dequeue = `SII.l2t3_sii_wib_dequeue;
wire l2t4_sii_wib_dequeue = `SII.l2t4_sii_wib_dequeue;
wire l2t5_sii_wib_dequeue = `SII.l2t5_sii_wib_dequeue;
wire l2t6_sii_wib_dequeue = `SII.l2t6_sii_wib_dequeue;
wire l2t7_sii_wib_dequeue = `SII.l2t7_sii_wib_dequeue;

/* For L2 Tag 0 */

always @(posedge (iol2clk && enabled))
begin
    if(sii_l2t0_req_vld)
        `PR_ALWAYS("siu_to_l2_mon", `ALWAYS, "<sii,l2t0,headercycle,reqvld>::SII_L2T_REQ_VLD Tag = 0");
        /* To get the Header cycle */
        repeat(2) @(posedge iol2clk)
        begin
            `PR_INFO("siu_to_l2_mon", `INFO, "SII to L2T = 0 Header Cycle Header = %x", sii_l2t0_req);
        end
        /* To bypass the dummy cycle */
        repeat(3) @(posedge iol2clk);
end

always @(posedge (iol2clk && enabled && l2t0_sii_iq_dequeue))
begin
    if(l2t0_sii_iq_dequeue)
        `PR_ALWAYS("siu_to_l2_mon", `ALWAYS, "<l2t0,sii,deque,readreq>::Read Requests from SIU Dequeued from L2Tag = 0 Input Queue");
end

always @(posedge (iol2clk && enabled && l2t0_sii_wib_dequeue))
begin
    if(l2t0_sii_wib_dequeue)
        `PR_ALWAYS("siu_to_l2_mon", `ALWAYS, "<l2t0,sii,datatomcu,64writedata>::L2Tag = 0 Drained 64 bytes write data. Data enroute to MCU");
end

/* For L2 Tag 1 */

always @(posedge (iol2clk && enabled))
begin
    if(sii_l2t1_req_vld)
        `PR_ALWAYS("siu_to_l2_mon", `ALWAYS, "<sii,l2t1,headercycle,reqvld>::SII_L2T_REQ_VLD Tag = 1");
        /* To get the Header cycle */
        repeat(2) @(posedge iol2clk)
        begin
            `PR_INFO("siu_to_l2_mon", `INFO, "SII to L2T = 1 Header Cycle Header = %x", sii_l2t1_req);
        end
        /* To bypass the dummy cycle */
        repeat(3) @(posedge iol2clk);
end

always @(posedge (iol2clk && enabled && l2t1_sii_iq_dequeue))
begin
    if(l2t1_sii_iq_dequeue)
        `PR_ALWAYS("siu_to_l2_mon", `ALWAYS, "<l2t1,sii,deque,readreq>::Read Requests from SIU Dequeued from L2Tag = 1 Input Queue");
end

always @(posedge (iol2clk && enabled && l2t1_sii_wib_dequeue))
begin
    if(l2t1_sii_wib_dequeue)
        `PR_ALWAYS("siu_to_l2_mon", `ALWAYS, "<l2t1,sii,datatomcu,64writedata>::L2Tag = 1 Drained 64 bytes write data. Data enroute to MCU");
end


/* For L2 Tag 2 */

always @(posedge (iol2clk && enabled))
begin
    if(sii_l2t2_req_vld)
        `PR_ALWAYS("siu_to_l2_mon", `ALWAYS, "<sii,l2t2,headercycle,reqvld>::SII_L2T_REQ_VLD Tag = 2");
        /* To get the Header cycle */
        repeat(2) @(posedge iol2clk)
        begin
            `PR_INFO("siu_to_l2_mon", `INFO, "SII to L2T = 2 Header Cycle Header = %x", sii_l2t2_req);
        end
        /* To bypass the dummy cycle */
        repeat(3) @(posedge iol2clk);
end

always @(posedge (iol2clk && enabled && l2t2_sii_iq_dequeue))
begin
    if(l2t2_sii_iq_dequeue)
        `PR_ALWAYS("siu_to_l2_mon", `ALWAYS, "<l2t2,sii,deque,readreq>::Read Requests from SIU Dequeued from L2Tag = 2 Input Queue");
end

always @(posedge (iol2clk && enabled && l2t2_sii_wib_dequeue))
begin
    if(l2t2_sii_wib_dequeue)
        `PR_ALWAYS("siu_to_l2_mon", `ALWAYS, "<l2t2,sii,datatomcu,64writedata>::L2Tag = 2 Drained 64 bytes write data. Data enroute to MCU");
end


/* For L2 Tag 3 */

always @(posedge (iol2clk && enabled))
begin
    if(sii_l2t3_req_vld)
        `PR_ALWAYS("siu_to_l2_mon", `ALWAYS, "<sii,l2t3,headercycle,reqvld>::SII_L2T_REQ_VLD Tag = 3");
        /* To get the Header cycle */
        repeat(2) @(posedge iol2clk)
        begin
            `PR_INFO("siu_to_l2_mon", `INFO, "SII to L2T = 3 Header Cycle Header = %x", sii_l2t3_req);
        end
        /* To bypass the dummy cycle */
        repeat(3) @(posedge iol2clk);
end

always @(posedge (iol2clk && enabled && l2t3_sii_iq_dequeue))
begin
    if(l2t3_sii_iq_dequeue)
        `PR_ALWAYS("siu_to_l2_mon", `ALWAYS, "<l2t3,sii,deque,readreq>::Read Requests from SIU Dequeued from L2Tag = 3 Input Queue");
end

always @(posedge (iol2clk && enabled && l2t3_sii_wib_dequeue))
begin
    if(l2t3_sii_wib_dequeue)
        `PR_ALWAYS("siu_to_l2_mon", `ALWAYS, "<l2t3,sii,datatomcu,64writedata>::L2Tag = 3 Drained 64 bytes write data. Data enroute to MCU");
end


/* For L2 Tag 4 */

always @(posedge (iol2clk && enabled))
begin
    if(sii_l2t4_req_vld)
        `PR_ALWAYS("siu_to_l2_mon", `ALWAYS, "<sii,l2t4,headercycle,reqvld>::SII_L2T_REQ_VLD Tag = 4");
        /* To get the Header cycle */
        repeat(2) @(posedge iol2clk)
        begin
            `PR_INFO("siu_to_l2_mon", `INFO, "SII to L2T = 4 Header Cycle Header = %x", sii_l2t4_req);
        end
        /* To bypass the dummy cycle */
        repeat(3) @(posedge iol2clk);
end

always @(posedge (iol2clk && enabled && l2t4_sii_iq_dequeue))
begin
    if(l2t4_sii_iq_dequeue)
        `PR_ALWAYS("siu_to_l2_mon", `ALWAYS, "<l2t4,sii,deque,readreq>::Read Requests from SIU Dequeued from L2Tag = 4 Input Queue");
end

always @(posedge (iol2clk && enabled && l2t4_sii_wib_dequeue))
begin
    if(l2t4_sii_wib_dequeue)
        `PR_ALWAYS("siu_to_l2_mon", `ALWAYS, "<l2t4,sii,datatomcu,64writedata>::L2Tag = 4 Drained 64 bytes write data. Data enroute to MCU");
end


/* For L2 Tag 5 */

always @(posedge (iol2clk && enabled))
begin
    if(sii_l2t5_req_vld)
        `PR_ALWAYS("siu_to_l2_mon", `ALWAYS, "<sii,l2t5,headercycle,reqvld>::SII_L2T_REQ_VLD Tag = 5");
        /* To get the Header cycle */
        repeat(2) @(posedge iol2clk)
        begin
            `PR_INFO("siu_to_l2_mon", `INFO, "SII to L2T = 5 Header Cycle Header = %x", sii_l2t5_req);
        end
        /* To bypass the dummy cycle */
        repeat(3) @(posedge iol2clk);
end

always @(posedge (iol2clk && enabled && l2t5_sii_iq_dequeue))
begin
    if(l2t5_sii_iq_dequeue)
        `PR_ALWAYS("siu_to_l2_mon", `ALWAYS, "<l2t5,sii,deque,readreq>::Read Requests from SIU Dequeued from L2Tag = 5 Input Queue");
end

always @(posedge (iol2clk && enabled && l2t5_sii_wib_dequeue))
begin
    if(l2t5_sii_wib_dequeue)
        `PR_ALWAYS("siu_to_l2_mon", `ALWAYS, "<l2t5,sii,datatomcu,64writedata>::L2Tag = 5 Drained 64 bytes write data. Data enroute to MCU");
end


/* For L2 Tag 6 */

always @(posedge (iol2clk && enabled))
begin
    if(sii_l2t6_req_vld)
        `PR_ALWAYS("siu_to_l2_mon", `ALWAYS, "<sii,l2t6,headercycle,reqvld>::SII_L2T_REQ_VLD Tag = 6");
        /* To get the Header cycle */
        repeat(2) @(posedge iol2clk)
        begin
            `PR_INFO("siu_to_l2_mon", `INFO, "SII to L2T = 6 Header Cycle Header = %x", sii_l2t6_req);
        end
        /* To bypass the dummy cycle */
        repeat(3) @(posedge iol2clk);
end

always @(posedge (iol2clk && enabled && l2t6_sii_iq_dequeue))
begin
    if(l2t6_sii_iq_dequeue)
        `PR_ALWAYS("siu_to_l2_mon", `ALWAYS, "<l2t6,sii,deque,readreq>::Read Requests from SIU Dequeued from L2Tag = 6 Input Queue");
end

always @(posedge (iol2clk && enabled && l2t6_sii_wib_dequeue))
begin
    if(l2t6_sii_wib_dequeue)
        `PR_ALWAYS("siu_to_l2_mon", `ALWAYS, "<l2t6,sii,datatomcu,64writedata>::L2Tag = 6 Drained 64 bytes write data. Data enroute to MCU");
end


/* For L2 Tag 7 */

always @(posedge (iol2clk && enabled))
begin
    if(sii_l2t7_req_vld)
        `PR_ALWAYS("siu_to_l2_mon", `ALWAYS, "<sii,l2t7,headercycle,reqvld>::SII_L2T_REQ_VLD Tag = 7");
        /* To get the Header cycle */
        repeat(2) @(posedge iol2clk)
        begin
            `PR_INFO("siu_to_l2_mon", `INFO, "SII to L2T = 7 Header Cycle Header = %x", sii_l2t7_req);
        end
        /* To bypass the dummy cycle */
        repeat(3) @(posedge iol2clk);
end

always @(posedge (iol2clk && enabled && l2t7_sii_iq_dequeue))
begin
    if(l2t7_sii_iq_dequeue)
        `PR_ALWAYS("siu_to_l2_mon", `ALWAYS, "<l2t7,sii,deque,readreq>::Read Requests from SIU Dequeued from L2Tag = 7 Input Queue");
end

always @(posedge (iol2clk && enabled && l2t7_sii_wib_dequeue))
begin
    if(l2t7_sii_wib_dequeue)
        `PR_ALWAYS("siu_to_l2_mon", `ALWAYS, "<l2t7,sii,datatomcu,64writedata>::L2Tag = 7 Drained 64 bytes write data. Data enroute to MCU");
end


endmodule
