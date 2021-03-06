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

`define L2B0 `CPU.l2b0
`define L2B1 `CPU.l2b1
`define L2B2 `CPU.l2b2
`define L2B3 `CPU.l2b3
`define L2B4 `CPU.l2b4
`define L2B5 `CPU.l2b5
`define L2B6 `CPU.l2b6
`define L2B7 `CPU.l2b7


module l2_proto_mon();


/*  Enabling the monitor based on the flush_reset_complete and the l2_proto_mon_off plusr arg flag 
    from command line
*/

reg enabled;
initial begin
    enabled = 1'b1;
    if($test$plusargs("l2_proto_mon_off"))
    begin
        enabled = 1'b0;
    end
    else
        `PR_INFO("l2_proto_mon", `INFO, "l2_proto_mon ENABLED");
end

wire flush_reset_complete = `TOP.flush_reset_complete;

always @(flush_reset_complete)
begin
    if(flush_reset_complete == 1'b0)
        enabled = 1'b0;
        `PR_INFO("l2_proto_mon", `INFO, "l2_proto_mon DISABLED by flush_reset_complete");
    if((flush_reset_complete == 1'b1) && (!($test$plusargs("l2_proto_mon_off"))))
        enabled = 1'b1;
end

/* L2 protocols are running at the same frequency as that of the core */

wire cmp_clk = `CPU.l2clk & enabled;
/* Not sure if this signal is needed. We will see TODO  */
wire cmp_rst_l = `CPU.rst_l2_por_; 


/* There are 8 L2 Banks and 4 MCUs. Each two L2s are connected with one MCU */

//////////////////////////////////////////////////////////////
//                                                          //
//      Signals for Receiving a request from Crossbar       //
//                                                          //
//////////////////////////////////////////////////////////////


wire pcx_l2t0_data_rdy_px1 = `L2T0.pcx_l2t_data_rdy_px1;
wire [129:0] pcx_l2t0_data_px2 = `L2T0.pcx_l2t_data_px2;
wire pcx_l2t0_atm_px1 = `L2T0.pcx_l2t_atm_px1;

wire pcx_l2t1_data_rdy_px1 = `L2T1.pcx_l2t_data_rdy_px1;
wire [129:0] pcx_l2t1_data_px2 = `L2T1.pcx_l2t_data_px2;
wire pcx_l2t1_atm_px1 = `L2T1.pcx_l2t_atm_px1;

wire pcx_l2t2_data_rdy_px1 = `L2T2.pcx_l2t_data_rdy_px1;
wire [129:0] pcx_l2t2_data_px2 = `L2T2.pcx_l2t_data_px2;
wire pcx_l2t2_atm_px1 = `L2T2.pcx_l2t_atm_px1;

wire pcx_l2t3_data_rdy_px1 = `L2T3.pcx_l2t_data_rdy_px1;
wire [129:0] pcx_l2t3_data_px2 = `L2T3.pcx_l2t_data_px2;
wire pcx_l2t3_atm_px1 = `L2T3.pcx_l2t_atm_px1;

wire pcx_l2t4_data_rdy_px1 = `L2T4.pcx_l2t_data_rdy_px1;
wire [129:0] pcx_l2t4_data_px2 = `L2T4.pcx_l2t_data_px2;
wire pcx_l2t4_atm_px1 = `L2T4.pcx_l2t_atm_px1;

wire pcx_l2t5_data_rdy_px1 = `L2T5.pcx_l2t_data_rdy_px1;
wire [129:0] pcx_l2t5_data_px2 = `L2T5.pcx_l2t_data_px2;
wire pcx_l2t5_atm_px1 = `L2T5.pcx_l2t_atm_px1;

wire pcx_l2t6_data_rdy_px1 = `L2T6.pcx_l2t_data_rdy_px1;
wire [129:0] pcx_l2t6_data_px2 = `L2T6.pcx_l2t_data_px2;
wire pcx_l2t6_atm_px1 = `L2T6.pcx_l2t_atm_px1;

wire pcx_l2t7_data_rdy_px1 = `L2T7.pcx_l2t_data_rdy_px1;
wire [129:0] pcx_l2t7_data_px2 = `L2T7.pcx_l2t_data_px2;
wire pcx_l2t7_atm_px1 = `L2T7.pcx_l2t_atm_px1;


//////////////////////////////////////////////////////////////
//                                                          //
//      Signals for Sending a packet to Crossbar            //
//                                                          //
//////////////////////////////////////////////////////////////

wire [7:0] l2t0_cpx_req_cq = `L2T0.l2t_cpx_req_cq;
wire [145:0] l2t0_cpx_data_ca = `L2T0.l2t_cpx_data_ca;
wire [7:0] cpx_l2t0_grant_cx = `L2T0.cpx_l2t_grant_cx;

wire [7:0] l2t1_cpx_req_cq = `L2T1.l2t_cpx_req_cq;
wire [145:0] l2t1_cpx_data_ca = `L2T1.l2t_cpx_data_ca;
wire [7:0] cpx_l2t1_grant_cx = `L2T1.cpx_l2t_grant_cx;

wire [7:0] l2t2_cpx_req_cq = `L2T2.l2t_cpx_req_cq;
wire [145:0] l2t2_cpx_data_ca = `L2T2.l2t_cpx_data_ca;
wire [7:0] cpx_l2t2_grant_cx = `L2T2.cpx_l2t_grant_cx;

wire [7:0] l2t3_cpx_req_cq = `L2T3.l2t_cpx_req_cq;
wire [145:0] l2t3_cpx_data_ca = `L2T3.l2t_cpx_data_ca;
wire [7:0] cpx_l2t3_grant_cx = `L2T3.cpx_l2t_grant_cx;

wire [7:0] l2t4_cpx_req_cq = `L2T4.l2t_cpx_req_cq;
wire [145:0] l2t4_cpx_data_ca = `L2T4.l2t_cpx_data_ca;
wire [7:0] cpx_l2t4_grant_cx = `L2T4.cpx_l2t_grant_cx;

wire [7:0] l2t5_cpx_req_cq = `L2T5.l2t_cpx_req_cq;
wire [145:0] l2t5_cpx_data_ca = `L2T5.l2t_cpx_data_ca;
wire [7:0] cpx_l2t5_grant_cx = `L2T5.cpx_l2t_grant_cx;

wire [7:0] l2t6_cpx_req_cq = `L2T6.l2t_cpx_req_cq;
wire [145:0] l2t6_cpx_data_ca = `L2T6.l2t_cpx_data_ca;
wire [7:0] cpx_l2t6_grant_cx = `L2T6.cpx_l2t_grant_cx;

wire [7:0] l2t7_cpx_req_cq = `L2T7.l2t_cpx_req_cq;
wire [145:0] l2t7_cpx_data_ca = `L2T7.l2t_cpx_data_ca;
wire [7:0] cpx_l2t7_grant_cx = `L2T7.cpx_l2t_grant_cx;

//////////////////////////////////////////////////////////////
//                                                          //
//      Signals for sending a read request to MCU           //
//                                                          //
//////////////////////////////////////////////////////////////


wire l2t0_mcu0_rd_req = `L2T0.l2t_mcu_rd_req;
wire [32:0] l2t0_mcu0_addr = `L2T0.l2t_mcu_addr;
wire [2:0] l2t0_mcu0_rd_req_id = `L2T0.l2t_mcu_rd_req_id;
wire mcu0_l2t0_rd_ack = `L2T0.mcu_l2t_rd_ack;
wire mcu0_l2t0_data_vld_r0 = `L2T0.mcu_l2t_data_vld_r0;
wire [1:0] mcu0_l2t0_chunk_id_r0 = `L2T0.mcu_l2t_chunk_id_r0;
wire [127:0] mcu0_l2b0_data_r2 = `L2B0.mcu_l2b_data_r2;
wire [27:0] mcu0_l2b0_ecc_r2 = `L2B0.mcu_l2b_ecc_r2;

wire l2t1_mcu0_rd_req = `L2T1.l2t_mcu_rd_req;
wire [32:0] l2t1_mcu0_addr = `L2T1.l2t_mcu_addr;
wire [2:0] l2t1_mcu0_rd_req_id = `L2T1.l2t_mcu_rd_req_id;
wire mcu0_l2t1_rd_ack = `L2T1.mcu_l2t_rd_ack;
wire mcu0_l2t1_data_vld_r0 = `L2T1.mcu_l2t_data_vld_r0;
wire [1:0] mcu0_l2t1_chunk_id_r0 = `L2T1.mcu_l2t_chunk_id_r0;
wire [127:0] mcu0_l2b1_data_r2 = `L2B1.mcu_l2b_data_r2;
wire [27:0] mcu0_l2b1_ecc_r2 = `L2B1.mcu_l2b_ecc_r2;

wire l2t2_mcu1_rd_req = `L2T2.l2t_mcu_rd_req;
wire [32:0] l2t2_mcu1_addr = `L2T2.l2t_mcu_addr;
wire [2:0] l2t2_mcu1_rd_req_id = `L2T2.l2t_mcu_rd_req_id;
wire mcu1_l2t2_rd_ack = `L2T2.mcu_l2t_rd_ack;
wire mcu1_l2t2_data_vld_r0 = `L2T2.mcu_l2t_data_vld_r0;
wire [1:0] mcu1_l2t2_chunk_id_r0 = `L2T2.mcu_l2t_chunk_id_r0;
wire [127:0] mcu1_l2b2_data_r2 = `L2B2.mcu_l2b_data_r2;
wire [27:0] mcu1_l2b2_ecc_r2 = `L2B2.mcu_l2b_ecc_r2;

wire l2t3_mcu1_rd_req = `L2T3.l2t_mcu_rd_req;
wire [32:0] l2t3_mcu1_addr = `L2T3.l2t_mcu_addr;
wire [2:0] l2t3_mcu1_rd_req_id = `L2T3.l2t_mcu_rd_req_id;
wire mcu1_l2t3_rd_ack = `L2T3.mcu_l2t_rd_ack;
wire mcu1_l2t3_data_vld_r0 = `L2T3.mcu_l2t_data_vld_r0;
wire [1:0] mcu1_l2t3_chunk_id_r0 = `L2T3.mcu_l2t_chunk_id_r0;
wire [127:0] mcu1_l2b3_data_r2 = `L2B3.mcu_l2b_data_r2;
wire [27:0] mcu1_l2b3_ecc_r2 = `L2B3.mcu_l2b_ecc_r2;

wire l2t4_mcu2_rd_req = `L2T4.l2t_mcu_rd_req;
wire [32:0] l2t4_mcu2_addr = `L2T4.l2t_mcu_addr;
wire [2:0] l2t4_mcu2_rd_req_id = `L2T4.l2t_mcu_rd_req_id;
wire mcu2_l2t4_rd_ack = `L2T4.mcu_l2t_rd_ack;
wire mcu2_l2t4_data_vld_r0 = `L2T4.mcu_l2t_data_vld_r0;
wire [1:0] mcu2_l2t4_chunk_id_r0 = `L2T4.mcu_l2t_chunk_id_r0;
wire [127:0] mcu2_l2b4_data_r2 = `L2B4.mcu_l2b_data_r2;
wire [27:0] mcu2_l2b4_ecc_r2 = `L2B4.mcu_l2b_ecc_r2;

wire l2t5_mcu2_rd_req = `L2T5.l2t_mcu_rd_req;
wire [32:0] l2t5_mcu2_addr = `L2T5.l2t_mcu_addr;
wire [2:0] l2t5_mcu2_rd_req_id = `L2T5.l2t_mcu_rd_req_id;
wire mcu2_l2t5_rd_ack = `L2T5.mcu_l2t_rd_ack;
wire mcu2_l2t5_data_vld_r0 = `L2T5.mcu_l2t_data_vld_r0;
wire [1:0] mcu2_l2t5_chunk_id_r0 = `L2T5.mcu_l2t_chunk_id_r0;
wire [127:0] mcu2_l2b5_data_r2 = `L2B5.mcu_l2b_data_r2;
wire [27:0] mcu2_l2b5_ecc_r2 = `L2B5.mcu_l2b_ecc_r2;

wire l2t6_mcu3_rd_req = `L2T6.l2t_mcu_rd_req;
wire [32:0] l2t6_mcu3_addr = `L2T6.l2t_mcu_addr;
wire [2:0] l2t6_mcu3_rd_req_id = `L2T6.l2t_mcu_rd_req_id;
wire mcu3_l2t6_rd_ack = `L2T6.mcu_l2t_rd_ack;
wire mcu3_l2t6_data_vld_r0 = `L2T6.mcu_l2t_data_vld_r0;
wire [1:0] mcu3_l2t6_chunk_id_r0 = `L2T6.mcu_l2t_chunk_id_r0;
wire [127:0] mcu3_l2b6_data_r2 = `L2B6.mcu_l2b_data_r2;
wire [27:0] mcu3_l2b6_ecc_r2 = `L2B6.mcu_l2b_ecc_r2;

wire l2t7_mcu3_rd_req = `L2T7.l2t_mcu_rd_req;
wire [32:0] l2t7_mcu3_addr = `L2T7.l2t_mcu_addr;
wire [2:0] l2t7_mcu3_rd_req_id = `L2T7.l2t_mcu_rd_req_id;
wire mcu3_l2t7_rd_ack = `L2T7.mcu_l2t_rd_ack;
wire mcu3_l2t7_data_vld_r0 = `L2T7.mcu_l2t_data_vld_r0;
wire [1:0] mcu3_l2t7_chunk_id_r0 = `L2T7.mcu_l2t_chunk_id_r0;
wire [127:0] mcu3_l2b7_data_r2 = `L2B7.mcu_l2b_data_r2;
wire [27:0] mcu3_l2b7_ecc_r2 = `L2B7.mcu_l2b_ecc_r2;


//////////////////////////////////////////////////////////////
//                                                          //
//      Signals for sending a write request to MCU          //
//                                                          //
//////////////////////////////////////////////////////////////

/* Note: l2t_mcu_addr will come from the Signals for sending Read request to MCU. Not declared
   here anymore
*/

wire l2t0_mcu0_wr_req = `L2T0.l2t_mcu_wr_req;
wire mcu0_l2t0_wr_ack = `L2T0.mcu_l2t_wr_ack;
wire l2b0_mcu0_data_vld_r5 = `L2B0.evict_l2b_mcu_data_vld_r5;
wire [63:0] l2b0_mcu0_wr_data_r5 = `L2B0.evict_l2b_mcu_wr_data_r5;

wire l2t1_mcu0_wr_req = `L2T1.l2t_mcu_wr_req;
wire mcu0_l2t1_wr_ack = `L2T1.mcu_l2t_wr_ack;
wire l2b1_mcu0_data_vld_r5 = `L2B1.evict_l2b_mcu_data_vld_r5;
wire [63:0] l2b1_mcu0_wr_data_r5 = `L2B1.evict_l2b_mcu_wr_data_r5;

wire l2t2_mcu1_wr_req = `L2T2.l2t_mcu_wr_req;
wire mcu1_l2t2_wr_ack = `L2T2.mcu_l2t_wr_ack;
wire l2b2_mcu1_data_vld_r5 = `L2B2.evict_l2b_mcu_data_vld_r5;
wire [63:0] l2b2_mcu1_wr_data_r5 = `L2B2.evict_l2b_mcu_wr_data_r5;

wire l2t3_mcu1_wr_req = `L2T3.l2t_mcu_wr_req;
wire mcu1_l2t3_wr_ack = `L2T3.mcu_l2t_wr_ack;
wire l2b3_mcu1_data_vld_r5 = `L2B3.evict_l2b_mcu_data_vld_r5;
wire [63:0] l2b3_mcu1_wr_data_r5 = `L2B3.evict_l2b_mcu_wr_data_r5;

wire l2t4_mcu2_wr_req = `L2T4.l2t_mcu_wr_req;
wire mcu2_l2t4_wr_ack = `L2T4.mcu_l2t_wr_ack;
wire l2b4_mcu2_data_vld_r5 = `L2B4.evict_l2b_mcu_data_vld_r5;
wire [63:0] l2b4_mcu2_wr_data_r5 = `L2B4.evict_l2b_mcu_wr_data_r5;

wire l2t5_mcu2_wr_req = `L2T5.l2t_mcu_wr_req;
wire mcu2_l2t5_wr_ack = `L2T5.mcu_l2t_wr_ack;
wire l2b5_mcu2_data_vld_r5 = `L2B5.evict_l2b_mcu_data_vld_r5;
wire [63:0] l2b5_mcu2_wr_data_r5 = `L2B5.evict_l2b_mcu_wr_data_r5;

wire l2t6_mcu3_wr_req = `L2T6.l2t_mcu_wr_req;
wire mcu3_l2t6_wr_ack = `L2T6.mcu_l2t_wr_ack;
wire l2b6_mcu3_data_vld_r5 = `L2B6.evict_l2b_mcu_data_vld_r5;
wire [63:0] l2b6_mcu3_wr_data_r5 = `L2B6.evict_l2b_mcu_wr_data_r5;

wire l2t7_mcu3_wr_req = `L2T7.l2t_mcu_wr_req;
wire mcu3_l2t7_wr_ack = `L2T7.mcu_l2t_wr_ack;
wire l2b7_mcu3_data_vld_r5 = `L2B7.evict_l2b_mcu_data_vld_r5;
wire [63:0] l2b7_mcu3_wr_data_r5 = `L2B7.evict_l2b_mcu_wr_data_r5;


/* Monitors for sending a Read Request from L2 to MCU Section 2.1.2.2 Section 3.4.1 Manual Vol 1 */

always @(posedge (cmp_clk && enabled))
begin
    if(l2t0_mcu0_rd_req)
    begin
        `PR_ALWAYS("l2_proto_mon", `ALWAYS, "<l2t0,mcu0,,l2tmcureadreq,{%x}>::L2T0 Read Request to MCU0", l2t0_mcu0_rd_req);
        `PR_ALWAYS("l2_proto_mon", `ALWAYS, "<l2t0,mcu0,,l2tmcureadreqid,{%x}>::L2T0 to MCU0 Read Request ID", l2t0_mcu0_rd_req_id);
        `PR_ALWAYS("l2_proto_mon", `ALWAYS, "<l2t0,mcu0,,l2tmcureadaddr,{%x}>::L2T0 to MCU0 Read Request Address", l2t0_mcu0_addr);
    end
end

always @(posedge (cmp_clk && enabled))
begin
    if(mcu0_l2t0_rd_ack)
        `PR_ALWAYS("l2_proto_mon", `ALWAYS, "<mcu0,l2t0,,mcul2treadack,{%x}>::MCU0 to L2T0 Read Request Acknowledgement", mcu0_l2t0_rd_ack);
end

always @(posedge (cmp_clk && enabled))
begin
    if(mcu0_l2t0_data_vld_r0)
    begin
        repeat (3) @(posedge cmp_clk);
        `PR_INFO("l2_proto_mon", `INFO, "MCU0 to L2B0 Read Data = %x",  mcu0_l2b0_data_r2);
        `PR_INFO("l2_proto_mon", `INFO, "MCU0 to L2B0 Read Data ECC = %x",  mcu0_l2b0_ecc_r2);
    end
end

////////////////////////////////////////////////////////////////

always @(posedge (cmp_clk && enabled))
begin
    if(l2t1_mcu0_rd_req)
    begin
        `PR_ALWAYS("l2_proto_mon", `ALWAYS, "<l2t1,mcu0,,l2tmcureadreq,{%x}>::L2T1 Read Request to MCU0", l2t1_mcu0_rd_req);
        `PR_ALWAYS("l2_proto_mon", `ALWAYS, "<l2t1,mcu0,,l2tmcureadreqid,{%x}>::L2T1 to MCU0 Read Request ID", l2t1_mcu0_rd_req_id);
        `PR_ALWAYS("l2_proto_mon", `ALWAYS, "<l2t1,mcu0,,l2tmcureadaddr,{%x}>::L2T1 to MCU0 Read Request Address", l2t1_mcu0_addr);
    end
end

always @(posedge (cmp_clk && enabled))
begin
    if(mcu0_l2t1_rd_ack)
        `PR_ALWAYS("l2_proto_mon", `ALWAYS, "<mcu0,l2t1,,mcul2treadack,{%x}>::MCU0 to L2T1 Read Request Acknowledgement", mcu0_l2t1_rd_ack);
end

always @(posedge (cmp_clk && enabled))
begin
    if(mcu0_l2t1_data_vld_r0)
    begin
        repeat(3) @(posedge cmp_clk);
        `PR_INFO("l2_proto_mon", `INFO, "MCU0 to L2B1 Read Data = %x",  mcu0_l2b1_data_r2);
        `PR_INFO("l2_proto_mon", `INFO, "MCU0 to L2B1 Read Data ECC = %x",  mcu0_l2b1_ecc_r2);
    end
end

/////////////////////////////////////////////////////////////////

always @(posedge (cmp_clk && enabled))
begin
    if(l2t2_mcu1_rd_req)
    begin
        `PR_ALWAYS("l2_proto_mon", `ALWAYS, "<l2t2,mcu1,,l2tmcureadreq,{%x}>::L2T2 Read Request to MCU1", l2t2_mcu1_rd_req);
        `PR_ALWAYS("l2_proto_mon", `ALWAYS, "<l2t2,mcu1,,l2tmcureadreqid,{%x}>::L2T2 to MCU1 Read Request ID", l2t2_mcu1_rd_req_id);
        `PR_ALWAYS("l2_proto_mon", `ALWAYS, "<l2t2,mcu1,,l2tmcureadaddr,{%x}>::L2T2 to MCU1 Read Request Address", l2t2_mcu1_addr);
    end
end

always @(posedge (cmp_clk && enabled))
begin
    if(mcu1_l2t2_rd_ack)
        `PR_ALWAYS("l2_proto_mon", `ALWAYS, "<mcu1,l2t2,,mcul2treadack,{%x}>::MCU1 to L2T2 Read Request Acknowledgement", mcu1_l2t2_rd_ack);
end

always @(posedge (cmp_clk && enabled))
begin
    if(mcu1_l2t2_data_vld_r0)
    begin
        repeat(3) @(posedge cmp_clk);
        `PR_INFO("l2_proto_mon", `INFO, "MCU1 to L2B2 Read Data = %x", mcu1_l2b2_data_r2);
        `PR_INFO("l2_proto_mon", `INFO, "MCU1 to L2B2 Read Data ECC = %x",  mcu1_l2b2_ecc_r2);
    end
end

//////////////////////////////////////////////////////////////////

always @(posedge (cmp_clk && enabled))
begin
    if(l2t3_mcu1_rd_req)
    begin
        `PR_ALWAYS("l2_proto_mon", `ALWAYS, "<l2t3,mcu1,,l2tmcureadreq,{%x}>::L2T3 Read Request to MCU1", l2t3_mcu1_rd_req);
        `PR_ALWAYS("l2_proto_mon", `ALWAYS, "<l2t3,mcu1,,l2tmcureadreqid,{%x}>::L2T3 to MCU1 Read Request ID", l2t3_mcu1_rd_req_id);
        `PR_ALWAYS("l2_proto_mon", `ALWAYS, "<l2t3,mcu1,,l2tmcureadaddr,{%x}>::L2T3 to MCU1 Read Request Address", l2t3_mcu1_addr);
    end
end

always @(posedge (cmp_clk && enabled))
begin
    if(mcu1_l2t3_rd_ack)
        `PR_ALWAYS("l2_proto_mon", `ALWAYS, "<mcu1,l2t3,,mcul2treadack,{%x}>::MCU1 to L2T3 Read Request Acknowledgement", mcu1_l2t3_rd_ack);
end

always @(posedge (cmp_clk && enabled))
begin
    if(mcu1_l2t3_data_vld_r0)
    begin
        repeat(3) @(posedge cmp_clk);
        `PR_INFO("l2_proto_mon", `INFO, "MCU1 to L2B3 Read Data = %x",  mcu1_l2b3_data_r2);
        `PR_INFO("l2_proto_mon", `INFO, "MCU1 to L2B3 Read Data ECC = %x",  mcu1_l2b3_ecc_r2);
    end
end

//////////////////////////////////////////////////////////////////

always @(posedge (cmp_clk && enabled))
begin
    if(l2t4_mcu2_rd_req)
    begin
        `PR_ALWAYS("l2_proto_mon", `ALWAYS, "<l2t4,mcu2,,l2tmcureadreq,{%x}>::L2T4 Read Request to MCU2", l2t4_mcu2_rd_req);
        `PR_ALWAYS("l2_proto_mon", `ALWAYS, "<l2t4,mcu2,,l2tmcureadreqid,{%x}>::L2T4 to MCU2 Read Request ID", l2t4_mcu2_rd_req_id);
        `PR_ALWAYS("l2_proto_mon", `ALWAYS, "<l2t4,mcu2,,l2tmcureadaddr,{%x}>::L2T4 to MCU2 Read Request Address", l2t4_mcu2_addr);
    end
end

always @(posedge (cmp_clk && enabled))
begin
    if(mcu2_l2t4_rd_ack)
        `PR_ALWAYS("l2_proto_mon", `ALWAYS, "<mcu2,l2t4,,mcul2treadack,{%x}>::MCU2 to L2T4 Read Request Acknowledgement", mcu2_l2t4_rd_ack);
end

always @(posedge (cmp_clk && enabled))
begin
    if(mcu2_l2t4_data_vld_r0)
    begin
        repeat(3) @(posedge cmp_clk);
        `PR_INFO("l2_proto_mon", `INFO, "MCU2 to L2B4 Read Data = %x", mcu2_l2b4_data_r2);
        `PR_INFO("l2_proto_mon", `INFO, "MCU2 to L2B4 Read Data ECC = %x",  mcu2_l2b4_ecc_r2);
    end
end

//////////////////////////////////////////////////////////////////

always @(posedge (cmp_clk && enabled))
begin
    if(l2t5_mcu2_rd_req)
    begin
        `PR_ALWAYS("l2_proto_mon", `ALWAYS, "<l2t5,mcu2,,l2tmcureadreq,{%x}>::L2T5 Read Request to MCU2", l2t5_mcu2_rd_req);
        `PR_ALWAYS("l2_proto_mon", `ALWAYS, "<l2t5,mcu2,,l2tmcureadreqid,{%x}>::L2T5 to MCU2 Read Request ID", l2t5_mcu2_rd_req_id);
        `PR_ALWAYS("l2_proto_mon", `ALWAYS, "<l2t5,mcu2,,l2tmcureadaddr,{%x}>::L2T5 to MCU2 Read Request Address", l2t5_mcu2_addr);
    end
end

always @(posedge (cmp_clk && enabled))
begin
    if(mcu2_l2t5_rd_ack)
        `PR_ALWAYS("l2_proto_mon", `ALWAYS, "<mcu2,l2t5,,mcul2treadack,{%x}>::MCU2 to L2T5 Read Request Acknowledgement", mcu2_l2t5_rd_ack);
end

always @(posedge (cmp_clk && enabled))
begin
    if(mcu2_l2t5_data_vld_r0)
    begin
        repeat(3) @(posedge cmp_clk);
        `PR_INFO("l2_proto_mon", `INFO, "MCU2 to L2B5 Read Data = %x", mcu2_l2b5_data_r2);
        `PR_INFO("l2_proto_mon", `INFO, "MCU2 to L2B5 Read Data ECC = %x", mcu2_l2b5_ecc_r2);
    end
end

//////////////////////////////////////////////////////////////////

always @(posedge (cmp_clk && enabled))
begin
    if(l2t6_mcu3_rd_req)
    begin
        `PR_ALWAYS("l2_proto_mon", `ALWAYS, "<l2t6,mcu3,,l2tmcureadreq,{%x}>::L2T6 Read Request to MCU3", l2t6_mcu3_rd_req);
        `PR_ALWAYS("l2_proto_mon", `ALWAYS, "<l2t6,mcu3,,l2tmcureadreqid,{%x}>::L2T6 to MCU3 Read Request ID", l2t6_mcu3_rd_req_id);
        `PR_ALWAYS("l2_proto_mon", `ALWAYS, "<l2t6,mcu3,,l2tmcureadaddr,{%x}>::L2T6 to MCU3 Read Request Address", l2t6_mcu3_addr);
    end
end

always @(posedge (cmp_clk && enabled))
begin
    if(mcu3_l2t6_rd_ack)
        `PR_ALWAYS("l2_proto_mon", `ALWAYS, "<mcu3,l2t6,,mcul2treadack,{%x}>::MCU3 to L2T6 Read Request Acknowledgement", mcu3_l2t6_rd_ack);
end

always @(posedge (cmp_clk && enabled))
begin
    if(mcu3_l2t6_data_vld_r0)
    begin
        repeat(3) @(posedge cmp_clk);
        `PR_INFO("l2_proto_mon", `INFO, "MCU3 to L2B6 Read Data = %x", mcu3_l2b6_data_r2);
        `PR_INFO("l2_proto_mon", `INFO, "MCU3 to L2B6 Read Data ECC = %x", mcu3_l2b6_ecc_r2);
    end
end

//////////////////////////////////////////////////////////////////

always @(posedge (cmp_clk && enabled))
begin
    if(l2t7_mcu3_rd_req)
    begin
        `PR_ALWAYS("l2_proto_mon", `ALWAYS, "<l2t7,mcu3,,l2tmcureadreq,{%x}>::L2T7 Read Request to MCU3", l2t7_mcu3_rd_req);
        `PR_ALWAYS("l2_proto_mon", `ALWAYS, "<l2t7,mcu3,,l2tmcureadreqid,{%x}>::L2T7 to MCU3 Read Request ID", l2t7_mcu3_rd_req_id);
        `PR_ALWAYS("l2_proto_mon", `ALWAYS, "<l2t7,mcu3,,l2tmcureadaddr,{%x}>::L2T7 to MCU3 Read Request Address", l2t7_mcu3_addr);
    end
end

always @(posedge (cmp_clk && enabled))
begin
    if(mcu3_l2t7_rd_ack)
        `PR_ALWAYS("l2_proto_mon", `ALWAYS, "<mcu3,l2t7,,mcul2treadack,{%x}>::MCU3 to L2T7 Read Request Acknowledgement", mcu3_l2t7_rd_ack);
end

always @(posedge (cmp_clk && enabled))
begin
    if(mcu3_l2t7_data_vld_r0)
    begin
        repeat(3) @(posedge cmp_clk);
        `PR_INFO("l2_proto_mon", `INFO, "MCU3 to L2B7 Read Data = %x", mcu3_l2b7_data_r2);
        `PR_INFO("l2_proto_mon", `INFO, "MCU3 to L2B7 Read Data ECC = %x", mcu3_l2b7_ecc_r2);
    end
end


/* Monitors for Sending Write Request from L2 to MCU Section 2.1.2.2 Section 3.4.2 Manual Vol 1 */

always @(posedge (cmp_clk && enabled))
begin
    if(l2t0_mcu0_wr_req)
    begin
        `PR_ALWAYS("l2_proto_mon", `ALWAYS, "<l2t0,mcu0,,l2tmcuwritereq,{%x}>::L2T0 Write Request to MCU0", l2t0_mcu0_wr_req);
        `PR_ALWAYS("l2_proto_mon", `ALWAYS, "<l2t0,mcu0,,l2tmcuwriteaddr,{%x}>::L2T0 to MCU0 Write Request Address", l2t0_mcu0_addr);
    end
end

always @(posedge (cmp_clk && enabled))
begin
    if(mcu0_l2t0_wr_ack)
    begin
        `PR_ALWAYS("l2_proto_mon", `ALWAYS, "<mcu0,l2t0,,mcul2twriteack,{%x}>::MCU0 to L2T0 Write Request Acknowledgement", mcu0_l2t0_wr_ack);
        repeat(5) @(posedge cmp_clk);
        if(l2b0_mcu0_data_vld_r5)
        begin
            `PR_ALWAYS("l2_proto_mon", `ALWAYS, "<l2b0,mcu0,,l2bmcudatavld,{%x}>::L2B0 to MCU0 Data Valid and Write Data Cycle", l2b0_mcu0_data_vld_r5);
            `PR_INFO("l2_proto_mon", `INFO, "L2B0 to MCU0 Write Data = %x", l2b0_mcu0_wr_data_r5);
            repeat (7) @(posedge cmp_clk)
            begin
                `PR_INFO("l2_proto_mon", `INFO, "L2B0 to MCU0 Write Data = %x", l2b0_mcu0_wr_data_r5);
            end
        end 
    end
end

//////////////////////////////////////////////////////////////////

always @(posedge (cmp_clk && enabled))
begin
    if(l2t1_mcu0_wr_req)
    begin
        `PR_ALWAYS("l2_proto_mon", `ALWAYS, "<l2t1,mcu0,,l2tmcuwritereq,{%x}>::L2T1 Write Request to MCU0", l2t1_mcu0_wr_req);
        `PR_ALWAYS("l2_proto_mon", `ALWAYS, "<l2t1,mcu0,,l2tmcuwriteaddr,{%x}>::L2T1 to MCU0 Write Request Address", l2t1_mcu0_addr);
    end
end

always @(posedge (cmp_clk && enabled))
begin
    if(mcu0_l2t1_wr_ack)
    begin
        `PR_ALWAYS("l2_proto_mon", `ALWAYS, "<mcu0,l2t1,,mcul2twriteack,{%x}>::MCU0 to L2T1 Write Request Acknowledgement", mcu0_l2t1_wr_ack);
        repeat(5) @(posedge cmp_clk);
        if(l2b1_mcu0_data_vld_r5)
        begin
            `PR_ALWAYS("l2_proto_mon", `ALWAYS, "<l2b1,mcu0,,l2bmcudatavld,{%x}>::L2B1 to MCU0 Data Valid and Write Data Cycle", l2b1_mcu0_data_vld_r5);
            `PR_INFO("l2_proto_mon", `INFO, "L2B1 to MCU0 Write Data = %x", l2b1_mcu0_wr_data_r5);
            repeat (7) @(posedge cmp_clk)
            begin
                `PR_INFO("l2_proto_mon", `INFO, "L2B1 to MCU0 Write Data = %x", l2b1_mcu0_wr_data_r5);
            end
        end
    end
end


//////////////////////////////////////////////////////////////////

always @(posedge (cmp_clk && enabled))
begin
    if(l2t2_mcu1_wr_req)
    begin
        `PR_ALWAYS("l2_proto_mon", `ALWAYS, "<l2t2,mcu1,,l2tmcuwritereq,{%x}>::L2T2 Write Request to MCU1", l2t2_mcu1_wr_req);
        `PR_ALWAYS("l2_proto_mon", `ALWAYS, "<l2t2,mcu1,,l2tmcuwriteaddr,{%x}>::L2T2 to MCU1 Write Request Address", l2t2_mcu1_addr);
    end
end

always @(posedge (cmp_clk && enabled))
begin
    if(mcu1_l2t2_wr_ack)
    begin
        `PR_ALWAYS("l2_proto_mon", `ALWAYS, "<mcu1,l2t2,,mcul2twriteack,{%x}>::MCU1 to L2T2 Write Request Acknowledgement", mcu1_l2t2_wr_ack);
        repeat(5) @(posedge cmp_clk);
        if(l2b2_mcu1_data_vld_r5)
        begin
            `PR_ALWAYS("l2_proto_mon", `ALWAYS, "<l2b2,mcu1,,l2bmcudatavld,{%x}>::L2B2 to MCU1 Data Valid and Write Data Cycle", l2b2_mcu1_data_vld_r5);
            `PR_INFO("l2_proto_mon", `INFO, "L2B2 to MCU1 Write Data = %x", l2b2_mcu1_wr_data_r5);
            repeat (7) @(posedge cmp_clk)
            begin
                `PR_INFO("l2_proto_mon", `INFO, "L2B2 to MCU1 Write Data = %x", l2b2_mcu1_wr_data_r5);
            end
        end
    end
end


//////////////////////////////////////////////////////////////////

always @(posedge (cmp_clk && enabled))
begin
    if(l2t3_mcu1_wr_req)
    begin
        `PR_ALWAYS("l2_proto_mon", `ALWAYS, "<l2t3,mcu1,,l2tmcuwritereq,{%x}>::L2T3 Write Request to MCU1", l2t3_mcu1_wr_req);
        `PR_ALWAYS("l2_proto_mon", `ALWAYS, "<l2t3,mcu1,,l2tmcuwriteaddr,{%x}>::L2T3 to MCU1 Write Request Address", l2t3_mcu1_addr);
    end
end

always @(posedge (cmp_clk && enabled))
begin
    if(mcu1_l2t3_wr_ack)
    begin
        `PR_ALWAYS("l2_proto_mon", `ALWAYS, "<mcu1,l2t3,,mcul2twriteack,{%x}>::MCU1 to L2T3 Write Request Acknowledgement", mcu1_l2t3_wr_ack);
        repeat(5) @(posedge cmp_clk);
        if(l2b3_mcu1_data_vld_r5)
        begin
            `PR_ALWAYS("l2_proto_mon", `ALWAYS, "<l2b3,mcu1,,l2bmcudatavld,{%x}>::L2B3 to MCU1 Data Valid and Write Data Cycle", l2b3_mcu1_data_vld_r5);
            `PR_INFO("l2_proto_mon", `INFO, "L2B3 to MCU1 Write Data = %x", l2b3_mcu1_wr_data_r5);
            repeat (7) @(posedge cmp_clk)
            begin
                `PR_INFO("l2_proto_mon", `INFO, "L2B3 to MCU1 Write Data = %x", l2b3_mcu1_wr_data_r5);
            end
        end
    end
end

//////////////////////////////////////////////////////////////////

always @(posedge (cmp_clk && enabled))
begin
    if(l2t4_mcu2_wr_req)
    begin
        `PR_ALWAYS("l2_proto_mon", `ALWAYS, "<l2t4,mcu2,,l2tmcuwritereq,{%x}>::L2T4 Write Request to MCU2", l2t4_mcu2_wr_req);
        `PR_ALWAYS("l2_proto_mon", `ALWAYS, "<l2t4,mcu2,,l2tmcuwriteaddr,{%x}>::L2T4 to MCU2 Write Request Address", l2t4_mcu2_addr);
    end
end

always @(posedge (cmp_clk && enabled))
begin
    if(mcu2_l2t4_wr_ack)
    begin
        `PR_ALWAYS("l2_proto_mon", `ALWAYS, "<mcu2,l2t4,,mcul2twriteack,{%x}>::MCU2 to L2T4 Write Request Acknowledgement", mcu2_l2t4_wr_ack);
        repeat(5) @(posedge cmp_clk);
        if(l2b4_mcu2_data_vld_r5)
        begin
            `PR_ALWAYS("l2_proto_mon", `ALWAYS, "<l2b4,mcu2,,l2bmcudatavld,{%x}>::L2B4 to MCU2 Data Valid and Write Data Cycle", l2b4_mcu2_data_vld_r5);
            `PR_INFO("l2_proto_mon", `INFO, "L2B4 to MCU2 Write Data = %x", l2b4_mcu2_wr_data_r5);
            repeat (7) @(posedge cmp_clk)
            begin
                `PR_INFO("l2_proto_mon", `INFO, "L2B4 to MCU2 Write Data = %x", l2b4_mcu2_wr_data_r5);
            end
        end
    end
end

//////////////////////////////////////////////////////////////////

always @(posedge (cmp_clk && enabled))
begin
    if(l2t5_mcu2_wr_req)
    begin
        `PR_ALWAYS("l2_proto_mon", `ALWAYS, "<l2t5,mcu2,,l2tmcuwritereq,{%x}>::L2T5 Write Request to MCU2", l2t5_mcu2_wr_req);
        `PR_ALWAYS("l2_proto_mon", `ALWAYS, "<l2t5,mcu2,,l2tmcuwriteaddr,{%x}>::L2T5 to MCU2 Write Request Address", l2t5_mcu2_addr);
    end
end

always @(posedge (cmp_clk && enabled))
begin
    if(mcu2_l2t5_wr_ack)
    begin
        `PR_ALWAYS("l2_proto_mon", `ALWAYS, "<mcu2,l2t5,,mcul2twriteack,{%x}>::MCU2 to L2T5 Write Request Acknowledgement", mcu2_l2t5_wr_ack);
        repeat(5) @(posedge cmp_clk);
        if(l2b5_mcu2_data_vld_r5)
        begin
            `PR_ALWAYS("l2_proto_mon", `ALWAYS, "<l2b5,mcu2,,l2bmcudatavld,{%x}>::L2B5 to MCU2 Data Valid and Write Data Cycle", l2b5_mcu2_data_vld_r5);
            `PR_INFO("l2_proto_mon", `INFO, "L2B5 to MCU2 Write Data = %x", l2b5_mcu2_wr_data_r5);
            repeat (7) @(posedge cmp_clk)
            begin
                `PR_INFO("l2_proto_mon", `INFO, "L2B5 to MCU2 Write Data = %x", l2b5_mcu2_wr_data_r5);
            end
        end
    end
end

//////////////////////////////////////////////////////////////////

always @(posedge (cmp_clk && enabled))
begin
    if(l2t6_mcu3_wr_req)
    begin
        `PR_ALWAYS("l2_proto_mon", `ALWAYS, "<l2t6,mcu3,,l2tmcuwritereq,{%x}>::L2T6 Write Request to MCU3", l2t6_mcu3_wr_req);
        `PR_ALWAYS("l2_proto_mon", `ALWAYS, "<l2t6,mcu3,,l2tmcuwriteaddr,{%x}>::L2T6 to MCU3 Write Request Address", l2t6_mcu3_addr);
    end
end

always @(posedge (cmp_clk && enabled))
begin
    if(mcu3_l2t6_wr_ack)
    begin
        `PR_ALWAYS("l2_proto_mon", `ALWAYS, "<mcu3,l2t6,,mcul2twriteack,{%x}>::MCU3 to L2T6 Write Request Acknowledgement", mcu3_l2t6_wr_ack);
        repeat(5) @(posedge cmp_clk);
        if(l2b6_mcu3_data_vld_r5)
        begin
            `PR_ALWAYS("l2_proto_mon", `ALWAYS, "<l2b6,mcu3,,l2bmcudatavld,{%x}>::L2B6 to MCU3 Data Valid and Write Data Cycle", l2b6_mcu3_data_vld_r5);
            `PR_INFO("l2_proto_mon", `INFO, "L2B6 to MCU3 Write Data = %x", l2b6_mcu3_wr_data_r5);
            repeat (7) @(posedge cmp_clk)
            begin
                `PR_INFO("l2_proto_mon", `INFO, "L2B6 to MCU3 Write Data = %x", l2b6_mcu3_wr_data_r5);
            end
        end
    end
end

//////////////////////////////////////////////////////////////////

always @(posedge (cmp_clk && enabled))
begin
    if(l2t7_mcu3_wr_req)
    begin
        `PR_ALWAYS("l2_proto_mon", `ALWAYS, "<l2t7,mcu3,,l2tmcuwritereq,{%x}>::L2T7 Write Request to MCU3", l2t7_mcu3_wr_req);
        `PR_ALWAYS("l2_proto_mon", `ALWAYS, "<l2t7,mcu3,,l2tmcuwriteaddr,{%x}>::L2T7 to MCU3 Write Request Address", l2t7_mcu3_addr);
    end
end

always @(posedge (cmp_clk && enabled))
begin
    if(mcu3_l2t7_wr_ack)
    begin
        `PR_ALWAYS("l2_proto_mon", `ALWAYS, "<mcu3,l2t7,,mcul2twriteack,{%x}>::MCU3 to L2T7 Write Request Acknowledgement", mcu3_l2t7_wr_ack);
        repeat(5) @(posedge cmp_clk);
        if(l2b7_mcu3_data_vld_r5)
        begin
            `PR_ALWAYS("l2_proto_mon", `ALWAYS, "<l2b7,mcu3,,l2bmcudatavld,{%x}>::L2B7 to MCU3 Data Valid and Write Data Cycle", l2b7_mcu3_data_vld_r5);
            `PR_INFO("l2_proto_mon", `INFO, "L2B7 to MCU3 Write Data = %x", l2b7_mcu3_wr_data_r5);
            repeat (7) @(posedge cmp_clk)
            begin
                `PR_INFO("l2_proto_mon", `INFO, "L2B7 to MCU3 Write Data = %x", l2b7_mcu3_wr_data_r5);
            end
        end
    end
end


/* Monitors for receiving a request from the crossbar Section 2.1.2.1 Manual Vol 1 */

reg pcx_l2t0_data_rdy_px1_d;
always @(posedge (cmp_clk && enabled))
begin
    pcx_l2t0_data_rdy_px1_d <= pcx_l2t0_data_rdy_px1;
    if(pcx_l2t0_data_rdy_px1)
    begin
        `PR_ALWAYS("l2_proto_mon", `ALWAYS, "<pcx,l2t0,,pcxl2tdatavld,{%x}>::L2T0 receiving a Request from PCX", pcx_l2t0_data_rdy_px1);
        if(pcx_l2t0_atm_px1)
            `PR_ALWAYS("l2_proto_mon", `ALWAYS, "<pcx,l2t0,,pcxl2tatminst,{%x}>::Atomic Request Received at L2T0 from PCX", pcx_l2t0_atm_px1);
        else
            `PR_ALWAYS("l2_proto_mon", `ALWAYS, "<pcx,l2t0,,pcxl2tatminst,{%x}>::Non-Atomic Request Received at L2T0 from PCX", pcx_l2t0_atm_px1);
    end
end

always @(posedge (cmp_clk && enabled))
begin
    if(pcx_l2t0_data_rdy_px1_d)
        `PR_ALWAYS("l2_proto_mon", `ALWAYS, "<pcx,l2t0,,pcxl2tdata>::DATA Cycle started at L2T0 from PCX");
end

//////////////////////////////////////////////////////////////////

reg pcx_l2t1_data_rdy_px1_d;
always @(posedge (cmp_clk && enabled))
begin
    pcx_l2t1_data_rdy_px1_d <= pcx_l2t1_data_rdy_px1;
    if(pcx_l2t1_data_rdy_px1)
    begin
        `PR_ALWAYS("l2_proto_mon", `ALWAYS, "<pcx,l2t1,,pcxl2tdatavld,{%x}>::L2T1 receiving a Request from PCX", pcx_l2t1_data_rdy_px1);
        if(pcx_l2t1_atm_px1)
            `PR_ALWAYS("l2_proto_mon", `ALWAYS, "<pcx,l2t1,,pcxl2tatminst,{%x}>::Atomic Request Received at L2T1 from PCX", pcx_l2t1_atm_px1);
        else
            `PR_ALWAYS("l2_proto_mon", `ALWAYS, "<pcx,l2t1,,pcxl2tatminst,{%x}>::Non-Atomic Request Received at L2T1 from PCX", pcx_l2t1_atm_px1);
    end
end

always @(posedge (cmp_clk && enabled))
begin
    if(pcx_l2t1_data_rdy_px1_d)
        `PR_ALWAYS("l2_proto_mon", `ALWAYS, "<pcx,l2t1,,pcxl2tdata>::DATA Cycle started at L2T1 from PCX");
end

//////////////////////////////////////////////////////////////////

reg pcx_l2t2_data_rdy_px1_d;
always @(posedge (cmp_clk && enabled))
begin
    pcx_l2t2_data_rdy_px1_d <= pcx_l2t2_data_rdy_px1;
    if(pcx_l2t2_data_rdy_px1)
    begin
        `PR_ALWAYS("l2_proto_mon", `ALWAYS, "<pcx,l2t2,,pcxl2tdatavld,{%x}>::L2T2 receiving a Request from PCX", pcx_l2t2_data_rdy_px1);
        if(pcx_l2t2_atm_px1)
            `PR_ALWAYS("l2_proto_mon", `ALWAYS, "<pcx,l2t2,,pcxl2tatminst,{%x}>::Atomic Request Received at L2T2 from PCX", pcx_l2t2_atm_px1);
        else
            `PR_ALWAYS("l2_proto_mon", `ALWAYS, "<pcx,l2t2,,pcxl2tatminst,{%x}>::Non-Atomic Request Received at L2T2 from PCX", pcx_l2t2_atm_px1);
    end
end

always @(posedge (cmp_clk && enabled))
begin
    if(pcx_l2t2_data_rdy_px1_d)
        `PR_ALWAYS("l2_proto_mon", `ALWAYS, "<pcx,l2t2,,pcxl2tdata>::DATA Cycle started at L2T2 from PCX");
end

//////////////////////////////////////////////////////////////////

reg pcx_l2t3_data_rdy_px1_d;
always @(posedge (cmp_clk && enabled))
begin
    pcx_l2t3_data_rdy_px1_d <= pcx_l2t3_data_rdy_px1;
    if(pcx_l2t3_data_rdy_px1)
    begin
        `PR_ALWAYS("l2_proto_mon", `ALWAYS, "<pcx,l2t3,,pcxl2tdatavld,{%x}>::L2T3 receiving a Request from PCX", pcx_l2t3_data_rdy_px1);
        if(pcx_l2t3_atm_px1)
            `PR_ALWAYS("l2_proto_mon", `ALWAYS, "<pcx,l2t3,,pcxl2tatminst,{%x}>::Atomic Request Received at L2T3 from PCX", pcx_l2t3_atm_px1);
        else
            `PR_ALWAYS("l2_proto_mon", `ALWAYS, "<pcx,l2t3,,pcxl2tatminst,{%x}>::Non-Atomic Request Received at L2T3 from PCX", pcx_l2t3_atm_px1);
    end
end

always @(posedge (cmp_clk && enabled))
begin
    if(pcx_l2t3_data_rdy_px1_d)
        `PR_ALWAYS("l2_proto_mon", `ALWAYS, "<pcx,l2t3,,pcxl2tdata>::DATA Cycle started at L2T3 from PCX");
end

//////////////////////////////////////////////////////////////////

reg pcx_l2t4_data_rdy_px1_d;
always @(posedge (cmp_clk && enabled))
begin
    pcx_l2t4_data_rdy_px1_d <= pcx_l2t4_data_rdy_px1;
    if(pcx_l2t4_data_rdy_px1)
    begin
        `PR_ALWAYS("l2_proto_mon", `ALWAYS, "<pcx,l2t4,,pcxl2tdatavld,{%x}>::L2T4 receiving a Request from PCX", pcx_l2t4_data_rdy_px1);
        if(pcx_l2t4_atm_px1)
            `PR_ALWAYS("l2_proto_mon", `ALWAYS, "<pcx,l2t4,,pcxl2tatminst,{%x}>::Atomic Request Received at L2T4 from PCX", pcx_l2t4_atm_px1);
        else
            `PR_ALWAYS("l2_proto_mon", `ALWAYS, "<pcx,l2t4,,pcxl2tatminst,{%x}>::Non-Atomic Request Received at L2T4 from PCX", pcx_l2t4_atm_px1);
    end
end

always @(posedge (cmp_clk && enabled))
begin
    if(pcx_l2t4_data_rdy_px1_d)
        `PR_ALWAYS("l2_proto_mon", `ALWAYS, "<pcx,l2t4,,pcxl2tdata>::DATA Cycle started at L2T4 from PCX");
end

//////////////////////////////////////////////////////////////////

reg pcx_l2t5_data_rdy_px1_d;
always @(posedge (cmp_clk && enabled))
begin
    pcx_l2t5_data_rdy_px1_d <= pcx_l2t5_data_rdy_px1;
    if(pcx_l2t5_data_rdy_px1)
    begin
        `PR_ALWAYS("l2_proto_mon", `ALWAYS, "<pcx,l2t5,,pcxl2tdatavld,{%x}>::L2T5 receiving a Request from PCX", pcx_l2t5_data_rdy_px1);
        if(pcx_l2t5_atm_px1)
            `PR_ALWAYS("l2_proto_mon", `ALWAYS, "<pcx,l2t5,,pcxl2tatminst,{%x}>::Atomic Request Received at L2T5 from PCX", pcx_l2t5_atm_px1);
        else
            `PR_ALWAYS("l2_proto_mon", `ALWAYS, "<pcx,l2t5,,pcxl2tatminst,{%x}>::Non-Atomic Request Received at L2T5 from PCX", pcx_l2t5_atm_px1);
    end
end

always @(posedge (cmp_clk && enabled))
begin
    if(pcx_l2t5_data_rdy_px1_d)
        `PR_ALWAYS("l2_proto_mon", `ALWAYS, "<pcx,l2t5,,pcxl2tdata>::DATA Cycle started at L2T5 from PCX");
end

//////////////////////////////////////////////////////////////////

reg pcx_l2t6_data_rdy_px1_d;
always @(posedge (cmp_clk && enabled))
begin
    pcx_l2t6_data_rdy_px1_d <= pcx_l2t6_data_rdy_px1;
    if(pcx_l2t6_data_rdy_px1)
    begin
        `PR_ALWAYS("l2_proto_mon", `ALWAYS, "<pcx,l2t6,,pcxl2tdatavld,{%x}>::L2T6 receiving a Request from PCX", pcx_l2t6_data_rdy_px1);
        if(pcx_l2t6_atm_px1)
            `PR_ALWAYS("l2_proto_mon", `ALWAYS, "<pcx,l2t6,,pcxl2tatminst,{%x}>::Atomic Request Received at L2T6 from PCX", pcx_l2t6_atm_px1);
        else
            `PR_ALWAYS("l2_proto_mon", `ALWAYS, "<pcx,l2t6,,pcxl2tatminst,{%x}>::Non-Atomic Request Received at L2T6 from PCX", pcx_l2t6_atm_px1);
    end
end

always @(posedge (cmp_clk && enabled))
begin
    if(pcx_l2t6_data_rdy_px1_d)
        `PR_ALWAYS("l2_proto_mon", `ALWAYS, "<pcx,l2t6,,pcxl2tdata>::DATA Cycle started at L2T6 from PCX");
end

//////////////////////////////////////////////////////////////////

reg pcx_l2t7_data_rdy_px1_d;
always @(posedge (cmp_clk && enabled))
begin
    pcx_l2t7_data_rdy_px1_d <= pcx_l2t7_data_rdy_px1;
    if(pcx_l2t7_data_rdy_px1)
    begin
        `PR_ALWAYS("l2_proto_mon", `ALWAYS, "<pcx,l2t7,,pcxl2tdatavld,{%x}>::L2T7 receiving a Request from PCX", pcx_l2t7_data_rdy_px1);
        if(pcx_l2t7_atm_px1)
            `PR_ALWAYS("l2_proto_mon", `ALWAYS, "<pcx,l2t7,,pcxl2tatminst,{%x}>::Atomic Request Received at L2T7 from PCX", pcx_l2t7_atm_px1);
        else
            `PR_ALWAYS("l2_proto_mon", `ALWAYS, "<pcx,l2t7,,pcxl2tatminst,{%x}>::Non-Atomic Request Received at L2T7 from PCX", pcx_l2t7_atm_px1);
    end
end

always @(posedge (cmp_clk && enabled))
begin
    if(pcx_l2t7_data_rdy_px1_d)
        `PR_ALWAYS("l2_proto_mon", `ALWAYS, "<pcx,l2t7,,pcxl2tdata>::DATA Cycle started at L2T7 from PCX");
end


/* Monitors for sending a request to the crossbar Section 2.1.2.1 Manual Vol 1 */

reg l2t0_cpx_req_cq_d;
reg cpx_l2t0_grant_cx_d;
reg l2t0_detected = 1'b1;
always@(posedge (cmp_clk && enabled))
begin
    l2t0_cpx_req_cq_d <= l2t0_cpx_req_cq;
    cpx_l2t0_grant_cx_d <= cpx_l2t0_grant_cx;
    /* l2t0_cpx_req_cq is a low enabled signal from Figure 2-4 Manual Vol 1 */
    if(l2t0_cpx_req_cq)
    begin
        `PR_ALWAYS("l2_proto_mon", `ALWAYS, "<l2t0,cpx,,l2tcpxreq,{%x}>::L2T0 sending request to CPX", l2t0_cpx_req_cq);
    end
end

always @(posedge (cmp_clk && enabled))
begin
    if(l2t0_cpx_req_cq_d)
    begin
        `PR_ALWAYS("l2_proto_mon", `ALWAYS, "<l2t0,cpx,,l2tcpxdata>::Data Cycle started from L2T0 to CPX");
        repeat(2) @(posedge (cmp_clk && l2t0_detected))
        begin
            if(cpx_l2t0_grant_cx_d != cpx_l2t0_grant_cx)
            begin
                `PR_ALWAYS("l2_proto_mon", `ALWAYS, "<cpx,l2t0,,cpxl2tack,{%x}>::ACKNOWLEDGE from CPX Detected", cpx_l2t0_grant_cx);
                l2t0_detected = 1'b0;
            end
        end
    end
end

//////////////////////////////////////////////////////////////////

reg l2t1_cpx_req_cq_d;
reg cpx_l2t1_grant_cx_d;
reg l2t1_detected = 1'b1;
always@(posedge (cmp_clk && enabled))
begin
    l2t1_cpx_req_cq_d <= l2t1_cpx_req_cq;
    cpx_l2t1_grant_cx_d <= cpx_l2t1_grant_cx;
    /* l2t1_cpx_req_cq is a low enabled signal from Figure 2-4 Manual Vol 1 */
    if(l2t1_cpx_req_cq)
    begin
        `PR_ALWAYS("l2_proto_mon", `ALWAYS, "<l2t1,cpx,,l2tcpxreq,{%x}>::L2T1 sending request to CPX", l2t1_cpx_req_cq);
    end
end

always @(posedge (cmp_clk && enabled))
begin
    if(l2t1_cpx_req_cq_d)
    begin
        `PR_ALWAYS("l2_proto_mon", `ALWAYS, "<l2t1,cpx,,l2tcpxdata>::Data Cycle started from L2T1 to CPX");
        repeat(2) @(posedge (cmp_clk && l2t1_detected))
        begin
            if(cpx_l2t1_grant_cx_d != cpx_l2t1_grant_cx)
            begin
                `PR_ALWAYS("l2_proto_mon", `ALWAYS, "<cpx,l2t1,,cpxl2tack,{%x}>::ACKNOWLEDGE from CPX Detected", cpx_l2t1_grant_cx);
                l2t1_detected = 1'b0;
            end
        end
    end
end

//////////////////////////////////////////////////////////////////

reg l2t2_cpx_req_cq_d;
reg cpx_l2t2_grant_cx_d;
reg l2t2_detected = 1'b1;
always@(posedge (cmp_clk && enabled))
begin
    l2t2_cpx_req_cq_d <= l2t2_cpx_req_cq;
    cpx_l2t2_grant_cx_d <= cpx_l2t2_grant_cx;
    /* l2t2_cpx_req_cq is a low enabled signal from Figure 2-4 Manual Vol 1 */
    if(l2t2_cpx_req_cq)
    begin
        `PR_ALWAYS("l2_proto_mon", `ALWAYS, "<l2t2,cpx,,l2tcpxreq,{%x}>::L2T2 sending request to CPX", l2t2_cpx_req_cq);
    end
end


always @(posedge (cmp_clk && enabled))
begin
    if(l2t2_cpx_req_cq_d)
    begin
        `PR_ALWAYS("l2_proto_mon", `ALWAYS, "<l2t2,cpx,,l2tcpxdata>::Data Cycle started from L2T2 to CPX");
        repeat(2) @(posedge (cmp_clk && l2t2_detected))
        begin
            if(cpx_l2t2_grant_cx_d != cpx_l2t2_grant_cx)
            begin
                `PR_ALWAYS("l2_proto_mon", `ALWAYS, "<cpx,l2t2,,cpxl2tack,{%x}>::ACKNOWLEDGE from CPX Detected", cpx_l2t2_grant_cx);
                l2t2_detected = 1'b0;
            end
        end
    end
end

//////////////////////////////////////////////////////////////////

reg l2t3_cpx_req_cq_d;
reg cpx_l2t3_grant_cx_d;
reg l2t3_detected = 1'b1;
always@(posedge (cmp_clk && enabled))
begin
    l2t3_cpx_req_cq_d <= l2t3_cpx_req_cq;
    cpx_l2t3_grant_cx_d <= cpx_l2t3_grant_cx;
    /* l2t3_cpx_req_cq is a low enabled signal from Figure 2-4 Manual Vol 1 */
    if(l2t3_cpx_req_cq)
    begin
        `PR_ALWAYS("l2_proto_mon", `ALWAYS, "<l2t3,cpx,,l2tcpxreq,{%x}>::L2T3 sending request to CPX", l2t3_cpx_req_cq);
    end
end

always @(posedge (cmp_clk && enabled))
begin
    if(l2t3_cpx_req_cq_d)
    begin
        `PR_ALWAYS("l2_proto_mon", `ALWAYS, "<l2t3,cpx,,l2tcpxdata>::Data Cycle started from L2T3 to CPX");
        repeat(2) @(posedge (cmp_clk && l2t3_detected))
        begin
            if(cpx_l2t3_grant_cx_d != cpx_l2t3_grant_cx)
            begin
                `PR_ALWAYS("l2_proto_mon", `ALWAYS, "<cpx,l2t3,,cpxl2tack,{%x}>::ACKNOWLEDGE from CPX Detected", cpx_l2t3_grant_cx);
                l2t3_detected = 1'b0;
            end
        end
    end
end

//////////////////////////////////////////////////////////////////

reg l2t4_cpx_req_cq_d;
reg cpx_l2t4_grant_cx_d;
reg l2t4_detected = 1'b1;
always@(posedge (cmp_clk && enabled))
begin
    l2t4_cpx_req_cq_d <= l2t4_cpx_req_cq;
    cpx_l2t4_grant_cx_d <= cpx_l2t4_grant_cx;
    /* l2t4_cpx_req_cq is a low enabled signal from Figure 2-4 Manual Vol 1 */
    if(l2t4_cpx_req_cq)
    begin
        `PR_ALWAYS("l2_proto_mon", `ALWAYS, "<l2t4,cpx,,l2tcpxreq,{%x}>::L2T4 sending request to CPX", l2t4_cpx_req_cq);
    end
end

always @(posedge (cmp_clk && enabled))
begin
    if(l2t4_cpx_req_cq_d)
    begin
        `PR_ALWAYS("l2_proto_mon", `ALWAYS, "<l2t4,cpx,,l2tcpxdata>::Data Cycle started from L2T4 to CPX");
        repeat(2) @(posedge (cmp_clk && l2t4_detected))
        begin
            if(cpx_l2t4_grant_cx_d != cpx_l2t4_grant_cx)
            begin
                `PR_ALWAYS("l2_proto_mon", `ALWAYS, "<cpx,l2t4,,cpxl2tack,{%x}>::ACKNOWLEDGE from CPX Detected", cpx_l2t4_grant_cx);
                l2t4_detected = 1'b0;
            end
        end
    end
end

//////////////////////////////////////////////////////////////////

reg l2t5_cpx_req_cq_d;
reg cpx_l2t5_grant_cx_d;
reg l2t5_detected = 1'b1;
always@(posedge (cmp_clk && enabled))
begin
    l2t5_cpx_req_cq_d <= l2t5_cpx_req_cq;
    cpx_l2t5_grant_cx_d <= cpx_l2t5_grant_cx;
    /* l2t5_cpx_req_cq is a low enabled signal from Figure 2-4 Manual Vol 1 */
    if(l2t5_cpx_req_cq)
    begin
        `PR_ALWAYS("l2_proto_mon", `ALWAYS, "<l2t5,cpx,,l2tcpxreq,{%x}>::L2T5 sending request to CPX", l2t5_cpx_req_cq);
    end
end

always @(posedge (cmp_clk && enabled))
begin
    if(l2t5_cpx_req_cq_d)
    begin
        `PR_ALWAYS("l2_proto_mon", `ALWAYS, "<l2t5,cpx,,l2tcpxdata>::Data Cycle started from L2T5 to CPX");
        repeat(2) @(posedge (cmp_clk && l2t5_detected))
        begin
            if(cpx_l2t5_grant_cx_d != cpx_l2t5_grant_cx)
            begin
                `PR_ALWAYS("l2_proto_mon", `ALWAYS, "<cpx,l2t5,,cpxl2tack,{%x}>::ACKNOWLEDGE from CPX Detected", cpx_l2t5_grant_cx);
                l2t5_detected = 1'b0;
            end
        end
    end
end


//////////////////////////////////////////////////////////////////

reg l2t6_cpx_req_cq_d;
reg cpx_l2t6_grant_cx_d;
reg l2t6_detected = 1'b1;
always@(posedge (cmp_clk && enabled))
begin
    l2t6_cpx_req_cq_d <= l2t6_cpx_req_cq;
    cpx_l2t6_grant_cx_d <= cpx_l2t6_grant_cx;
    /* l2t6_cpx_req_cq is a low enabled signal from Figure 2-4 Manual Vol 1 */
    if(l2t6_cpx_req_cq)
    begin
        `PR_ALWAYS("l2_proto_mon", `ALWAYS, "<l2t6,cpx,,l2tcpxreq,{%x}>::L2T6 sending request to CPX", l2t6_cpx_req_cq);
    end
end

always @(posedge (cmp_clk && enabled))
begin
    if(l2t6_cpx_req_cq_d)
    begin
        `PR_ALWAYS("l2_proto_mon", `ALWAYS, "<l2t6,cpx,,l2tcpxdata>::Data Cycle started from L2T6 to CPX");
        repeat(2) @(posedge (cmp_clk && l2t6_detected))
        begin
            if(cpx_l2t6_grant_cx_d != cpx_l2t6_grant_cx)
            begin
                `PR_ALWAYS("l2_proto_mon", `ALWAYS, "<cpx,l2t6,,cpxl2tack,{%x}>::ACKNOWLEDGE from CPX Detected", cpx_l2t6_grant_cx);
                l2t6_detected = 1'b0;
            end
        end
    end
end

//////////////////////////////////////////////////////////////////

reg l2t7_cpx_req_cq_d;
reg cpx_l2t7_grant_cx_d;
reg l2t7_detected = 1'b1;
always@(posedge (cmp_clk && enabled))
begin
    l2t7_cpx_req_cq_d <= l2t7_cpx_req_cq;
    cpx_l2t7_grant_cx_d <= cpx_l2t7_grant_cx;
    /* l2t7_cpx_req_cq is a low enabled signal from Figure 2-4 Manual Vol 1 */
    if(l2t7_cpx_req_cq)
    begin
        `PR_ALWAYS("l2_proto_mon", `ALWAYS, "<l2t7,cpx,,l2tcpxreq,{%x}>::L2T7 sending request to CPX", l2t7_cpx_req_cq);
    end
end

always @(posedge (cmp_clk && enabled))
begin
    if(l2t7_cpx_req_cq_d)
    begin
        `PR_ALWAYS("l2_proto_mon", `ALWAYS, "<l2t7,cpx,,l2tcpxdata>::Data Cycle started from L2T7 to CPX");
        repeat(2) @(posedge (cmp_clk && l2t7_detected))
        begin
            if(cpx_l2t7_grant_cx_d != cpx_l2t7_grant_cx)
            begin
                `PR_ALWAYS("l2_proto_mon", `ALWAYS, "<cpx,l2t7,,cpxl2tack,{%x}>::ACKNOWLEDGE from CPX Detected", cpx_l2t7_grant_cx);
                l2t7_detected = 1'b0;
            end
        end
    end
end

endmodule
