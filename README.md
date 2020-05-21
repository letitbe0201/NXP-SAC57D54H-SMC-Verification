# UVM Verification on NXP’s SMC Module

#### SUMMARY
This is an UVM verification plan of NXP SAC57D54H SoC's Step Motor Contoller(SMC). The test contains three main parts, an observation model, a reference model and the comparison part. The observation segment has 4 classes(boxes), taking the output values from the SMC to get the observation rising/falling edges, period, duty(pulse width). The reference models is built by another 4 boxes, taking the inputs to determine the predicted Pulse Width Modulation(PWM) signal. Lastly, the comparison part(another 7 boxes) verifies the SMC by taking input from both the observation and reference side.

[**Documentation of Scoreboards**](https://github.com/letitbe0201/NXP-SAC57D54H-SMC-Verification/blob/master/documentation/boxes.txt)

**Box Diagram:**

![Image of Boxes](https://raw.githubusercontent.com/letitbe0201/NXP-SAC57D54H-SMC-Verification/master/documentation/boxes.jpg)

**Sequence:**

Initially, the test set a RESET signal to set all the registers to 0. In sequence item, the test makes memory for all the internal registers. The sequence randomizes the value for those registers and sends them to the driver through the sequencer. At every positive edge of clock, the driver sends the ADDRESS and DATAIN value to the DUT, respectively. Then, the address is incremented to the next valid address. Once all the data is set in the DUT, the driver turns WRITE signal to low and keeps SEL signal as high. Then, all the address are again fed into the DUT at every clock cycle to get values on DATAOUT.


#### SMC
The SMC block is a PWM motor controller suitable for driving small stepper and air core motors used in instrumentation applications. The
module can also be used for other motor control or PWM applications that match the frequency, resolution and output drive capabilities of the module. The SMC has 12 PWM channels associated with two pins each (24 pins in total).

Reference: *SAC57D54H Reference Manual Rev. 6, NXP Semiconductors, Eindhoven, Netherlands,2017.*

Credit:
- Atijav Dua
- Mohit Vanage
- Ranyang Zhou
- Yida Chung