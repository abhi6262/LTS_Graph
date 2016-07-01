/*

Monitor written by : Debjit Pal
Email ID: dpal2@illinois.edu
Institute: Univerisity of Illinois at Urbana-Champaign

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
end

wire flush_reset_complete = `TOP.flush_reset_complete;

always @(flush_reset_complete)
begin
    if(flush_reset_complete == 1'b0)
        enabled = 1'b0;
    if((flush_reset_complete == 1'b1) && (!($test$plusargs("l2_proto_mon_off"))))
        enabled = 1'b1;
end

/* L2 protocols are running at the same frequency as that of the core */

wire cmp_clk = `CPU.l2clk & enabled;


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

wire l2t0_cpx_req_cq = `L2T0.l2t_cpx_req_cq;
wire l2t0_cpx_data_ca = `L2T0.l2t_cpx_data_ca;
wire cpx_l2t0_grant_cx = `L2T0.cpx_l2t_grant_cx;

wire l2t1_cpx_req_cq = `L2T1.l2t_cpx_req_cq;
wire l2t1_cpx_data_ca = `L2T1.l2t_cpx_data_ca;
wire cpx_l2t1_grant_cx = `L2T1.cpx_l2t_grant_cx;

wire l2t2_cpx_req_cq = `L2T2.l2t_cpx_req_cq;
wire l2t2_cpx_data_ca = `L2T2.l2t_cpx_data_ca;
wire cpx_l2t2_grant_cx = `L2T2.cpx_l2t_grant_cx;

wire l2t3_cpx_req_cq = `L2T3.l2t_cpx_req_cq;
wire l2t3_cpx_data_ca = `L2T3.l2t_cpx_data_ca;
wire cpx_l2t3_grant_cx = `L2T3.cpx_l2t_grant_cx;

wire l2t4_cpx_req_cq = `L2T4.l2t_cpx_req_cq;
wire l2t4_cpx_data_ca = `L2T4.l2t_cpx_data_ca;
wire cpx_l2t4_grant_cx = `L2T4.cpx_l2t_grant_cx;

wire l2t5_cpx_req_cq = `L2T5.l2t_cpx_req_cq;
wire l2t5_cpx_data_ca = `L2T5.l2t_cpx_data_ca;
wire cpx_l2t5_grant_cx = `L2T5.cpx_l2t_grant_cx;

wire l2t6_cpx_req_cq = `L2T6.l2t_cpx_req_cq;
wire l2t6_cpx_data_ca = `L2T6.l2t_cpx_data_ca;
wire cpx_l2t6_grant_cx = `L2T6.cpx_l2t_grant_cx;

wire l2t7_cpx_req_cq = `L2T7.l2t_cpx_req_cq;
wire l2t7_cpx_data_ca = `L2T7.l2t_cpx_data_ca;
wire cpx_l2t7_grant_cx = `L2T7.cpx_l2t_grant_cx;


//////////////////////////////////////////////////////////////
//                                                          //
//      Signals for RDD hit in L2 (Interactions with SIU)   //
//                                                          //
//////////////////////////////////////////////////////////////


wire sii_l2t0_req_vld = `L2T0.sii_l2t_req_vld;
wire [31:0] sii_l2t0_req = `L2T0.sii_l2t_req;       // In the doc it is mentioned as sii_l2t_data
wire l2t0_sii_iq_dequeue = `L2T0.l2t_sii_iq_dequeue;
wire l2t0_sii_wib_dequeue = `L2T0.l2t_sii_iq_dequeue;
wire l2b0_sio_ctag_vld = `L2B0.l2b_sio_ctag_vld;
wire l2b0_sio_ue_err = `L2B0.l2b_sio_ue_err;
wire [31:0] l2b0_sio_data = `L2B0.l2b_sio_data;

wire sii_l2t1_req_vld = `L2T1.sii_l2t_req_vld;
wire [31:0] sii_l2t1_req = `L2T1.sii_l2t_req;       // In the doc it is mentioned as sii_l2t_data
wire l2t1_sii_iq_dequeue = `L2T1.l2t_sii_iq_dequeue;
wire l2t1_sii_wib_dequeue = `L2T1.l2t_sii_iq_dequeue;
wire l2b1_sio_ctag_vld = `L2B1.l2b_sio_ctag_vld;
wire l2b1_sio_ue_err = `L2B1.l2b_sio_ue_err;
wire [31:0] l2b1_sio_data = `L2B1.l2b_sio_data;

wire sii_l2t2_req_vld = `L2T2.sii_l2t_req_vld;
wire [31:0] sii_l2t2_req = `L2T2.sii_l2t_req;       // In the doc it is mentioned as sii_l2t_data
wire l2t2_sii_iq_dequeue = `L2T2.l2t_sii_iq_dequeue;
wire l2t2_sii_wib_dequeue = `L2T2.l2t_sii_iq_dequeue;
wire l2b2_sio_ctag_vld = `L2B2.l2b_sio_ctag_vld;
wire l2b2_sio_ue_err = `L2B2.l2b_sio_ue_err;
wire [31:0] l2b2_sio_data = `L2B2.l2b_sio_data;

wire sii_l2t3_req_vld = `L2T3.sii_l2t_req_vld;
wire [31:0] sii_l2t3_req = `L2T3.sii_l2t_req;       // In the doc it is mentioned as sii_l2t_data
wire l2t3_sii_iq_dequeue = `L2T3.l2t_sii_iq_dequeue;
wire l2t3_sii_wib_dequeue = `L2T3.l2t_sii_iq_dequeue;
wire l2b3_sio_ctag_vld = `L2B3.l2b_sio_ctag_vld;
wire l2b3_sio_ue_err = `L2B3.l2b_sio_ue_err;
wire [31:0] l2b3_sio_data = `L2B3.l2b_sio_data;

wire sii_l2t4_req_vld = `L2T4.sii_l2t_req_vld;
wire [31:0] sii_l2t4_req = `L2T4.sii_l2t_req;       // In the doc it is mentioned as sii_l2t_data
wire l2t4_sii_iq_dequeue = `L2T4.l2t_sii_iq_dequeue;
wire l2t4_sii_wib_dequeue = `L2T4.l2t_sii_iq_dequeue;
wire l2b4_sio_ctag_vld = `L2B4.l2b_sio_ctag_vld;
wire l2b4_sio_ue_err = `L2B4.l2b_sio_ue_err;
wire [31:0] l2b4_sio_data = `L2B4.l2b_sio_data;

wire sii_l2t5_req_vld = `L2T5.sii_l2t_req_vld;
wire [31:0] sii_l2t5_req = `L2T5.sii_l2t_req;       // In the doc it is mentioned as sii_l2t_data
wire l2t5_sii_iq_dequeue = `L2T5.l2t_sii_iq_dequeue;
wire l2t5_sii_wib_dequeue = `L2T5.l2t_sii_iq_dequeue;
wire l2b5_sio_ctag_vld = `L2B5.l2b_sio_ctag_vld;
wire l2b5_sio_ue_err = `L2B5.l2b_sio_ue_err;
wire [31:0] l2b5_sio_data = `L2B5.l2b_sio_data;

wire sii_l2t6_req_vld = `L2T6.sii_l2t_req_vld;
wire [31:0] sii_l2t6_req = `L2T6.sii_l2t_req;       // In the doc it is mentioned as sii_l2t_data
wire l2t6_sii_iq_dequeue = `L2T6.l2t_sii_iq_dequeue;
wire l2t6_sii_wib_dequeue = `L2T6.l2t_sii_iq_dequeue;
wire l2b6_sio_ctag_vld = `L2B6.l2b_sio_ctag_vld;
wire l2b6_sio_ue_err = `L2B6.l2b_sio_ue_err;
wire [31:0] l2b6_sio_data = `L2B6.l2b_sio_data;

wire sii_l2t7_req_vld = `L2T7.sii_l2t_req_vld;
wire [31:0] sii_l2t7_req = `L2T7.sii_l2t_req;       // In the doc it is mentioned as sii_l2t_data
wire l2t7_sii_iq_dequeue = `L2T7.l2t_sii_iq_dequeue;
wire l2t7_sii_wib_dequeue = `L2T7.l2t_sii_iq_dequeue;
wire l2b7_sio_ctag_vld = `L2B7.l2b_sio_ctag_vld;
wire l2b7_sio_ue_err = `L2B7.l2b_sio_ue_err;
wire [31:0] l2b7_sio_data = `L2B7.l2b_sio_data;


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


wire l2t0_mcu0_wr_req = `L2T0.l2t_mcu_wr_req;
wire [39:7] l2t0_mcu0_addr = `L2T0.l2t_mcu_addr;
wire mcu0_l2t0_rd_ack = `L2T0.mcu_l2t_rd_ack;
wire l2b0_mcu0_data_vld_r5 = `L2B0.evict_l2b_mcu_data_vld_r5;
wire [63:0] l2b0_mcu0_wr_data_r5 = `L2B0.evict_l2b_mcu_wr_data_r5;

wire l2t1_mcu0_wr_req = `L2T1.l2t_mcu_wr_req;
wire [39:7] l2t1_mcu0_addr = `L2T1.l2t_mcu_addr;
wire mcu0_l2t1_rd_ack = `L2T1.mcu_l2t_rd_ack;
wire l2b1_mcu0_data_vld_r5 = `L2B1.evict_l2b_mcu_data_vld_r5;
wire [63:0] l2b1_mcu0_wr_data_r5 = `L2B1.evict_l2b_mcu_wr_data_r5;

wire l2t2_mcu1_wr_req = `L2T2.l2t_mcu_wr_req;
wire [39:7] l2t2_mcu1_addr = `L2T2.l2t_mcu_addr;
wire mcu1_l2t2_rd_ack = `L2T2.mcu_l2t_rd_ack;
wire l2b2_mcu1_data_vld_r5 = `L2B2.evict_l2b_mcu_data_vld_r5;
wire [63:0] l2b2_mcu1_wr_data_r5 = `L2B2.evict_l2b_mcu_wr_data_r5;

wire l2t3_mcu1_wr_req = `L2T3.l2t_mcu_wr_req;
wire [39:7] l2t3_mcu1_addr = `L2T3.l2t_mcu_addr;
wire mcu1_l2t3_rd_ack = `L2T3.mcu_l2t_rd_ack;
wire l2b3_mcu1_data_vld_r5 = `L2B3.evict_l2b_mcu_data_vld_r5;
wire [63:0] l2b3_mcu1_wr_data_r5 = `L2B3.evict_l2b_mcu_wr_data_r5;

wire l2t4_mcu2_wr_req = `L2T4.l2t_mcu_wr_req;
wire [39:7] l2t4_mcu2_addr = `L2T4.l2t_mcu_addr;
wire mcu2_l2t4_rd_ack = `L2T4.mcu_l2t_rd_ack;
wire l2b4_mcu2_data_vld_r5 = `L2B4.evict_l2b_mcu_data_vld_r5;
wire [63:0] l2b4_mcu2_wr_data_r5 = `L2B4.evict_l2b_mcu_wr_data_r5;

wire l2t5_mcu2_wr_req = `L2T5.l2t_mcu_wr_req;
wire [39:7] l2t5_mcu2_addr = `L2T5.l2t_mcu_addr;
wire mcu2_l2t5_rd_ack = `L2T5.mcu_l2t_rd_ack;
wire l2b5_mcu2_data_vld_r5 = `L2B5.evict_l2b_mcu_data_vld_r5;
wire [63:0] l2b5_mcu2_wr_data_r5 = `L2B5.evict_l2b_mcu_wr_data_r5;

wire l2t6_mcu3_wr_req = `L2T6.l2t_mcu_wr_req;
wire [39:7] l2t6_mcu3_addr = `L2T6.l2t_mcu_addr;
wire mcu3_l2t6_rd_ack = `L2T6.mcu_l2t_rd_ack;
wire l2b6_mcu3_data_vld_r5 = `L2B6.evict_l2b_mcu_data_vld_r5;
wire [63:0] l2b6_mcu3_wr_data_r5 = `L2B6.evict_l2b_mcu_wr_data_r5;

wire l2t7_mcu3_wr_req = `L2T7.l2t_mcu_wr_req;
wire [39:7] l2t7_mcu3_addr = `L2T7.l2t_mcu_addr;
wire mcu3_l2t7_rd_ack = `L2T7.mcu_l2t_rd_ack;
wire l2b7_mcu3_data_vld_r5 = `L2B7.evict_l2b_mcu_data_vld_r5;
wire [63:0] l2b7_mcu3_wr_data_r5 = `L2B7.evict_l2b_mcu_wr_data_r5;

/* Section 3.4.1 Manual Vol 1 */

/* L2 to MCU Read Request */
always @(posedge (cmp_clk && enabled))
begin
    if(l2t0_mcu0_rd_req)
    begin
        `PR_ALWAYS("l2_proto_mon", `ALWAYS, "L2T0 Read Request to MCU0");
        `PR_INFO("l2_proto_mon", `INFO, "L2T0 to MCU0 Read Request Address = %x", l2t0_mcu0_addr);
        `PR_INFO("l2_proto_mon", `INFO, "L2T0 to MCU0 Read Request ID = %x", l2t0_mcu0_rd_req_id);
    end
end

always @(posedge (cmp_clk && enabled))
begin
    if(l2t1_mcu0_rd_req)
    begin
        `PR_ALWAYS("l2_proto_mon", `ALWAYS, "L2T1 Read Request to MCU0");
        `PR_INFO("l2_proto_mon", `INFO, "L2T1 to MCU0 Read Request Address = %x", l2t1_mcu0_addr);
        `PR_INFO("l2_proto_mon", `INFO, "L2T1 to MCU0 Read Request ID = %x", l2t1_mcu0_rd_req_id);
    end
end

always @(posedge (cmp_clk && enabled))
begin
    if(l2t2_mcu1_rd_req)
    begin
        `PR_ALWAYS("l2_proto_mon", `ALWAYS, "L2T2 Read Request to MCU1");
        `PR_INFO("l2_proto_mon", `INFO, "L2T2 to MCU1 Read Request Address = %x", l2t2_mcu1_addr);
        `PR_INFO("l2_proto_mon", `INFO, "L2T2 to MCU1 Read Request ID = %x", l2t2_mcu1_rd_req_id);
    end
end

always @(posedge (cmp_clk && enabled))
begin
    if(l2t3_mcu1_rd_req)
    begin
        `PR_ALWAYS("l2_proto_mon", `ALWAYS, "L2T3 Read Request to MCU1");
        `PR_INFO("l2_proto_mon", `INFO, "L2T3 to MCU1 Read Request Address = %x", l2t3_mcu1_addr);
        `PR_INFO("l2_proto_mon", `INFO, "L2T3 to MCU1 Read Request ID = %x", l2t3_mcu1_rd_req_id);
    end
end

always @(posedge (cmp_clk && enabled))
begin
    if(l2t4_mcu2_rd_req)
    begin
        `PR_ALWAYS("l2_proto_mon", `ALWAYS, "L2T4 Read Request to MCU2");
        `PR_INFO("l2_proto_mon", `INFO, "L2T4 to MCU2 Read Request Address = %x", l2t4_mcu2_addr);
        `PR_INFO("l2_proto_mon", `INFO, "L2T4 to MCU2 Read Request ID = %x", l2t4_mcu2_rd_req_id);
    end
end

always @(posedge (cmp_clk && enabled))
begin
    if(l2t5_mcu2_rd_req)
    begin
        `PR_ALWAYS("l2_proto_mon", `ALWAYS, "L2T5 Read Request to MCU2");
        `PR_INFO("l2_proto_mon", `INFO, "L2T5 to MCU2 Read Request Address = %x", l2t5_mcu2_addr);
        `PR_INFO("l2_proto_mon", `INFO, "L2T5 to MCU2 Read Request ID = %x", l2t5_mcu2_rd_req_id);
    end
end

always @(posedge (cmp_clk && enabled))
begin
    if(l2t6_mcu3_rd_req)
    begin
        `PR_ALWAYS("l2_proto_mon", `ALWAYS, "L2T6 Read Request to MCU3");
        `PR_INFO("l2_proto_mon", `INFO, "L2T6 to MCU3 Read Request Address = %x", l2t6_mcu3_addr);
        `PR_INFO("l2_proto_mon", `INFO, "L2T6 to MCU3 Read Request ID = %x", l2t6_mcu3_rd_req_id);
    end
end

always @(posedge (cmp_clk && enabled))
begin
    if(l2t7_mcu3_rd_req)
    begin
        `PR_ALWAYS("l2_proto_mon", `ALWAYS, "L2T7 Read Request to MCU3");
        `PR_INFO("l2_proto_mon", `INFO, "L2T7 to MCU3 Read Request Address = %x", l2t7_mcu3_addr);
        `PR_INFO("l2_proto_mon", `INFO, "L2T7 to MCU3 Read Request ID = %x", l2t7_mcu3_rd_req_id);
    end
end



/* MCU to L2 Read Request Acknowledgement */
always @(posedge (cmp_clk && enabled))
begin
    if(mcu0_l2t0_rd_ack)
        `PR_ALWAYS("l2_proto_mon", `ALWAYS, "MCU0 to L2T0 Read Request Acknowledgement");
end

always @(posedge (cmp_clk && enabled))
begin
    if(mcu0_l2t1_rd_ack)
        `PR_ALWAYS("l2_proto_mon", `ALWAYS, "MCU0 to L2T1 Read Request Acknowledgement");
end

always @(posedge (cmp_clk && enabled))
begin
    if(mcu1_l2t2_rd_ack)
        `PR_ALWAYS("l2_proto_mon", `ALWAYS, "MCU1 to L2T2 Read Request Acknowledgement");
end

always @(posedge (cmp_clk && enabled))
begin
    if(mcu1_l2t3_rd_ack)
        `PR_ALWAYS("l2_proto_mon", `ALWAYS, "MCU1 to L2T3 Read Request Acknowledgement");
end

always @(posedge (cmp_clk && enabled))
begin
    if(mcu2_l2t4_rd_ack)
        `PR_ALWAYS("l2_proto_mon", `ALWAYS, "MCU2 to L2T4 Read Request Acknowledgement");
end

always @(posedge (cmp_clk && enabled))
begin
    if(mcu2_l2t5_rd_ack)
        `PR_ALWAYS("l2_proto_mon", `ALWAYS, "MCU2 to L2T5 Read Request Acknowledgement");
end

always @(posedge (cmp_clk && enabled))
begin
    if(mcu3_l2t6_rd_ack)
        `PR_ALWAYS("l2_proto_mon", `ALWAYS, "MCU3 to L2T6 Read Request Acknowledgement");
end

always @(posedge (cmp_clk && enabled))
begin
    if(mcu3_l2t7_rd_ack)
        `PR_ALWAYS("l2_proto_mon", `ALWAYS, "MCU3 to L2T7 Read Request Acknowledgement");
end


/* MCU to L2 Read Rquest Data */
always @(posedge (cmp_clk && enabled))
begin
    if(mcu0_l2t0_data_vld_r0)
    begin
        `PR_INFO("l2_proto_mon", `INFO, "MCU0 to L2B0 Read Data = %x", ##3 mcu0_l2b0_data_r2);
        `PR_INFO("l2_proto_mon", `INFO, "MCU0 to L2B0 Read Data ECC = %x", ##3 mcu0_l2b0_ecc_r2);
    end
end

always @(posedge (cmp_clk && enabled))
begin
    if(mcu0_l2t1_data_vld_r0)
    begin
        `PR_INFO("l2_proto_mon", `INFO, "MCU0 to L2B1 Read Data = %x", ##3 mcu0_l2b1_data_r2);
        `PR_INFO("l2_proto_mon", `INFO, "MCU0 to L2B1 Read Data ECC = %x", ##3 mcu0_l2b1_ecc_r2);
    end
end

always @(posedge (cmp_clk && enabled))
begin
    if(mcu1_l2t2_data_vld_r0)
    begin
        `PR_INFO("l2_proto_mon", `INFO, "MCU1 to L2B2 Read Data = %x", ##3 mcu1_l2b2_data_r2);
        `PR_INFO("l2_proto_mon", `INFO, "MCU1 to L2B2 Read Data ECC = %x", ##3 mcu1_l2b2_ecc_r2);
    end
end

always @(posedge (cmp_clk && enabled))
begin
    if(mcu1_l2t3_data_vld_r0)
    begin
        `PR_INFO("l2_proto_mon", `INFO, "MCU1 to L2B3 Read Data = %x", ##3 mcu1_l2b3_data_r2);
        `PR_INFO("l2_proto_mon", `INFO, "MCU1 to L2B3 Read Data ECC = %x", ##3 mcu1_l2b3_ecc_r2);
    end
end

always @(posedge (cmp_clk && enabled))
begin
    if(mcu2_l2t4_data_vld_r0)
    begin
        `PR_INFO("l2_proto_mon", `INFO, "MCU2 to L2B4 Read Data = %x", ##3 mcu2_l2b4_data_r2);
        `PR_INFO("l2_proto_mon", `INFO, "MCU2 to L2B4 Read Data ECC = %x", ##3 mcu2_l2b4_ecc_r2);
    end
end

always @(posedge (cmp_clk && enabled))
begin
    if(mcu2_l2t5_data_vld_r0)
    begin
        `PR_INFO("l2_proto_mon", `INFO, "MCU2 to L2B5 Read Data = %x", ##3 mcu2_l2b5_data_r2);
        `PR_INFO("l2_proto_mon", `INFO, "MCU2 to L2B5 Read Data ECC = %x", ##3 mcu2_l2b5_ecc_r2);
    end
end

always @(posedge (cmp_clk && enabled))
begin
    if(mcu3_l2t6_data_vld_r0)
    begin
        `PR_INFO("l2_proto_mon", `INFO, "MCU3 to L2B6 Read Data = %x", ##3 mcu3_l2b6_data_r2);
        `PR_INFO("l2_proto_mon", `INFO, "MCU3 to L2B6 Read Data ECC = %x", ##3 mcu3_l2b6_ecc_r2);
    end
end

always @(posedge (cmp_clk && enabled))
begin
    if(mcu3_l2t7_data_vld_r0)
    begin
        `PR_INFO("l2_proto_mon", `INFO, "MCU3 to L2B7 Read Data = %x", ##3 mcu3_l2b7_data_r2);
        `PR_INFO("l2_proto_mon", `INFO, "MCU3 to L2B7 Read Data ECC = %x", ##3 mcu3_l2b7_ecc_r2);
    end
end


endmodule
