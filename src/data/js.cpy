000100 01 WS-JS-TEST PIC X(36) VALUE 'console.log("Hello from Javascript
000200-'")'.
000300*REMEMBER these are only accesible to the library.
000400*Look into UNSTRING as far as getting pic values to be the proper
000500*length as errors will occur otherwise unless some wrapper or
000600*something trims after.
000700*01 WS-ELEMENT PIC X(100).
000800*01 WS-ELEMENT-TYPE PIC X(100).
000900*So these will have to be set and trimmed in runtime. Also the
001000*pic sizes are arbitrary.
001100 01 WS-JS-COMMAND PIC X(256).
001200 01 WS-NULL-BYTE PIC X(1) VALUE X'00'.
001300*01 WS-PARENTHESIS PIC X(2) VALUE ')'
001400*Again, arbitrary size, need to figure that out.
001500 01 WS-JS-COMMANDS.
001600   05 STATUS-WRAPPER.
001700     10 PART-A PIC X(21) VALUE '(function() { try { '.
001800     10 PART-B PIC X(48) VALUE '; return 1; } catch (error) { retu
001900-'rn -1; } })()'.
002000   05 CREATE-ELEMENT.
002100     10 PART-A PIC X(26) VALUE '=document.createElement("'.
002200     10 PART-B PIC X(3) VALUE '")'.
002300   05 APPEND-CHILD.
002400     10 PART-A PIC X(27) VALUE '.appendChild('.
002500     10 PART-B PIC X(2) VALUE ')'.
002600   05 REMOVE-CHILD.
002700     10 PART-A PIC X(27) VALUE '.removeChild('.
002800     10 PART-B PIC X(2) VALUE ')'.
002900*We can either define all of these here in subsections or use MOVE
003000*in the function itself. Static constants would be faster though.
003100*How do we want to do data naming? A, B, C with dynamic data
003200*between?
