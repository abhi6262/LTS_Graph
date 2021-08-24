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
    begin
        `PR_ALWAYS("siu_to_l2_mon", `ALWAYS, "<sii,l2t0,,siil2treqvld,{%x}>::First cycle of Packet transfer from SIU to L2", sii_l2t0_req_vld);
        /* To get the Header cycle */
        `PR_ALWAYS("siu_to_l2_mon", `ALWAYS, "<sii,l2t0,,siil2topes,{%x}>::Header Cycle from SII to L2", sii_l2t0_req[30:27]);
        `PR_ALWAYS("siu_to_l2_mon", `ALWAYS, "<sii,l2t0,,siil2tconfig,{%x}>::Header Cycle from SII to L2", sii_l2t0_req[26:24]);
        `PR_ALWAYS("siu_to_l2_mon", `ALWAYS, "<sii,l2t0,,siil2tag,{%x}>::Header Cycle from SII to L2", sii_l2t0_req[21:8]);
        `PR_ALWAYS("siu_to_l2_mon", `ALWAYS, "<sii,l2t0,,siil2taddr3932,{%x}>::Header Cycle from SII to L2", sii_l2t0_req[7:0]);
        repeat(1) @(posedge iol2clk)
        begin
            `PR_ALWAYS("siu_to_l2_mon", `ALWAYS, "<sii,l2t0,,siil2taddr310,{%x}>::Header Cycle from SII to L2", sii_l2t0_req);
        end
        /* To bypass the dummy cycle */
        repeat(3) @(posedge iol2clk);
    end
end

always @(posedge (iol2clk && enabled && l2t0_sii_iq_dequeue))
begin
    if(l2t0_sii_iq_dequeue)
    begin
        `PR_ALWAYS("siu_to_l2_mon", `ALWAYS, "<l2t0,sii,,l2tsiidequeue,{%x}>::Read Requests from SIU Dequeued from L2T Input Queue", l2t0_sii_iq_dequeue);
    end
end

always @(posedge (iol2clk && enabled && l2t0_sii_wib_dequeue))
begin
    if(l2t0_sii_wib_dequeue)
    begin
        `PR_ALWAYS("siu_to_l2_mon", `ALWAYS, "<l2t0,sii,,l2tsiiwibdeq,{%x}>::L2 moved out 64 byte data from I/O write buffer and data towards MCU", l2t0_sii_wib_dequeue);
    end
end

/* For L2 Tag 1 */

always @(posedge (iol2clk && enabled))
begin
    if(sii_l2t1_req_vld)
    begin
        `PR_ALWAYS("siu_to_l2_mon", `ALWAYS, "<sii,l2t1,,siil2treqvld,{%x}>::First cycle of Packet transfer from SIU to L2", sii_l2t1_req_vld);
        /* To get the Header cycle */
        `PR_ALWAYS("siu_to_l2_mon", `ALWAYS, "<sii,l2t1,,siil2topes,{%x}>::Header Cycle from SII to L2", sii_l2t1_req[30:27]);
        `PR_ALWAYS("siu_to_l2_mon", `ALWAYS, "<sii,l2t1,,siil2tconfig,{%x}>::Header Cycle from SII to L2", sii_l2t1_req[26:24]);
        `PR_ALWAYS("siu_to_l2_mon", `ALWAYS, "<sii,l2t1,,siil2tag,{%x}>::Header Cycle from SII to L2", sii_l2t1_req[21:8]);
        `PR_ALWAYS("siu_to_l2_mon", `ALWAYS, "<sii,l2t1,,siil2taddr3932,{%x}>::Header Cycle from SII to L2", sii_l2t1_req[7:0]);
        repeat(1) @(posedge iol2clk)
        begin
            `PR_ALWAYS("siu_to_l2_mon", `ALWAYS, "<sii,l2t1,,siil2taddr310,{%x}>::Header Cycle from SII to L2", sii_l2t1_req);
        end
        /* To bypass the dummy cycle */
        repeat(3) @(posedge iol2clk);
    end
end

always @(posedge (iol2clk && enabled && l2t1_sii_iq_dequeue))
begin
    if(l2t1_sii_iq_dequeue)
    begin
        `PR_ALWAYS("siu_to_l2_mon", `ALWAYS, "<l2t1,sii,,l2tsiidequeue,{%x}>::Read Requests from SIU Dequeued from L2 Input Queue", l2t1_sii_iq_dequeue);
    end
end

always @(posedge (iol2clk && enabled && l2t1_sii_wib_dequeue))
begin
    if(l2t1_sii_wib_dequeue)
    begin
        `PR_ALWAYS("siu_to_l2_mon", `ALWAYS, "<l2t1,sii,,l2tsiiwibdeq,{%x}>::L2 moved out 64 byte data from I/O write buffer and data towards MCU", l2t1_sii_wib_dequeue);
    end
end


/* For L2 Tag 2 */

always @(posedge (iol2clk && enabled))
begin
    if(sii_l2t2_req_vld)
    begin
        `PR_ALWAYS("siu_to_l2_mon", `ALWAYS, "<sii,l2t2,,siil2treqvld,{%x}>::First cycle of Packet transfer from SIU to L2", sii_l2t2_req_vld);
        /* To get the Header cycle */
        `PR_ALWAYS("siu_to_l2_mon", `ALWAYS, "<sii,l2t2,,siil2topes,{%x}>::Header Cycle from SII to L2", sii_l2t2_req[30:27]);
        `PR_ALWAYS("siu_to_l2_mon", `ALWAYS, "<sii,l2t2,,siil2tconfig,{%x}>::Header Cycle from SII to L2", sii_l2t2_req[26:24]);
        `PR_ALWAYS("siu_to_l2_mon", `ALWAYS, "<sii,l2t2,,siil2tag,{%x}>::Header Cycle from SII to L2", sii_l2t2_req[21:8]);
        `PR_ALWAYS("siu_to_l2_mon", `ALWAYS, "<sii,l2t2,,siil2taddr3932,{%x}>::Header Cycle from SII to L2", sii_l2t2_req[7:0]);
        repeat(1) @(posedge iol2clk)
        begin
            `PR_ALWAYS("siu_to_l2_mon", `ALWAYS, "<sii,l2t2,,siil2taddr310,{%x}>::Header Cycle from SII to L2", sii_l2t2_req);
        end
        /* To bypass the dummy cycle */
        repeat(3) @(posedge iol2clk);
    end
end

always @(posedge (iol2clk && enabled && l2t2_sii_iq_dequeue))
begin
    if(l2t2_sii_iq_dequeue)
    begin
        `PR_ALWAYS("siu_to_l2_mon", `ALWAYS, "<l2t2,sii,,l2tsiidequeue,{%x}>::Read Requests from SIU Dequeued from L2 Input Queue", l2t2_sii_iq_dequeue);
    end
end

always @(posedge (iol2clk && enabled && l2t2_sii_wib_dequeue))
begin
    if(l2t2_sii_wib_dequeue)
    begin
        `PR_ALWAYS("siu_to_l2_mon", `ALWAYS, "<l2t2,sii,,l2tsiiwibdeq,{%x}>::L2 moved out 64 byte data from I/O write buffer and data towards MCU", l2t2_sii_wib_dequeue);
    end
end


/* For L2 Tag 3 */

always @(posedge (iol2clk && enabled))
begin
    if(sii_l2t3_req_vld)
    begin
        `PR_ALWAYS("siu_to_l2_mon", `ALWAYS, "<sii,l2t3,,siil2treqvld,{%x}>::First cycle of Packet transfer from SIU to L2", sii_l2t3_req_vld);
        /* To get the Header cycle */
        `PR_ALWAYS("siu_to_l2_mon", `ALWAYS, "<sii,l2t3,,siil2topes,{%x}>::Header Cycle from SII to L2", sii_l2t3_req[30:27]);
        `PR_ALWAYS("siu_to_l2_mon", `ALWAYS, "<sii,l2t3,,siil2tconfig,{%x}>::Header Cycle from SII to L2", sii_l2t3_req[26:24]);
        `PR_ALWAYS("siu_to_l2_mon", `ALWAYS, "<sii,l2t3,,siil2tag,{%x}>::Header Cycle from SII to L2", sii_l2t3_req[21:8]);
        `PR_ALWAYS("siu_to_l2_mon", `ALWAYS, "<sii,l2t3,,siil2taddr3932,{%x}>::Header Cycle from SII to L2", sii_l2t3_req[7:0]);
        repeat(1) @(posedge iol2clk)
        begin
            `PR_ALWAYS("siu_to_l2_mon", `ALWAYS, "<sii,l2t3,,siil2taddr310,{%x}>::Header Cycle from SII to L2", sii_l2t3_req);
        end
        /* To bypass the dummy cycle */
        repeat(3) @(posedge iol2clk);
    end
end

always @(posedge (iol2clk && enabled && l2t3_sii_iq_dequeue))
begin
    if(l2t3_sii_iq_dequeue)
    begin
        `PR_ALWAYS("siu_to_l2_mon", `ALWAYS, "<l2t3,sii,,l2tsiidequeue,{%x}>::Read Requests from SIU Dequeued from L2 Input Queue", l2t3_sii_iq_dequeue);
    end
end

always @(posedge (iol2clk && enabled && l2t3_sii_wib_dequeue))
begin
    if(l2t3_sii_wib_dequeue)
    begin
        `PR_ALWAYS("siu_to_l2_mon", `ALWAYS, "<l2t3,sii,,l2tsiiwibdeq,{%x}>::L2 moved out 64 byte data from I/O write buffer and data towards MCU", l2t3_sii_wib_dequeue);
    end
end


/* For L2 Tag 4 */

always @(posedge (iol2clk && enabled))
begin
    if(sii_l2t4_req_vld)
    begin
        `PR_ALWAYS("siu_to_l2_mon", `ALWAYS, "<sii,l2t4,,siil2treqvld,{%x}>::First cycle of Packet transfer from SIU to L2", sii_l2t4_req_vld);
        /* To get the Header cycle */
        `PR_ALWAYS("siu_to_l2_mon", `ALWAYS, "<sii,l2t4,,siil2topes,{%x}>::Header Cycle from SII to L2", sii_l2t4_req[30:27]);
        `PR_ALWAYS("siu_to_l2_mon", `ALWAYS, "<sii,l2t4,,siil2tconfig,{%x}>::Header Cycle from SII to L2", sii_l2t4_req[26:24]);
        `PR_ALWAYS("siu_to_l2_mon", `ALWAYS, "<sii,l2t4,,siil2tag,{%x}>::Header Cycle from SII to L2", sii_l2t4_req[21:8]);
        `PR_ALWAYS("siu_to_l2_mon", `ALWAYS, "<sii,l2t4,,siil2taddr3932,{%x}>::Header Cycle from SII to L2", sii_l2t4_req[7:0]);
        repeat(1) @(posedge iol2clk)
        begin
            `PR_ALWAYS("siu_to_l2_mon", `ALWAYS, "<sii,l2t4,,siil2taddr310,{%x}>::Header Cycle from SII to L2", sii_l2t4_req);
        end
        /* To bypass the dummy cycle */
        repeat(3) @(posedge iol2clk);
    end
end

always @(posedge (iol2clk && enabled && l2t4_sii_iq_dequeue))
begin
    if(l2t4_sii_iq_dequeue)
    begin
        `PR_ALWAYS("siu_to_l2_mon", `ALWAYS, "<l2t4,sii,,l2tsiidequeue,{%x}>::Read Requests from SIU Dequeued from L2 Input Queue", l2t4_sii_iq_dequeue);
    end
end

always @(posedge (iol2clk && enabled && l2t4_sii_wib_dequeue))
begin
    if(l2t4_sii_wib_dequeue)
    begin
        `PR_ALWAYS("siu_to_l2_mon", `ALWAYS, "<l2t4,sii,,l2tsiiwibdeq,{%x}>::L2 moved out 64 byte data from I/O write buffer and data towards MCU", l2t4_sii_wib_dequeue);
    end
end


/* For L2 Tag 5 */

always @(posedge (iol2clk && enabled))
begin
    if(sii_l2t5_req_vld)
    begin
        `PR_ALWAYS("siu_to_l2_mon", `ALWAYS, "<sii,l2t5,,siil2treqvld,{%x}>::First cycle of Packet transfer from SIU to L2", sii_l2t5_req_vld);
        /* To get the Header cycle */
        `PR_ALWAYS("siu_to_l2_mon", `ALWAYS, "<sii,l2t5,,siil2topes,{%x}>::Header Cycle from SII to L2", sii_l2t5_req[30:27]);
        `PR_ALWAYS("siu_to_l2_mon", `ALWAYS, "<sii,l2t5,,siil2tconfig,{%x}>::Header Cycle from SII to L2", sii_l2t5_req[26:24]);
        `PR_ALWAYS("siu_to_l2_mon", `ALWAYS, "<sii,l2t5,,siil2tag,{%x}>::Header Cycle from SII to L2", sii_l2t5_req[21:8]);
        `PR_ALWAYS("siu_to_l2_mon", `ALWAYS, "<sii,l2t5,,siil2taddr3932,{%x}>::Header Cycle from SII to L2", sii_l2t5_req[7:0]);
        repeat(1) @(posedge iol2clk)
        begin
            `PR_ALWAYS("siu_to_l2_mon", `ALWAYS, "<sii,l2t5,,siil2taddr310,{%x}>::Header Cycle from SII to L2", sii_l2t5_req);
        end
        /* To bypass the dummy cycle */
        repeat(3) @(posedge iol2clk);
    end
end

always @(posedge (iol2clk && enabled && l2t5_sii_iq_dequeue))
begin
    if(l2t5_sii_iq_dequeue)
    begin
        `PR_ALWAYS("siu_to_l2_mon", `ALWAYS, "<l2t5,sii,,l2tsiidequeue,{%x}>::Read Requests from SIU Dequeued from L2 Input Queue", l2t5_sii_iq_dequeue);
    end
end

always @(posedge (iol2clk && enabled && l2t5_sii_wib_dequeue))
begin
    if(l2t5_sii_wib_dequeue)
    begin
        `PR_ALWAYS("siu_to_l2_mon", `ALWAYS, "<l2t5,sii,,l2tsiiwibdeq,{%x}>::L2 moved out 64 byte data from I/O write buffer and data towards MCU", l2t5_sii_wib_dequeue);
    end
end


/* For L2 Tag 6 */

always @(posedge (iol2clk && enabled))
begin
    if(sii_l2t6_req_vld)
    begin
        `PR_ALWAYS("siu_to_l2_mon", `ALWAYS, "<sii,l2t6,,siil2treqvld,{%x}>::First cycle of Packet transfer from SIU to L2", sii_l2t6_req_vld);
        /* To get the Header cycle */
        `PR_ALWAYS("siu_to_l2_mon", `ALWAYS, "<sii,l2t6,,siil2topes,{%x}>::Header Cycle from SII to L2", sii_l2t6_req[30:27]);
        `PR_ALWAYS("siu_to_l2_mon", `ALWAYS, "<sii,l2t6,,siil2tconfig,{%x}>::Header Cycle from SII to L2", sii_l2t6_req[26:24]);
        `PR_ALWAYS("siu_to_l2_mon", `ALWAYS, "<sii,l2t6,,siil2tag,{%x}>::Header Cycle from SII to L2", sii_l2t6_req[21:8]);
        `PR_ALWAYS("siu_to_l2_mon", `ALWAYS, "<sii,l2t6,,siil2taddr3932,{%x}>::Header Cycle from SII to L2", sii_l2t6_req[7:0]);
        repeat(1) @(posedge iol2clk)
        begin
            `PR_ALWAYS("siu_to_l2_mon", `ALWAYS, "<sii,l2t6,,siil2taddr310,{%x}>::Header Cycle from SII to L2", sii_l2t6_req);
        end
        /* To bypass the dummy cycle */
        repeat(3) @(posedge iol2clk);
    end
end

always @(posedge (iol2clk && enabled && l2t6_sii_iq_dequeue))
begin
    if(l2t6_sii_iq_dequeue)
    begin
        `PR_ALWAYS("siu_to_l2_mon", `ALWAYS, "<l2t6,sii,,l2tsiidequeue,{%x}>::Read Requests from SIU Dequeued from L2 Input Queue", l2t6_sii_iq_dequeue);
    end
end

always @(posedge (iol2clk && enabled && l2t6_sii_wib_dequeue))
begin
    if(l2t6_sii_wib_dequeue)
    begin
        `PR_ALWAYS("siu_to_l2_mon", `ALWAYS, "<l2t6,sii,,l2tsiiwibdeq,{%x}>::L2 moved out 64 byte data from I/O write buffer and data towards MCU", l2t6_sii_wib_dequeue);
    end
end


/* For L2 Tag 7 */

always @(posedge (iol2clk && enabled))
begin
    if(sii_l2t7_req_vld)
    begin
        `PR_ALWAYS("siu_to_l2_mon", `ALWAYS, "<sii,l2t7,,siil2treqvld,{%x}>::First cycle of Packet transfer from SIU to L2", sii_l2t7_req_vld);
        /* To get the Header cycle */
        `PR_ALWAYS("siu_to_l2_mon", `ALWAYS, "<sii,l2t7,,siil2topes,{%x}>::Header Cycle from SII to L2", sii_l2t7_req[30:27]);
        `PR_ALWAYS("siu_to_l2_mon", `ALWAYS, "<sii,l2t7,,siil2tconfig,{%x}>::Header Cycle from SII to L2", sii_l2t7_req[26:24]);
        `PR_ALWAYS("siu_to_l2_mon", `ALWAYS, "<sii,l2t7,,siil2tag,{%x}>::Header Cycle from SII to L2", sii_l2t7_req[21:8]);
        `PR_ALWAYS("siu_to_l2_mon", `ALWAYS, "<sii,l2t7,,siil2taddr3932,{%x}>::Header Cycle from SII to L2", sii_l2t7_req[7:0]);
        repeat(1) @(posedge iol2clk)
        begin
            `PR_ALWAYS("siu_to_l2_mon", `ALWAYS, "<sii,l2t7,,siil2taddr310,{%x}>::Header Cycle from SII to L2", sii_l2t7_req);
        end
        /* To bypass the dummy cycle */
        repeat(3) @(posedge iol2clk);
    end
end

always @(posedge (iol2clk && enabled && l2t7_sii_iq_dequeue))
begin
    if(l2t7_sii_iq_dequeue)
    begin
        `PR_ALWAYS("siu_to_l2_mon", `ALWAYS, "<l2t7,sii,,l2tsiidequeue,{%x}>::Read Requests from SIU Dequeued from L2 Input Queue", l2t7_sii_iq_dequeue);
    end
end

always @(posedge (iol2clk && enabled && l2t7_sii_wib_dequeue))
begin
    if(l2t7_sii_wib_dequeue)
    begin
        `PR_ALWAYS("siu_to_l2_mon", `ALWAYS, "<l2t7,sii,,l2tsiiwibdeq,{%x}>::L2 moved out 64 byte data from I/O write buffer and data towards MCU", l2t7_sii_wib_dequeue);
    end
end


endmodule
