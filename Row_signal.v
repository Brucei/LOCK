module Row_Signal(
    output reg  [3:0]   Row,
    input       [11:0]  Key,
    input       [2:0]   Col
);

always @(Key,Col) begin
    Row[0]=Key[0]&&Col[0]||Key[1]&&Col[1]||Key[2]&&Col[2];
    Row[1]=Key[3]&&Col[0]||Key[4]&&Col[1]||Key[5]&&Col[2];
    Row[2]=Key[6]&&Col[0]||Key[7]&&Col[1]||Key[8]&&Col[2];
    Row[3]=Key[9]&&Col[0]||Key[10]&&Col[1]||Key[11]&&Col[2];
end

endmodule
