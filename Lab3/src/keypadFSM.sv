// Lab 3 - Keypad Scanner
// Name: Joaquin Gonzalez-Salgado
// Date: September 17, 2026
// Email: jgonzalezsalgado@hmc.edu
module keypadFSM(
    input  logic clk,
    input  logic reset,
    input  logic anyKey, //AT LEAST one column low on active row
    input  logic oneKey, //ONLY one column low on the active row
    input  logic sameKey, //Recently stored digit is the same as the decoded digit!!!
    input  logic dbDone, //Debounce is over
    output logic scanEn, //Enable scanning to the next row
    output logic dbClear, //Keeps debounce timer at 0 (when its unecessary)
    output logic newKey //new key press decoded
);
    typedef enum logic [1:0] {IDLE, DEBOUNCE, HOLD} statetype;
    statetype state, nextstate;

    always_ff @(posedge clk)
        if (!reset) state <= IDLE;
        else        state <= nextstate;

    always_comb begin
        nextstate = state; 
        case (state)
            IDLE: if (oneKey)            nextstate = DEBOUNCE;
            else                         nextstate = IDLE;
            DEBOUNCE: if (!oneKey)       nextstate = IDLE;
            else if (dbDone)             nextstate = HOLD;
            else                         nextstate = DEBOUNCE;
            HOLD: if (!anyKey)           nextstate = IDLE;
            else if (oneKey & !sameKey)  nextstate = DEBOUNCE;
            else                         nextstate = HOLD;
            default:                     nextstate = IDLE;
        endcase
    end

    assign scanEn  = (state == IDLE) & !anyKey;
    assign dbClear = (state != DEBOUNCE);
    assign newKey  = (state == DEBOUNCE) & oneKey & dbDone;
endmodule