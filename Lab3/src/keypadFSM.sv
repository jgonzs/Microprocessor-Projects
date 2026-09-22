// Lab 3 - Keypad Scanner
// Name: Joaquin Gonzalez-Salgado
// Date: September 17, 2026
// Email: jgonzalezsalgado@hmc.edu
module keypadFSM(
    input  logic clk,
    input  logic reset,
    input  logic anyKey,    //at least one column low on the active row
    input  logic oneKey,    //exactly one column low on the active row
    input  logic sameKey,   //decoded key equals the most recently stored digit
    input  logic dbDone,    //debounce timer expired
    output logic scanEn,    //lets the scanner advance to the next row
    output logic dbClear,   //holds the debounce timer at zero
    output logic newKey     //store the decoded key this cycle
);
    typedef enum logic [1:0]
    {IDLE, DEBOUNCE, HOLD, RELEASE} statetype;
    statetype state, nextstate;

    always_ff @(posedge clk)
        if (!reset) state <= IDLE;
        else        state <= nextstate;

    always_comb begin
        case(state)
            IDLE:     nextstate = oneKey ? DEBOUNCE : IDLE;
            DEBOUNCE: if (!oneKey)              nextstate = IDLE;
                      else if (dbDone)          nextstate = HOLD;
                      else                      nextstate = DEBOUNCE;
            HOLD:     if (!anyKey)              nextstate = RELEASE;
                      else if (oneKey & !sameKey) nextstate = DEBOUNCE;
                      else                      nextstate = HOLD;
            RELEASE:  if (anyKey)               nextstate = HOLD;
                      else if (dbDone)          nextstate = IDLE;
                      else                      nextstate = RELEASE;
            default:                            nextstate = IDLE;
        endcase
    end

    assign scanEn  = (state == IDLE) & ~anyKey;
    assign dbClear = (state == IDLE) | (state == HOLD);
    assign newKey  = (state == DEBOUNCE) & oneKey & dbDone;
endmodule
