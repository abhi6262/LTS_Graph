/*

Monitor written by : Debjit Pal
Email ID: dpal2@illinois.edu
Institute: Univerisity of Illinois at Urbana-Champaign

*/

module ncu_proto_mon();

reg enabled;
reg ncu_dmu_pio_hdr_vld_d;
reg ncu_cpx_req_cq_d;
reg ncu_pcx_stall_pq_strobe;
reg pcx_mcu_data_rdy_px1_strobe;
reg ncu_mcu0_vld_strobe;
reg ncu_mcu1_vld_strobe;
reg ncu_mcu2_vld_strobe;
reg ncu_mcu3_vld_strobe;
reg mcu0_ncu_vld_strobe;
reg mcu1_ncu_vld_strobe;
reg mcu2_ncu_vld_strobe;
reg mcu3_ncu_vld_strobe;

initial begin
    enabled = 1'b1;
    ncu_dmu_pio_hdr_vld_d = 1'b0;
    ncu_cpx_req_cq_d = 1'b0;
    ncu_pcx_stall_pq_strobe = 1'b0;
    pcx_mcu_data_rdy_px1_strobe = 1'b0;
	ncu_mcu0_vld_strobe = 1'b0;
	ncu_mcu1_vld_strobe = 1'b0;
	ncu_mcu2_vld_strobe = 1'b0;
	ncu_mcu3_vld_strobe = 1'b0;
	mcu0_ncu_vld_strobe = 1'b0;
	mcu1_ncu_vld_strobe = 1'b0;
	mcu2_ncu_vld_strobe = 1'b0;
	mcu3_ncu_vld_strobe = 1'b0;
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

wire cmp_clk = `CPU.l2clk;

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

/* From PCX Interface to NCU Downstream Path */

wire ncu_pcx_stall_pq = `NCU.ncu_pcx_stall_pq;
wire [129:0] pcx_ncu_data_px2 = `NCU.pcx_ncu_data_px2;
wire ocx_ncu_data_rdy_px1 = `NCU.pcx_ncu_data_rdy_px1;

/* From NCU to CPX Interface Upstream Path */

wire [7:0] cpx_ncu_grant_cx = `NCU.cpx_ncu_grant_cx;
wire [7:0] ncu_cpx_req_cq = `NCU.ncu_cpx_req_cq;
wire [145:0] ncu_cpx_data_ca = `NCU.ncu_cpx_data_ca;

/* Downstream Non-cacheable read / write monitors Section 7.4.1.1 Vol 1 */

always @(posedge (cmp_clk && enabled && !ncu_pcx_stall_pq_strobe))
begin
    if(ncu_pcx_stall_pq)
    begin
        `PR_ALWAYS("ncu_proto_mon", `ALWAYS, "NCU backpressuring PCX");
        ncu_pcx_stall_pq_strobe = 1'b1;
    end
end

always @(posedge (cmp_clk && enabled && ncu_pcx_stall_pq_strobe))
begin
    if(!ncu_pcx_stall_pq)
        ncu_pcx_stall_pq_strobe = 1'b0;
end

always @(posedge (cmp_clk && enabled && !pcx_mcu_data_rdy_px1_strobe))
begin
    if(pcx_ncu_data_rdy_px1)
    begin
        `PR_ALWAYS("ncu_proto_mon", `ALWAYS, "PCX initiating data transfer to NCU");
        pcx_mcu_data_rdy_px1_strobe = 1'b1;
    end
end

always @(posedge (cmp_clk && enabled && pcx_mcu_data_rdy_px1_strobe))
begin
    if(pcx_ncu_data_rdy_px1)
        pcx_mcu_data_rdy_px1_strobe = 1'b0;
end

/* Upstream Non-cacheable read / write monitors Section 7.4.1.2 Vol 1 */

always @(posedge (cmp_clk && enabled))
begin
    if(ncu_cpx_req_cq != 8'b0)
    begin
        `PR_ALWAYS("ncu_proto_mon", `ALWAYS, "NCU sending Request to CPX for CPU = %x", ncu_cpx_req_cq);
        ncu_cpx_req_cq_d <= ncu_cpx_req_cq;
    end
end

always @(posedge (cmp_clk && enabled))
begin
    if(ncu_cpx_req_cq_d != 8'b0)
    begin
        `PR_ALWAYS("ncu_proto_mon", `ALWAYS, "NCU transferring data to CPX for CPU = %x", ncu_cpx_req_cq_d);
    end
end

always @(posedge (cmp_clk && enabled))
begin
    if(cpx_ncu_grant_cx != 8'b0)
    begin
        `PR_ALWAYS("ncu_proto_mon", `ALWAYS, "CPX indicatuing packet reached at CPU = %x", cpx_ncu_grant_cx);
    end
end


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

always @(posedge (iol2clk && enabled && !ncu_mcu0_vld_strobe))
begin
    if(ncu_mcu0_vld)
    begin
        `PR_INFO("ncu_proto_mon", `INFO, "NCU to MCU0 Transaction Initiated");
        ncu_mcu0_vld_strobe = 1'b1;
        if(ncu_mcu0_data == 4'b0100)
            `PR_ALWAYS("ncu_proto_mon", `ALWAYS, "NCU to MCU0 READ_REQ for PCX Packet");
        else if(ncu_mcu0_data == 4'b0101)
            `PR_ALWAYS("ncu_proto_mon", `ALWAYS, "NCU to MCU0 WRITE_REQ for PCX Packet");
        else if(ncu_mcu0_data == 4'b0110)
            `PR_ALWAYS("ncu_proto_mon", `ALWAYS, "NCU to MCU0 IFILL_REQ for PCX Packet");
    end
end

always @(posedge (iol2clk && enabled && ncu_mcu0_vld_strobe))
begin
    if(!ncu_mcu0_vld)
        ncu_mcu0_vld_strobe = 1'b0;
end

always @(posedge (iol2clk && enabled && mcu0_ncu_stall))
begin
    if(mcu0_ncu_stall)
    begin
        `PR_INFO("ncu_proto_mon", `INFO, "Stall Initiated from MCU0 to NCU");
    end
end

always @(posedge (iol2clk && enabled && !ncu_mcu1_vld_strobe))
begin
    if(ncu_mcu1_vld)
    begin
        `PR_INFO("ncu_proto_mon", `INFO, "NCU to MCU1 Transaction Initiated");
        ncu_mcu1_vld_strobe = 1'b1;
        if(ncu_mcu1_data == 4'b0100)
            `PR_ALWAYS("ncu_proto_mon", `ALWAYS, "NCU to MCU1 READ_REQ for PCX Packet");
        else if(ncu_mcu1_data == 4'b0101)
            `PR_ALWAYS("ncu_proto_mon", `ALWAYS, "NCU to MCU1 WRITE_REQ for PCX Packet");
        else if(ncu_mcu1_data == 4'b0110)
            `PR_ALWAYS("ncu_proto_mon", `ALWAYS, "NCU to MCU1 IFILL_REQ for PCX Packet");
    end
end

always @(posedge (iol2clk && enabled && ncu_mcu1_vld_strobe))
begin
    if(!ncu_mcu1_vld)
        ncu_mcu1_vld_strobe = 1'b0;
end


always @(posedge (iol2clk && enabled && mcu1_ncu_stall))
begin
    if(mcu1_ncu_stall)
    begin
        `PR_INFO("ncu_proto_mon", `INFO, "Stall Initiated from MCU1 to NCU");
    end
end

always @(posedge (iol2clk && enabled && !ncu_mcu2_vld_strobe))
begin
    if(ncu_mcu2_vld)
    begin
        `PR_INFO("ncu_proto_mon", `INFO, "NCU to MCU2 Transaction Initiated");
        ncu_mcu2_vld_strobe = 1'b1;
        if(ncu_mcu2_data == 4'b0100)
            `PR_ALWAYS("ncu_proto_mon", `ALWAYS, "NCU to MCU2 READ_REQ for PCX Packet");
        else if(ncu_mcu2_data == 4'b0101)
            `PR_ALWAYS("ncu_proto_mon", `ALWAYS, "NCU to MCU2 WRITE_REQ for PCX Packet");
        else if(ncu_mcu2_data == 4'b0110)
            `PR_ALWAYS("ncu_proto_mon", `ALWAYS, "NCU to MCU2 IFILL_REQ for PCX Packet");
    end
end

always @(posedge (iol2clk && enabled && ncu_mcu2_vld_strobe))
begin
    if(!ncu_mcu2_vld)
        ncu_mcu2_vld_strobe = 1'b0;
end

always @(posedge (iol2clk && enabled && mcu2_ncu_stall))
begin
    if(mcu2_ncu_stall)
    begin
        `PR_INFO("ncu_proto_mon", `INFO, "Stall Initiated from MCU2 to NCU");
    end
end

always @(posedge (iol2clk && enabled && !ncu_mcu3_vld_strobe))
begin
    if(ncu_mcu3_vld)
    begin
        `PR_INFO("ncu_proto_mon", `INFO, "NCU to MCU3 Transaction Initiated");
        ncu_mcu3_vld_strobe = 1'b1;
        if(ncu_mcu3_data == 4'b0100)
            `PR_ALWAYS("ncu_proto_mon", `ALWAYS, "NCU to MCU3 READ_REQ for PCX Packet");
        else if(ncu_mcu3_data == 4'b0101)
            `PR_ALWAYS("ncu_proto_mon", `ALWAYS, "NCU to MCU3 WRITE_REQ for PCX Packet");
        else if(ncu_mcu3_data == 4'b0110)
            `PR_ALWAYS("ncu_proto_mon", `ALWAYS, "NCU to MCU3 IFILL_REQ for PCX Packet");
    end
end

always @(posedge (iol2clk && enabled && ncu_mcu3_vld_strobe))
begin
    if(!ncu_mcu3_vld)
        ncu_mcu3_vld_strobe = 1'b0;
end

/* From MCU to NCU Upstream Monitors Section 7.4.2 Manual Vol 1 */

always @(posedge (iol2clk && enabled && !mcu0_ncu_vld_strobe))
begin
    if(mcu0_ncu_vld)
    begin
        `PR_INFO("ncu_proto_mon", `INFO, "MCU0 to NCU Transaction Initiated");
        mcu0_ncu_vld_strobe = 1'b1;
        if(mcu0_ncu_data == 4'b0000)
            `PR_ALWAYS("ncu_proto_mon", `ALWAYS, "MCU0 to NCU READ NACK for CPX NCU Load Return");
        else if(mcu0_ncu_data == 4'b0001)
            `PR_ALWAYS("ncu_proto_mon", `ALWAYS, "MCU0 to NCU READ ACK for CPX NCU Load Reaturn");
        else if(mcu0_ncu_data == 4'b0011)
            `PR_ALWAYS("ncu_proto_mon", `ALWAYS, "MCU0 to NCU IFILL ACK for CPX NCU Ifill Return");
        else if(mcu0_ncu_data == 4'b0111)
            `PR_ALWAYS("ncu_proto_mon", `ALWAYS, "MCU0 to NCU IFILL NACK for CPX NCU Ifill Return");
        else if(mcu0_ncu_data == 4'b1000)
            `PR_ALWAYS("ncu_proto_mon", `ALWAYS, "MCU0 to NCU INT");
        else if(mcu0_ncu_data == 4'b1100)
            `PR_ALWAYS("ncu_proto_mon", `ALWAYS, "MCU0 to NCU INT_VEC");
    end
end

always @(posedge (iol2clk && enabled && mcu0_ncu_vld_strobe))
begin
    if(mcu0_ncu_vld)
        mcu0_ncu_vld_strobe = 1'b0;
end

always @(posedge (iol2clk && enabled && ncu_mcu0_stall))
begin
    if(ncu_mcu0_stall)
    begin
        `PR_INFO("ncu_proto_mon", `INFO, "Stall Initiated from MCU0 to NCU");
    end
end


always @(posedge (iol2clk && enabled && !mcu1_ncu_vld_strobe))
begin
    if(mcu1_ncu_vld)
    begin
        `PR_INFO("ncu_proto_mon", `INFO, "MCU1 to NCU Transaction Initiated");
        mcu1_ncu_vld_strobe = 1'b1;
        if(mcu1_ncu_data == 4'b0000)
            `PR_ALWAYS("ncu_proto_mon", `ALWAYS, "MCU1 to NCU READ NACK for CPX NCU Load Return");
        else if(mcu1_ncu_data == 4'b0001)
            `PR_ALWAYS("ncu_proto_mon", `ALWAYS, "MCU1 to NCU READ ACK for CPX NCU Load Reaturn");
        else if(mcu1_ncu_data == 4'b0011)
            `PR_ALWAYS("ncu_proto_mon", `ALWAYS, "MCU1 to NCU IFILL ACK for CPX NCU Ifill Return");
        else if(mcu1_ncu_data == 4'b0111)
            `PR_ALWAYS("ncu_proto_mon", `ALWAYS, "MCU1 to NCU IFILL NACK for CPX NCU Ifill Return");
        else if(mcu1_ncu_data == 4'b1000)
            `PR_ALWAYS("ncu_proto_mon", `ALWAYS, "MCU1 to NCU INT");
        else if(mcu1_ncu_data == 4'b1100)
            `PR_ALWAYS("ncu_proto_mon", `ALWAYS, "MCU1 to NCU INT_VEC");
    end
end

always @(posedge (iol2clk && enabled && mcu1_ncu_vld_strobe))
begin
    if(mcu1_ncu_vld)
        mcu1_ncu_vld_strobe = 1'b0;
end

always @(posedge (iol2clk && enabled && ncu_mcu1_stall))
begin
    if(ncu_mcu1_stall)
    begin
        `PR_INFO("ncu_proto_mon", `INFO, "Stall Initiated from MCU1 to NCU");
    end
end


always @(posedge (iol2clk && enabled && !mcu2_ncu_vld_strobe))
begin
    if(mcu2_ncu_vld)
    begin
        `PR_INFO("ncu_proto_mon", `INFO, "MCU2 to NCU Transaction Initiated");
        mcu2_ncu_vld_strobe = 1'b1;
        if(mcu2_ncu_data == 4'b0000)
            `PR_ALWAYS("ncu_proto_mon", `ALWAYS, "MCU2 to NCU READ NACK for CPX NCU Load Return");
        else if(mcu2_ncu_data == 4'b0001)
            `PR_ALWAYS("ncu_proto_mon", `ALWAYS, "MCU2 to NCU READ ACK for CPX NCU Load Reaturn");
        else if(mcu2_ncu_data == 4'b0011)
            `PR_ALWAYS("ncu_proto_mon", `ALWAYS, "MCU2 to NCU IFILL ACK for CPX NCU Ifill Return");
        else if(mcu2_ncu_data == 4'b0111)
            `PR_ALWAYS("ncu_proto_mon", `ALWAYS, "MCU2 to NCU IFILL NACK for CPX NCU Ifill Return");
        else if(mcu2_ncu_data == 4'b1000)
            `PR_ALWAYS("ncu_proto_mon", `ALWAYS, "MCU2 to NCU INT");
        else if(mcu2_ncu_data == 4'b1100)
            `PR_ALWAYS("ncu_proto_mon", `ALWAYS, "MCU2 to NCU INT_VEC");
    end
end

always @(posedge (iol2clk && enabled && mcu2_ncu_vld_strobe))
begin
    if(mcu2_ncu_vld)
        mcu2_ncu_vld_strobe = 1'b0;
end

always @(posedge (iol2clk && enabled && ncu_mcu2_stall))
begin
    if(ncu_mcu2_stall)
    begin
        `PR_INFO("ncu_proto_mon", `INFO, "Stall Initiated from MCU2 to NCU");
    end
end


always @(posedge (iol2clk && enabled && !mcu3_ncu_vld_strobe))
begin
    if(mcu3_ncu_vld)
    begin
        `PR_INFO("ncu_proto_mon", `INFO, "MCU3 to NCU Initiated");
        mcu3_ncu_vld_strobe = 1'b1;
        if(mcu3_ncu_data == 4'b0000)
            `PR_ALWAYS("ncu_proto_mon", `ALWAYS, "MCU3 to NCU READ NACK for CPX NCU Load Return");
        else if(mcu3_ncu_data == 4'b0001)
            `PR_ALWAYS("ncu_proto_mon", `ALWAYS, "MCU3 to NCU READ ACK for CPX NCU Load Reaturn");
        else if(mcu3_ncu_data == 4'b0011)
            `PR_ALWAYS("ncu_proto_mon", `ALWAYS, "MCU3 to NCU IFILL ACK for CPX NCU Ifill Return");
        else if(mcu3_ncu_data == 4'b0111)
            `PR_ALWAYS("ncu_proto_mon", `ALWAYS, "MCU3 to NCU IFILL NACK for CPX NCU Ifill Return");
        else if(mcu3_ncu_data == 4'b1000)
            `PR_ALWAYS("ncu_proto_mon", `ALWAYS, "MCU3 to NCU INT");
        else if(mcu3_ncu_data == 4'b1100)
            `PR_ALWAYS("ncu_proto_mon", `ALWAYS, "MCU3 to NCU INT_VEC");
    end
end

always @(posedge (iol2clk && enabled && mcu3_ncu_vld_strobe))
begin
    if(mcu3_ncu_vld)
        mcu3_ncu_vld_strobe = 1'b0;
end

always @(posedge (iol2clk && enabled && ncu_mcu3_stall))
begin
    if(ncu_mcu3_stall)
    begin
        `PR_INFO("ncu_proto_mon", `INFO, "Stall Initiated from MCU3 to NCU");
    end
end

endmodule
