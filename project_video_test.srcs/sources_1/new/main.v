`timescale 1ns / 1ps

module main(
    led, led0, sysclk, btn, pio1
    );
    input sysclk;
    input [1:0] btn;
    output pio1;
    output [1:0] led;
    output [2:0] led0;
    
    reg [3:0] cnt_mhz;
    reg clk1MHz;
    always @(posedge sysclk or posedge btn[0]) begin
        if (btn[0]) begin
            cnt_mhz <= 0;
            clk1MHz <= 0;
        end else begin
            if (cnt_mhz == 5) begin
                cnt_mhz <= 0;
                clk1MHz <= ~clk1MHz;
            end else begin
                cnt_mhz <= cnt_mhz + 1;
            end
        end
    end
    
    reg [9:0] cnt_khz;
    reg clk1kHz;
    always @(posedge clk1MHz or posedge btn[0]) begin
        if (btn[0]) begin
            cnt_khz <= 0;
            clk1kHz <= 0;
        end else begin
            if (cnt_khz == 499) begin
                cnt_khz <= 0;
                clk1kHz <= ~clk1kHz;
            end else begin
                cnt_khz <= cnt_khz + 1;
            end
        end
    end
    
    reg [9:0] cnt_hz;
    reg clk1Hz;
    always @(posedge clk1kHz or posedge btn[0]) begin
        if (btn[0]) begin
            cnt_hz <= 0;
            clk1Hz <= 0;
        end else begin
            if (cnt_hz == 499) begin
                cnt_hz <= 0;
                clk1Hz <= ~clk1Hz;
            end else begin
                cnt_hz <= cnt_hz + 1;
            end
        end
    end
    
    reg [2:0] led_stat;
    always @(posedge clk1Hz or posedge btn[0]) begin
        if (btn[0]) begin
            led_stat <= 3'b111;
        end else begin
            if (led_stat == 3'b011) led_stat <= 3'b111;
            else begin
                if (led_stat == 3'b111)
                    led_stat <= 3'b110;
                else led_stat <= ~((~led_stat) << 1);
            end
        end
    end
    
    assign led0 = led_stat;
    assign led[1] = btn[1];
    assign led[0] = clk1Hz;
    assign pio1 = clk1kHz;
endmodule
