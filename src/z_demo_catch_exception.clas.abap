CLASS z_demo_catch_exception DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_oo_adt_classrun .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS z_demo_catch_exception IMPLEMENTATION.


  METHOD if_oo_adt_classrun~main.

    DATA number_1 TYPE  i VALUE IS INITIAL.

    DATA number_2 TYPE  i VALUE '5'.

    TRY.
        number_2 = 10 / number_1.
      CATCH cx_sy_zerodivide INTO DATA(exception).
        out->write( exception->get_text( ) ).
    ENDTRY.

     out->write( 'Continue' ).
  ENDMETHOD.
ENDCLASS.
