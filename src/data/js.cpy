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
001300*Again, arbitrary size, need to figure that out.
001400 01 WS-JS-COMMANDS.
001500   05 CREATE-ELEMENT.
001600     10 PART-A PIC X(26) VALUE '=document.createElement("'.
001700     10 PART-B PIC X(3) VALUE '")'.
001800   05 APPEND-CHILD.
001900     10 PART-A PIC X(27) VALUE '.appendChild('.
002000     10 PART-B PIC X(2) VALUE ')'.
002100*We can either define all of these here in subsections or use MOVE
002200*in the function itself. Static constants would be faster though.
002300*How do we want to do data naming? A, B, C with dynamic data
002400*between?
