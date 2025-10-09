000100 01 WS-JS-TEST PIC X(35) VALUE 'console.log("Hello from Javascript
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
001300 01 WS-DOUBLE-QUOTE PIC X(1) VALUE '"'.
001400 01 WS-END-PARENTHESIS PIC X(1) VALUE ')'. 
001500 01 WS-COB-INIT PIC X(104) VALUE '(function() { try { Module.ccall
001600-'("cob_init", null, [], []);return 1;} catch (error) { return -1;
001700-' } })()'.
001800 01 WS-EQUALS PIC X(1) VALUE '='.
001900*01 WS-PARENTHESIS PIC X(2) VALUE ')'
002000*Again, arbitrary size, need to figure that out.
002100 01 WS-JS-COMMANDS.
002200   05 STATUS-WRAPPER.
002300     10 PART-A PIC X(20) VALUE '(function() { try { '.
002400     10 PART-B PIC X(47) VALUE '; return 1; } catch (error) { retu
002500-'rn -1; } })()'.
002600*TO-DO: Veryify all of these PIC sizes.
002700   05 CREATE-ELEMENT.
002800     10 PART-A PIC X(25) VALUE '=document.createElement("'.
002900     10 PART-B PIC X(2) VALUE '")'.
003000   05 APPEND-CHILD.
003100     10 PART-A PIC X(26) VALUE '.appendChild('.
003200*    10 PART-B PIC X(2) VALUE ')'.
003300   05 REMOVE-CHILD.
003400     10 PART-A PIC X(26) VALUE '.removeChild('.
003500*    10 PART-B PIC X(2) VALUE ')'.
003600   05 INNER-HTML.
003700     10 PART-A PIC X(12) VALUE '.innerHTML="'.
003800*    10 PART-B PIC X(2) VALUE '"'.
003900   05 ADD-EVENT-LISTENER.
004000     10 PART-A PIC X(19) VALUE '.addEventListener("'.
004100     10 PART-B PIC X(2) VALUE '",'.
004200*    10 PART-C PIC X() VALUE ')'.
004300   05 CLASS-NAME.
004400     10 PART-A PIC X(12) VALUE '.className="'.
004500   05 STYLE.
004600     10 PART-A PIC X(7) VALUE '.style.'.
004700   05 SET-COOKIE.
004800     10 PART-A PIC X(17) VALUE 'document.cookie="'.
004900*    10 PART-B PIC X(1) VALUE '='. Instead we use WS-EQUALS
005000*    10 PART-C PIC X(1) VALUE '"'. Instead we use WS-DOUBLE-QUOTE
005100*We can either define all of these here in subsections or use MOVE
005200*in the function itself. Static constants would be faster though.
005300*How do we want to do data naming? A, B, C with dynamic data
005400*between?
