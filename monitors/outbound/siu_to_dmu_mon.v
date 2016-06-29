/*

Monitor written by : Debjit Pal
Email ID: dpal2@illinois.edu
Institute: Univerisity of Illinois at Urbana-Champaign

*/

module siu_to_dmu_mon();

reg enabled;
initial begin
    enabled = 1'b1;
    if ($test$plusargs("siu_to_dmu_mon_disable"))
    begin
        enabled = 1'b0;
    end
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

/* Detecting the Header Cycle */
always @(posedge (iol2clk && enabled))
begin
    if(sio_dmu_hdr_vld)
        `PR_ALWAYS("sio_to_dmu_mon", `ALWAYS, "SIU sending packet to DMU sio_dmu_hdr_vld = %b", sio_dmu_hdr_vld);
        if(sio_dmu_datareq)
            `PR_ALWAYS("sio_to_dmu_mon", `ALWAYS, "Four Cycle Payload follows with 64 bytes of data from SIU to DMU sio_dmu_datareq = %b", sio_dmu_datareq);
        else
            `PR_ALWAYS("sio_to_dmu_mon", `ALWAYS, "Write Acknowledge and No Data Payload follows sio_dmu_hdr_vld = %b", sio_dmu_hdr_vld);
end

/* Detecting Payload Cycles */

always @(posedge (iol2clk && enabled))
begin
    if(sio_dmu_datareq_d)
        `PR_ALWAYS("sio_to_dmu_mon", `ALWAYS, "Payload cycle initiated");
end

endmodule
