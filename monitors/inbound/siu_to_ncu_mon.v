/*

Monitor written by : Debjit Pal
Email ID: dpal2@illinois.edu
Institute: Univerisity of Illinois at Urbana-Champaign

*/

module siu_to_ncu_mon();

reg enabled;
initial begin
    enabled = 1'b1;
    if($test$plusargs("siu_to_ncu_mon_disable"))
    begin
        enabled = 1'b0;
    end
end

/* From SII to NCU monitoring INBOUND Messages */ 

wire iol2clk = `SII.iol2clk;
wire [31:0] sii_ncu_data = `SII.sii_ncu_data;
wire [1:0] sii_ncu_dparity = `SII.sii_ncu_dparity;
wire sii_ncu_req = `SII.sii_ncu_req;
wire ncu_sii_gnt = `SII.ncu_sii_gnt;

always @(posedge (iol2clk && enabled))
begin
    `PR_ALWAYS("siu_to_ncu_mon", `ALWAYS, "SII_NCU_REQ sii_ncu_req = %b", sii_ncu_req);
end

endmodule
