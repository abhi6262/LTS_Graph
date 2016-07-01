/*

Monitor written by : Debjit Pal
Email ID: dpal2@illinois.edu
Institute: Univerisity of Illinois at Urbana-Champaign

Modified by: Abhishek Sharma
Email ID: sharma53@illinois.edu
*/

module siu_to_niu_mon();

reg enabled;
initial begin
    enabled = 1'b1;
    if ($test$plusargs("siu_to_niu_mon_disable"))
    begin
        enabled = 1'b0;
    end
end

/* From SIU to NIU monitoring Outbound messages */

wire iol2clk = `SIO.iol2clk;
wire sio_niu_hdr_vld = `SIO.sio_niu_hdr_vld;
wire sio_niu_datareq = `SIO.sio_niu_datareq;
wire [127:0] sio_niu_data = `SIO.sio_niu_data;
wire [7:0] sio_niu_parity = `SIO.sio_niu_parity;

/* datareq delayed to make sure we identify the Payload cycle correctly */
reg sio_niu_datareq_d;

always @(posedge iol2clk)
begin
    sio_niu_datareq_d <= sio_niu_datareq;
end


/* Section 6.5.1.2 Manual Vol 1 */

/* Detecting Header Cycle */

always @(posedge (iol2clk && enabled))
begin
    if(sio_niu_hdr_vld)
    begin
        `PR_ALWAYS("sio_to_niu_mon", `ALWAYS, "SIU sending packet to NIU sio_niu_hdr_vld = %b", sio_niu_hdr_vld);
        if (sio_niu_datareq)
            `PR_ALWAYS("sio_to_niu_mon", `ALWAYS, "Four Cycle Payload follows with 64 bytes of data from SIU to NIU sio_niu_datareq = %b", sio_niu_datareq);
        else
            `PR_ALWAYS("sio_to_niu_mon", `ALWAYS, "Write Acknowledge and No Data Payload follows sio_niu_hdr_vld = %b", sio_niu_hdr_vld);
        `PR_INFO("sio_to_niu_mon", `INFO, "Header Bits = %x", sio_niu_data);
    end
end


/* Detecting Payload Cycle */

always @(posedge (iol2clk & enabled))
begin
    if (sio_niu_datareq_d)
    begin
        `PR_ALWAYS("sio_to_niu_mon", `ALWAYS, "Payload cycle initiated");
        repeat (4) @(posedge iol2clk)
        begin
            `PR_INFO("sio_to_niu_mon", `INFO, "DMA Response Payload = %x", sio_niu_data);
            `PR_INFO("sio_to_niu_mon", `INFO, "DMA Response Parity = %x", sio_niu_parity);
        end
    end
end

endmodule
