# UART (Universal Asynchronous Receiver/Transmitter)

A synthesizable UART Transmitter and Receiver designed in **SystemVerilog**. The project implements asynchronous serial communication using separate transmitter and receiver finite state machines (FSMs), a configurable baud rate generator, and comprehensive testbenches for functional verification.

---

## Overview

UART is one of the most widely used serial communication protocols in embedded systems. This project implements a basic UART core capable of transmitting and receiving 8-bit data frames.

The design consists of four RTL modules:

- Baud Rate Generator
- UART Transmitter (TX)
- UART Receiver (RX)
- Top-Level UART Integration

Each module has an independent testbench and has been verified using **Icarus Verilog** and **GTKWave**.

---

## Features

- Configurable baud rate generator
- UART Transmitter FSM
- UART Receiver FSM
- 8-bit data transmission
- 1 Start Bit
- 1 Stop Bit
- LSB-first transmission
- 16× oversampling in receiver
- Modular RTL design
- Independent testbenches for each module
- Simulation support using Icarus Verilog

---

## Project Structure

```
UART/
├── README.md
├── rtl/
│   ├── baud_gen.sv
│   ├── tx.sv
│   ├── rx.sv
│   └── uart.sv
│
├── tb/
│   ├── baud_gen_tb.sv
│   ├── tx_tb.sv
│   ├── rx_tb.sv
│   └── uart_tb.sv
│
├── scripts/
│   ├── baud_gen.sh
│   ├── tx.sh
│   ├── rx.sh
│   └── uart.sh
│
└── sim/
    ├── baud_gen/
    ├── tx/
    ├── rx/
    └── uart/
```

---

## UART Frame Format

```
Idle | Start | D0 | D1 | D2 | D3 | D4 | D5 | D6 | D7 | Stop
  1      0      LSB -------------------------------> MSB     1
```

---

## Module Description

### Baud Rate Generator

- Generates baud tick from system clock
- Parameterized clock frequency and baud rate

### UART Transmitter

Implements an FSM with four states:

- IDLE
- START
- DATA
- STOP

Transmits one bit on every baud tick.

### UART Receiver

Implements an FSM that:

- Detects falling edge of start bit
- Waits until the middle of the start bit
- Samples every 16 baud ticks
- Reconstructs received byte

### UART Top

Integrates:

- Baud Generator
- TX
- RX

---

## Simulation

Each RTL module includes an individual testbench.

To simulate:

```bash
cd scripts
./scripts/tx.sh
```

Similarly,

```bash
./scripts/baud_gen.sh
./scripts/rx.sh
./scripts/uart.sh
```

Waveforms are generated in the `sim/` directory and can be viewed using GTKWave.

Example:

```bash
gtkwave sim/tx/tx.vcd
```

---

## Verification

The following functionality has been verified through simulation:

- Baud tick generation
- UART transmission
- UART reception
- End-to-end UART communication
- State machine transitions
- Correct serial data reconstruction

---

## Concepts Learned

Through this project I gained practical experience with:

- Finite State Machines (FSMs)
- Asynchronous serial communication
- UART protocol
- Baud rate generation
- Shift registers
- 16× oversampling
- Testbench development
- Digital waveform debugging
- Functional verification using GTKWave

---

## Future Improvements

Planned enhancements include:

- FIFO integration
- Configurable parity bit
- Multiple stop-bit support
- Variable data width
- AXI/APB wrapper
- UVM-based verification
- FPGA implementation

---

## Tools Used

- SystemVerilog
- Icarus Verilog
- GTKWave
- Git
- GitHub

---

## Author

**Shreyas J**

Electronics & Telecommunication Engineering

Interested in RTL Design, Digital Design, and Design Verification.
