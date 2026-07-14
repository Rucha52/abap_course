*"* use this source file for the definition and implementation of
*"* local helper classes, interface definitions and type
*"* declarations
CLASS lcl_connection DEFINITION.

  PUBLIC SECTION.

    CLASS-DATA conn_counter TYPE i READ-ONLY.

    METHODS constructor
      IMPORTING
        i_connection_id TYPE /dmo/connection_id
        i_carrier_id    TYPE /dmo/carrier_id
      RAISING
        cx_abap_invalid_value .

    CLASS-METHODS class_constructor.

    METHODS get_output
      RETURNING
        VALUE(r_output) TYPE string_table.

  PROTECTED SECTION.

  PRIVATE SECTION.

    TYPES:
      BEGIN OF st_details,
        departureairport   TYPE /dmo/airport_from_id,
        destinationairport TYPE   /dmo/airport_to_id,
        airlinename        TYPE   /dmo/carrier_name,
      END OF st_details.

    TYPES:
      BEGIN OF st_airport,
        AirportID TYPE /dmo/airport_id,
        Name      TYPE /dmo/airport_name,
      END OF st_airport.

    TYPES tt_airports TYPE STANDARD TABLE OF st_airport WITH NON-UNIQUE DEFAULT KEY.


    DATA carrier_id    TYPE /dmo/carrier_id.
    DATA connection_id TYPE /dmo/connection_id.
    CLASS-DATA airports TYPE tt_airports.

*    DATA airport_from_id TYPE /dmo/airport_from_id.
*    DATA airport_to_id   TYPE /dmo/airport_to_id.
*
*    DATA carrier_name    TYPE /dmo/carrier_name.

    DATA details TYPE st_details.

ENDCLASS.

CLASS lcl_connection IMPLEMENTATION.

  METHOD constructor.

    " ensure non-initial input
    IF i_carrier_id IS INITIAL OR i_connection_id IS INITIAL.
      RAISE EXCEPTION TYPE cx_abap_invalid_value.
    ENDIF.

    " check existence and read additional data
    SELECT SINGLE
      FROM /dmo/i_connection
    FIELDS departureairport, destinationairport, \_airline-name AS airlinename
     WHERE airlineid    = @i_carrier_id
       AND connectionid = @i_connection_id
*      INTO ( @airport_from_id, @airport_to_id, @carrier_name  ).
      INTO CORRESPONDING FIELDS OF @details.

    IF sy-subrc <> 0.
      RAISE EXCEPTION TYPE cx_abap_invalid_value.
    ENDIF.

    me->connection_id = i_connection_id.
    me->carrier_id    = i_carrier_id.

    conn_counter = conn_counter + 1.

  ENDMETHOD.

  METHOD get_output.

*    APPEND |--------------------------------|             TO r_output.
*    APPEND |Carrier:     { carrier_id } { carrier_name }| TO r_output.
*    APPEND |Connection:  { connection_id   }|             TO r_output.
*    APPEND |Departure:   { airport_from_id }|             TO r_output.
*    APPEND |Destination: { airport_to_id   }|             TO r_output.

    DATA(departure) = airports[ airportid =  details-departureairport ].
    DATA(destination) = airports[ airportid =  details-destinationairport ].

    APPEND |--------------------------------|                    TO r_output.
    APPEND |Carrier:     { carrier_id } { details-airlinename }| TO r_output.
    APPEND |Connection:  { connection_id   }|                    TO r_output.
    APPEND |Departure:   { details-DepartureAirport   } { departure-name }| TO r_output.
    APPEND |Destination: { details-DestinationAirport } { destination-name }| TO r_output.

  ENDMETHOD.

  METHOD class_constructor.
    SELECT
    FROM /DMO/I_Airport
    FIELDS airportid, Name
    INTO CORRESPONDING FIELDS OF TABLE @airports.
  ENDMETHOD.

ENDCLASS.
