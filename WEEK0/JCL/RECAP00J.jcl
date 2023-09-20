//RECAP00 JOB 1,NOTIFY=&SYSUID
//***************************************************/
//*RECAP00 programini derle ve load da calistirilabilir dosya uret.
//*Urettigin dosyayi DATA dan input alarak calisitir.
//*outputunu CIKTI adli dosyaya yaz. 
//***************************************************/
//COBRUN  EXEC IGYWCL
//COBOL.SYSIN  DD DSN=&SYSUID..CBL(RECAP00),DISP=SHR
//LKED.SYSLMOD DD DSN=&SYSUID..LOAD(RECAP00),DISP=SHR
//***************************************************/
// IF RC = 0 THEN
//***************************************************/
//RUN     EXEC PGM=RECAP00
//STEPLIB   DD DSN=&SYSUID..LOAD,DISP=SHR
//ACCTREC   DD DSN=&SYSUID..DATA,DISP=SHR
//*PRTLINE   DD SYSOUT=*,OUTLIM=15000 -> standart terminale cikti almak icin
//PRTLINE   DD DSN=&SYSUID..CIKTI,DISP=(NEW,CATLG,DELETE),
//             UNIT=SYSDA,SPACE=(TRK,(1,1),RLSE)
////*DSN -> cikti dosyasinin pathi
//*DISP -> islemin nasil konfigure edilecegi belirtir NEW yeni veri seti olustur
//*         CATLG veri setinin kataloglanmasini saglar.
//*UNIT -> Bu, veri setinin fiziksel cihazin adini belirtir. 
//*        "SYSDA" genellikle disk birimini ifade eder.
//*SPACE -> Boyut belirtir TRK silindir olarak yer acilir.
//SYSOUT    DD SYSOUT=*,OUTLIM=15000
//CEEDUMP   DD DUMMY
//SYSUDUMP  DD DUMMY
//***************************************************/
// ELSE
// ENDIF
