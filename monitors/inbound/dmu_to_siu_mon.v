/*

Monitor written by : Debjit Pal
Email ID: dpal2@illinois.edu
Institute: Univerisity of Illinois at Urbana-Champaign

*/

module dmu_to_siu_mon();

reg enabled;
reg write_payload_cycle_detected;
reg interrupt_pioread_payload_cycle_detected;
reg dmu_sii_reqbypass_d;
initial begin
    enabled = 1'b1;
    write_payload_cycle_detected = 1'b0;
    interrupt_pioread_payload_cycle_detected = 1'b0;
    dmu_sii_reqbypass_d = 1'b0;
    if ($test$plusargs("dmu_to_siu_mon_disable"))
    begin
        enabled = 1'b0;
    end
    else
        `PR_INFO("dmu_to_siu_mon", `INFO, "dmu_to_siu_mon ENABLED");
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


/* Section 6.4.3 and Section 6.4.4.2 Manual Vol 1 */

/* Fire DMU ensure it has DMA Credit before sending DMA Read Request, Write Request,
   Mondo Interrupt Request packet to SIU
*/
always @(posedge (iol2clk && enabled && sii_dmu_wrack_vld))
begin
    if(sii_dmu_wrack_vld)
    begin
        `PR_ALWAYS("dmu_to_siu_mon", `ALWAYS, "<sii,dmu,dmawrite,creditret>::SIU Returning Credit after forwarding DMA write");
    end
end

/* Detetct Header Cycle */

always @(posedge (iol2clk && enabled))
begin
    if(dmu_sii_hdr_vld)
    begin
        /* Single and Back-to-Back DMA Read Request from Fire DMU to SIU */
        if(!dmu_sii_datareq && !dmu_sii_datareq16)
        begin
            `PR_ALWAYS("dmu_to_siu_mon", `ALWAYS, "<dmu,sii,rheadercycle,dmuheader,{%x}::DMU  to SIU DMA Read Request Header Cycle", dmu_sii_hdr_vld);
            `PR_ALWAYS("dmu_to_siu_mon", `ALWAYS, "<dmu,sii,rheadercycle,dmarwm,{%x%x}>::DMU to SIU DMA Read Request", dmu_sii_datareq,dmu_sii_datareq16);
            if (dmu_sii_reqbypass)
                `PR_ALWAYS("dmu_to_siu_mon", `ALWAYS, "<dmu,sii,rheadercycle,dmudestq,{%x}>::Read Request Sent to SIU Bypass Queue", dmu_sii_reqbypass);
            else
                `PR_ALWAYS("dmu_to_siu_mon", `ALWAYS, "<dmu,sii,rheadercycle,dmudestq,{%x}>::Read Request Sent to SIU Ordered Queue", dmu_sii_reqbypass);
            `PR_INFO("dmu_to_siu_mon", `INFO, "Header Bits = %x", dmu_sii_data);
            `PR_INFO("dmu_to_siu_mon", `INFO, "Header Cycle Parity = %x", dmu_sii_parity);
            `PR_ALWAYS("dmu_to_siu_mon", `ALWAYS, "<dmu,sii,rheadercycle,dmutagid,{%x}>::Read Request DMU Tag ID", dmu_sii_data[79:64]);
            `PR_ALWAYS("dmu_to_siu_mon", `ALWAYS, "<dmu,sii,rheadercycle,dmupa,{%x}>::Read Request PA", dmu_sii_data[39:0]);
        end
        /* Single and Back-to-Back DMA Write Request from Fire DMU to SIU */
        else if (dmu_sii_datareq && !dmu_sii_datareq16)
        begin
            `PR_ALWAYS("dmu_to_siu_mon", `ALWAYS, "<dmu,sii,wheadercycle,dmuheader,{%x}>::DMU  to SIU DMA Write Request Header Cycle", dmu_sii_hdr_vld);
            `PR_ALWAYS("dmu_to_siu_mon", `ALWAYS, "<dmu,sii,wheadercycle,dmarwm,{%x%x}>::DMU to SIU DMA Write Request", dmu_sii_datareq, dmu_sii_datareq16);
            if (dmu_sii_reqbypass)
                `PR_ALWAYS("dmu_to_siu_mon", `ALWAYS, "<dmu,sii,wheadercycle,dmadestq,{%x}>::Write Request Sent to SIU Bypass Queue", dmu_sii_reqbypass);
            else
                `PR_ALWAYS("dmu_to_siu_mon", `ALWAYS, "<dmu,sii,wheadercycle,dmadestq,{%x}>::Write Request Sent to SIU Orderded Queue", dmu_sii_reqbypass);
            `PR_INFO("dmu_to_siu_mon", `INFO, "Header Bits = %x", dmu_sii_data);
            `PR_INFO("dmu_to_siu_mon", `INFO, "Header Cycle Parity = %b", dmu_sii_parity);
            `PR_ALWAYS("dmu_to_siu_mon", `ALWAYS, "<dmu,sii,wheadercycle,dmutagid,{%x}>::Write Request DMU Tag ID", dmu_sii_data[79:64]);
            `PR_ALWAYS("dmu_to_siu_mon", `ALWAYS, "<dmu,sii,wheadercycle,dmupa,{%x}>::Write Request PA", dmu_sii_data[39:0]);
        end
        /* Single and Back-to-Back Mondor Interrupt Request from Fire DMU to SIU */
        else if (dmu_sii_datareq && dmu_sii_datareq16)
        begin
            if (!dmu_sii_reqbypass)
            begin
                `PR_ALWAYS("dmu_to_siu_mon", `ALWAYS, "<dmu,sii,mheadercycle,dmuheader,{%x}>::DMU to SIU Mondo Interrupt Header Cycle", dmu_sii_hdr_vld);
                `PR_ALWAYS("dmu_to_siu_mon", `ALWAYS, "<dmu,sii,mheadercycle,dmarwm,{%x%x}>::DMU to SIU Mondo Interrupt Request", dmu_sii_datareq, dmu_sii_datareq16);
                `PR_ALWAYS("dmu_to_siu_mon", `ALWAYS, "<dmu,sii,mheadercycle,dmadestq,{%x}>::Mondo Interrupt Request Sent to SIU Ordered Queue", dmu_sii_reqbypass);
                `PR_ALWAYS("dmu_to_siu_mon", `ALWYAS, "<dmu,sii,mheadercycle,dmutagid,{%x}>::Mondo Interrupt ID", dmu_sii_data[79:64])
            end
            else
            begin
                `PR_ALWAYS("dmu_to_siu_mon", `ALWAYS, "<dmu,sii,pheadercycle,dmuheader,{%x}>::DMU to SIU PIO Read Completion Header Cycle", dmu_sii_hdr_vld);
                `PR_ALWAYS("dmu_to_siu_mon", `ALWAYS, "<dmu,sii,pheadercycle,dmarwm,{%x%x}>::DMU to SIU PIO Read Header", dmu_sii_datareq, dmu_sii_datareq16);
                `PR_ALWAYS("dmu_to_siu_mon", `ALWAYS, "<dmu,sii,pheadercycle,dmadestq,{%x}>::PIO Read Data Return Sent to SIU Bypass Queue", dmu_sii_reqbypass);
                `PR_ALWAYS("dmu_to_siu_mon", `ALWYAS, "<dmu,sii,pheadercycle,dmutagid,{%x}>::PIO NCU Cred ID and CPU Thread ID", dmu_sii_data[79:64])
            end
            `PR_INFO("dmu_to_siu_mon", `INFO, "Header Bits =%x", dmu_sii_data);
            `PR_INFO("dmu_to_siu_mon", `INFO, "Header Cycle Parity = %x", dmu_sii_parity);
        end
    end
end

/* Detect Write Request Payload Cycle */
always @(posedge (iol2clk && enabled))
begin
    write_payload_cycle_detected <= dmu_sii_datareq && !dmu_sii_datareq16;
end

always @(posedge (iol2clk && enabled && write_payload_cycle_detected))
begin
    `PR_ALWAYS("dmu_to_siu_mon", `ALWAYS, "<dmu,sii,wpayloadcycle,dmawritepayload>::DMU TO SIU DMA Write Request Payload Cycle");
    repeat (4) @(posedge iol2clk)
    begin
        `PR_INFO("dmu_to_siu_mon", `INFO, "DMA Write Payload = %x", dmu_sii_data);
        `PR_INFO("dmu_to_siu_mon", `INFO, "Write Payload Parity = %x", dmu_sii_parity);
    end
end

/* Detect Mondo Interrupt / PIO Read Data Return Payload Cycle */
always @(posedge (iol2clk && enabled))
begin
    interrupt_pioread_payload_cycle_detected <= dmu_sii_datareq && dmu_sii_datareq16;
    dmu_sii_reqbypass_d <=  dmu_sii_reqbypass;
end

always @(posedge (iol2clk && enabled && interrupt_pioread_payload_cycle_detected))
begin
    if (!dmu_sii_reqbypass_d)
    begin
        `PR_ALWAYS("dmu_to_siu_mon", `ALWAYS, "<dmu,sii,mpayloadcycle,mondointpayload>::DMU to SIU Mondo Interrupt Request / PIO Read Data Return Payload Cycle");
        `PR_INFO("dmu_to_siu_mon", `INFO, "Mondo Data Payload = %x", dmu_sii_data);
        `PR_INFO("dmu_to_siu_mon", `INFO, "Mondo Payload Parity = %x", dmu_sii_parity);
    end
    else
    begin
        `PR_ALWAYS("dmu_to_siu_mon", `ALWAYS, "<dmu,sii,ppayloadcycle,pioreadpayload>::DMU to SIU Mondo Interrupt Request / PIO Read Data Return Payload Cycle");
        `PR_INFO("dmu_to_siu_mon", `INFO, "PIO Read Data Payload = %x", dmu_sii_data);
        `PR_INFO("dmu_to_siu_mon", `INFO, "PIO Read Data Payload Parity = %x", dmu_sii_parity);
    end
end

endmodule
