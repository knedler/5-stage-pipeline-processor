DEOVGA version 1.6:

This package contain all of the files need to get VGA running on DE0-CV boards.

To use this packabe, simply copy all the files into a quartus project folder, and add the "DEOVGA" symbol into your block diagram from the symbol dialog.
Folders:
VGA_DEMO: Contains a function Quartus Project demonstrating VGA functionality.

NOTE: The displays in the Kepware lab tend to display the output differently from each other, this is a function of the screens, not the code.


CHANGE NAME OR LABELS:

-Open charengine.v and edit name and labels.  Follow instructions in comments.
-If you change parameter values you must update them in VGA_BLOCK.bdf too.
-Update symbols in your BDF and compile.
-If all characters are backwards reverse bit order of mem_out (commented on in charengine) and recompile.




Files:

char_engine.v: The module in charge of taking data, and rendering it to video memory.
color_encoder.v: The module in charge of determining the color of values from video memory
DEOVGA.bdf: block diagram of the VGA system
DEOVGA.bsf: the symbol file of the above block diagram
vga_control.v: The module that controls the timings necessary for screen output.
vgaclk.v: Changes a 50mhz clock to a 25.125mhz clock needed for the other modules.
vram.v: The video memory.


Once the files are added, you must connect the following I/O on the symbol to pins on the board.

CLOCK_50: the input of the DEO-CV boards clock signal.
VGA_R[3..0]: the red signal to the VGA network on the DEO-CV
VGA_G[3..0]: the green signal to the VGA network on the DEO-CV
VGA_B[3..0]: the blue signal to the VGA network on the DEO-CV
VGA_HS: Horizontal sync on the vga port
VGA_VS: Vertical sync on the vga port

Once connected you should see output on a monitor.

To display data on the screen you must put data onto the various inputs on the symbol.

Outputs:

vga_clk: this is the same clock the screen uses to render information, it is necessary to run the debug ports of instruction, data, and register memory at this clock speed to keep the data in sync.

Inputs:

pll_rst: Resets the phase lock loop driving the vga clock, should not be necessary, but is here in case.

project_clock, and prg_counter: These are meant to display your projects program counter. It will show the 10 most recent values the input has recieved. the project clock need to be the same clock your processor is using.

ins_data, and the output ins_sw: ins_sw is meant to send an address to your instruction memory, and recieve the returned value in ins_data. For this to occur, your instruction memory must use the vga_clock output.

mem_data, and mem_sw: These behave the same as the instruction memory, but are meant to connect to the system memory of your project.

reg_dat, and reg_sw: These are meant to connect to your projects register file, works the same as the 2 above except it only sends out a 5 bit address.

debug[31..0]: Making any one of the bits on the debug output high results in a 1 appearing on screen in the debug section corresponding to the bit made high.

gp_debug_reg_X: 4 general purpose registers take any data received and will render it as a hex value on screen.


