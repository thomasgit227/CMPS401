GNU nano 4.8                                                                P1.f
program P1
  implicit none

  logical :: running = .true.
  character (len = 10) :: menuChoice

  do while(running)
    !reset variables
    menuChoice = ""

    print *, NEW_LINE('a'), "Select a conversion to perform"
    print *, "------------------------------"
    print *, "(1) pounds to kilograms"
    print *, "(2) kilograms to pounds"
    print *, "(3) feet to meters"
    print *, "(4) meters to feet"
    print *, "(5) fahrenheit to celsius"
    print *, "(6) celsius to fahrenheit"
    print *, "(0) exit program"
    print *, "------------------------------"

    read *, menuChoice
    select case (menuChoice)
      case ("0")
        running = .false.
      case ("1")
        call PoundsToKilograms()
      case ("2")
        call KilogramsToPounds()
      case ("3")
        call FeetToMeters()
      case ("4")
        call MetersToFeet()
      case ("5")
        call FahrenhitToCelsius()
      case ("6")
        call CelsiusToFahrenhit()
      case default
        print *, NEW_LINE('a'), "Invalid input, please try again"
    end select
        end do
        end program P1

    subroutine PoundsToKilograms()
        implicit none
        real :: pounds, kilograms

        print *, "pounds:"
        read *, pounds

        kilograms = pounds / 2.2046
        print *, "kilograms:", kilograms
    end subroutine PoundsToKilograms

    subroutine KilogramsToPounds()
        implicit none
        real :: x, y

        print *, "How many Kilograms?"
        read *, x

        y = x*2.2046
        PRINT*, y, " Pounds"
    end subroutine

    subroutine FeetToMeters()
        implicit none
        REAL :: x, y

        PRINT*, "How many Feet?"
        READ*, x

        y = (x/3.28084)
        PRINT*, y, " Meters"
    END subroutine

    subroutine MetersToFeet()
        implicit none
        REAL :: x, y

        PRINT*, "How many Meters?"
        READ*, x

        y = (x*3.28084)
        PRINT*, y, " Feet"
    END subroutine

    subroutine FahrenhitToCelsius()
        implicit none
        REAL :: x, y

        PRINT*, "What is the fahrenhit?"
        READ*, x

        y = (x-32)*5/9
        PRINT*, y, " Celsius"
    END subroutine
    
    subroutine CelsiusToFahrenhit()
        implicit none
        REAL :: x, y

        PRINT*, "What is the celsius?"
        READ*, x

        y = (x*9/5)+32
        PRINT*, y, " Fahrenhit"
    END subroutine
        