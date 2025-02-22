`include "consts.svh"

module lcd (
  input  logic          PixelClk,
  input  logic          nRST,

  output logic          LCD_DE,

  output logic [4:0]    LCD_B,
  output logic [5:0]    LCD_G,
  output logic [4:0]    LCD_R
);

  // Horizontal and Vertical pixel counters
  logic [15:0] H_PixelCount;
  logic [15:0] V_PixelCount;
  logic [ 8:0] counter = 0;

  // Sequential logic for pixel counters
  always_ff @(posedge PixelClk or negedge nRST) begin
    if (!nRST) begin
      V_PixelCount <= 16'd0;
      H_PixelCount <= 16'd0;
      counter <= 16'd0;
    end else if (H_PixelCount == PixelForHS) begin
      V_PixelCount <= V_PixelCount + 1'b1;
      H_PixelCount <= 16'd0;
    end else if (V_PixelCount == PixelForVS) begin
      V_PixelCount <= 16'd0;
      H_PixelCount <= 16'd0;
      counter <= counter + 1'b1;
    end else begin
      // V_PixelCount remains unchanged in this branch
      H_PixelCount <= H_PixelCount + 1'b1;
    end
  end

  // SYNC-DE MODE
  assign LCD_DE = ((H_PixelCount >= H_BackPorch) &&
                     (H_PixelCount <= (H_Pixel_Valid + H_BackPorch)) &&
                     (V_PixelCount >= V_BackPorch) &&
                     (V_PixelCount <= (V_Pixel_Valid + V_BackPorch))) ? 1'b1 : 1'b0;


  // Sprite definition
  logic [15:0] sprite[15:0];

  initial begin
    // Initialize the sprite
    sprite[0]  = 16'b1111111111111111;
    sprite[1]  = 16'b1000000000000001;
    sprite[2]  = 16'b1011111111111101;
    sprite[3]  = 16'b1010000000000101;
    sprite[4]  = 16'b1010111111110101;
    sprite[5]  = 16'b1010100000010101;
    sprite[6]  = 16'b1010101111010101;
    sprite[7]  = 16'b1010101001010101;
    sprite[8]  = 16'b1010101001010101;
    sprite[9]  = 16'b1010101111010101;
    sprite[10] = 16'b1010100000010101;
    sprite[11] = 16'b1010111111110101;
    sprite[12] = 16'b1010000000000101;
    sprite[13] = 16'b1011111111111101;
    sprite[14] = 16'b1000000000000001;
    sprite[15] = 16'b1111111111111111;
  end


  logic [15:0] spx = 16'd0;
  logic [15:0] spy = 16'd0;

  // Draw the sprite
  always_ff @(posedge PixelClk or negedge nRST) begin
    logic [15:0] x = H_PixelCount - H_BackPorch;
    logic [15:0] y = V_PixelCount - V_BackPorch;

    if (!nRST) begin
      LCD_R <= 5'b00000;
      LCD_G <= 6'b000000;
      LCD_B <= 5'b00000;
      spx <= 16'd0;
      spy <= 16'd0;
    end else if (LCD_DE) begin
      if (x == H_Pixel_Valid && y == V_Pixel_Valid) begin
        if (spx == 16'd480) begin
          spx <= 16'd0;
        end else begin
          spx <= spx + 16'd1;
        end
        if (spy == 16'd272) begin
          spy <= 16'd0;
        end else begin
          spy <= spy + 16'd1;
        end
      end


      if ((x >= spx) && (spx + 16 > x) && (y >= spy) && (spy + 16 > y)) begin
        LCD_R <= 5'b00000;
        LCD_G <= {6{sprite[x-spx][y-spy]}};
        LCD_B <= 5'b00000;
      end else begin
        LCD_R <= 5'b00000;
        LCD_G <= 6'b000000;
        LCD_B <= 5'b0000;
      end
    end else begin
      LCD_R <= 5'b00000;
      LCD_G <= 6'b000000;
      LCD_B <= 5'b00000;
    end
  end

endmodule
