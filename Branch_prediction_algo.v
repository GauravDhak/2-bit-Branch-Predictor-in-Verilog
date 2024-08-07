
/*
File Name :Branch_prediction_algo.v (Verilog)
Type      :Module
Version   : 1.0
Date      :07/24
*/
module BranchPredictor (
    input wire clk,            // Clock signal
    input wire reset,          // Reset signal
    input wire [31:0] pc,      // Program counter (address of the branch)
    input wire branch_taken,   // Actual outcome of the branch
    output reg prediction      // Predicted outcome of the branch
);

    // Define the number of entries in the prediction table
    parameter TABLE_SIZE = 64;

    // Define the states for the 2-bit saturating counter
    parameter STRONGLY_NOT_TAKEN = 2'b00;
    parameter WEAKLY_NOT_TAKEN = 2'b01;
    parameter WEAKLY_TAKEN = 2'b10;
    parameter STRONGLY_TAKEN = 2'b11;

    // The prediction table, which holds the 2-bit counters
    reg [1:0] prediction_table [TABLE_SIZE-1:0];

    // Calculate the index for the prediction table using part of the PC
    wire [$clog2(TABLE_SIZE)-1:0] index;
    assign index = pc[$clog2(TABLE_SIZE)+1:2];

    // Initialize the prediction table with the default state
    integer i;
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            // On reset, set all entries to 'WEAKLY_TAKEN'
            for (i = 0; i < TABLE_SIZE; i = i + 1) begin
                prediction_table[i] <= WEAKLY_TAKEN;
            end
        end
    end

    // Make a prediction based on the current state of the counter
    always @(*) begin
        case (prediction_table[index])
            STRONGLY_NOT_TAKEN, WEAKLY_NOT_TAKEN: prediction = 0; // Predict 'not taken'
            WEAKLY_TAKEN, STRONGLY_TAKEN: prediction = 1;         // Predict 'taken'
        endcase
    end

    // Update the prediction table based on the actual outcome
    always @(posedge clk) begin
        if (!reset) begin
            // Update the state of the counter based on the actual outcome
            case ({prediction_table[index], branch_taken})
                // Strongly Not Taken
                {STRONGLY_NOT_TAKEN, 1'b0}: prediction_table[index] <= STRONGLY_NOT_TAKEN; // Correct, stay
                {STRONGLY_NOT_TAKEN, 1'b1}: prediction_table[index] <= WEAKLY_NOT_TAKEN;  // Incorrect, move to weakly not taken
                
                // Weakly Not Taken
                {WEAKLY_NOT_TAKEN, 1'b0}: prediction_table[index] <= STRONGLY_NOT_TAKEN;  // Correct, move to strongly not taken
                {WEAKLY_NOT_TAKEN, 1'b1}: prediction_table[index] <= WEAKLY_TAKEN;       // Incorrect, move to weakly taken
                
                // Weakly Taken
                {WEAKLY_TAKEN, 1'b0}: prediction_table[index] <= WEAKLY_NOT_TAKEN;       // Incorrect, move to weakly not taken
                {WEAKLY_TAKEN, 1'b1}: prediction_table[index] <= STRONGLY_TAKEN;         // Correct, move to strongly taken
                
                // Strongly Taken
                {STRONGLY_TAKEN, 1'b0}: prediction_table[index] <= WEAKLY_TAKEN;         // Incorrect, move to weakly taken
                {STRONGLY_TAKEN, 1'b1}: prediction_table[index] <= STRONGLY_TAKEN;       // Correct, stay
            endcase
        end
    end

endmodule
