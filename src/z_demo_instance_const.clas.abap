CLASS z_demo_instance_const DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_oo_adt_classrun.
    METHODS:
      constructor IMPORTING color TYPE string OPTIONAL,
      accelerate IMPORTING delta  TYPE i,
      show_speed RETURNING VALUE(rv_output) TYPE string.
  PROTECTED SECTION.
  PRIVATE SECTION.
    DATA: color TYPE string,
          speed TYPE i.
ENDCLASS.



CLASS z_demo_instance_const IMPLEMENTATION.
  METHOD constructor.
    me->color = color.
  ENDMETHOD.

  METHOD accelerate.
    speed = speed + delta.
  ENDMETHOD.

  METHOD show_speed.
    rv_output = |{ color }: { speed }|.
  ENDMETHOD.

  METHOD if_oo_adt_classrun~main.
*1. Create the instances with colors
    DATA(car_red)   = NEW z_demo_instance_const( color = 'Red' ).
    DATA(car_blue)  = NEW z_demo_instance_const( color = 'Blue' ).
    DATA(car_green) = NEW z_demo_instance_const( color = 'Green' ).

    " 2. Accelerate them respectively
    car_red->accelerate( 100 ).
    car_blue->accelerate( 200 ).
    car_green->accelerate( 300 ).

    " 3. Write the outputs to the console
    out->write( car_red->show_speed( ) ).
    out->write( car_blue->show_speed( ) ).
    out->write( car_green->show_speed( ) ).
  ENDMETHOD.

ENDCLASS.
