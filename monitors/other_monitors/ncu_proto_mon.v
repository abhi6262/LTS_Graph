/*

Monitor written by : Debjit Pal
Email ID: dpal2@illinois.edu
Institute: Univerisity of Illinois at Urbana-Champaign

*/

module ncu_proto_mon();

reg enabled;
reg ncu_dmu_pio_hdr_vld_d;
initial begin
    enabled = 1'b1;
    ncu_dmu_pio_hdr_vld_d = 1'b0;
    if ($test$plusargs("ncu_proto_mon_disable"))
    begin
        enabled = 1'b0;
    end
    else
        `PR_INFO("ncu_proto_mon", `INFO, "ncu_proto_mon ENABLED");
end

/* Common clock for all NCU IO Side Protocol monitoring */

wire iol2clk = `NCU.iol2clk;

/* Common clock for all NCU CPU Side Protocol monitoring */

wire cmp_clk = `CPU.l2clk

/* From NCU to DMU PIO Interface */

wire [63:0] ncu_dmu_pio_data = `NCU.ncu_dmu_pio_data;
wire ncu_dmu_pio_hdr_vld = `NCU.ncu_dmu_pio_hdr_vld;
wire dmu_ncu_wrack_vld = `NCU.dmu_ncu_wrack_vld;
wire [3:0] dmu_ncu_wrack_tag = `NCU.dmu_ncu_wrack_tag;
wire ncu_dmu_mmu_addr_vld = `NCU.ncu_dmu_mmu_addr_vld;


/* From NCU to DMU Mondo Interface */

wire [5:0] ncu_dmu_mondo_id = `NCU.ncu_dmu_mondo_id;
wire ncu_dmu_mondo_ack = `NCU.ncu_dmu_mondo_ack;
wire ncu_dmu_mondo_nack = `NCU.ncu_dmu_mondo_nack;

/* From NCU to MCU Downstream Monitoring (4 MCUs) */

wire ncu_mcu0_vld = `NCU.ncu_mcu0_vld; 
wire [3:0] ncu_mcu0_data = `NCU.ncu_mcu0_data;
wire mcu0_ncu_stall = `NCU.mcu0_ncu_stall;

wire ncu_mcu1_vld = `NCU.ncu_mcu1_vld; 
wire [3:0] ncu_mcu1_data = `NCU.ncu_mcu1_data;
wire mcu1_ncu_stall = `NCU.mcu1_ncu_stall;

wire ncu_mcu2_vld = `NCU.ncu_mcu2_vld; 
wire [3:0] ncu_mcu2_data = `NCU.ncu_mcu2_data;
wire mcu2_ncu_stall = `NCU.mcu2_ncu_stall;

wire ncu_mcu3_vld = `NCU.ncu_mcu3_vld; 
wire [3:0] ncu_mcu3_data = `NCU.ncu_mcu3_data;
wire mcu3_ncu_stall = `NCU.mcu3_ncu_stall;

/* From MCU to NCU Upstream (4 MCUs) */

wire mcu0_ncu_vld = `NCU.mcu0_ncu_vld;
wire [3:0] mcu0_ncu_data = `NCU.mcu0_ncu_data;
wire ncu_mcu0_stall = `NCU.ncu_mcu0_stall;

wire mcu1_ncu_vld = `NCU.mcu1_ncu_vld;
wire [3:0] mcu1_ncu_data = `NCU.mcu1_ncu_data;
wire ncu_mcu1_stall = `NCU.ncu_mcu1_stall;

wire mcu2_ncu_vld = `NCU.mcu2_ncu_vld;
wire [3:0] mcu2_ncu_data = `NCU.mcu2_ncu_data;
wire ncu_mcu2_stall = `NCU.ncu_mcu2_stall;

wire mcu3_ncu_vld = `NCU.mcu3_ncu_vld;
wire [3:0] mcu3_ncu_data = `NCU.mcu3_ncu_data;
wire ncu_mcu3_stall = `NCU.ncu_mcu3_stall;

/* PIO Interface monitors Section 7.4.9 Manual Vol 1, Section 1.14.4.15 Manual Vol 2 */

always @(posedge (iol2clk && enabled))
begin
    ncu_dmu_pio_hdr_vld_d <= ncu_dmu_pio_hdr_vld;
end

always @(posedge (iol2clk && enabled))
begin
    if (ncu_dmu_pio_hdr_vld)
    begin
        if(ncu_dmu_pio_data[60] == 1'b1)
        begin
            `PR_ALWAYS("ncu_proto_mon", `ALWAYS, "PIO Header Valid for PIO Reads from SIU header to NCU Credit Pool");
            `PR_INFO("ncu_proto_mon", `INFO, "Credit ID returned in PIO Read Header Data = %x", ncu_dmu_pio_data[59:56]);
        end
        else if(ncu_dmu_pio_data[60] == 1'b0)
        begin
            `PR_ALWAYS("ncu_proto_mon", `ALWAYS, "PIO Header Valid for PIO Write from DMU to NCU Credit Pool");
            if(dmu_ncu_wrack_tag != 4'bxxxx)
                `PR_INFO("ncu_proto_mon", `INFO, "DMU Returning credit = %x", dmu_ncu_wrack_tag);
        end
    end
end

always @(posedge (iol2clk && enabled && ncu_dmu_pio_hdr_vld_d))
begin
    `PR_ALWAYS("ncu_proto_mon", `ALWAYS, "Payload Cycle for PIO Write = %x", ncu_dmu_pio_data);
end

/* Mondo Interrupt Monitors Section 7.4.10 Manual Vol 1, Section 1.14.4.15 Manual Vol 2 */

always @(posedge (iol2clk && enabled))
begin
    if (ncu_dmu_mondo_ack)
    begin
        `PR_ALWAYS("ncu_proto_mon", `ALWAYS, "NCU sending Mondo Packet acknowledge (ack) to DMU for Mondo ID = %x", ncu_dmu_mondo_id);
    end
end

always @(posedge (iol2clk && enabled))
begin
    if (ncu_dmu_mondo_nack)
    begin
        `PR_ALWAYS("ncu_proto_mon", `ALWAYS, "NCU sending Mondo Packet Nacknowledge (nack) to DMU for Mondo ID = %x", ncu_dmu_mondo_id);
    end
end

/* From NCU to MCU Downstream Monitors Section 7.4.2 Manual Vol 1 */

always @(posedge (iol2clk && enabled && ncu_mcu0_vld))
begin
    if(ncu_mcu0_vld)
    begin
        `PR_ALWAYS("ncu_proto_mon", `ALWAYS, "NCU to MCU0 READ_REQ / WRITE REQ Initiated");
        `PR_ALWAYS("ncu_proto_mon", `ALWAYS, "NCU to MCU0 READ DATA / WRITE DATA Initiated");
    end
end

always @(posedge (iol2clk && enabled && mcu0_ncu_stall))
begin
    if(mcu0_ncu_stall)
    begin
        `PR_INFO("ncu_proto_mon", `INFO, "Stall Initiated from MCU0 to NCU");
    end
end

always @(posedge (iol2clk && enabled && ncu_mcu1_vld))
begin
    if(ncu_mcu1_vld)
    begin
        `PR_ALWAYS("ncu_proto_mon", `ALWAYS, "NCU to MCU1 READ_REQ / WRITE REQ Initiated");
        `PR_ALWAYS("ncu_proto_mon", `ALWAYS, "NCU to MCU1 READ DATA / WRITE DATA Initiated");
    end
end

always @(posedge (iol2clk && enabled && mcu1_ncu_stall))
begin
    if(mcu1_ncu_stall)
    begin
        `PR_INFO("ncu_proto_mon", `INFO, "Stall Initiated from MCU1 to NCU");
    end
end

always @(posedge (iol2clk && enabled && ncu_mcu2_vld))
begin
    if(ncu_mcu2_vld)
    begin
        `PR_ALWAYS("ncu_proto_mon", `ALWAYS, "NCU to MCU2 READ_REQ / WRITE REQ Initiated");
        `PR_ALWAYS("ncu_proto_mon", `ALWAYS, "NCU to MCU2 READ DATA / WRITE DATA Initiated");
    end
end

always @(posedge (iol2clk && enabled && mcu2_ncu_stall))
begin
    if(mcu2_ncu_stall)
    begin
        `PR_INFO("ncu_proto_mon", `INFO, "Stall Initiated from MCU2 to NCU");
    end
end

always @(posedge (iol2clk && enabled && ncu_mcu3_vld))
begin
    if(ncu_mcu3_vld)
    begin
        `PR_ALWAYS("ncu_proto_mon", `ALWAYS, "NCU to MCU3 READ_REQ / WRITE REQ Initiated");
        `PR_ALWAYS("ncu_proto_mon", `ALWAYS, "NCU to MCU3 READ DATA / WRITE DATA Initiated");
    end
end

/* From MCU to NCU Upstream Monitors Section 7.4.2 Manual Vol 1 */

always @(posedge (iol2clk && enabled && mcu0_ncu_vld))
begin
    if(mcu0_ncu_vld)
    begin
        `PR_ALWAYS("ncu_proto_mon", `ALWAYS, "MCU0 to NCU READ_REQ / WRITE REQ Initiated");
        `PR_ALWAYS("ncu_proto_mon", `ALWAYS, "MCU0 to NCU READ DATA / WRITE DATA Initiated");
    end
end

always @(posedge (iol2clk && enabled && ncu_mcu0_stall))
begin
    if(ncu_mcu0_stall)
    begin
        `PR_INFO("ncu_proto_mon", `INFO, "Stall Initiated from MCU0 to NCU");
    end
end

always @(posedge (iol2clk && enabled && mcu1_ncu_vld))
begin
    if(mcu1_ncu_vld)
    begin
        `PR_ALWAYS("ncu_proto_mon", `ALWAYS, "MCU1 to NCU READ_REQ / WRITE REQ Initiated");
        `PR_ALWAYS("ncu_proto_mon", `ALWAYS, "MCU1 to NCU READ DATA / WRITE DATA Initiated");
    end
end

always @(posedge (iol2clk && enabled && ncu_mcu1_stall))
begin
    if(ncu_mcu1_stall)
    begin
        `PR_INFO("ncu_proto_mon", `INFO, "Stall Initiated from MCU1 to NCU");
    end
end

always @(posedge (iol2clk && enabled && mcu2_ncu_vld))
begin
    if(mcu2_ncu_vld)
    begin
        `PR_ALWAYS("ncu_proto_mon", `ALWAYS, "MCU2 to NCU READ_REQ / WRITE REQ Initiated");
        `PR_ALWAYS("ncu_proto_mon", `ALWAYS, "MCU2 to NCU READ DATA / WRITE DATA Initiated");
    end
end

always @(posedge (iol2clk && enabled && ncu_mcu2_stall))
begin
    if(ncu_mcu2_stall)
    begin
        `PR_INFO("ncu_proto_mon", `INFO, "Stall Initiated from MCU2 to NCU");
    end
end

always @(posedge (iol2clk && enabled && mcu3_ncu_vld))
begin
    if(mcu3_ncu_vld)
    begin
        `PR_ALWAYS("ncu_proto_mon", `ALWAYS, "MCU3 to NCU READ_REQ / WRITE REQ Initiated");
        `PR_ALWAYS("ncu_proto_mon", `ALWAYS, "MCU3 to NCU READ DATA / WRITE DATA Initiated");
    end
end

always @(posedge (iol2clk && enabled && ncu_mcu3_stall))
begin
    if(ncu_mcu3_stall)
    begin
        `PR_INFO("ncu_proto_mon", `INFO, "Stall Initiated from MCU3 to NCU");
    end
end

endmodule
