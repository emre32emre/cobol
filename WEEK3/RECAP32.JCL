//RECAP32 JOB 1,NOTIFY=&SYSUID
//COBRUN  EXEC IGYWCL
//COBOL.SYSIN  DD DSN=&SYSUID..CBL(RECAP32),DISP=SHR
//LKED.SYSLMOD DD DSN=&SYSUID..LOAD(RECAP32),DISP=SHR
// IF RC <= 4 THEN
//RUN     EXEC PGM=WEEK3
//STEPLIB   DD DSN=&SYSUID..LOAD,DISP=SHR
//INPFILE   DD DSN=&SYSUID..QSAM.INP,DISP=SHR
//IDXFILE   DD DSN=&SYSUID..VSAM.AA,DISP=SHR
//OUTFILE   DD DSN=&SYSUID..QSAM.OUT,
//             DISP=(NEW,CATLG,DELETE),
//             UNIT=SYSDA,
//             SPACE=(TRK,(10,10),RLSE),
//             DCB=(RECFM=FB,LRECL=67,BLKSIZE=0)
//SYSOUT    DD SYSOUT=*,OUTLIM=15000
//CEEDUMP   DD DUMMY
//SYSUDUMP  DD DUMMY
// ELSE
// ENDIF