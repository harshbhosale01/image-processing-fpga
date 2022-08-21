# Guidelines for writing readable verilog code:

Prefixes:</p>

    i_   Input signal  
    o_   Output signal 
    r_   Register signal (has registered logic) 
    w_   Wire signal (has no registered logic) 
    c_   Constant 
    t_   User-Defined Type 

You should use above prefixes for corrseponding signals for writing a high readability verilog code.

## A Note About Initializing Signals:
All registers (as identified by r_ prefix) should always have an initial condition applied to them. No wires (as identified by w_ prefix) should EVER have an initial condition applied to them.