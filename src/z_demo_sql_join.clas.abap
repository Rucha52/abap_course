CLASS z_demo_sql_join DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES if_oo_adt_classrun .
  PROTECTED SECTION.
  PRIVATE SECTION.
    CLASS-METHODS Inner_join_demo
      IMPORTING
        i_out TYPE REF TO if_oo_adt_classrun_out.
ENDCLASS.



CLASS z_demo_sql_join IMPLEMENTATION.
  METHOD if_oo_adt_classrun~main.
    " --- 1. INNER JOIN EXAMPLE ---
    Inner_join_demo( out ).
    TRY.


        DATA(lv_user_language) = cl_abap_context_info=>get_user_language_abap_format(  ).
      CATCH cx_abap_context_info_error INTO DATA(cx).
    ENDTRY.
    out->write( lv_user_language ).

    " --- 2. LEFT OUTER JOIN EXAMPLE ---
    SELECT FROM /dmo/carrier AS c
      LEFT OUTER JOIN /dmo/flight AS fl
        ON c~carrier_id = fl~carrier_id
      FIELDS c~carrier_id,
             c~name AS airline_name,
             fl~flight_date,
             fl~price,
             fl~currency_code
      INTO TABLE @DATA(lt_left_join)
      UP TO 15 ROWS.

    out->write( '--- 2. LEFT OUTER JOIN: All Carriers, Flights if any ---' ).
    out->write( lt_left_join ).
    out->write( space ).
*

    " --- 3. RIGHT OUTER JOIN EXAMPLE ---
    SELECT FROM /dmo/connection AS conn
      RIGHT OUTER JOIN /dmo/flight AS fl
        ON conn~carrier_id     = fl~carrier_id
       AND conn~connection_id  = fl~connection_id
      FIELDS fl~carrier_id,
             fl~connection_id,
             fl~flight_date,
             conn~airport_from_id,
             conn~airport_to_id
      INTO TABLE @DATA(lt_right_join)
      UP TO 10 ROWS.

    out->write( '--- 3. RIGHT OUTER JOIN: All Flights matched with Route info ---' ).
    out->write( lt_right_join ).
    out->write( space ).
*
*    " --- 4. TRIPLE CHAIR JOIN EXAMPLE ---
    SELECT FROM /dmo/flight AS fl
      INNER JOIN /dmo/carrier AS c
        ON fl~carrier_id = c~carrier_id
      LEFT OUTER JOIN /dmo/airport AS air
        ON air~airport_id = fl~plane_type_id " Mapping dynamically or via route
      FIELDS fl~carrier_id,
             c~name AS airline_name,
             fl~connection_id,
             fl~flight_date,
             air~name AS airport_name,
             air~city AS airport_city
      INTO TABLE @DATA(lt_triple_join)
      UP TO 10 ROWS.

    out->write( '--- 4. MULTIPLE JOINS: Flights + Carriers + Airports ---' ).
    out->write( lt_triple_join ).
    out->write( space ).

    " --- 5. CROSS JOIN EXAMPLE ---
    SELECT FROM /dmo/carrier AS c
      CROSS JOIN /dmo/airport AS air
      FIELDS c~carrier_id,
             c~name AS airline_name,
             air~airport_id,
             air~city
      INTO TABLE @DATA(lt_cross_join)
      UP TO 20 ROWS. " Capped strictly for display limits

    out->write( '--- 5. CROSS JOIN: Combinatorial Matrix (Carrier x Airport) ---' ).
    out->write( lt_cross_join ).
  ENDMETHOD.


  METHOD Inner_join_demo.

    SELECT FROM /dmo/carrier AS c
      INNER JOIN /dmo/connection AS conn
        ON c~carrier_id = conn~carrier_id
      FIELDS c~carrier_id,
             c~name         AS airline_name,
             conn~connection_id,
             conn~airport_from_id,
             conn~airport_to_id
      INTO TABLE @DATA(lt_inner_join)
      UP TO 10 ROWS.

    i_out->write( '--- 1. INNER JOIN: Carriers with Connections ---'(001) ).
    i_out->write( lt_inner_join ).
    i_out->write( space ).

  ENDMETHOD.

ENDCLASS.
