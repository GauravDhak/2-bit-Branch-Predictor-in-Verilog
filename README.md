# 2-bit-Branch-Predictor-in-Verilog
This project implements a 2-bit branch predictor in Verilog. Branch prediction is a technique used in CPU instruction pipelines to guess the outcome of a conditional branch instruction to avoid pipeline stalls. The 2-bit predictor uses a saturating counter to improve prediction accuracy.
Branch Prediction in Instruction Cycle
In an instruction pipeline, branch instructions can disrupt the smooth flow of instructions. When the CPU encounters a branch instruction, it doesn't immediately know whether to execute the branch (taken) or continue with the next sequential instruction (not taken). Branch prediction aims to guess the outcome to keep the pipeline filled and improve performance.

Advantage of this approach is that a few atypical branches will not influence the prediction (a better measure of ―the common case‖). Only when we have two successive mispredictions,
we will switch prediction. This is especially useful when multiple branches share the same counter (some bits of the branch PC are used to index into the branch predictor). 
This can be easily extended to N-bits. Suppose we have three bits, then there are 8 possible states and only when there are three successive mispredictions, the prediction
will be changed. However, studies have shown that a 2-bit predictor itself is accurate enough.


##  Control Hazards
Control hazards occur when the pipeline makes incorrect decisions on branch predictions, causing the pipeline to fetch incorrect instructions. Correct branch prediction reduces control hazards by minimizing the number of pipeline stalls


## 2-bit Saturating Counter Algorithm
The 2-bit saturating counter algorithm uses a small table of 2-bit counters indexed by part of the branch instruction's address (program counter). Each counter can be in one of four states:

1. Strongly Not Taken (00)
2. Weakly Not Taken (01)
3. Weakly Taken (10)
4. Strongly Taken (11)

![Screenshot 2024-07-29 115443](https://github.com/user-attachments/assets/f68a11ff-fc98-4aa3-b3cf-5031ccadb26b)

-If the branch is not taken (0), the state moves towards "Not Taken".

-If the branch is taken (1), the state moves towards "Taken".

##  Working
1. Initialization: On reset, all entries in the prediction table are set to 'WEAKLY_TAKEN'.
2. Prediction: The predictor uses part of the program counter to index into the prediction table and retrieves the current state of the counter to make a prediction.
3. Update: After the actual outcome of the branch is known, the predictor updates the counter based on the outcome.


##  Advantages
1. Improved Performance: By predicting the outcome of branch instructions, the pipeline can continue fetching and executing instructions without waiting, thus reducing stalls.
2. Simplicity: The 2-bit predictor is relatively simple to implement and provides a good balance between complexity and accuracy.


##  Expected Accuracy:
For typical applications, a 2-bit predictor might achieve accuracy in the range of 80-90%, depending on the workload and branch behavior patterns.
Real-world performance depends on the specific program's branching characteristics and how well the predictor can capture and adapt to these patterns.

##  Waveform

![Screenshot 2024-07-29 113857](https://github.com/user-attachments/assets/5ac46e61-e648-4143-baa4-75d1c225ef32)


![Screenshot 2024-07-29 113946](https://github.com/user-attachments/assets/753b292c-69bc-4570-8a36-1a52e8a9f8fb)

##  Output

At time 0: pc = 00000000, branch_taken = 0, prediction = 1

At time 15: pc = 00000000, branch_taken = 0, prediction = 0

At time 20: pc = 00000004, branch_taken = 0, prediction = 1

At time 25: pc = 00000004, branch_taken = 0, prediction = 0

At time 50: pc = 00000008, branch_taken = 1, prediction = 1

At time 80: pc = 0000000c, branch_taken = 1, prediction = 1

At time 90: pc = 0000000c, branch_taken = 0, prediction = 1

At time 100: pc = 0000000c, branch_taken = 1, prediction = 1

At time 110: pc = 0000000c, branch_taken = 0, prediction = 1

At time 125: pc = 0000000c, branch_taken = 0, prediction = 0

