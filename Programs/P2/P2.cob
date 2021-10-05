IDENTIFICATION DIVISION.
PROGRAM-ID. P2.
ENVIRONMENT DIVISION.
    INPUT-OUTPUT SECTION.
    FILE-CONTROL.
    SELECT myInput  ASSIGN TO "P2In.dat"
        ORGANIZATION IS LINE SEQUENTIAL
        ACCESS IS SEQUENTIAL.
    SELECT myOutput ASSIGN TO "P2Out.dat"
        ORGANIZATION IS LINE SEQUENTIAL
        ACCESS IS SEQUENTIAL.
DATA DIVISION.
    FILE SECTION.
      FD myInput.
          01 course.
              02 studentName PIC X(18).
              02 wNumber PIC X(8).
              02 term PIC X(12).
              02 classCode PIC X(9).
              02 desc PIC X(28).
              02 grade PIC X(1).
              02 hours PIC X(1).
      FD myOutput.
          01 printHeadding PIC X(100).
          01 printStudentName PIC X(100).
          01 printStudentNumber PIC X(8).
                01 printSubHeading PIC X(100).
          01 transcript.
              02 term-transcript PIC X(12).
              02 classCode-transcript PIC X(9).
              02 desc-transcript PIC X(28).
              02 grade-transcript PIC A(1).
              02 hours-transcript PIC A(1).
              02 qp-transcript PIC 99.99 VALUE 00.00.
              02 term-hours PIC 999.99 VALUE 000.00.
              02 term-qp PIC 999.99 VALUE 000.00.
              02 term-gpa PIC 9.99 VALUE 0.00.

 WORKING-STORAGE SECTION.
        01 fileEndFlag PIC 9 VALUE 0.
        01 firstRead PIC 9 VALUE 1.
        01 headding1.
            02 FILLER PIC X(100) VALUE '                      SOUTHEASTERN LOUISIANA UNIVERSITY'.
        01 headding2.
            02 FILLER PIC X(100) VALUE '                             HAMMOND, LA 70402'.
        01 studentNameHeadder.
            02 FILLER PIC X(100).
        01 subHeading.
                02 FILLER PIC X(100) Value 'Course        Title                               GR    Earned    QPTS'.
        01 cumulatives.
                02 cumulative-gpa PIC 9.99 VALUE 0.00.
                02 cumulative-qp PIC 999.99 VALUE 000.00.

        01 current-student PIC X(18).
        01 current-term PIC X(12).

PROCEDURE DIVISION.
    OPEN INPUT myInput.
    OPEN OUTPUT myOutput.
    WRITE printHeadding FROM headding1.
        DISPLAY headding1.
    WRITE printHeadding FROM headding2.
        display headding2.

    PERFORM UNTIL fileEndFlag = 1
        PERFORM readInput
    END-PERFORM.

    CLOSE myInput, myOutput.
STOP RUN.

readInput.
    READ myInput
        AT END
            MOVE 1 to fileEndFlag
        NOT AT END
                IF firstRead = 1
                MOVE studentName TO studentNameHeadder
                WRITE printStudentName FROM studentNameHeadder
                DISPLAY printStudentName

                WRITE printStudentNumber FROM wNumber
                DISPLAY printStudentNumber

                WRITE printSubHeading FROM subHeading
                DISPLAY printSubHeading

                MOVE 0 to firstRead

                IF current-student = student
                        IF current-term = term

                        ELSE

                        END-IF
                ELSE

                END-IF
        END-IF

        MOVE term to term-transcript
        MOVE classCode to classCode-transcript
        MOVE desc to desc-transcript
        MOVE grade to grade-transcript
        MOVE hours to hours-transcript
        WRITE transcript
        DISPLAY transcript

        *> Update Cumulatives
    END-READ.

