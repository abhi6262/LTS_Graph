/*

Monitor written by : Debjit Pal
Email ID: dpal2@illinois.edu
Institute: Univerisity of Illinois at Urbana-Champaign

Modified by: Abhishek Sharma
Email ID: sharma53@illinois.edu
*/

module siu_to_dmu_mon();

reg enabled;
initial begin
    enabled = 1'b1;
    if ($test$plusargs("siu_to_dmu_mon_disable"))
    begin
        enabled = 1'b0;
    end
    else
        `PR_INFO("siu_to_dmu_mon", `INFO, "siu_to_dmu_mon ENABLED");
end

/* From SIU to DMU monitoring Outbound messages */


wire iol2clk = `SIO.iol2clk;
wire sio_dmu_hdr_vld = `SIO.sio_dmu_hdr_vld;
wire sio_dmu_datareq = `SIO.sio_dmu_datareq_unused; /* Not sure about this signal */ 
wire [127:0] sio_dmu_data = `SIO.sio_dmu_data;
wire [7:0] sio_dmu_parity = `SIO.sio_dmu_parity;

/* datareq delayed to make sure we identify the Payload cycle correctly */
reg sio_dmu_datareq_d;
always @(posedge iol2clk)
begin
    sio_dmu_datareq_d <= sio_dmu_datareq;
end


/* Section 6.5.1.3 Manual Vol 1 */

/* Detecting the Header Cycle */
always @(posedge (iol2clk && enabled))
begin
    if(sio_dmu_hdr_vld)
    begin
        `PR_ALWAYS("sio_to_dmu_mon", `ALWAYS, "<sio,dmu,,siodmuhdrvld,{%x}>::SIU sending packet to DMU", sio_dmu_hdr_vld);
        if(sio_dmu_datareq)
            `PR_ALWAYS("sio_to_dmu_mon", `ALWAYS, "<sio,dmu,,siodmu64payload,{%x}>::Four Cycle Payload follows with 64 bytes of data from SIU to DMU", sio_dmu_datareq);
        else
            `PR_ALWAYS("sio_to_dmu_mon", `ALWAYS, "<sio,dmu,,siodmu64payload,{%x}>::No Data Payload follows", sio_dmu_datareq);
        `PR_ALWAYS("sio_to_dmu_mon", `ALWAYS, "<sio,dmu,,siodmureadres,{%x}>::SIO to DMU Read Response", sio_dmu_data[127:122]);
        `PR_ALWAYS("sio_to_dmu_mon", `ALWAYS, "<sio,dmu,,dmutagid,{%x}>::SIO to DMU Read Tag", sio_dmu_data[79:64]);
        /* For Responses SIO does not return the address and hence sio_dmu_data[39:0] has been neglected here. Manual 1 Page 6-68 */
    end
end

/* Detecting Payload Cycles */

always @(posedge (iol2clk && enabled))
begin
    if(sio_dmu_datareq_d)
    begin
        `PR_ALWAYS("sio_to_dmu_mon", `ALWAYS, "<sio,dmu,,dmapayload>::SIO to DMU Return Data Payload Cycle");
        `PR_INFO("sio_to_dmu_mon", `INFO, "DMA Response Payload = %x", sio_dmu_data);
        `PR_INFO("sio_to_dmu_mon", `INFO, "DMA Response Parity = %x", sio_dmu_parity);
        repeat (3) @(posedge iol2clk)
        begin
            `PR_INFO("sio_to_dmu_mon", `INFO, "DMA Response Payload = %x", sio_dmu_data);
            `PR_INFO("sio_to_dmu_mon", `INFO, "DMA Response Parity = %x", sio_dmu_parity);
        end
    end
end

endmodule
