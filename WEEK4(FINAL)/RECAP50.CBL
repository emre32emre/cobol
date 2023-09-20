       IDENTIFICATION DIVISION.
       PROGRAM-ID. RECAP50.
       ENVIRONMENT DIVISION.
       INPUT-OUTPUT SECTION.
       FILE-CONTROL.
           SELECT INP-FILE ASSIGN TO 'INPFILE'
                           STATUS INPUT-STATUS.
           SELECT OUT-FILE ASSIGN TO 'OUTFILE'
                           STATUS OUTPUT-STATUS.
      ******************************************************************
       DATA DIVISION.
      ******************************************************************
       FILE SECTION.
       FD  INP-FILE RECORDING MODE F.
         01 INP-FILE-MEMBERS.
           05 INP-FILE-RECORD  PIC X(9).
       FD  OUT-FILE RECORDING MODE F.
         01 OUT-FILE-MEMBERS.
           05 OUT-FILE-LOG            PIC X(60).
       WORKING-STORAGE SECTION.
       01  CONTROL-STATEMENTS.
         05 INPUT-STATUS           PIC 9(2).
           88 INPUT-FILE-SUCCESS   VALUE 00 97.
           88 INPUT-FILE-EOF       VALUE 10.
         05 OUTPUT-STATUS          PIC 9(2).
           88 OUTPUT-FILE-SUCCESS  VALUE 00 97.
       01 WW-SEND-AREA.
          05 WW-SELECT-MODE        PIC X(1).
          05 WW-INP-IDX-FILE-ID    PIC S9(5) COMP-3.
          05 WW-REPORT             PIC X(60) VALUE SPACES.
       01 WK-SUB-PROG              PIC X(08) VALUE 'RECAP51'.
       01 WS-INP-FILE-ID           PIC X(5).
      ******************************************************************
       PROCEDURE DIVISION.
      ******************************************************************
       0001-MAIN-PROCESS.
           PERFORM H100-OPEN-FILES.
           PERFORM H300-READ-ACTION UNTIL INPUT-FILE-EOF.
           PERFORM H999-EXIT.
       0001-END. EXIT.
      *--------------------------------
       H100-OPEN-FILES.
           OPEN INPUT  INP-FILE.
           OPEN OUTPUT OUT-FILE.
           PERFORM H110-FILE-CONTROL.
           READ INP-FILE.
       H100-END. EXIT.
      *--------------------------------
       H110-FILE-CONTROL.
           IF (INPUT-STATUS NOT = 97) AND (INPUT-STATUS NOT = 0)
              DISPLAY 'INPUT NOT OPENED. ERROR CODE:' INPUT-STATUS
              PERFORM H999-EXIT
           END-IF.
           IF (OUTPUT-STATUS NOT = 97) AND (OUTPUT-STATUS NOT = 0)
              DISPLAY 'OUTPUT NOT OPENED. ERROR CODE:' OUTPUT-STATUS
              PERFORM H999-EXIT
           END-IF.
       H110-END. EXIT.
      *--------------------------------
       H300-READ-ACTION.
           MOVE INP-FILE-RECORD(1:1) TO WW-SELECT-MODE
           MOVE INP-FILE-RECORD(2:5) TO WS-INP-FILE-ID
           COMPUTE WW-INP-IDX-FILE-ID = FUNCTION NUMVAL(WS-INP-FILE-ID)
           CALL WK-SUB-PROG USING WW-SEND-AREA
           MOVE WW-REPORT TO OUT-FILE-LOG
           WRITE OUT-FILE-MEMBERS.
           READ INP-FILE AT END SET INPUT-FILE-EOF TO TRUE
           END-READ.
       H300-READ-ACTION-END. EXIT.
      *--------------------------------
       H999-EXIT.
           CLOSE INP-FILE.
           CLOSE OUT-FILE.
           STOP RUN.
       H999-END. EXIT.
