# Introduction to Verilog

Verilog is a type of Hardware Description Language (HDL). Verilog is one of the two languages used by education and business to design FPGAs and ASICs.<br/>

First we will write the verilog code for AND gate,
AND Gate has two inputs and one output. The output is equal to 1 only when both of the inputs are equal to 1.<br/>

<img src="https://nandland.com/verilog/tutorials/images/and_gate.png">

## Module Basics:
- Module keyword in verilog shows a creation of a block of code with defined input and outputs.<br/>

  Example:<br/>

  <code>module example_and_gate 
  ( 
    input_1,
    input_2,
    and_result);
   
  input  input_1;<br/>
  input  input_2;<br/>
  output and_result;</code>

   This can also be written as,<br/>
  <code>module example_and_gate
  (input input_1,input_2 output and_result);</code>

  Writing the logic for AND gate,<br/>
  <code>module example_and_gate 
  ( 
    input_1,
    input_2,
    and_result);<br/>
  input  input_1;
  input  input_2;
  output and_result;

  wire   and_temp;<br/>
  assign and_temp = input_1 & input_2;<br/>
  assign and_result = and_temp;
 
  endmodule</code>

  Here, if you see we have made a use of 'wire' which is again a keyword and assign to for assigning the value at right to left. We have also made use of ampersand (&) sign wich is for boolean AND. A module should always be closed by endmodule.

## Verilog Always block :<br/>

  - Always Blocks are used in two main scenarios:
    - To define a block of combinational logic<br/>
    - To define a block of sequential logic<br/>

    Diffrence between combinational and sequential logic is that combinational logic is logic that does not require [clock signal](https://www.symmetryelectronics.com/blog/what-are-clock-signals-in-digital-circuits-and-how-are-they-produced-symmetry-blog/) to operate whereas the sequential logic require the clock signal to operate.<br/>
    Example of Combinational logic: AND gate<br/>
    Example of Sequential logic: [D flip-flop](https://nandland.com/lesson-5-what-is-a-flip-flop/)

**Combinational Always Block:**<br/>

  <code>always @ (input_1 or input_2)<br/>
    begin<br/>
    and_gate = input_1 & input_2;<br/>
      end</code>

   In code above, input_1 and input_2 are in what is called a sensitivity list. The sensitivity list is a list of all of the signals that will cause the Always Block to execute. In the example above, a change on either input_1 or input_2 will cause the Always Block to execute. This process/always block takes the two inputs, perform an “and” operation on them, and stores the result in the signal and_gate. This is the exact same functionality as this code:<br/>
   <code>assign and_gate = input_1 & input_2;</code>

**Sequential Always Block:**<br/>
   For sequential logic, Always Block can have at most two signals in its sensitivity list.If the Process/Always Blocks uses an asynchronous reset, it will have two signals in the sensitivity list. If the FPGA designer uses a synchronous reset or no reset at all, it will only have one signal in the sensitivity list. For now we will look at the example that uses no reset at all:</p>
<code>always @ (posedge i_clock)
  begin<br/>
    and_gate <= input_1 & input_2;<br/>
  end</code>

By using the @ (posedge i_clock), we are telling to tools to create a register (Flip-Flop). This will in fact behave slightly differently than the combinational example; the value of and_gate will only be updated on the clock edges! In this case we used the keyword posedge which means when the clock goes from a 0 to 1. This is almost always the edge that you will be using to trigger your flip-flop logic.
>Sequential logic is what the majority of your FPGA design will be constructed with.

Refer this for more [example](https://nandland.com/tutorial-sequential-code-on-your-fpga/) on sequential logic: