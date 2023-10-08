# CPU-Microarchitecture-Simulation

## Overview
This program simulates the central processing unit (CPU) microarchitecture shown below. This design and simulation was an assignment a part of the Digital Design module in Electronic & Electrical Engineering at UCL. 

SystemVerilog hardware design language was used to write the main code and testbench code, simualted with Icarus Verilog, and simulation waveforms were plotted using GTKWave.

A modular design approach was used, building and testing the individual logic units before combining. This includes the arithmetic logic unit, register file, read-only memory, program counter and control unit.

The testbench shows that the instruction memory (read from the text file) is correctly executed by the microprocessor. The output will be log2(32) = 5, once the program has been executed. 

![CPU-Microarchitecture-Simulation/cpu-architecure.png](https://github.com/RonaldoBaker/CPU-Microarchitecture-Simulation/blob/main/cpu_microarchitecture.jpg)
