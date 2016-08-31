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
        `PR_ALWAYS("dmu_to_siu_mon", `ALWAYS, "<sii,dmu,dmaw,cred>::SIU Returning Credit after forwarding DMA write");
    end
end

/* Detetct Header Cycle */

always @(posedge (iol2clk && enabled))
begin
    if(dmu_sii_hdr_vld)
    begin
        `PR_INFO("dmu_to_siu_mon", `INFO, "DMU_SIU_HDR niu_sii_hdr_vld = %b", dmu_sii_hdr_vld);
        /* Single and Back-to-Back DMA Read Request from Fire DMU to SIU */
        if(!dmu_sii_datareq && !dmu_sii_datareq16)
        begin
            `PR_ALWAYS("dmu_to_siu_mon", `ALWAYS, "<dmu,sii,header,readreq>::DMU to SIU DMA Read Request Header Cycle");
            if (dmu_sii_reqbypass)
                `PR_INFO("dmu_to_siu_mon", `INFO, "Read Request Sent to SIU Bypass Queue");
            else
                `PR_INFO("dmu_to_siu_mon", `INFO, "Read Request Sent to SIU Ordered Queue");
            `PR_INFO("dmu_to_siu_mon", `INFO, "Header Bits = %x", dmu_sii_data);
            `PR_INFO("dmu_to_siu_mon", `INFO, "Header Cycle Parity = %x", dmu_sii_parity);
        end
        /* Single and Back-to-Back DMA Write Request from Fire DMU to SIU */
        else if (dmu_sii_datareq && !dmu_sii_datareq16)
        begin
            `PR_ALWAYS("dmu_to_siu_mon", `ALWAYS, "<dmu,sii,header,dmaw>::DMU to SIU DMA Write Request Header Cycle");
            if (dmu_sii_reqbypass)
                `PR_INFO("dmu_to_siu_mon", `INFO, "Write Request Sent to SIU Bypass Queue");
            else
                `PR_INFO("dmu_to_siu_mon", `INFO, "Write Request Sent to SIU Orderded Queue");
            `PR_INFO("dmu_to_siu_mon", `INFO, "Header Bits = %x", dmu_sii_data);
            `PR_INFO("dmu_to_siu_mon", `INFO, "Header Cycle Parity = %b", dmu_sii_parity);
        end
        /* Single and Back-to-Back Mondor Interrupt Request from Fire DMU to SIU */
        else if (dmu_sii_datareq && dmu_sii_datareq16)
        begin
            `PR_INFO("dmu_to_siu_mon", `INFO, "DMU to SIU Mondo Interrupt Request / PIO Read Header Cycle");
            if (!dmu_sii_reqbypass)
                `PR_ALWAYS("dmu_to_siu_mon", `ALWAYS, "<dmu,sii,intr,ordered>::Mondo Interrupt Request Sent to SIU Ordered Queue");
            else
                `PR_ALWAYS("dmu_to_siu_mon", `ALWAYS, "<dmu,sii,pioredd,bypass>::PIO Read Data Return Sent to SIU Bypass Queue");
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
    `PR_ALWAYS("dmu_to_siu_mon", `ALWAYS, "<dmu,sii,payload,dmaw>::DMU TO SIU DMA Write Request Payload Cycle");
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
    `PR_ALWAYS("dmu_to_siu_mon", `ALWAYS, "<dmu,sii,payload,pioredrm>::DMU to SIU Mondo Interrupt Request / PIO Read Data Return Payload Cycle");
    if (!dmu_sii_reqbypass_d)
    begin
        `PR_INFO("dmu_to_siu_mon", `INFO, "Mondo Data Payload = %x", dmu_sii_data);
        `PR_INFO("dmu_to_siu_mon", `INFO, "Mondo Payload Parity = %x", dmu_sii_parity);
    end
    else
    begin
        `PR_INFO("dmu_to_siu_mon", `INFO, "PIO Read Data Payload = %x", dmu_sii_data);
        `PR_INFO("dmu_to_siu_mon", `INFO, "PIO Read Data Payload Parity = %x", dmu_sii_parity);
    end
end

endmodule
