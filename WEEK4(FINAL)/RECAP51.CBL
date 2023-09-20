       IDENTIFICATION DIVISION.
       PROGRAM-ID. RECAP51.
       ENVIRONMENT DIVISION.
       INPUT-OUTPUT SECTION.
       FILE-CONTROL.
           SELECT IDX-FILE ASSIGN TO 'IDXFILE'
                           ORGANIZATION IS INDEXED
                           ACCESS RANDOM
                           RECORD KEY IS IDX-FILE-KEY
                           STATUS VSAM-STATUS.
      ******************************************************************
       DATA DIVISION.
      ******************************************************************
       FILE SECTION.
       FD  IDX-FILE.
         01 IDX-FILE-MEMBERS.
           05 IDX-FILE-KEY.
             10 IDX-FILE-ID          PIC S9(5)  COMP-3.
           05 IDX-FILE-DVZ           PIC S9(3)  COMP.
           05 IDX-FILE-NAME          PIC X(15).
           05 IDX-FILE-SURNAME       PIC X(15).
           05 IDX-FILE-DATE          PIC S9(7)  COMP-3.
           05 IDX-FILE-BALANCE       PIC S9(15) COMP-3.
       WORKING-STORAGE SECTION.
       01  CONTROL-STATEMENTS.
         05 VSAM-STATUS       PIC 9(2).
           88 INDEX-FILE-SUCCESS   VALUE 00 97.
         05 WS-NAME-STRING         PIC X(15).
         05 WS-TEMP                PIC X.
         05 WS-INDEX               PIC 9(2) VALUE 0.
         05 WS-INDEX2              PIC 9(2) VALUE 1.
         05 WS-CHECK               PIC 9(1).
       LINKAGE SECTION.
       01 LS-LINK-AREA.
          05 LS-SELECT-MODE          PIC X(1).
          05 LS-INP-IDX-FILE-ID      PIC S9(5) COMP-3.
          05 LS-REPORT               PIC X(60).
      ******************************************************************
       PROCEDURE DIVISION USING LS-LINK-AREA.
      ******************************************************************
       0001-MAIN-PROCESS.
           PERFORM H100-OPEN-FILES.
           PERFORM H300-READ-ACTION.
           PERFORM H999-EXIT.
       0001-END. EXIT.
      *--------------------------------
       H010-CHECK-MEMBER.
           MOVE LS-INP-IDX-FILE-ID TO IDX-FILE-ID
           READ IDX-FILE INVALID KEY
              MOVE 0 TO WS-CHECK
           NOT INVALID KEY
              MOVE 1 TO WS-CHECK
           END-READ.
       H010-CHECK-MEMBER-END. EXIT.
      *--------------------------------
       H100-OPEN-FILES.
           OPEN I-O    IDX-FILE.
           IF (VSAM-STATUS NOT = 97) AND (VSAM-STATUS NOT = 0)
              MOVE 'VSAM NOT OPENED. ERROR CODE:' TO LS-REPORT(1:28)
              MOVE VSAM-STATUS TO LS-REPORT(29:2)
              PERFORM H999-EXIT
           END-IF.
       H100-END. EXIT.
      *--------------------------------
       H300-READ-ACTION.
              IF (LS-SELECT-MODE NOT EQUAL 'W' AND
              LS-SELECT-MODE NOT EQUAL 'R' AND
              LS-SELECT-MODE NOT EQUAL 'U' AND
              LS-SELECT-MODE NOT EQUAL 'D')
              MOVE SPACES TO LS-REPORT
              MOVE 'HATALI SECIM MODU:' TO LS-REPORT(1:18)
              MOVE LS-SELECT-MODE TO LS-REPORT(19:1)
              PERFORM H999-EXIT
           END-IF.
           EVALUATE LS-SELECT-MODE
              WHEN 'R' PERFORM H310-READ-FUNCTION
              WHEN 'W' PERFORM H320-WRITE-FUNCTION
              WHEN 'D' PERFORM H330-DELETE-FUNCTION
              WHEN 'U' PERFORM H340-UPDATE-FUNCTION
           END-EVALUATE.
       H300-READ-ACTION-END. EXIT.
      *--------------------------------
       H310-READ-FUNCTION.
           PERFORM H010-CHECK-MEMBER
           IF (WS-CHECK = 0)
             MOVE LS-INP-IDX-FILE-ID TO LS-REPORT
             MOVE '-read-rc:' TO LS-REPORT(6:9)
             MOVE VSAM-STATUS TO LS-REPORT(15:2)
             MOVE '-KAYIT BULUNMADI' TO LS-REPORT(17:16)
           ELSE
             MOVE LS-INP-IDX-FILE-ID TO LS-REPORT
             MOVE '-read-rc:' TO LS-REPORT(6:9)
             MOVE VSAM-STATUS TO LS-REPORT(15:2)
             MOVE '-KAYIT OKUNDU' TO LS-REPORT(17:13)
           END-IF.
       H310-READ-FUNCTION-END. EXIT.
      *--------------------------------
       H320-WRITE-FUNCTION.
           PERFORM H010-CHECK-MEMBER
           IF (WS-CHECK = 1)
              MOVE LS-INP-IDX-FILE-ID TO LS-REPORT
              MOVE '-write-rc:' TO LS-REPORT(6:10)
              MOVE VSAM-STATUS TO LS-REPORT(16:2)
              MOVE '-KAYIT ZATEN VSAM DA MEVCUT' TO LS-REPORT(18:27)
           ELSE
              MOVE 949 TO IDX-FILE-DVZ
              MOVE 'Yeni isim      ' TO IDX-FILE-NAME
              MOVE 'Yeni Soyisim   ' TO IDX-FILE-SURNAME
              MOVE 2023071 TO IDX-FILE-DATE
              MOVE 100000000000001 TO IDX-FILE-BALANCE
              WRITE IDX-FILE-MEMBERS INVALID KEY
                  MOVE LS-INP-IDX-FILE-ID TO LS-REPORT
                  MOVE '-write-rc:' TO LS-REPORT(6:10)
                  MOVE VSAM-STATUS TO LS-REPORT(16:2)
                  MOVE '-KAYIT EKLENEMEDI' TO LS-REPORT(18:17)
              NOT INVALID KEY
                  MOVE LS-INP-IDX-FILE-ID TO LS-REPORT
                  MOVE '-write-rc:' TO LS-REPORT(6:10)
                  MOVE VSAM-STATUS TO LS-REPORT(16:2)
                  MOVE '-KAYIT EKLENDI' TO LS-REPORT(18:14)
              END-WRITE
           END-IF.
       H320-WRITE-FUNCTION-END. EXIT.
      *--------------------------------
       H330-DELETE-FUNCTION.
           PERFORM H010-CHECK-MEMBER
           IF (WS-CHECK = 1)
              DELETE IDX-FILE INVALID KEY
                  MOVE LS-INP-IDX-FILE-ID TO LS-REPORT
                  MOVE '-delete-rc:' TO LS-REPORT(6:11)
                  MOVE VSAM-STATUS TO LS-REPORT(17:2)
                  MOVE '-KAYIT SILINEMEDI' TO LS-REPORT(19:17)
              NOT INVALID KEY
                  MOVE LS-INP-IDX-FILE-ID TO LS-REPORT
                  MOVE '-delete-rc:' TO LS-REPORT(6:11)
                  MOVE VSAM-STATUS TO LS-REPORT(17:2)
                  MOVE '-KAYIT SILINDI' TO LS-REPORT(19:14)
              END-DELETE
           ELSE
               MOVE LS-INP-IDX-FILE-ID TO LS-REPORT
               MOVE '-delete-rc:' TO LS-REPORT(6:11)
               MOVE VSAM-STATUS TO LS-REPORT(17:2)
               MOVE '-KAYIT VSAMDA MEVCUT DEGIL' TO LS-REPORT(19:26)
           END-IF.
       H330-DELETE-FUNCTION-END. EXIT.
      *--------------------------------
       H340-UPDATE-FUNCTION.
           PERFORM H010-CHECK-MEMBER
           IF (WS-CHECK = 1)
              MOVE SPACES TO WS-NAME-STRING
              MOVE 1 TO WS-INDEX2
              PERFORM VARYING WS-INDEX FROM 1 BY 1
                      UNTIL WS-INDEX > LENGTH OF IDX-FILE-NAME
                 MOVE IDX-FILE-NAME(WS-INDEX:1) TO WS-TEMP
                 IF WS-TEMP NOT = SPACE
                    MOVE WS-TEMP TO WS-NAME-STRING(WS-INDEX2:1)
                    COMPUTE WS-INDEX2 = WS-INDEX2 + 1
                 END-IF
              END-PERFORM
              INSPECT IDX-FILE-SURNAME REPLACING ALL 'E' BY 'I',
                      'A' BY 'E'
              MOVE WS-NAME-STRING TO IDX-FILE-NAME
              REWRITE IDX-FILE-MEMBERS INVALID KEY
                  MOVE LS-INP-IDX-FILE-ID TO LS-REPORT
                  MOVE '-update-rc:' TO LS-REPORT(6:11)
                  MOVE VSAM-STATUS TO LS-REPORT(17:2)
                  MOVE '-KAYIT UPDATE EDILEMEDI' TO LS-REPORT(19:23)
              NOT INVALID KEY
                  MOVE LS-INP-IDX-FILE-ID TO LS-REPORT
                  MOVE '-update-rc:' TO LS-REPORT(6:11)
                  MOVE VSAM-STATUS TO LS-REPORT(17:2)
                  MOVE '-KAYIT UPDATE EDILDI' TO LS-REPORT(19:20)
              END-REWRITE
           ELSE
               MOVE LS-INP-IDX-FILE-ID TO LS-REPORT
               MOVE '-update-rc:' TO LS-REPORT(6:11)
               MOVE VSAM-STATUS TO LS-REPORT(17:2)
               MOVE '-KAYIT VSAMDA MEVCUT DEGIL' TO LS-REPORT(19:26)
           END-IF.
       H340-UPDATE-FUNCTION-END. EXIT.
      *--------------------------------
       H999-EXIT.
           CLOSE IDX-FILE.
           GOBACK.
       H999-END. EXIT.
