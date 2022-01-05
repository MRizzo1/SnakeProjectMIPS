# ProyectoSnake

This is a project created in MIPS assembly language, making use of the Mars tool to generate a set of the little snake in a bitmap. Its purpose is solely educational, it was made for the computer architecture course (CI-3815) at Universidad Simón Bolívar (Venezuela). 


--------------------------- Instructions ---------------------------

**You have to use Mars to run this project**
1. Run speed of instructions at maximum.
2. To play, you have to connect the BitMap and the Keyboard and Display MMIO Simulator.
3. To move the snake, you must press the key while the snake is not drawn, otherwise the movement will not be read.

**The recommended values for the BitMap are:**

Height and width of the pixels: 16 
Height and width of display: 512 (Extend the BitMap window to see the whole display. #

Base address for display: 0x100080000. The reason is that it cannot  be in the static or global data, nor in the heap because it occupies the space of the dynamic structures. 
.
