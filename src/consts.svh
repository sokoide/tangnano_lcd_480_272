// consts.svh

`ifndef CONSTS_SVH
`define CONSTS_SVH

// VRAM
parameter int VRAM_WIDTH = 480/4;
parameter int VRAM_HEIGHT = 272/4;

// LCD
parameter int H_Pixel_Valid = 16'd480;
parameter int H_FrontPorch  = 16'd50;
parameter int H_BackPorch   = 16'd30;
parameter int PixelForHS    = H_Pixel_Valid + H_FrontPorch + H_BackPorch;

parameter int V_Pixel_Valid = 16'd272;
parameter int V_FrontPorch  = 16'd20;
parameter int V_BackPorch   = 16'd8;
parameter int PixelForVS    = V_Pixel_Valid + V_FrontPorch + V_BackPorch;

// VSync Period = (20+8) * (480+50+30) =  15680 cycles

`endif