
Digital-electronics-2/Labs/02_leds/TwoLeds/screenshot_simulIDE_TwoLeds.png

### Tables for DDRB, PORTB, and their combination

| **DDRB** | **Description** |
| :-: | :-- |
| 0 | input pin |
| 1 | output pin |

| **PORTB** | **Description** |
| :-: | :-- |
| 0 | output low value |
| 1 | output high value |

| **DDRB** | **PORTB** | **Direction** | **Internal pull-up resistor** | **Description** |
| :-: | :-: | :-: | :-: | :-- |
| 0 | 0 | input | no | tri-state, high-impedance |
| 0 | 1 | input | yes | tri-state, high-impedance |
| 1 | 0 | output | no | Output low |
| 1 | 1 | output | no |Output high |

### Table with input/output pins available on ATmega328P

| **Port** | **Pin** | **Input/output usage?** |
| :-: | :-: | :-- |
| A | x | Microcontroller ATmega328P does not contain port A |
| B | 0 | yes (Arduino pin 8) |
|   | 1 | yes (Arduino pin 9) |
|   | 2 | yes (Arduino pin 10) |
|   | 3 | yes (Arduino pin 11) |
|   | 4 | yes (Arduino pin 12) |
|   | 5 | yes (Arduino pin 13) |
|   | 6 | no |
|   | 7 | no |
| C | 0 | yes (Arduino pin A0) |
|   | 1 | yes (Arduino pin A1) |
|   | 2 | yes (Arduino pin A2) |
|   | 3 | yes (Arduino pin A3) |
|   | 4 | yes (Arduino pin A4) |
|   | 5 | yes (Arduino pin A5) |
|   | 6 | no |
|   | 7 | no |
| D | 0 | yes (Arduino pin RX<-0) |
|   | 1 | yes (Arduino pin TX<-1) |
|   | 2 |  yes (Arduino pin 2) |
|   | 3 |  yes (Arduino pin 3) |
|   | 4 |  yes (Arduino pin 4) |
|   | 5 |  yes (Arduino pin 5) |
|   | 6 |  yes (Arduino pin 6) |
|   | 7 |  yes (Arduino pin 7) |
