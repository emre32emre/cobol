       IDENTIFICATION DIVISION.
       PROGRAM-ID.    RECAP04
       AUTHOR.        MUSA.
      *--------------------
       ENVIRONMENT DIVISION.
      *--------------------
       INPUT-OUTPUT SECTION.
       FILE-CONTROL.
           SELECT PRINT-LINE ASSIGN TO PRTLINE.
           SELECT ACCT-REC   ASSIGN TO ACCTREC.
      *-------------
       DATA DIVISION.
      *-------------
       FILE SECTION.
       FD PRINT-LINE RECORDING MODE F.
       01  PRINT-REC.
           05  USER-ID-O         PIC 9(4).
           05  SPACE-1           PIC X(3).
           05  USER-NAME-O       PIC X(15).
           05  USER-SURNAME-O    PIC X(15).
           05  USER-TC-NO-O      PIC 9(11).
           05  SPACE-2           PIC X(5).
           05  USER-BIRTHDAY-O   PIC 9(8).
           05  SPACE-3           PIC X(3).
           05  USER-LIVE-O       PIC 9(6).
       FD  ACCT-REC RECORDING MODE F.
       01  ACCT-FIELDS.
           05  USER-ID         PIC 9(4).
           05  USER-NAME       PIC X(15).
           05  USER-SURNAME    PIC X(15).
           05  USER-TC-NO      PIC 9(11).
           05  USER-BIRTHDAY   PIC 9(8).
           05  USER-TODAY      PIC 9(8).
       WORKING-STORAGE SECTION.
       01 FLAGS.
         05 LASTREC           PIC X VALUE SPACE.
       01 DATE-VARIABLE.
         05 INT-LIVE-DAY     PIC 9(6).
         05 INT-TODAY        PIC 9(8).
         05 INT-BIRTHDAY     PIC 9(8).
       01  HEADER-1.
           05  FILLER         PIC X(23) VALUE 'YASANILAN GUN HESAPLAMA'.
           05  FILLER         PIC X(47) VALUE SPACES.
       01  HEADER-2.
           05  FILLER         PIC X(05) VALUE 'YIL '.
           05  HDR-YR         PIC 9(04).
           05  FILLER         PIC X(02) VALUE SPACES.
           05  FILLER         PIC X(06) VALUE 'AY '.
           05  HDR-MO         PIC X(02).
           05  FILLER         PIC X(02) VALUE SPACES.
           05  FILLER         PIC X(04) VALUE 'GUN '.
           05  HDR-DAY        PIC X(02).
           05  FILLER         PIC X(43) VALUE SPACES.
       01  HEADER-3.
           05  FILLER         PIC X(02) VALUE 'ID'.
           05  FILLER         PIC X(05) VALUE SPACES.
           05  FILLER         PIC X(04) VALUE 'ISIM'.
           05  FILLER         PIC X(11) VALUE SPACES.
           05  FILLER         PIC X(07) VALUE 'SOYISIM'.
           05  FILLER         PIC X(08) VALUE SPACES.
           05  FILLER         PIC X(09) VALUE 'KIMLIK-NO'.
           05  FILLER         PIC X(07) VALUE SPACES.
           05  FILLER         PIC X(07) VALUE 'DOGUM-T'.
           05  FILLER         PIC X(04) VALUE SPACES.
           05  FILLER         PIC X(03) VALUE 'GUN'.
           05  FILLER         PIC X(03) VALUE SPACES.
       01  HEADER-4.
           05  FILLER         PIC X(04) VALUE '----'.
           05  FILLER         PIC X(03) VALUE SPACES.
           05  FILLER         PIC X(10) VALUE '----------'.
           05  FILLER         PIC X(05) VALUE SPACES.
           05  FILLER         PIC X(10) VALUE '----------'.
           05  FILLER         PIC X(05) VALUE SPACES.
           05  FILLER         PIC X(11) VALUE '-----------'.
           05  FILLER         PIC X(05) VALUE SPACES.
           05  FILLER         PIC X(08) VALUE '--------'.
           05  FILLER         PIC X(03) VALUE SPACES.
           05  FILLER         PIC X(08) VALUE '--------'.
       01 WS-CURRENT-DATE-DATA.
           05  WS-CURRENT-DATE.
               10  WS-CURRENT-YEAR         PIC 9(04).
               10  WS-CURRENT-MONTH        PIC 9(02).
               10  WS-CURRENT-DAY          PIC 9(02).
      *------------------
       PROCEDURE DIVISION.
      *------------------
       OPEN-FILES.
           OPEN INPUT  ACCT-REC.
           OPEN OUTPUT PRINT-LINE.
       WRITE-HEADERS.
           MOVE FUNCTION CURRENT-DATE TO WS-CURRENT-DATE-DATA.
           MOVE WS-CURRENT-YEAR  TO HDR-YR.
           MOVE WS-CURRENT-MONTH TO HDR-MO.
           MOVE WS-CURRENT-DAY   TO HDR-DAY.
           WRITE PRINT-REC FROM HEADER-1.
           WRITE PRINT-REC FROM HEADER-2.
           WRITE PRINT-REC FROM HEADER-3.
           WRITE PRINT-REC FROM HEADER-4.
       READ-NEXT-RECORD.
           PERFORM READ-RECORD
           PERFORM UNTIL LASTREC = 'Y'
               PERFORM WRITE-RECORD
               PERFORM READ-RECORD
           END-PERFORM.
       CLOSE-STOP.
           CLOSE ACCT-REC.
           CLOSE PRINT-LINE.
           GOBACK.
       READ-RECORD.
           READ ACCT-REC
               AT END MOVE 'Y' TO LASTREC
           END-READ.
       WRITE-RECORD.
           COMPUTE INT-TODAY = FUNCTION INTEGER-OF-DATE(USER-TODAY).
           COMPUTE INT-BIRTHDAY = FUNCTION INTEGER-OF-DATE
           (USER-BIRTHDAY).
           COMPUTE INT-LIVE-DAY = INT-TODAY - INT-BIRTHDAY.
           MOVE USER-ID        TO  USER-ID-O.
           MOVE SPACE          TO  SPACE-1.
           MOVE USER-NAME      TO  USER-NAME-O.
           MOVE USER-SURNAME   TO  USER-SURNAME-O.
           MOVE USER-TC-NO     TO  USER-TC-NO-O.
           MOVE SPACE          TO  SPACE-2.
           MOVE USER-BIRTHDAY  TO  USER-BIRTHDAY-O.
           MOVE SPACE          TO  SPACE-3.
           MOVE INT-LIVE-DAY   TO  USER-LIVE-O.
           WRITE PRINT-REC.

