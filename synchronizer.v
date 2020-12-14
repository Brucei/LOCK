module Synchronizer(
    input       [3:0]   Row,
    input               clock,
    input               reset,
    
    output              S_Row
);

assign S_Row = (Row[0]||Row[1]||Row[2]||Row[3]);
endmodule
