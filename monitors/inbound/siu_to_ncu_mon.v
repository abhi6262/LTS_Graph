/*

Monitor written by : Debjit Pal
Email ID: dpal2@illinois.edu
Institute: Univerisity of Illinois at Urbana-Champaign

*/

module siu_to_ncu_mon();

reg enabled;
reg sii_ncu_req_serviced;
reg ncu_sii_gnt_d;
initial begin
    enabled = 1'b1;
    sii_ncu_req_serviced = 1'b0;
    ncu_sii_gnt_d = 1'b0;
    if($test$plusargs("siu_to_ncu_mon_disable"))
    begin
        enabled = 1'b0;
    end
    else
        `PR_INFO("siu_to_ncu_mon", `INFO, "siu_to_ncu_mon ENABLED");
end

/* From SII to NCU monitoring INBOUND Messages */ 

wire iol2clk = `SII.iol2clk;
wire [31:0] sii_ncu_data = `SII.sii_ncu_data;
wire [1:0] sii_ncu_dparity = `SII.sii_ncu_dparity;
wire sii_ncu_req = `SII.sii_ncu_req;
wire ncu_sii_gnt = `SII.ncu_sii_gnt;

/* Section 6.4.3 and Section 6.4.4.4 Manual Vol 1 */

/* SIU to NCU can be Mondo Interrupt or PIO Completion. SIU is waiting for NCU confirmation for being
   serviced 
*/

always @(posedge (iol2clk && enabled && !sii_ncu_req_serviced && sii_ncu_req))
begin
	if (sii_ncu_req)
	begin
		`PR_ALWAYS("siu_to_ncu_mon", `ALWAYS, "SIU Signalling a Transfer to NCU");
		sii_ncu_req_serviced = 1'b1;
	end
end

/* Detecting NCU is ready to serice SIU request */

always @(posedge (iol2clk && enabled && sii_ncu_req_serviced && ncu_sii_gnt))
begin
	if(ncu_sii_gnt)
	begin
		`PR_ALWAYS("siu_to_ncu_mon", `ALWAYS, "NCU Granting SIU for Transfer");
		sii_ncu_req_serviced = 1'b0;
	end
end

/* Detect the Payload cycle after one cycle of getting ncu_sii_gnt */

always @(posedge (iol2clk && enabled))
begin
    ncu_sii_gnt_d <= ncu_sii_gnt;
end

always @(posedge (iol2clk && enabled && ncu_sii_gnt_d))
begin
    `PR_ALWAYS("siu_to_ncu_mon", `ALWAYS, "SIU to NCU Header and Payload Cycle");
    /* One cycle of Header */
    repeat(1) @(posedge iol2clk)
    begin
        `PR_INFO("siu_to_ncu_mon", `INFO, "SIU to NCU Header = %x", sii_ncu_data);
    end
    /* Four cycles of Payload and Parity */
    repeat(4) @(posedge iol2clk)
    begin
        `PR_INFO("siu_to_ncu_mon", `INFO, "SIU to NCU Payload = %x", sii_ncu_data);
        `PR_INFO("siu_to_ncu_mon", `INFO, "SIU to NCU Payload Parity = %x", sii_ncu_dparity);
    end
end

endmodule
