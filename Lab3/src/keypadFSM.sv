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
    typedef enum logic [1:0] {IDLE, DEBOUNCE, HOLD} statetype;
    statetype state, nextstate;

    always_ff @(posedge clk)
        if (!reset) state <= IDLE;
        else        state <= nextstate;

    always_comb begin
        nextstate = state;  //stay put unless a transition below fires
        case (state)
            IDLE:     if (oneKey)       nextstate = DEBOUNCE;
            DEBOUNCE: if (!oneKey)      nextstate = IDLE;
                      else if (dbDone)  nextstate = HOLD;
            HOLD:     if (!anyKey)                nextstate = IDLE;
                      else if (oneKey & !sameKey)  nextstate = DEBOUNCE;
            default:                    nextstate = IDLE;
        endcase
    end

    assign scanEn  = (state == IDLE) & ~anyKey;
    assign dbClear = (state != DEBOUNCE);
    assign newKey  = (state == DEBOUNCE) & oneKey & dbDone;
endmodule