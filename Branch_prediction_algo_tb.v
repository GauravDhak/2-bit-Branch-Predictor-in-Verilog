`include "Branch_prediction_algo.v"

module BranchPredictor_tb;

    reg clk;
    reg reset;
    reg [31:0] pc;
    reg branch_taken;
    wire prediction;

    // Instantiate the branch predictor
    BranchPredictor uut (
        .clk(clk),
        .reset(reset),
        .pc(pc),
        .branch_taken(branch_taken),
        .prediction(prediction)
    );

    // Clock generation
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    // Test sequence
    initial begin
        // Initialize
        reset = 1;
        pc = 0;
        branch_taken = 0;
        #10 reset = 0;

        // Test case 1: branch not taken
        #10 pc = 32'h00000004; branch_taken = 0;
        #10 pc = 32'h00000004; branch_taken = 0;
        #10 pc = 32'h00000004; branch_taken = 0;

        // Test case 2: branch taken
        #10 pc = 32'h00000008; branch_taken = 1;
        #10 pc = 32'h00000008; branch_taken = 1;
        #10 pc = 32'h00000008; branch_taken = 1;

        // Test case 3: branch taken and not taken alternately
        #10 pc = 32'h0000000C; branch_taken = 1;
        #10 pc = 32'h0000000C; branch_taken = 0;
        #10 pc = 32'h0000000C; branch_taken = 1;
        #10 pc = 32'h0000000C; branch_taken = 0;

        // End simulation
        #20 $finish;
    end

    // Monitor the outputs
    initial begin
        $dumpfile("BranchPredictor_tb.vcd");
        $dumpvars(0,BranchPredictor_tb);
        $monitor("At time %0t: pc = %h, branch_taken = %b, prediction = %b",
                 $time, pc, branch_taken, prediction);
    end

endmodule
