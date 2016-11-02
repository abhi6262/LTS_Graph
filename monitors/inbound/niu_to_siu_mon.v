/*

Monitor written by : Debjit Pal
Email ID: dpal2@illinois.edu
Institute: Univerisity of Illinois at Urbana-Champaign

*/

module niu_to_siu_mon();

reg enabled;
reg write_payload_cycle_detected;
initial begin
    enabled = 1'b1;
    write_payload_cycle_detected = 1'b0;
    if ($test$plusargs("niu_to_siu_mon_disable"))
    begin
        enabled = 1'b0;
    end
    else
        `PR_INFO("niu_to_siu_mon", `INFO, "niu_to_siu_mon ENABLED");
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


/* Section 6.4.3 and Section 6.4.4.1 Manual Vol 1 */


/* Detetct Header Cycle */

always @(posedge (iol2clk && enabled))
begin
    if(niu_sii_hdr_vld)
    begin
        /* Single and Back-to-Back DMA Read Request from NIU to SIU */
        if(!niu_sii_datareq && !niu_sii_datareq16)
        begin
            `PR_ALWAYS("niu_to_siu_mon", `ALWAYS, "<niu,sii,rheadercycle,niuheader,{%x}>::NIU to SIU DMA Read Request Header Cycle", niu_sii_hdr_vld);
            `PR_ALWAYS("niu_to_siu_mon", `ALWAYS, "<niu,sii,rheadercycle,dmarw,{%x%x}>::NIU to SIU DMA Read Request", niu_sii_datareq, niu_sii_datareq16);
            if (niu_sii_reqbypass)
                `PR_ALWYAS("niu_to_siu_mon", `ALWAYS, "<niu,sii,rheadercycle,niudestq,{%x}>::Read Request Sent to SIU Bypass Queue", niu_sii_reqbypass);
            else
                `PR_ALWYAS("niu_to_siu_mon", `ALWAYS, "<niu,sii,rheadercycle,niudestq,{%x}>::Read Request Sent to SIU Ordered Queue", niu_sii_reqbypass);
            `PR_INFO("niu_to_siu_mon", `INFO, "Header Bits = %x", niu_sii_data);
            `PR_INFO("niu_to_siu_mon", `INFO, "Header Cycle Parity = %x", niu_sii_parity);
            `PR_ALWAYS("niu_to_siu_mon", `ALWAYS, "<niu,sii,rheadercycle,niutagid,{%x}>::Read Request NIU Tag ID", niu_sii_data[79:64]);
            `PR_ALWAYS("niu_to_siu_mon", `ALWAYS, "<niu,sii,rheadercycle,niupa,{%x}>::Read Request NIU PA", niu_sii_data[39:0]);
        end
        /* Single and Back-to-Back DMA Write Request from NIU to SIU */
        else if (niu_sii_datareq && !niu_sii_datareq16)
        begin
            `PR_ALWAYS("niu_to_siu_mon", `ALWAYS, "<niu,sii,wheadercycle,niuheader,{%x}>::NIU to SIU DMA Write Request Header Cycle", niu_sii_hdr_vld)
            `PR_ALWAYS("niu_to_siu_mon", `ALWAYS, "<niu,sii,wheadercycle,dmarw,{%x%x}>::NIU to SIU DMA Write Request", niu_sii_datareq, niu_sii_datareq16);
            `PR_ALWAYS("niu_to_siu_mon", `ALWAYS, "<niu,sii,header,dmaw>::NIU to SIU DMA Write Request Header Cycle");
            if (niu_sii_reqbypass)
                `PR_ALWAYS("niu_to_siu_mon", `ALWAYS, "<niu,sii,wheadercycle,niudestq,{%x}>::Write Request Sent to SIU Bypass Queue", niu_sii_reqbypass);
            else
                `PR_ALWAYS("niu_to_siu_mon", `ALWAYS, "<niu,sii,wheadercycle,niudestq,{%x}>::Write Request Sent to SIU Orderded Queue", niu_sii_reqbypass);
            `PR_INFO("niu_to_siu_mon", `INFO, "Header Bits = %x", niu_sii_data);
            `PR_INFO("niu_to_siu_mon", `INFO, "Header Cycle Parity = %b", niu_sii_parity);
            `PR_ALWAYS("niu_to_siu_mon", `ALWAYS, "<niu,sii,wheadercycle,niutagid,{%x}>::Write Request NIU Tag ID", niu_sii_data[79:64]);
            `PR_ALWAYS("niu_to_siu_mon", `ALWAYS, "<niu,sii,wheadercycle,niupa,{%x}>::Write Request NIU PA", niu_sii_data[39:0]);
        end
    end
end

/* Detect Write Request Payload Cycle */
always @(posedge (iol2clk && enabled))
begin
    write_payload_cycle_detected <= niu_sii_datareq && !niu_sii_datareq16;
end


always @(posedge (iol2clk && enabled && write_payload_cycle_detected))
begin
    `PR_ALWAYS("niu_to_siu_mon", `ALWAYS, "<niu,sii,wpayloadcycle,dmawritepayload>::NIU TO SIU DMA Write Request Payload Cycle");
    repeat (4) @(posedge iol2clk)
    begin
        `PR_INFO("niu_to_siu_mon", `INFO, "DMA Write Payload = %x", niu_sii_data);
        `PR_INFO("niu_to_siu_mon", `INFO, "Write Payload Parity = %x", niu_sii_parity);
    end
end


endmodule
