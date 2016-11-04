/*

Monitor written by : Debjit Pal
Email ID: dpal2@illinois.edu
Institute: Univerisity of Illinois at Urbana-Champaign

Modified by: Abhishek Sharma
Email ID: sharma53@illinois.edu
*/


/* Define the modules */

`define L2T0 `CPU.l2t0
`define L2T1 `CPU.l2t1
`define L2T2 `CPU.l2t2
`define L2T3 `CPU.l2t3
`define L2T4 `CPU.l2t4
`define L2T5 `CPU.l2t5
`define L2T6 `CPU.l2t6
`define L2T7 `CPU.l2t7

module l2_to_siu_mon();

reg enabled;
initial begin
    enabled = 1'b1;
    if ($test$plusargs("l2_to_siu_mon_disable"))
    begin
        enabled = 1'b0;
    end
    else
        `PR_ALWAYS("l2_to_siu_mon", `ALWAYS, "l2_to_siu_mon ENABLED");
end

/* From L2 to SIU monitoring OUTBOUND Messages */

wire iol2clk = `SII.iol2clk; // `SII.iol2clk and `SIO.iol2clk are same

/* Signals needed for Read response from L2 to SIU */ 

wire l2b7_sio_ctag_vld = `SIO.l2b7_sio_ctag_vld;
wire l2b6_sio_ctag_vld = `SIO.l2b6_sio_ctag_vld;
wire l2b5_sio_ctag_vld = `SIO.l2b5_sio_ctag_vld;
wire l2b4_sio_ctag_vld = `SIO.l2b4_sio_ctag_vld;
wire l2b3_sio_ctag_vld = `SIO.l2b3_sio_ctag_vld;
wire l2b2_sio_ctag_vld = `SIO.l2b2_sio_ctag_vld;
wire l2b1_sio_ctag_vld = `SIO.l2b1_sio_ctag_vld;
wire l2b0_sio_ctag_vld = `SIO.l2b0_sio_ctag_vld;

wire [31:0] l2b7_sio_data = `SIO.l2b7_sio_data;
wire [31:0] l2b6_sio_data = `SIO.l2b6_sio_data;
wire [31:0] l2b5_sio_data = `SIO.l2b5_sio_data;
wire [31:0] l2b4_sio_data = `SIO.l2b4_sio_data;
wire [31:0] l2b3_sio_data = `SIO.l2b3_sio_data;
wire [31:0] l2b2_sio_data = `SIO.l2b2_sio_data;
wire [31:0] l2b1_sio_data = `SIO.l2b1_sio_data;
wire [31:0] l2b0_sio_data = `SIO.l2b0_sio_data;

wire [1:0] l2b7_sio_parity = `SIO.l2b7_sio_parity;
wire [1:0] l2b6_sio_parity = `SIO.l2b6_sio_parity;
wire [1:0] l2b5_sio_parity = `SIO.l2b5_sio_parity;
wire [1:0] l2b4_sio_parity = `SIO.l2b4_sio_parity;
wire [1:0] l2b3_sio_parity = `SIO.l2b3_sio_parity;
wire [1:0] l2b2_sio_parity = `SIO.l2b2_sio_parity;
wire [1:0] l2b1_sio_parity = `SIO.l2b1_sio_parity;
wire [1:0] l2b0_sio_parity = `SIO.l2b0_sio_parity;

wire l2b7_sio_ue_err = `SIO.l2b7_sio_ue_err;
wire l2b6_sio_ue_err = `SIO.l2b6_sio_ue_err;
wire l2b5_sio_ue_err = `SIO.l2b5_sio_ue_err;
wire l2b4_sio_ue_err = `SIO.l2b4_sio_ue_err;
wire l2b3_sio_ue_err = `SIO.l2b3_sio_ue_err;
wire l2b2_sio_ue_err = `SIO.l2b2_sio_ue_err;
wire l2b1_sio_ue_err = `SIO.l2b1_sio_ue_err;
wire l2b0_sio_ue_err = `SIO.l2b0_sio_ue_err;


/* Monitors for Single Read Response from L2 to SIO Section 6.5.1.1 Manual Vol 1 */
/* Monitors for Write 8 Response from L2 to SIO Section 6.5.1.1 Manual Vol 1 */
/* Monitors for Write Invalidate Response from L2 to SIO Section 6.5.1.1 Manual Vol 1 */

/*

    NOTE: Since its hard to differentiate between the Single Read Response, Write 8 Response and
    Write Invalidate Response from L2 to SIO (same set of signals shared and no essential difference in the signal response)
    I merge them all now. I also remove the 17 cycles repeat operator as in case of WR8 and WRI that 17 cycles
    do not make much sense. Also `PR_ALWAYS on Parity check bit are removed now as for WRI that signal
    dont make sense. SIU to L2 inbound monitor is a better place to differentiate between what kind
    of request came from SII to L2. siu_to_l2_mon in inbound will do that. In that monitor WRI has also 
    been incorporated now.

*/

/* L2 Bank 0*/

always @(posedge(iol2clk && enabled))
begin
    if(l2b0_sio_ctag_vld)
    begin
        `PR_ALWAYS("l2_to_siu_mon", `ALWAYS, "<l2b0,sio,,l2bsiovld,{%x}>::Read Reasponse Cycle from L2B to SIO Started", l2b0_sio_ctag_vld);
        `PR_ALWAYS("l2_to_siu_mon", `ALWAYS, "<l2b0,sio,,l2bsioopes,{%x}>::L2B TO SIU Read Response  = %x", l2b0_sio_data[23:20]);
        `PR_ALWAYS("l2_to_siu_mon", `ALWAYS, "<l2b0,sio,,l2bsiocba,{%x}>::L2B TO SIU Read Response  = %x", l2b0_sio_data[19:16]);
        `PR_ALWAYS("l2_to_siu_mon", `ALWAYS, "<l2b0,sio,,l2bsiotag,{%x}>::L2B TO SIU Read Response  = %x", l2b0_sio_data[15:0]);
    end
end

always @(posedge (iol2clk && enabled))
begin
    if(l2b0_sio_ue_err)
        `PR_ALWAYS("l2_to_siu_mon", `ALWAYS, "Uncorrectable error detetcted by L2B0 to SIO");
end

/* L2 Bank 1*/

always @(posedge(iol2clk && enabled))
begin
    if(l2b1_sio_ctag_vld)
    begin
        `PR_ALWAYS("l2_to_siu_mon", `ALWAYS, "<l2b1,sio,,l2bsiovld,{%x}>::Read Reasponse Cycle from L2B to SIO Started", l2b1_sio_ctag_vld);
        `PR_ALWAYS("l2_to_siu_mon", `ALWAYS, "<l2b1,sio,,l2bsioopes,{%x}>::L2B TO SIU Read Response  = %x", l2b1_sio_data[23:20]);
        `PR_ALWAYS("l2_to_siu_mon", `ALWAYS, "<l2b1,sio,,l2bsiocba,{%x}>::L2B TO SIU Read Response  = %x", l2b1_sio_data[19:16]);
        `PR_ALWAYS("l2_to_siu_mon", `ALWAYS, "<l2b1,sio,,l2bsiotag,{%x}>::L2B TO SIU Read Response  = %x", l2b1_sio_data[15:0]);
    end
end

always @(posedge (iol2clk && enabled))
begin
    if(l2b1_sio_ue_err)
        `PR_ALWAYS("l2_to_siu_mon", `ALWAYS, "Uncorrectable error detetcted by L2B1 to SIO");
end

/* L2 Bank 2*/

always @(posedge(iol2clk && enabled))
begin
    if(l2b2_sio_ctag_vld)
    begin
        `PR_ALWAYS("l2_to_siu_mon", `ALWAYS, "<l2b2,sio,,l2bsiovld,{%x}>::Read Reasponse Cycle from L2B to SIO Started", l2b2_sio_ctag_vld);
        `PR_ALWAYS("l2_to_siu_mon", `ALWAYS, "<l2b2,sio,,l2bsioopes,{%x}>::L2B TO SIU Read Response  = %x", l2b2_sio_data[23:20]);
        `PR_ALWAYS("l2_to_siu_mon", `ALWAYS, "<l2b2,sio,,l2bsiocba,{%x}>::L2B TO SIU Read Response  = %x", l2b2_sio_data[19:16]);
        `PR_ALWAYS("l2_to_siu_mon", `ALWAYS, "<l2b2,sio,,l2bsiotag,{%x}>::L2B TO SIU Read Response  = %x", l2b2_sio_data[15:0]);
    end
end

always @(posedge (iol2clk && enabled))
begin
    if(l2b2_sio_ue_err)
        `PR_ALWAYS("l2_to_siu_mon", `ALWAYS, "Uncorrectable error detetcted by L2B2 to SIO");
end

/* L2 Bank 3*/

always @(posedge(iol2clk && enabled))
begin
    if(l2b3_sio_ctag_vld)
    begin
        `PR_ALWAYS("l2_to_siu_mon", `ALWAYS, "<l2b3,sio,,l2bsiovld,{%x}>::Read Reasponse Cycle from L2B to SIO Started", l2b3_sio_ctag_vld);
        `PR_ALWAYS("l2_to_siu_mon", `ALWAYS, "<l2b3,sio,,l2bsioopes,{%x}>::L2B TO SIU Read Response  = %x", l2b3_sio_data[23:20]);
        `PR_ALWAYS("l2_to_siu_mon", `ALWAYS, "<l2b3,sio,,l2bsiocba,{%x}>::L2B TO SIU Read Response  = %x", l2b3_sio_data[19:16]);
        `PR_ALWAYS("l2_to_siu_mon", `ALWAYS, "<l2b3,sio,,l2bsiotag,{%x}>::L2B TO SIU Read Response  = %x", l2b3_sio_data[15:0]);
    end
end

always @(posedge (iol2clk && enabled))
begin
    if(l2b3_sio_ue_err)
        `PR_ALWAYS("l2_to_siu_mon", `ALWAYS, "Uncorrectable error detetcted by L2B3 to SIO");
end

/* L2 Bank 4*/

always @(posedge(iol2clk && enabled))
begin
    if(l2b4_sio_ctag_vld)
    begin
        `PR_ALWAYS("l2_to_siu_mon", `ALWAYS, "<l2b4,sio,,l2bsiovld,{%x}>::Read Reasponse Cycle from L2B to SIO Started", l2b3_sio_ctag_vld);
        `PR_ALWAYS("l2_to_siu_mon", `ALWAYS, "<l2b4,sio,,l2bsioopes,{%x}>::L2B TO SIU Read Response  = %x", l2b4_sio_data[23:20]);
        `PR_ALWAYS("l2_to_siu_mon", `ALWAYS, "<l2b4,sio,,l2bsiocba,{%x}>::L2B TO SIU Read Response  = %x", l2b4_sio_data[19:16]);
        `PR_ALWAYS("l2_to_siu_mon", `ALWAYS, "<l2b4,sio,,l2bsiotag,{%x}>::L2B TO SIU Read Response  = %x", l2b4_sio_data[15:0]);
    end
end

always @(posedge (iol2clk && enabled))
begin
    if(l2b4_sio_ue_err)
        `PR_ALWAYS("l2_to_siu_mon", `ALWAYS, "Uncorrectable error detetcted by L2B4 to SIO");
end

/* L2 Bank 5*/

always @(posedge(iol2clk && enabled))
begin
    if(l2b5_sio_ctag_vld)
    begin
        `PR_ALWAYS("l2_to_siu_mon", `ALWAYS, "<l2b5,sio,,l2bsiovld,{%x}>::Read Reasponse Cycle from L2B to SIO Started", l2b5_sio_ctag_vld);
        `PR_ALWAYS("l2_to_siu_mon", `ALWAYS, "<l2b5,sio,,l2bsioopes,{%x}>::L2B TO SIU Read Response  = %x", l2b5_sio_data[23:20]);
        `PR_ALWAYS("l2_to_siu_mon", `ALWAYS, "<l2b5,sio,,l2bsiocba,{%x}>::L2B TO SIU Read Response  = %x", l2b5_sio_data[19:16]);
        `PR_ALWAYS("l2_to_siu_mon", `ALWAYS, "<l2b5,sio,,l2bsiotag,{%x}>::L2B TO SIU Read Response  = %x", l2b5_sio_data[15:0]);
    end
end

always @(posedge (iol2clk && enabled))
begin
    if(l2b5_sio_ue_err)
        `PR_ALWAYS("l2_to_siu_mon", `ALWAYS, "Uncorrectable error detetcted by L2B5 to SIO");
end

/* L2 Bank 6*/

always @(posedge(iol2clk && enabled))
begin
    if(l2b6_sio_ctag_vld)
    begin
        `PR_ALWAYS("l2_to_siu_mon", `ALWAYS, "<l2b6,sio,,l2bsiovld,{%x}>::Read Reasponse Cycle from L2B to SIO Started", l2b6_sio_ctag_vld);
        `PR_ALWAYS("l2_to_siu_mon", `ALWAYS, "<l2b6,sio,,l2bsioopes,{%x}>::L2B TO SIU Read Response  = %x", l2b6_sio_data[23:20]);
        `PR_ALWAYS("l2_to_siu_mon", `ALWAYS, "<l2b6,sio,,l2bsiocba,{%x}>::L2B TO SIU Read Response  = %x", l2b6_sio_data[19:16]);
        `PR_ALWAYS("l2_to_siu_mon", `ALWAYS, "<l2b6,sio,,l2bsiotag,{%x}>::L2B TO SIU Read Response  = %x", l2b6_sio_data[15:0]);
    end
end

always @(posedge (iol2clk && enabled))
begin
    if(l2b6_sio_ue_err)
        `PR_ALWAYS("l2_to_siu_mon", `ALWAYS, "Uncorrectable error detetcted by L2B6 to SIO");
end

/* L2 Bank 7*/

always @(posedge(iol2clk && enabled))
begin
    if(l2b7_sio_ctag_vld)
    begin
        `PR_ALWAYS("l2_to_siu_mon", `ALWAYS, "<l2b7,sio,,l2bsiovld,{%x}>::Read Reasponse Cycle from L2B to SIO Started", l2b7_sio_ctag_vld);
        `PR_ALWAYS("l2_to_siu_mon", `ALWAYS, "<l2b7,sio,,l2bsioopes,{%x}>::L2B TO SIU Read Response  = %x", l2b7_sio_data[23:20]);
        `PR_ALWAYS("l2_to_siu_mon", `ALWAYS, "<l2b7,sio,,l2bsiocba,{%x}>::L2B TO SIU Read Response  = %x", l2b7_sio_data[19:16]);
        `PR_ALWAYS("l2_to_siu_mon", `ALWAYS, "<l2b7,sio,,l2bsiotag,{%x}>::L2B TO SIU Read Response  = %x", l2b7_sio_data[15:0]);
    end
end

always @(posedge (iol2clk && enabled))
begin
    if(l2b7_sio_ue_err)
        `PR_ALWAYS("l2_to_siu_mon", `ALWAYS, "Uncorrectable error detetcted by L2B7 to SIO");
end



endmodule
