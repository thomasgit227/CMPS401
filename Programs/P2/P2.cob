IDENTIFICATION DIVISION. PROGRAM-ID. P2.

ENVIRONMENT DIVISION.
    INPUT-OUTPUT SECTION.
    FILE-CONTROL.
    SELECT myInput  ASSIGN TO "P2In.dat"
        ORGANIZATION IS LINE SEQUENTIAL
        ACCESS IS SEQUENTIAL.
    SELECT toBePrinted ASSIGN to "P2Out.dat"
        ORGANIZATION IS LINE SEQUENTIAL
        ACCESS IS SEQUENTIAL.
    SELECT myOutput ASSIGN TO "P2Out.dat"
        ORGANIZATION IS LINE SEQUENTIAL
        ACCESS IS SEQUENTIAL.


DATA DIVISION.
    FILE SECTION.

      FD toBePrinted.
        01 lineToBePrinted PIC X(130).

      FD myInput.
          01 course.
              02 studentName PIC X(18).
              02 wNumber PIC X(8).
              02 term PIC X(11).
              02 classCode PIC X(10).
              02 desc PIC X(28).
              02 grade PIC X(1).
              02 hours PIC 9(1)V99.

      FD myOutput.
          01 printNewLine PIC X(10).
          01 printHeadding PIC X(100).
          01 printSubHeading PIC X(100).
          01 printStudentName PIC X(100).
          01 printStudentNumber PIC X(8).
          01 printTerm PIC X(12).

          01 transcript.
              02 classCode-transcript PIC X(14).
              02 desc-transcript PIC X(33).
              02 grade-transcript PIC A(5).
              02 hours-transcript PIC Z(2).99.
              02 FILLER PIC X(10).
              02 qpts-transcript PIC Z(2).99.

          01 printQpts.
              02 printQptsFinal PIC Z(2).99.

          01 printCumulative.
              02 printSemester PIC X(42).
              02 FILLER PIC X(11) VALUE SPACES.
              02 cumulative-hours-print PIC 99.99.
              02 FILLER PIC X(10) VALUE SPACES.
              02 cumulative-quality-points-print PIC 9(2).99.
              02 FILLER PIC X(10) VALUE SPACES.
              02 cumulative-gpa-print PIC 99.99.

        01 blankSpace.
                02 FILLER PIC X(200) VALUE ZERO.
                02 FILLER PIC X(200) VALUE ZERO.

    WORKING-STORAGE SECTION.
        01 fileEndFlag PIC 9 VALUE 0.
        01 firstRead PIC 9 VALUE 1.
        01 WS-LineToBePrinted PIC X(130).
        01 printNewLineWS PIC X(10) VALUE ' '.

        01 headding1.
            02 FILLER PIC X(100) VALUE '                 SOUTHEASTERN LOUISIANA UNIVERSITY'.

        01 headding2.
            02 FILLER PIC X(100) VALUE '                         HAMMOND, LA 70402'.

        01 subHeading.
            02 FILLER PIC X(130) VALUE 'Course        Title                            GR    Hour          QPTS             GPA'.

        01 studentNameHeadder.
            02 FILLER PIC X(100).

        01 student-termWS.
            02 FILLER PIC X(100).

        01 qptsWS.
            02 calculatedQtps PIC 9(2)V99 VALUE ZERO.
            02 calculatedQtpsTotal PIC 9(2)V99 VALUE ZERO.

        01 semesterCumulative.
            02 FILLER PIC X(42) VALUE '                                 SEMESTER:'.
            02 FILLER PIC X(10) VALUE SPACES.
            02 semester-hours PIC 9(2).99 VALUE ZERO.
            02 FILLER PIC X(10) VALUE SPACES.
            02 semester-quality-points PIC Z(2).99.
            02 FILLER PIC X(10) VALUE '          '.
            02 semester-gpa-person PIC Z(2).99.

        01 personCumulative.
            02 FILLER PIC X(42) VALUE '                               CUMULATIVE:'.
            02 FILLER PIC X(10) VALUE SPACES.
            02 cumulative-hours PIC 99.99 VALUE ZERO.
            02 FILLER PIC X(10) VALUE '          '.
            02 cumulative-quality-points PIC Z(2).99.
            02 FILLER PIC X(10) VALUE SPACES.
            02 cumulative-gpa-person PIC Z(2).99.

        01 temp-quality-pointsWS PIC 9(2)V99.

        01 totalCumulatives.
        01 cumulative-gpa PIC 9(2).99.
        01 semester-quality-points-WS PIC 9(2)V99.
        01 calculated-semester-hours PIC 9(2)V99.
        01 calculatedQpts PIC 9(2)V99.

        *> THESE VARIABLES ARE THE GOOD ONES, DONT TOUCH THE OTHERS THOUGH FOR THE SAKE OF HUMANITY

        01 actual-semester-hours PIC 9(2)V99.
        01 actual-semester-gpa PIC 9(2)V99.

        01 actual-semester-quality-points PIC 9(2)V99.

        01 cumulative-hours-math PIC 9(2)V99.

        01 actual-total-hours PIC 9(2)V99.

        01 live-gpa PIC 9(2)V99.

        01 live-hours PIC 9(2)V99.
        01 live-quality-points PIC 9(2)V99.

        01 blankSpaceArea.
                02 deadspace PIC X(200) VALUE '                                                                                                             >
                02 deadspaceTwo PIC X(200) VALUE '                                                                                                          >
PROCEDURE DIVISION.
    OPEN INPUT myInput.
    OPEN OUTPUT myOutput.
    WRITE printHeadding FROM headding1.
    WRITE printHeadding FROM headding2.

    PERFORM writeEmptyLine

    PERFORM UNTIL fileEndFlag = 1
        PERFORM readInput
    END-PERFORM.
    WRITE blankSpace from blankSpaceArea.

    CLOSE myInput, myOutput.

    OPEN INPUT toBePrinted.
    MOVE 0 TO fileEndFlag
    PERFORM UNTIL fileEndFlag = 1
        PERFORM printFile
    END-PERFORM.
    CLOSE toBePrinted

STOP RUN.


readInput.
    READ myInput
        AT END
            MOVE 1 to fileEndFlag

            MOVE cumulative-hours TO cumulative-hours-print
            *>WRITE printCumulative FROM personCumulative

        NOT AT END
           *> FIRST READ PRINT STUFF
            if firstRead = 1
                MOVE studentName TO studentNameHeadder
                WRITE printStudentName FROM studentNameHeadder
                WRITE printStudentNumber FROM wNumber
            PERFORM writeEmptyLine
                WRITE printSubHeading FROM subHeading
                PERFORM writeEmptyLine
                MOVE term TO student-termWS
                MOVE student-termWS to printTerm
                WRITE printTerm
                MOVE 0 to firstRead
            end-if

            if student-termWS IS NOT = term


                MOVE calculated-semester-hours TO semester-hours

                MOVE semester-quality-points-WS to semester-quality-points

                MOVE cumulative-gpa TO cumulative-gpa-person

                MOVE actual-semester-hours TO semester-hours
                MOVE actual-semester-gpa TO semester-gpa-person

                MOVE semester-hours TO live-hours

                MOVE semester-quality-points TO live-quality-points

                DIVIDE live-quality-points BY live-hours GIVING live-gpa
                MOVE live-gpa TO semester-gpa-person

                WRITE printCumulative FROM semesterCumulative

                ADD actual-semester-hours TO actual-total-hours
              MOVE ZERO TO actual-semester-hours

                MOVE ZERO TO semester-hours
                MOVE ZERO to semester-quality-points-WS

                MOVE actual-total-hours TO cumulative-hours

                MOVE cumulative-hours TO cumulative-hours-print
                MOVE calculatedQtpsTotal TO cumulative-quality-points
                MOVE cumulative-gpa TO cumulative-gpa-person

                MOVE cumulative-hours-print  TO live-hours

                MOVE cumulative-quality-points  TO live-quality-points

                DIVIDE live-quality-points BY live-hours GIVING live-gpa
                MOVE live-gpa TO cumulative-gpa-person


                WRITE printCumulative FROM personCumulative

                *> When 'term' changes update the term and write to file
                PERFORM writeEmptyLine

                MOVE term to student-termWS
                MOVE term TO printTerm
                PERFORM calculateQPTS
                PERFORM calculateGPA

                WRITE printTerm
            ELSE
                PERFORM calculateQPTS
            END-IF

            *>PERFORM calculateGPA
            MOVE ZERO to hours-transcript
            MOVE ZERO to qpts-transcript
            *> print each class
            MOVE classCode to classCode-transcript
            MOVE desc to desc-transcript
            MOVE grade to grade-transcript
            MOVE hours to hours-transcript
            MOVE calculatedQtps to qpts-transcript
            *> calculating cumulative hours
            ADD hours TO cumulative-hours-math

            WRITE transcript
            *> WRITE printQpts FROM calculatedQtpsTotal
    END-READ.
EXIT.

writeEmptyLine.
    WRITE printNewLine FROM printNewLineWS
EXIT.

calculateGPA.
        DIVIDE actual-semester-quality-points BY actual-semester-hours GIVING actual-semester-gpa.
EXIT.

calculateQPTS.

    ADD actual-semester-hours hours GIVING actual-semester-hours
    IF grade = "A"
            MULTIPLY 4 BY hours GIVING calculatedQtps
            ADD calculatedQtps TO calculatedQtpsTotal
            ADD calculatedQtps TO actual-semester-quality-points

    END-IF
    IF grade = "B"
            MULTIPLY 3 BY hours GIVING calculatedQtps
            ADD calculatedQtps TO calculatedQtpsTotal
            ADD calculatedQtps TO actual-semester-quality-points

    END-IF
    IF grade = 'C'
            MULTIPLY 2 BY hours GIVING calculatedQtps
            ADD calculatedQtps TO calculatedQtpsTotal
            ADD calculatedQtps TO actual-semester-quality-points

    END-IF
    IF grade = 'D'
            MULTIPLY 1 BY hours GIVING calculatedQtps
            ADD calculatedQtps TO calculatedQtpsTotal
            ADD calculatedQtps TO actual-semester-quality-points
    END-IF

    ADD hours TO  calculated-semester-hours

    ADD calculatedQtps TO semester-quality-points-WS

EXIT.

printFile.
    READ toBePrinted
        AT END
            MOVE 1 to fileEndFlag
        NOT AT END
                MOVE lineToBePrinted to WS-LineToBePrinted
                DISPLAY WS-LineToBePrinted
    END-READ.
EXIT.