/*

Monitor written by : Debjit Pal
Email ID: dpal2@illinois.edu
Institute: Univerisity of Illinois at Urbana-Champaign

*/

/* Define the modules */

module dmu_to_ncu_proto_mon();

reg enabled;
initial begin
    enabled = 1'b1;
    if($test$plusargs("dmu_ncu_proto_mon_off"))
    begin
        enabled = 1'b0;
    end
end


endmodule
