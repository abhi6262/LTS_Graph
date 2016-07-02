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


/* Molnitors for Single Read Response from L2 to SIO Section 6.5.1.1 Manual Vol 1 */

always @(posedge(iol2clk && enabled))
begin
    if(l2b0_sio_ctag_vld)
    begin
        `PR_ALWAYS("l2_to_siu_mon", `ALWAYS, "Read Reasponse Cycle from L2B0 to SIO Started");
        repeat (17) @(posedge iol2clk)
        begin
            `PR_INFO("l2_to_siu_mon", `INFO, "L2B0 TO SIU Read Response  = %x", l2b0_sio_data);
            `PR_INFO("l2_to_siu_mon", `INFO, "L2B0 TO SIU Read Data Parity = %x", l2b0_sio_parity);
        end
    end
end

always @(posedge (iol2clk && enabled))
begin
    if(l2b0_sio_ue_err)
        `PR_INFO("l2_to_siu_mon", `INFO, "Uncorrectable error detetcted by L2B0 to SIO", l2b0_sio_ue_err);
end


always @(posedge(iol2clk && enabled))
begin
    if(l2b1_sio_ctag_vld)
    begin
        `PR_ALWAYS("l2_to_siu_mon", `ALWAYS, "Read Reasponse Cycle from L2B1 to SIO Started");
        repeat (17) @(posedge iol2clk)
        begin
            `PR_INFO("l2_to_siu_mon", `INFO, "L2B1 TO SIU Read Response  = %x", l2b1_sio_data);
            `PR_INFO("l2_to_siu_mon", `INFO, "L2B1 TO SIU Read Data Parity = %x", l2b1_sio_parity);
        end
    end
end

always @(posedge (iol2clk && enabled))
begin
    if(l2b1_sio_ue_err)
        `PR_INFO("l2_to_siu_mon", `INFO, "Uncorrectable error detetcted by L2B1 to SIO", l2b1_sio_ue_err);
end


always @(posedge(iol2clk && enabled))
begin
    if(l2b2_sio_ctag_vld)
    begin
        `PR_ALWAYS("l2_to_siu_mon", `ALWAYS, "Read Reasponse Cycle from L2B2 to SIO Started");
        repeat (17) @(posedge iol2clk)
        begin
            `PR_INFO("l2_to_siu_mon", `INFO, "L2B2 TO SIU Read Response  = %x", l2b2_sio_data);
            `PR_INFO("l2_to_siu_mon", `INFO, "L2B2 TO SIU Read Data Parity = %x", l2b2_sio_parity);
        end
    end
end

always @(posedge (iol2clk && enabled))
begin
    if(l2b2_sio_ue_err)
        `PR_INFO("l2_to_siu_mon", `INFO, "Uncorrectable error detetcted by L2B2 to SIO", l2b2_sio_ue_err);
end


always @(posedge(iol2clk && enabled))
begin
    if(l2b3_sio_ctag_vld)
    begin
        `PR_ALWAYS("l2_to_siu_mon", `ALWAYS, "Read Reasponse Cycle from L2B3 to SIO Started");
        repeat (17) @(posedge iol2clk)
        begin
            `PR_INFO("l2_to_siu_mon", `INFO, "L2B3 TO SIU Read Response  = %x", l2b3_sio_data);
            `PR_INFO("l2_to_siu_mon", `INFO, "L2B3 TO SIU Read Data Parity = %x", l2b3_sio_parity);
        end
    end
end

always @(posedge (iol2clk && enabled))
begin
    if(l2b3_sio_ue_err)
        `PR_INFO("l2_to_siu_mon", `INFO, "Uncorrectable error detetcted by L2B3 to SIO", l2b3_sio_ue_err);
end


always @(posedge(iol2clk && enabled))
begin
    if(l2b4_sio_ctag_vld)
    begin
        `PR_ALWAYS("l2_to_siu_mon", `ALWAYS, "Read Reasponse Cycle from L2B4 to SIO Started");
        repeat (17) @(posedge iol2clk)
        begin
            `PR_INFO("l2_to_siu_mon", `INFO, "L2B4 TO SIU Read Response  = %x", l2b4_sio_data);
            `PR_INFO("l2_to_siu_mon", `INFO, "L2B4 TO SIU Read Data Parity = %x", l2b4_sio_parity);
        end
    end
end

always @(posedge (iol2clk && enabled))
begin
    if(l2b4_sio_ue_err)
        `PR_INFO("l2_to_siu_mon", `INFO, "Uncorrectable error detetcted by L2B4 to SIO", l2b4_sio_ue_err);
end


always @(posedge(iol2clk && enabled))
begin
    if(l2b5_sio_ctag_vld)
    begin
        `PR_ALWAYS("l2_to_siu_mon", `ALWAYS, "Read Reasponse Cycle from L2B5 to SIO Started");
        repeat (17) @(posedge iol2clk)
        begin
            `PR_INFO("l2_to_siu_mon", `INFO, "L2B5 TO SIU Read Response  = %x", l2b5_sio_data);
            `PR_INFO("l2_to_siu_mon", `INFO, "L2B5 TO SIU Read Data Parity = %x", l2b5_sio_parity);
        end
    end
end

always @(posedge (iol2clk && enabled))
begin
    if(l2b5_sio_ue_err)
        `PR_INFO("l2_to_siu_mon", `INFO, "Uncorrectable error detetcted by L2B5 to SIO", l2b5_sio_ue_err);
end


always @(posedge(iol2clk && enabled))
begin
    if(l2b6_sio_ctag_vld)
    begin
        `PR_ALWAYS("l2_to_siu_mon", `ALWAYS, "Read Reasponse Cycle from L2B6 to SIO Started");
        repeat (17) @(posedge iol2clk)
        begin
            `PR_INFO("l2_to_siu_mon", `INFO, "L2B6 TO SIU Read Response  = %x", l2b6_sio_data);
            `PR_INFO("l2_to_siu_mon", `INFO, "L2B6 TO SIU Read Data Parity = %x", l2b6_sio_parity);
        end
    end
end

always @(posedge (iol2clk && enabled))
begin
    if(l2b6_sio_ue_err)
        `PR_INFO("l2_to_siu_mon", `INFO, "Uncorrectable error detetcted by L2B6 to SIO", l2b6_sio_ue_err);
end


always @(posedge(iol2clk && enabled))
begin
    if(l2b7_sio_ctag_vld)
    begin
        `PR_ALWAYS("l2_to_siu_mon", `ALWAYS, "Read Reasponse Cycle from L2B7 to SIO Started");
        repeat (17) @(posedge iol2clk)
        begin
            `PR_INFO("l2_to_siu_mon", `INFO, "L2B7 TO SIU Read Response  = %x", l2b7_sio_data);
            `PR_INFO("l2_to_siu_mon", `INFO, "L2B7 TO SIU Read Data Parity = %x", l2b7_sio_parity);
        end
    end
end

always @(posedge (iol2clk && enabled))
begin
    if(l2b7_sio_ue_err)
        `PR_INFO("l2_to_siu_mon", `INFO, "Uncorrectable error detetcted by L2B7 to SIO", l2b7_sio_ue_err);
end



endmodule
