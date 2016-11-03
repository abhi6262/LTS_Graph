/*

Monitor written by : Debjit Pal
Email ID: dpal2@illinois.edu
Institute: Univerisity of Illinois at Urbana-Champaign

*/

module ncu_proto_mon();

reg enabled;
reg ncu_dmu_pio_hdr_vld_d;
reg [7:0] ncu_cpx_req_cq_d;
reg ncu_pcx_stall_pq_strobe;
reg pcx_ncu_data_rdy_px1_strobe;
reg pcx_ncu_data_rdy_px1_d;

reg ncu_mcu0_vld_strobe;
reg ncu_mcu1_vld_strobe;
reg ncu_mcu2_vld_strobe;
reg ncu_mcu3_vld_strobe;

reg mcu0_ncu_vld_strobe;
reg mcu1_ncu_vld_strobe;
reg mcu2_ncu_vld_strobe;
reg mcu3_ncu_vld_strobe;

reg [127:0] mcu3_ncu_data_packet;
reg [127:0] mcu2_ncu_data_packet;
reg [127:0] mcu1_ncu_data_packet;
reg [127:0] mcu0_ncu_data_packet;

integer N3_mn;
integer N2_mn;
integer N1_mn;
integer N0_mn;

reg [127:0] ncu_mcu3_data_packet;
reg [127:0] ncu_mcu2_data_packet;
reg [127:0] ncu_mcu1_data_packet;
reg [127:0] ncu_mcu0_data_packet;

integer N3_nm;
integer N2_nm;
integer N1_nm;
integer N0_nm;

initial begin
    enabled = 1'b1;
    ncu_dmu_pio_hdr_vld_d = 1'b0;
    ncu_cpx_req_cq_d = 8'b0;
    ncu_pcx_stall_pq_strobe = 1'b0;
    pcx_ncu_data_rdy_px1_strobe = 1'b0;
    pcx_ncu_data_rdy_px1_d = 1'b0;

	ncu_mcu0_vld_strobe = 1'b0;
	ncu_mcu1_vld_strobe = 1'b0;
	ncu_mcu2_vld_strobe = 1'b0;
	ncu_mcu3_vld_strobe = 1'b0;

	mcu0_ncu_vld_strobe = 1'b0;
	mcu1_ncu_vld_strobe = 1'b0;
	mcu2_ncu_vld_strobe = 1'b0;
	mcu3_ncu_vld_strobe = 1'b0;

    mcu3_ncu_data_packet = 128'bx;
    mcu2_ncu_data_packet = 128'bx;
    mcu1_ncu_data_packet = 128'bx;
    mcu0_ncu_data_packet = 128'bx;

    N3_mn = 0;
    N2_mn = 0;
    N1_mn = 0;
    N0_mn = 0;

    ncu_mcu3_data_packet = 128'bx;
    ncu_mcu2_data_packet = 128'bx;
    ncu_mcu1_data_packet = 128'bx;
    ncu_mcu0_data_packet = 128'bx;

    N3_nm = 0;
    N2_nm = 0;
    N1_nm = 0;
    N0_nm = 0;

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
wire pcx_ncu_data_rdy_px1 = `NCU.pcx_ncu_data_rdy_px1;

/* From NCU to CPX Interface Upstream Path */

wire [7:0] cpx_ncu_grant_cx = `NCU.cpx_ncu_grant_cx;
wire [7:0] ncu_cpx_req_cq = `NCU.ncu_cpx_req_cq;
wire [145:0] ncu_cpx_data_ca = `NCU.ncu_cpx_data_ca;

/* Downstream Non-cacheable read / write monitors Section 7.4.1.1 Vol 1 */

always @(posedge (cmp_clk && enabled && !ncu_pcx_stall_pq_strobe))
begin
    if(ncu_pcx_stall_pq)
    begin
        `PR_ALWAYS("ncu_proto_mon", `ALWAYS, "<ncu,pcx,,backpressurestall,{%x}>::NCU backpressuring PCX", ncu_pcx_stall_pq);
        ncu_pcx_stall_pq_strobe = 1'b1;
    end
end

always @(posedge (cmp_clk && enabled && ncu_pcx_stall_pq_strobe))
begin
    if(!ncu_pcx_stall_pq)
        ncu_pcx_stall_pq_strobe = 1'b0;
end

always @(posedge (cmp_clk && enabled && !pcx_ncu_data_rdy_px1_strobe))
begin
    if(pcx_ncu_data_rdy_px1)
    begin
        `PR_ALWAYS("ncu_proto_mon", `ALWAYS, "<pcx,ncu,,initdatatxfr,{%x}>::PCX initiating data transfer to NCU", pcx_ncu_data_rdy_px1);
        pcx_ncu_data_rdy_px1_strobe = 1'b1;
    end
end

always @(posedge (cmp_clk && enabled && pcx_ncu_data_rdy_px1_strobe))
begin
    if(!pcx_ncu_data_rdy_px1)
        pcx_ncu_data_rdy_px1_strobe = 1'b0;
end

always @(posedge (cmp_clk && enabled))
begin
    pcx_ncu_data_rdy_px1_d <= pcx_ncu_data_rdy_px1;
end

always @(posedge (cmp_clk && enabled && pcx_ncu_data_rdy_px1_d))
begin
    if(pcx_ncu_data_rdy_px1_d)
        `PR_ALWAYS("ncu_proto_mon", `ALWAYS, "<pcx,ncu,,datatxfr,{%x}>::PCX Sending data to NCU", pcx_ncu_data_px2);
end


/* Upstream Non-cacheable read / write monitors Section 7.4.1.2 Vol 1 */

always @(posedge (cmp_clk && enabled))
begin
    if(ncu_cpx_req_cq != 8'b0)
    begin
        `PR_ALWAYS("ncu_proto_mon", `ALWAYS, "<ncu,cpx,,ncucpxreq,{%x}>::NCU sending Request to CPX", ncu_cpx_req_cq);
    end
    ncu_cpx_req_cq_d <= ncu_cpx_req_cq;
end

always @(posedge (cmp_clk && enabled))
begin
    if(ncu_cpx_req_cq_d != 8'b0)
    begin
        `PR_ALWAYS("ncu_proto_mon", `ALWAYS, "<ncu,cpx,,ncucpxdata,{%x,%x}>::NCU transferring data to CPX for CPU", ncu_cpx_data_ca, ncu_cpx_req_cq_d);
    end
end

always @(posedge (cmp_clk && enabled))
begin
    if(cpx_ncu_grant_cx != 8'b0)
    begin
        `PR_ALWAYS("ncu_proto_mon", `ALWAYS, "<cpx,ncu,,cpxncugnt,{%x}>::CPX indicating packet reached at CPU", cpx_ncu_grant_cx);
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
        `PR_ALWAYS("ncu_proto_mon", `ALWAYS, "<ncu,dmu,,pioheader,{%x}>::PIO Header Valid for PIO Operations", ncu_dmu_pio_hdr_vld);
        if(ncu_dmu_pio_data[60] == 1'b1)
        begin
            `PR_ALWAYS("ncu_proto_mon", `ALWAYS, "<ncu,dmu,pioread,pioreadwrite,{%x}>::PIO Header Valid for PIO Reads from NCU to DMU", ncu_dmu_pio_data[60]);
            `PR_ALWAYS("ncu_proto_mon", `ALWAYS, "<ncu,dmu,pioread,ncucredid,{%x}>::Credit ID Associated with PIO Read", ncu_dmu_pio_data[59:56]);
            /* Breaking NCU PIO ID*/
            `PR_ALWAYS("ncu_proto_mon", `ALWAYS, "<ncu,dmu,pioread,bufid,{%x}>::Buffer ID Associated with PIO Read", ncu_dmu_pio_data[47:46]);
            `PR_ALWAYS("ncu_proto_mon", `ALWAYS, "<ncu,dmu,pioread,cputhreadid,{%x}>::CPU Thread ID Associated with PIO Read", ncu_dmu_pio_data[45:40]);
            /* Breaking NCU PIO ID*/
            `PR_ALWAYS("ncu_proto_mon", `ALWAYS, "<ncu,dmu,pioread,busaddr,{%x}>::PCX Bus Address Associated with PIO Read", ncu_dmu_pio_data[35:0]);
        end
        else if(ncu_dmu_pio_data[60] == 1'b0)
        begin
            `PR_ALWAYS("ncu_proto_mon", `ALWAYS, "<ncu,dmu,piowrite,pioreadwrite,{%x}>::PIO Header Valid for PIO Write from NCU to DMU", ncu_dmu_pio_data[60]);
            `PR_ALWAYS("ncu_proto_mon", `ALWAYS, "<ncu,dmu,piowrite,ncucredid,{%x}>::Credit ID Associated with PIO Write", ncu_dmu_pio_data[59:56]);
            /* Breaking NCU PIO ID*/
            `PR_ALWAYS("ncu_proto_mon", `ALWAYS, "<ncu,dmu,piowrite,bufid,{%x}>::Buffer ID Associated with PIO Write", ncu_dmu_pio_data[47:46]);
            `PR_ALWAYS("ncu_proto_mon", `ALWAYS, "<ncu,dmu,piowrite,cputhwriteid,{%x}>::CPU Thwrite ID Associated with PIO Write", ncu_dmu_pio_data[45:40]);
            /* Breaking NCU PIO ID*/
            `PR_ALWAYS("ncu_proto_mon", `ALWAYS, "<ncu,dmu,piowrite,busaddr,{%x}>::PCX Bus Address Associated with PIO Write", ncu_dmu_pio_data[35:0]);
        end
    end
end


always @(posedge (iol2clk && enabled))
begin
    if(dmu_ncu_wrack_vld)
    begin
        `PR_ALWAYS("ncu_proto_mon", `ALWAYS, "<dmu,ncu,piowritecompletion,ncucredvld,{%x}>::PIO Write Completion Ack from DMU to NCU", dmu_ncu_wrack_vld);
        `PR_ALWAYS("ncu_proto_mon", `ALWAYS, "<dmu,ncu,piowritecompletion,ncucredid,{%x}>::PIO Write Completion Returning NCU Credit from DMU to NCU", dmu_ncu_wrack_tag);
    end
end

always @(posedge (iol2clk && enabled && ncu_dmu_pio_hdr_vld_d))
begin
    `PR_ALWAYS("ncu_proto_mon", `ALWAYS, "<ncu,dmu,piowrite,piopayload>::Payload Cycle for PIO Write");
end

/* Mondo Interrupt Monitors Section 7.4.10 Manual Vol 1, Section 1.14.4.15 Manual Vol 2 */

always @(posedge (iol2clk && enabled))
begin
    if (ncu_dmu_mondo_ack)
    begin
        `PR_ALWAYS("ncu_proto_mon", `ALWAYS, "<ncu,dmu,mondoint,ack,{%x}>::NCU to DMU Mondo Interrupt Qualified with ACK", ncu_dmu_mondo_ack);
        `PR_ALWAYS("ncu_proto_mon", `ALWAYS, "<ncu,dmu,mondoint,mondoid,{%x}>::NCU to DMU Mondo Interrupt ID", ncu_dmu_mondo_id);
    end
end

always @(posedge (iol2clk && enabled))
begin
    if (ncu_dmu_mondo_nack)
    begin
        `PR_ALWAYS("ncu_proto_mon", `ALWAYS, "<ncu,dmu,mondoint,nack,{%x}>::NCU to DMU Mondo Interrupt Qualified with NACK", ncu_dmu_mondo_nack);
        `PR_ALWAYS("ncu_proto_mon", `ALWAYS, "<ncu,dmu,mondoint,mondoid,{%x}>::NCU to DMU Mondo Interrupt ID", ncu_dmu_mondo_id);
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
            `PR_ALWAYS("ncu_proto_mon", `ALWAYS, "<ncu,mcu0,,readreqpcx,{%x,%x}>::NCU to MCU0 READ_REQ for PCX Packet", ncu_mcu0_vld, ncu_mcu0_data);
        else if(ncu_mcu0_data == 4'b0101)
            `PR_ALWAYS("ncu_proto_mon", `ALWAYS, "<ncu,mcu0,,writereqpcx,{%x,%x}>::NCU to MCU0 WRITE_REQ for PCX Packet", ncu_mcu0_vld, ncu_mcu0_data);
        else if(ncu_mcu0_data == 4'b0110)
            `PR_ALWAYS("ncu_proto_mon", `ALWAYS, "<ncu,mcu0,,ifillpcx,{%x,%x}>::NCU to MCU0 IFILL_REQ for PCX Packet", ncu_mcu0_vld, ncu_mcu0_data);
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
        `PR_ALWAYS("ncu_proto_mon", `ALWAYS, "<mcu0,ncu,,stall>::Stall Initiated from MCU0 to NCU");
    end
end

always @(posedge (iol2clk && enabled))
begin
    if(ncu_mcu0_vld && !mcu0_ncu_stall && N0_nm < 32)
    begin
        case(N0_nm)
            0: ncu_mcu0_data_packet[3:0] = ncu_mcu0_data;
            1: ncu_mcu0_data_packet[7:4] = ncu_mcu0_data;
            2: ncu_mcu0_data_packet[11:8] = ncu_mcu0_data;
            3: ncu_mcu0_data_packet[15:12] = ncu_mcu0_data;
            4: ncu_mcu0_data_packet[19:16] = ncu_mcu0_data;
            5: ncu_mcu0_data_packet[23:20] = ncu_mcu0_data;
            6: ncu_mcu0_data_packet[27:24] = ncu_mcu0_data;
            7: ncu_mcu0_data_packet[31:28] = ncu_mcu0_data;
            8: ncu_mcu0_data_packet[35:32] = ncu_mcu0_data;
            9: ncu_mcu0_data_packet[39:36] = ncu_mcu0_data;
            10: ncu_mcu0_data_packet[43:40] = ncu_mcu0_data;
            11: ncu_mcu0_data_packet[47:44] = ncu_mcu0_data;
            12: ncu_mcu0_data_packet[51:48] = ncu_mcu0_data;
            13: ncu_mcu0_data_packet[55:52] = ncu_mcu0_data;
            14: ncu_mcu0_data_packet[59:56] = ncu_mcu0_data;
            15: ncu_mcu0_data_packet[63:60] = ncu_mcu0_data;
            16: ncu_mcu0_data_packet[67:64] = ncu_mcu0_data;
            17: ncu_mcu0_data_packet[71:68] = ncu_mcu0_data;
            18: ncu_mcu0_data_packet[75:72] = ncu_mcu0_data;
            19: ncu_mcu0_data_packet[79:76] = ncu_mcu0_data;
            20: ncu_mcu0_data_packet[83:80] = ncu_mcu0_data;
            21: ncu_mcu0_data_packet[87:84] = ncu_mcu0_data;
            22: ncu_mcu0_data_packet[91:88] = ncu_mcu0_data;
            23: ncu_mcu0_data_packet[95:92] = ncu_mcu0_data;
            24: ncu_mcu0_data_packet[99:96] = ncu_mcu0_data;
            25: ncu_mcu0_data_packet[103:100] = ncu_mcu0_data;
            26: ncu_mcu0_data_packet[107:104] = ncu_mcu0_data;
            27: ncu_mcu0_data_packet[111:108] = ncu_mcu0_data;
            28: ncu_mcu0_data_packet[115:112] = ncu_mcu0_data;
            29: ncu_mcu0_data_packet[119:116] = ncu_mcu0_data;
            30: ncu_mcu0_data_packet[123:120] = ncu_mcu0_data;
            31: ncu_mcu0_data_packet[127:124] = ncu_mcu0_data;
        endcase
        N0_nm = N0_nm + 1;
    end
    else if (!ncu_mcu0_vld && N0_nm == 32)
    begin
        `PR_ALWAYS("ncu_proto_mon", `ALWAYS, "<ncu,mcu0,,threadid,{%x}>::NCU to MCU Packet from CPU Source Thread", ncu_mcu0_data_packet[6:4]);
        `PR_ALWAYS("ncu_proto_mon", `ALWAYS, "<ncu,mcu0,,cpuid,{%x}>::NCU to MCU Packet from Source CPU ", ncu_mcu0_data_packet[9:7]);
        `PR_ALWAYS("ncu_proto_mon", `ALWAYS, "<ncu,mcu0,,bufferid,{%x}>::NCU to MCU Packet Origin", ncu_mcu0_data_packet[11:10]);
        `PR_ALWAYS("ncu_proto_mon", `ALWAYS, "<ncu,mcu0,,paaddr,{%x}>::NCU to MCU Packet PD", ncu_mcu0_data_packet[54:15]);
        ncu_mcu0_data_packet = 128'bx;
        N0_nm = 0;
    end
    else if (!ncu_mcu0_vld)
    begin
        ncu_mcu0_data_packet = 128'bx;
        N0_nm = 0;
    end
end

always @(posedge (iol2clk && enabled && !ncu_mcu1_vld_strobe))
begin
    if(ncu_mcu1_vld)
    begin
        `PR_INFO("ncu_proto_mon", `INFO, "NCU to MCU1 Transaction Initiated");
        ncu_mcu1_vld_strobe = 1'b1;
        if(ncu_mcu1_data == 4'b0100)
            `PR_ALWAYS("ncu_proto_mon", `ALWAYS, "<ncu,mcu1,,readreqpcx,{%x,%x}>::NCU to MCU1 READ_REQ for PCX Packet", ncu_mcu1_vld, ncu_mcu1_data);
        else if(ncu_mcu1_data == 4'b0101)
            `PR_ALWAYS("ncu_proto_mon", `ALWAYS, "<ncu,mcu1,,writereqpcx,{%x,%x}>::NCU to MCU1 WRITE_REQ for PCX Packet", ncu_mcu1_vld, ncu_mcu1_data);
        else if(ncu_mcu1_data == 4'b0110)
            `PR_ALWAYS("ncu_proto_mon", `ALWAYS, "<ncu,mcu1,,ifillpcx,{%x,%x}>::NCU to MCU1 IFILL_REQ for PCX Packet", ncu_mcu1_vld, ncu_mcu1_data);
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
        `PR_ALWAYS("ncu_proto_mon", `ALWAYS, "<mcu1,ncu,,stall>::Stall Initiated from MCU1 to NCU");
    end
end

//// Packet Construction Code for the NCU to MCU downstream Packet (May be unstable) ////
always @(posedge (iol2clk && enabled))
begin
    if(ncu_mcu1_vld && !mcu1_ncu_stall && N1_nm < 32)
    begin
        case(N1_nm)
            0: ncu_mcu1_data_packet[3:0] = ncu_mcu1_data;
            1: ncu_mcu1_data_packet[7:4] = ncu_mcu1_data;
            2: ncu_mcu1_data_packet[11:8] = ncu_mcu1_data;
            3: ncu_mcu1_data_packet[15:12] = ncu_mcu1_data;
            4: ncu_mcu1_data_packet[19:16] = ncu_mcu1_data;
            5: ncu_mcu1_data_packet[23:20] = ncu_mcu1_data;
            6: ncu_mcu1_data_packet[27:24] = ncu_mcu1_data;
            7: ncu_mcu1_data_packet[31:28] = ncu_mcu1_data;
            8: ncu_mcu1_data_packet[35:32] = ncu_mcu1_data;
            9: ncu_mcu1_data_packet[39:36] = ncu_mcu1_data;
            10: ncu_mcu1_data_packet[43:40] = ncu_mcu1_data;
            11: ncu_mcu1_data_packet[47:44] = ncu_mcu1_data;
            12: ncu_mcu1_data_packet[51:48] = ncu_mcu1_data;
            13: ncu_mcu1_data_packet[55:52] = ncu_mcu1_data;
            14: ncu_mcu1_data_packet[59:56] = ncu_mcu1_data;
            15: ncu_mcu1_data_packet[63:60] = ncu_mcu1_data;
            16: ncu_mcu1_data_packet[67:64] = ncu_mcu1_data;
            17: ncu_mcu1_data_packet[71:68] = ncu_mcu1_data;
            18: ncu_mcu1_data_packet[75:72] = ncu_mcu1_data;
            19: ncu_mcu1_data_packet[79:76] = ncu_mcu1_data;
            20: ncu_mcu1_data_packet[83:80] = ncu_mcu1_data;
            21: ncu_mcu1_data_packet[87:84] = ncu_mcu1_data;
            22: ncu_mcu1_data_packet[91:88] = ncu_mcu1_data;
            23: ncu_mcu1_data_packet[95:92] = ncu_mcu1_data;
            24: ncu_mcu1_data_packet[99:96] = ncu_mcu1_data;
            25: ncu_mcu1_data_packet[103:100] = ncu_mcu1_data;
            26: ncu_mcu1_data_packet[107:104] = ncu_mcu1_data;
            27: ncu_mcu1_data_packet[111:108] = ncu_mcu1_data;
            28: ncu_mcu1_data_packet[115:112] = ncu_mcu1_data;
            29: ncu_mcu1_data_packet[119:116] = ncu_mcu1_data;
            30: ncu_mcu1_data_packet[123:120] = ncu_mcu1_data;
            31: ncu_mcu1_data_packet[127:124] = ncu_mcu1_data;
        endcase
        N1_nm = N1_nm + 1;
    end
    else if (!ncu_mcu1_vld && N1_nm == 32)
    begin
        `PR_ALWAYS("ncu_proto_mon", `ALWAYS, "<ncu,mcu1,,threadid,{%x}>::NCU to MCU Packet from CPU Source Thread", ncu_mcu1_data_packet[6:4]);
        `PR_ALWAYS("ncu_proto_mon", `ALWAYS, "<ncu,mcu1,,cpuid,{%x}>::NCU to MCU Packet from Source CPU ", ncu_mcu1_data_packet[9:7]);
        `PR_ALWAYS("ncu_proto_mon", `ALWAYS, "<ncu,mcu1,,bufferid,{%x}>::NCU to MCU Packet Origin", ncu_mcu1_data_packet[11:10]);
        `PR_ALWAYS("ncu_proto_mon", `ALWAYS, "<ncu,mcu1,,paaddr,{%x}>::NCU to MCU Packet PD", ncu_mcu1_data_packet[54:15]);
        ncu_mcu1_data_packet = 128'bx;
        N1_nm = 0;
    end
    else if (!ncu_mcu1_vld)
    begin
        ncu_mcu1_data_packet = 128'bx;
        N1_nm = 0;
    end
end
//// Packet Construction Code for the NCU to MCU downstream Packet (May be unstable) ////


always @(posedge (iol2clk && enabled && !ncu_mcu2_vld_strobe))
begin
    if(ncu_mcu2_vld)
    begin
        `PR_INFO("ncu_proto_mon", `INFO, "NCU to MCU2 Transaction Initiated");
        ncu_mcu2_vld_strobe = 1'b1;
        if(ncu_mcu2_data == 4'b0100)
            `PR_ALWAYS("ncu_proto_mon", `ALWAYS, "<ncu,mcu2,,readreqpcx,{%x,%x}>::NCU to MCU2 READ_REQ for PCX Packet", ncu_mcu2_vld, ncu_mcu2_data);
        else if(ncu_mcu2_data == 4'b0101)
            `PR_ALWAYS("ncu_proto_mon", `ALWAYS, "<ncu,mcu2,,writereqpcx,{%x,%x}>::NCU to MCU2 WRITE_REQ for PCX Packet", ncu_mcu2_vld, ncu_mcu2_data);
        else if(ncu_mcu2_data == 4'b0110)
            `PR_ALWAYS("ncu_proto_mon", `ALWAYS, "<ncu,mcu2,,ifillpcx,{%x,%x}>::NCU to MCU2 IFILL_REQ for PCX Packet", ncu_mcu2_vld, ncu_mcu2_data);
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
        `PR_ALWAYS("ncu_proto_mon", `ALWAYS, "<mcu2,ncu,,stall>::Stall Initiated from MCU2 to NCU");
    end
end

//// Packet Construction Code for the NCU to MCU downstream Packet (May be unstable) ////
always @(posedge (iol2clk && enabled))
begin
    if(ncu_mcu2_vld && !mcu2_ncu_stall && N2_nm < 32)
    begin
        case(N2_nm)
            0: ncu_mcu2_data_packet[3:0] = ncu_mcu2_data;
            1: ncu_mcu2_data_packet[7:4] = ncu_mcu2_data;
            2: ncu_mcu2_data_packet[11:8] = ncu_mcu2_data;
            3: ncu_mcu2_data_packet[15:12] = ncu_mcu2_data;
            4: ncu_mcu2_data_packet[19:16] = ncu_mcu2_data;
            5: ncu_mcu2_data_packet[23:20] = ncu_mcu2_data;
            6: ncu_mcu2_data_packet[27:24] = ncu_mcu2_data;
            7: ncu_mcu2_data_packet[31:28] = ncu_mcu2_data;
            8: ncu_mcu2_data_packet[35:32] = ncu_mcu2_data;
            9: ncu_mcu2_data_packet[39:36] = ncu_mcu2_data;
            10: ncu_mcu2_data_packet[43:40] = ncu_mcu2_data;
            11: ncu_mcu2_data_packet[47:44] = ncu_mcu2_data;
            12: ncu_mcu2_data_packet[51:48] = ncu_mcu2_data;
            13: ncu_mcu2_data_packet[55:52] = ncu_mcu2_data;
            14: ncu_mcu2_data_packet[59:56] = ncu_mcu2_data;
            15: ncu_mcu2_data_packet[63:60] = ncu_mcu2_data;
            16: ncu_mcu2_data_packet[67:64] = ncu_mcu2_data;
            17: ncu_mcu2_data_packet[71:68] = ncu_mcu2_data;
            18: ncu_mcu2_data_packet[75:72] = ncu_mcu2_data;
            19: ncu_mcu2_data_packet[79:76] = ncu_mcu2_data;
            20: ncu_mcu2_data_packet[83:80] = ncu_mcu2_data;
            21: ncu_mcu2_data_packet[87:84] = ncu_mcu2_data;
            22: ncu_mcu2_data_packet[91:88] = ncu_mcu2_data;
            23: ncu_mcu2_data_packet[95:92] = ncu_mcu2_data;
            24: ncu_mcu2_data_packet[99:96] = ncu_mcu2_data;
            25: ncu_mcu2_data_packet[103:100] = ncu_mcu2_data;
            26: ncu_mcu2_data_packet[107:104] = ncu_mcu2_data;
            27: ncu_mcu2_data_packet[111:108] = ncu_mcu2_data;
            28: ncu_mcu2_data_packet[115:112] = ncu_mcu2_data;
            29: ncu_mcu2_data_packet[119:116] = ncu_mcu2_data;
            30: ncu_mcu2_data_packet[123:120] = ncu_mcu2_data;
            31: ncu_mcu2_data_packet[127:124] = ncu_mcu2_data;
        endcase
        N2_nm = N2_nm + 1;
    end
    else if (!ncu_mcu2_vld && N2_nm == 32)
    begin
        `PR_ALWAYS("ncu_proto_mon", `ALWAYS, "<ncu,mcu2,,threadid,{%x}>::NCU to MCU Packet from CPU Source Thread", ncu_mcu2_data_packet[6:4]);
        `PR_ALWAYS("ncu_proto_mon", `ALWAYS, "<ncu,mcu2,,cpuid,{%x}>::NCU to MCU Packet from Source CPU ", ncu_mcu2_data_packet[9:7]);
        `PR_ALWAYS("ncu_proto_mon", `ALWAYS, "<ncu,mcu2,,bufferid,{%x}>::NCU to MCU Packet Origin", ncu_mcu2_data_packet[11:10]);
        `PR_ALWAYS("ncu_proto_mon", `ALWAYS, "<ncu,mcu2,,paaddr,{%x}>::NCU to MCU Packet PD", ncu_mcu2_data_packet[54:15]);
        ncu_mcu2_data_packet = 128'bx;
        N2_nm = 0;
    end
    else if (!ncu_mcu2_vld)
    begin
        ncu_mcu2_data_packet = 128'bx;
        N2_nm = 0;
    end
end
//// Packet Construction Code for the NCU to MCU downstream Packet (May be unstable) ////


always @(posedge (iol2clk && enabled && !ncu_mcu3_vld_strobe))
begin
    if(ncu_mcu3_vld)
    begin
        `PR_INFO("ncu_proto_mon", `INFO, "NCU to MCU3 Transaction Initiated");
        ncu_mcu3_vld_strobe = 1'b1;
        if(ncu_mcu3_data == 4'b0100)
            `PR_ALWAYS("ncu_proto_mon", `ALWAYS, "<ncu,mcu3,,readreqpcx,{%x,%x}>::NCU to MCU3 READ_REQ for PCX Packet", ncu_mcu3_vld, ncu_mcu3_data);
        else if(ncu_mcu3_data == 4'b0101)
            `PR_ALWAYS("ncu_proto_mon", `ALWAYS, "<ncu,mcu3,,writereqpcx,{%x,%x}>::NCU to MCU3 WRITE_REQ for PCX Packet", ncu_mcu3_vld, ncu_mcu3_data);
        else if(ncu_mcu3_data == 4'b0110)
            `PR_ALWAYS("ncu_proto_mon", `ALWAYS, "<ncu,mcu3,,ifillpcx,{%x,%x}>::NCU to MCU3 IFILL_REQ for PCX Packet", ncu_mcu3_vld, ncu_mcu3_data);
    end
end

always @(posedge (iol2clk && enabled && ncu_mcu3_vld_strobe))
begin
    if(!ncu_mcu3_vld)
        ncu_mcu3_vld_strobe = 1'b0;
end

always @(posedge (iol2clk && enabled && mcu3_ncu_stall))
begin
    if(mcu3_ncu_stall)
    begin
        `PR_ALWAYS("ncu_proto_mon", `ALWAYS, "<mcu3,ncu,,stall>::Stall Initiated from MCU3 to NCU");
    end
end

//// Packet Construction Code for the NCU to MCU downstream Packet (May be unstable) ////
always @(posedge (iol2clk && enabled))
begin
    if(ncu_mcu3_vld && !mcu3_ncu_stall && N3_nm < 32)
    begin
        case(N3_nm)
            0: ncu_mcu3_data_packet[3:0] = ncu_mcu3_data;
            1: ncu_mcu3_data_packet[7:4] = ncu_mcu3_data;
            2: ncu_mcu3_data_packet[11:8] = ncu_mcu3_data;
            3: ncu_mcu3_data_packet[15:12] = ncu_mcu3_data;
            4: ncu_mcu3_data_packet[19:16] = ncu_mcu3_data;
            5: ncu_mcu3_data_packet[23:20] = ncu_mcu3_data;
            6: ncu_mcu3_data_packet[27:24] = ncu_mcu3_data;
            7: ncu_mcu3_data_packet[31:28] = ncu_mcu3_data;
            8: ncu_mcu3_data_packet[35:32] = ncu_mcu3_data;
            9: ncu_mcu3_data_packet[39:36] = ncu_mcu3_data;
            10: ncu_mcu3_data_packet[43:40] = ncu_mcu3_data;
            11: ncu_mcu3_data_packet[47:44] = ncu_mcu3_data;
            12: ncu_mcu3_data_packet[51:48] = ncu_mcu3_data;
            13: ncu_mcu3_data_packet[55:52] = ncu_mcu3_data;
            14: ncu_mcu3_data_packet[59:56] = ncu_mcu3_data;
            15: ncu_mcu3_data_packet[63:60] = ncu_mcu3_data;
            16: ncu_mcu3_data_packet[67:64] = ncu_mcu3_data;
            17: ncu_mcu3_data_packet[71:68] = ncu_mcu3_data;
            18: ncu_mcu3_data_packet[75:72] = ncu_mcu3_data;
            19: ncu_mcu3_data_packet[79:76] = ncu_mcu3_data;
            20: ncu_mcu3_data_packet[83:80] = ncu_mcu3_data;
            21: ncu_mcu3_data_packet[87:84] = ncu_mcu3_data;
            22: ncu_mcu3_data_packet[91:88] = ncu_mcu3_data;
            23: ncu_mcu3_data_packet[95:92] = ncu_mcu3_data;
            24: ncu_mcu3_data_packet[99:96] = ncu_mcu3_data;
            25: ncu_mcu3_data_packet[103:100] = ncu_mcu3_data;
            26: ncu_mcu3_data_packet[107:104] = ncu_mcu3_data;
            27: ncu_mcu3_data_packet[111:108] = ncu_mcu3_data;
            28: ncu_mcu3_data_packet[115:112] = ncu_mcu3_data;
            29: ncu_mcu3_data_packet[119:116] = ncu_mcu3_data;
            30: ncu_mcu3_data_packet[123:120] = ncu_mcu3_data;
            31: ncu_mcu3_data_packet[127:124] = ncu_mcu3_data;
        endcase
        N3_nm = N3_nm + 1;
    end
    else if (!ncu_mcu3_vld && N3_nm == 32)
    begin
        `PR_ALWAYS("ncu_proto_mon", `ALWAYS, "<ncu,mcu3,,threadid,{%x}>::NCU to MCU Packet from CPU Source Thread", ncu_mcu3_data_packet[6:4]);
        `PR_ALWAYS("ncu_proto_mon", `ALWAYS, "<ncu,mcu3,,cpuid,{%x}>::NCU to MCU Packet from Source CPU ", ncu_mcu3_data_packet[9:7]);
        `PR_ALWAYS("ncu_proto_mon", `ALWAYS, "<ncu,mcu3,,bufferid,{%x}>::NCU to MCU Packet Origin", ncu_mcu3_data_packet[11:10]);
        `PR_ALWAYS("ncu_proto_mon", `ALWAYS, "<ncu,mcu3,,paaddr,{%x}>::NCU to MCU Packet PD", ncu_mcu3_data_packet[54:15]);
        ncu_mcu3_data_packet = 128'bx;
        N3_nm = 0;
    end
    else if (!ncu_mcu3_vld)
    begin
        ncu_mcu3_data_packet = 128'bx;
        N3_nm = 0;
    end
end
//// Packet Construction Code for the NCU to MCU downstream Packet (May be unstable) ////


/* From MCU to NCU Upstream Monitors Section 7.4.2 Manual Vol 1 */

always @(posedge (iol2clk && enabled && !mcu0_ncu_vld_strobe))
begin
    if(mcu0_ncu_vld)
    begin
        `PR_INFO("ncu_proto_mon", `INFO, "MCU0 to NCU Transaction Initiated");
        mcu0_ncu_vld_strobe = 1'b1;
        if(mcu0_ncu_data == 4'b0000)
            `PR_ALWAYS("ncu_proto_mon", `ALWAYS, "<mcu0,ncu,,readnackcpxncuload,{%x,%x}>::MCU0 to NCU READ NACK for CPX NCU Load Return", mcu0_ncu_vld, mcu0_ncu_data);
        else if(mcu0_ncu_data == 4'b0001)
            `PR_ALWAYS("ncu_proto_mon", `ALWAYS, "<mcu0,ncu,,readackcpxncuload,{%x,%x}>::MCU0 to NCU READ ACK for CPX NCU Load Reaturn", mcu0_ncu_vld, mcu0_ncu_data);
        else if(mcu0_ncu_data == 4'b0011)
            `PR_ALWAYS("ncu_proto_mon", `ALWAYS, "<mcu0,ncu,,ifillackcpxncuifill,{%x,%x}>::MCU0 to NCU IFILL ACK for CPX NCU Ifill Return", mcu0_ncu_vld, mcu0_ncu_data);
        else if(mcu0_ncu_data == 4'b0111)
            `PR_ALWAYS("ncu_proto_mon", `ALWAYS, "<mcu0,ncu,,ifillnackcpxncuifill,{%x,%x}>::MCU0 to NCU IFILL NACK for CPX NCU Ifill Return", mcu0_ncu_vld, mcu0_ncu_data);
        else if(mcu0_ncu_data == 4'b1000)
            `PR_ALWAYS("ncu_proto_mon", `ALWAYS, "<mcu0,ncu,,int,{%x,%x}>::MCU0 to NCU INT", mcu0_ncu_vld, mcu0_ncu_data);
        else if(mcu0_ncu_data == 4'b1100)
            `PR_ALWAYS("ncu_proto_mon", `ALWAYS, "<mcu0,ncu,,intvec,{%x,%x}>::MCU0 to NCU INT_VEC", mcu0_ncu_vld, mcu0_ncu_data);
    end
end

always @(posedge (iol2clk && enabled && mcu0_ncu_vld_strobe))
begin
    if(!mcu0_ncu_vld)
        mcu0_ncu_vld_strobe = 1'b0;
end

always @(posedge (iol2clk && enabled && ncu_mcu0_stall))
begin
    if(ncu_mcu0_stall)
    begin
        `PR_ALWAYS("ncu_proto_mon", `ALWAYS, "<ncu,mcu0,,stall>::Stall Initiated from NCU to MCU0");
    end
end

//// Packet Construction Code for the MCU to NCU upstream Packet (May be unstable) ////
always @(posedge (iol2clk && enabled))
begin
    if(mcu0_ncu_vld && !ncu_mcu0_stall && N0_mn < 32)
    begin
        case(N0_mn)
            0: mcu0_ncu_data_packet[3:0] = mcu0_ncu_data;
            1: mcu0_ncu_data_packet[7:4] = mcu0_ncu_data;
            2: mcu0_ncu_data_packet[11:8] = mcu0_ncu_data;
            3: mcu0_ncu_data_packet[15:12] = mcu0_ncu_data;
            4: mcu0_ncu_data_packet[19:16] = mcu0_ncu_data;
            5: mcu0_ncu_data_packet[23:20] = mcu0_ncu_data;
            6: mcu0_ncu_data_packet[27:24] = mcu0_ncu_data;
            7: mcu0_ncu_data_packet[31:28] = mcu0_ncu_data;
            8: mcu0_ncu_data_packet[35:32] = mcu0_ncu_data;
            9: mcu0_ncu_data_packet[39:36] = mcu0_ncu_data;
            10: mcu0_ncu_data_packet[43:40] = mcu0_ncu_data;
            11: mcu0_ncu_data_packet[47:44] = mcu0_ncu_data;
            12: mcu0_ncu_data_packet[51:48] = mcu0_ncu_data;
            13: mcu0_ncu_data_packet[55:52] = mcu0_ncu_data;
            14: mcu0_ncu_data_packet[59:56] = mcu0_ncu_data;
            15: mcu0_ncu_data_packet[63:60] = mcu0_ncu_data;
            16: mcu0_ncu_data_packet[67:64] = mcu0_ncu_data;
            17: mcu0_ncu_data_packet[71:68] = mcu0_ncu_data;
            18: mcu0_ncu_data_packet[75:72] = mcu0_ncu_data;
            19: mcu0_ncu_data_packet[79:76] = mcu0_ncu_data;
            20: mcu0_ncu_data_packet[83:80] = mcu0_ncu_data;
            21: mcu0_ncu_data_packet[87:84] = mcu0_ncu_data;
            22: mcu0_ncu_data_packet[91:88] = mcu0_ncu_data;
            23: mcu0_ncu_data_packet[95:92] = mcu0_ncu_data;
            24: mcu0_ncu_data_packet[99:96] = mcu0_ncu_data;
            25: mcu0_ncu_data_packet[103:100] = mcu0_ncu_data;
            26: mcu0_ncu_data_packet[107:104] = mcu0_ncu_data;
            27: mcu0_ncu_data_packet[111:108] = mcu0_ncu_data;
            28: mcu0_ncu_data_packet[115:112] = mcu0_ncu_data;
            29: mcu0_ncu_data_packet[119:116] = mcu0_ncu_data;
            30: mcu0_ncu_data_packet[123:120] = mcu0_ncu_data;
            31: mcu0_ncu_data_packet[127:124] = mcu0_ncu_data;
        endcase
        N0_mn = N0_mn + 1;
    end
    else if (!mcu0_ncu_vld && N0_mn == 32)
    begin
        `PR_ALWAYS("ncu_proto_mon", `ALWAYS, "<mcu0,ncu,,threadid,{%x}>::MCU0 to NCU Packet from CPU Source Thread", mcu0_ncu_data_packet[6:4]);
        `PR_ALWAYS("ncu_proto_mon", `ALWAYS, "<mcu0,ncu,,cpuid,{%x}>::MCU0 to NCU Packet from Source CPU ", mcu0_ncu_data_packet[9:7]);
        `PR_ALWAYS("ncu_proto_mon", `ALWAYS, "<mcu0,ncu,,bufferid,{%x}>::MCU0 to NCU Packet Origin", mcu0_ncu_data_packet[11:10]);
        `PR_ALWAYS("ncu_proto_mon", `ALWAYS, "<mcu0,ncu,,paaddr,{%x}>::MCU0 to NCU Packet PD", mcu0_ncu_data_packet[54:15]);
        mcu0_ncu_data_packet = 128'bx;
        N0_mn = 0;
    end
    else if (!mcu0_ncu_vld)
    begin
        mcu0_ncu_data_packet = 128'bx;
        N0_mn = 0;
    end
end
//// Packet Construction Code for the MCU to NCU upstream Packet (May be unstable) ////


always @(posedge (iol2clk && enabled && !mcu1_ncu_vld_strobe))
begin
    if(mcu1_ncu_vld)
    begin
        `PR_INFO("ncu_proto_mon", `INFO, "MCU1 to NCU Transaction Initiated");
        mcu1_ncu_vld_strobe = 1'b1;
        if(mcu1_ncu_data == 4'b0000)
            `PR_ALWAYS("ncu_proto_mon", `ALWAYS, "<mcu1,ncu,,readnackcpxncuload,{%x,%x}>::MCU1 to NCU READ NACK for CPX NCU Load Return", mcu1_ncu_vld, mcu1_ncu_data);
        else if(mcu1_ncu_data == 4'b0001)
            `PR_ALWAYS("ncu_proto_mon", `ALWAYS, "<mcu1,ncu,,readackcpxncuload,{%x,%x}>::MCU1 to NCU READ ACK for CPX NCU Load Reaturn", mcu1_ncu_vld, mcu1_ncu_data);
        else if(mcu1_ncu_data == 4'b0011)
            `PR_ALWAYS("ncu_proto_mon", `ALWAYS, "<mcu1,ncu,,ifillackcpxncuifill,{%x,%x}>::MCU1 to NCU IFILL ACK for CPX NCU Ifill Return", mcu1_ncu_vld, mcu1_ncu_data);
        else if(mcu1_ncu_data == 4'b0111)
            `PR_ALWAYS("ncu_proto_mon", `ALWAYS, "<mcu1,ncu,,ifillnackcpxncuifill,{%x,%x}>::MCU1 to NCU IFILL NACK for CPX NCU Ifill Return", mcu1_ncu_vld, mcu1_ncu_data);
        else if(mcu1_ncu_data == 4'b1000)
            `PR_ALWAYS("ncu_proto_mon", `ALWAYS, "<mcu1,ncu,,int,{%x,%x}>::MCU1 to NCU INT", mcu1_ncu_vld, mcu1_ncu_data);
        else if(mcu1_ncu_data == 4'b1100)
            `PR_ALWAYS("ncu_proto_mon", `ALWAYS, "<mcu1,ncu,,intvec,{%x,%x}>::MCU1 to NCU INT_VEC", mcu1_ncu_vld, mcu1_ncu_data);
    end
end

always @(posedge (iol2clk && enabled && mcu1_ncu_vld_strobe))
begin
    if(!mcu1_ncu_vld)
        mcu1_ncu_vld_strobe = 1'b0;
end

always @(posedge (iol2clk && enabled && ncu_mcu1_stall))
begin
    if(ncu_mcu1_stall)
    begin
        `PR_ALWAYS("ncu_proto_mon", `ALWAYS, "<ncu,mcu1,,stall>::Stall Initiated from NCU to MCU1");
    end
end

//// Packet Construction Code for the MCU to NCU upstream Packet (May be unstable) ////
always @(posedge (iol2clk && enabled))
begin
    if(mcu1_ncu_vld && !ncu_mcu1_stall && N1_mn < 32)
    begin
        case(N1_mn)
            0: mcu1_ncu_data_packet[3:0] = mcu1_ncu_data;
            1: mcu1_ncu_data_packet[7:4] = mcu1_ncu_data;
            2: mcu1_ncu_data_packet[11:8] = mcu1_ncu_data;
            3: mcu1_ncu_data_packet[15:12] = mcu1_ncu_data;
            4: mcu1_ncu_data_packet[19:16] = mcu1_ncu_data;
            5: mcu1_ncu_data_packet[23:20] = mcu1_ncu_data;
            6: mcu1_ncu_data_packet[27:24] = mcu1_ncu_data;
            7: mcu1_ncu_data_packet[31:28] = mcu1_ncu_data;
            8: mcu1_ncu_data_packet[35:32] = mcu1_ncu_data;
            9: mcu1_ncu_data_packet[39:36] = mcu1_ncu_data;
            10: mcu1_ncu_data_packet[43:40] = mcu1_ncu_data;
            11: mcu1_ncu_data_packet[47:44] = mcu1_ncu_data;
            12: mcu1_ncu_data_packet[51:48] = mcu1_ncu_data;
            13: mcu1_ncu_data_packet[55:52] = mcu1_ncu_data;
            14: mcu1_ncu_data_packet[59:56] = mcu1_ncu_data;
            15: mcu1_ncu_data_packet[63:60] = mcu1_ncu_data;
            16: mcu1_ncu_data_packet[67:64] = mcu1_ncu_data;
            17: mcu1_ncu_data_packet[71:68] = mcu1_ncu_data;
            18: mcu1_ncu_data_packet[75:72] = mcu1_ncu_data;
            19: mcu1_ncu_data_packet[79:76] = mcu1_ncu_data;
            20: mcu1_ncu_data_packet[83:80] = mcu1_ncu_data;
            21: mcu1_ncu_data_packet[87:84] = mcu1_ncu_data;
            22: mcu1_ncu_data_packet[91:88] = mcu1_ncu_data;
            23: mcu1_ncu_data_packet[95:92] = mcu1_ncu_data;
            24: mcu1_ncu_data_packet[99:96] = mcu1_ncu_data;
            25: mcu1_ncu_data_packet[103:100] = mcu1_ncu_data;
            26: mcu1_ncu_data_packet[107:104] = mcu1_ncu_data;
            27: mcu1_ncu_data_packet[111:108] = mcu1_ncu_data;
            28: mcu1_ncu_data_packet[115:112] = mcu1_ncu_data;
            29: mcu1_ncu_data_packet[119:116] = mcu1_ncu_data;
            30: mcu1_ncu_data_packet[123:120] = mcu1_ncu_data;
            31: mcu1_ncu_data_packet[127:124] = mcu1_ncu_data;
        endcase
        N1_mn = N1_mn + 1;
    end
    else if (!mcu1_ncu_vld && N1_mn == 32)
    begin
        `PR_ALWAYS("ncu_proto_mon", `ALWAYS, "<mcu1,ncu,,threadid,{%x}>::MCU1 to NCU Packet from CPU Source Thread", mcu1_ncu_data_packet[6:4]);
        `PR_ALWAYS("ncu_proto_mon", `ALWAYS, "<mcu1,ncu,,cpuid,{%x}>::MCU1 to NCU Packet from Source CPU ", mcu1_ncu_data_packet[9:7]);
        `PR_ALWAYS("ncu_proto_mon", `ALWAYS, "<mcu1,ncu,,bufferid,{%x}>::MCU1 to NCU Packet Origin", mcu1_ncu_data_packet[11:10]);
        `PR_ALWAYS("ncu_proto_mon", `ALWAYS, "<mcu1,ncu,,paaddr,{%x}>::MCU1 to NCU Packet PD", mcu1_ncu_data_packet[54:15]);
        mcu1_ncu_data_packet = 128'bx;
        N1_mn = 0;
    end
    else if (!mcu1_ncu_vld)
    begin
        mcu1_ncu_data_packet = 128'bx;
        N1_mn = 0;
    end
end
//// Packet Construction Code for the MCU to NCU upstream Packet (May be unstable) ////



always @(posedge (iol2clk && enabled && !mcu2_ncu_vld_strobe))
begin
    if(mcu2_ncu_vld)
    begin
        `PR_INFO("ncu_proto_mon", `INFO, "MCU2 to NCU Transaction Initiated");
        mcu2_ncu_vld_strobe = 1'b1;
        if(mcu2_ncu_data == 4'b0000)
            `PR_ALWAYS("ncu_proto_mon", `ALWAYS, "<mcu2,ncu,,readnackcpxncuload,{%x,%x}>::MCU2 to NCU READ NACK for CPX NCU Load Return", mcu2_ncu_vld, mcu2_ncu_data);
        else if(mcu2_ncu_data == 4'b0001)
            `PR_ALWAYS("ncu_proto_mon", `ALWAYS, "<mcu2,ncu,,readackcpxncuload,{%x,%x}>::MCU2 to NCU READ ACK for CPX NCU Load Reaturn", mcu2_ncu_vld, mcu2_ncu_data);
        else if(mcu2_ncu_data == 4'b0011)
            `PR_ALWAYS("ncu_proto_mon", `ALWAYS, "<mcu2,ncu,,ifillackcpxncuifill,{%x,%x}>::MCU2 to NCU IFILL ACK for CPX NCU Ifill Return", mcu2_ncu_vld, mcu2_ncu_data);
        else if(mcu2_ncu_data == 4'b0111)
            `PR_ALWAYS("ncu_proto_mon", `ALWAYS, "<mcu2,ncu,,ifillnackcpxncuifill,{%x,%x}>::MCU2 to NCU IFILL NACK for CPX NCU Ifill Return", mcu2_ncu_vld, mcu2_ncu_data);
        else if(mcu2_ncu_data == 4'b1000)
            `PR_ALWAYS("ncu_proto_mon", `ALWAYS, "<mcu2,ncu,,int,{%x,%x}>::MCU2 to NCU INT", mcu2_ncu_vld, mcu2_ncu_data);
        else if(mcu2_ncu_data == 4'b1100)
            `PR_ALWAYS("ncu_proto_mon", `ALWAYS, "<mcu2,ncu,,intvec,{%x,%x}>::MCU2 to NCU INT_VEC", mcu2_ncu_vld, mcu2_ncu_data);
    end
end

always @(posedge (iol2clk && enabled && mcu2_ncu_vld_strobe))
begin
    if(!mcu2_ncu_vld)
        mcu2_ncu_vld_strobe = 1'b0;
end

always @(posedge (iol2clk && enabled && ncu_mcu2_stall))
begin
    if(ncu_mcu2_stall)
    begin
        `PR_ALWAYS("ncu_proto_mon", `ALWAYS, "<ncu,mcu2,,stall>::Stall Initiated from NCU to MCU2");
    end
end

//// Packet Construction Code for the MCU to NCU upstream Packet (May be unstable) ////
always @(posedge (iol2clk && enabled))
begin
    if(mcu2_ncu_vld && !ncu_mcu2_stall && N2_mn < 32)
    begin
        case(N2_mn)
            0: mcu2_ncu_data_packet[3:0] = mcu2_ncu_data;
            1: mcu2_ncu_data_packet[7:4] = mcu2_ncu_data;
            2: mcu2_ncu_data_packet[11:8] = mcu2_ncu_data;
            3: mcu2_ncu_data_packet[15:12] = mcu2_ncu_data;
            4: mcu2_ncu_data_packet[19:16] = mcu2_ncu_data;
            5: mcu2_ncu_data_packet[23:20] = mcu2_ncu_data;
            6: mcu2_ncu_data_packet[27:24] = mcu2_ncu_data;
            7: mcu2_ncu_data_packet[31:28] = mcu2_ncu_data;
            8: mcu2_ncu_data_packet[35:32] = mcu2_ncu_data;
            9: mcu2_ncu_data_packet[39:36] = mcu2_ncu_data;
            10: mcu2_ncu_data_packet[43:40] = mcu2_ncu_data;
            11: mcu2_ncu_data_packet[47:44] = mcu2_ncu_data;
            12: mcu2_ncu_data_packet[51:48] = mcu2_ncu_data;
            13: mcu2_ncu_data_packet[55:52] = mcu2_ncu_data;
            14: mcu2_ncu_data_packet[59:56] = mcu2_ncu_data;
            15: mcu2_ncu_data_packet[63:60] = mcu2_ncu_data;
            16: mcu2_ncu_data_packet[67:64] = mcu2_ncu_data;
            17: mcu2_ncu_data_packet[71:68] = mcu2_ncu_data;
            18: mcu2_ncu_data_packet[75:72] = mcu2_ncu_data;
            19: mcu2_ncu_data_packet[79:76] = mcu2_ncu_data;
            20: mcu2_ncu_data_packet[83:80] = mcu2_ncu_data;
            21: mcu2_ncu_data_packet[87:84] = mcu2_ncu_data;
            22: mcu2_ncu_data_packet[91:88] = mcu2_ncu_data;
            23: mcu2_ncu_data_packet[95:92] = mcu2_ncu_data;
            24: mcu2_ncu_data_packet[99:96] = mcu2_ncu_data;
            25: mcu2_ncu_data_packet[103:100] = mcu2_ncu_data;
            26: mcu2_ncu_data_packet[107:104] = mcu2_ncu_data;
            27: mcu2_ncu_data_packet[111:108] = mcu2_ncu_data;
            28: mcu2_ncu_data_packet[115:112] = mcu2_ncu_data;
            29: mcu2_ncu_data_packet[119:116] = mcu2_ncu_data;
            30: mcu2_ncu_data_packet[123:120] = mcu2_ncu_data;
            31: mcu2_ncu_data_packet[127:124] = mcu2_ncu_data;
        endcase
        N2_mn = N2_mn + 1;
    end
    else if (!mcu2_ncu_vld && N2_mn == 32)
    begin
        `PR_ALWAYS("ncu_proto_mon", `ALWAYS, "<mcu2,ncu,,threadid,{%x}>::MCU2 to NCU Packet from CPU Source Thread", mcu2_ncu_data_packet[6:4]);
        `PR_ALWAYS("ncu_proto_mon", `ALWAYS, "<mcu2,ncu,,cpuid,{%x}>::MCU2 to NCU Packet from Source CPU ", mcu2_ncu_data_packet[9:7]);
        `PR_ALWAYS("ncu_proto_mon", `ALWAYS, "<mcu2,ncu,,bufferid,{%x}>::MCU2 to NCU Packet Origin", mcu2_ncu_data_packet[11:10]);
        `PR_ALWAYS("ncu_proto_mon", `ALWAYS, "<mcu2,ncu,,paaddr,{%x}>::MCU2 to NCU Packet PD", mcu2_ncu_data_packet[54:15]);
        mcu2_ncu_data_packet = 128'bx;
        N2_mn = 0;
    end
    else if (!mcu2_ncu_vld)
    begin
        mcu2_ncu_data_packet = 128'bx;
        N2_mn = 0;
    end
end
//// Packet Construction Code for the MCU to NCU upstream Packet (May be unstable) ////


always @(posedge (iol2clk && enabled && !mcu3_ncu_vld_strobe))
begin
    if(mcu3_ncu_vld)
    begin
        `PR_INFO("ncu_proto_mon", `INFO, "MCU3 to NCU Initiated");
        mcu3_ncu_vld_strobe = 1'b1;
        if(mcu3_ncu_data == 4'b0000)
            `PR_ALWAYS("ncu_proto_mon", `ALWAYS, "<mcu3,ncu,,readnackcpxncuload{%x,%x}>::MCU3 to NCU READ NACK for CPX NCU Load Return", mcu3_ncu_vld, mcu3_ncu_data);
        else if(mcu3_ncu_data == 4'b0001)
            `PR_ALWAYS("ncu_proto_mon", `ALWAYS, "<mcu3,ncu,,readackcpxncuload{%x,%x}>::MCU3 to NCU READ ACK for CPX NCU Load Reaturn", mcu3_ncu_vld, mcu3_ncu_data);
        else if(mcu3_ncu_data == 4'b0011)
            `PR_ALWAYS("ncu_proto_mon", `ALWAYS, "<mcu3,ncu,,ifillackcpxncuifill{%x,%x}>::MCU3 to NCU IFILL ACK for CPX NCU Ifill Return", mcu3_ncu_vld, mcu3_ncu_data);
        else if(mcu3_ncu_data == 4'b0111)
            `PR_ALWAYS("ncu_proto_mon", `ALWAYS, "<mcu3,ncu,,ifillnackcpxncuifill{%x,%x}>::MCU3 to NCU IFILL NACK for CPX NCU Ifill Return", mcu3_ncu_vld, mcu3_ncu_data);
        else if(mcu3_ncu_data == 4'b1000)
            `PR_ALWAYS("ncu_proto_mon", `ALWAYS, "<mcu3,ncu,,int{%x,%x}>::MCU3 to NCU INT", mcu3_ncu_vld, mcu3_ncu_data);
        else if(mcu3_ncu_data == 4'b1100)
            `PR_ALWAYS("ncu_proto_mon", `ALWAYS, "<mcu3,ncu,,intvec{%x,%x}>::MCU3 to NCU INT_VEC", mcu3_ncu_vld, mcu3_ncu_data);
    end
end

always @(posedge (iol2clk && enabled && mcu3_ncu_vld_strobe))
begin
    if(!mcu3_ncu_vld)
        mcu3_ncu_vld_strobe = 1'b0;
end

always @(posedge (iol2clk && enabled && ncu_mcu3_stall))
begin
    if(ncu_mcu3_stall)
    begin
        `PR_ALWAYS("ncu_proto_mon", `ALWAYS, "<ncu,mcu3,,stall>::Stall Initiated from NCU to MCU3");
    end
end

//// Packet Construction Code for the MCU to NCU upstream Packet (May be unstable) ////
always @(posedge (iol2clk && enabled))
begin
    if(mcu3_ncu_vld && !ncu_mcu3_stall && N3_mn < 32)
    begin
        case(N3_mn)
            0: mcu3_ncu_data_packet[3:0] = mcu3_ncu_data;
            1: mcu3_ncu_data_packet[7:4] = mcu3_ncu_data;
            2: mcu3_ncu_data_packet[11:8] = mcu3_ncu_data;
            3: mcu3_ncu_data_packet[15:12] = mcu3_ncu_data;
            4: mcu3_ncu_data_packet[19:16] = mcu3_ncu_data;
            5: mcu3_ncu_data_packet[23:20] = mcu3_ncu_data;
            6: mcu3_ncu_data_packet[27:24] = mcu3_ncu_data;
            7: mcu3_ncu_data_packet[31:28] = mcu3_ncu_data;
            8: mcu3_ncu_data_packet[35:32] = mcu3_ncu_data;
            9: mcu3_ncu_data_packet[39:36] = mcu3_ncu_data;
            10: mcu3_ncu_data_packet[43:40] = mcu3_ncu_data;
            11: mcu3_ncu_data_packet[47:44] = mcu3_ncu_data;
            12: mcu3_ncu_data_packet[51:48] = mcu3_ncu_data;
            13: mcu3_ncu_data_packet[55:52] = mcu3_ncu_data;
            14: mcu3_ncu_data_packet[59:56] = mcu3_ncu_data;
            15: mcu3_ncu_data_packet[63:60] = mcu3_ncu_data;
            16: mcu3_ncu_data_packet[67:64] = mcu3_ncu_data;
            17: mcu3_ncu_data_packet[71:68] = mcu3_ncu_data;
            18: mcu3_ncu_data_packet[75:72] = mcu3_ncu_data;
            19: mcu3_ncu_data_packet[79:76] = mcu3_ncu_data;
            20: mcu3_ncu_data_packet[83:80] = mcu3_ncu_data;
            21: mcu3_ncu_data_packet[87:84] = mcu3_ncu_data;
            22: mcu3_ncu_data_packet[91:88] = mcu3_ncu_data;
            23: mcu3_ncu_data_packet[95:92] = mcu3_ncu_data;
            24: mcu3_ncu_data_packet[99:96] = mcu3_ncu_data;
            25: mcu3_ncu_data_packet[103:100] = mcu3_ncu_data;
            26: mcu3_ncu_data_packet[107:104] = mcu3_ncu_data;
            27: mcu3_ncu_data_packet[111:108] = mcu3_ncu_data;
            28: mcu3_ncu_data_packet[115:112] = mcu3_ncu_data;
            29: mcu3_ncu_data_packet[119:116] = mcu3_ncu_data;
            30: mcu3_ncu_data_packet[123:120] = mcu3_ncu_data;
            31: mcu3_ncu_data_packet[127:124] = mcu3_ncu_data;
        endcase
        N3_mn = N3_mn + 1;
    end
    else if (!mcu3_ncu_vld && N3_mn == 32)
    begin
        `PR_ALWAYS("ncu_proto_mon", `ALWAYS, "<mcu3,ncu,,threadid,{%x}>::MCU3 to NCU Packet from CPU Source Thread", mcu3_ncu_data_packet[6:4]);
        `PR_ALWAYS("ncu_proto_mon", `ALWAYS, "<mcu3,ncu,,cpuid,{%x}>::MCU3 to NCU Packet from Source CPU ", mcu3_ncu_data_packet[9:7]);
        `PR_ALWAYS("ncu_proto_mon", `ALWAYS, "<mcu3,ncu,,bufferid,{%x}>::MCU3 to NCU Packet Origin", mcu3_ncu_data_packet[11:10]);
        `PR_ALWAYS("ncu_proto_mon", `ALWAYS, "<mcu3,ncu,,paaddr,{%x}>::MCU3 to NCU Packet PD", mcu3_ncu_data_packet[54:15]);
        mcu3_ncu_data_packet = 128'bx;
        N3_mn = 0;
    end
    else if (!mcu3_ncu_vld)
    begin
        mcu3_ncu_data_packet = 128'bx;
        N3_mn = 0;
    end
end
//// Packet Construction Code for the MCU to NCU upstream Packet (May be unstable) ////

endmodule
