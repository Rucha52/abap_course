CLASS lhc_zr_s4d400_6666_fl DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.
    METHODS:
      get_global_authorizations FOR GLOBAL AUTHORIZATION
        IMPORTING
        REQUEST requested_authorizations FOR Connection_2
        RESULT result,
      validatePrice FOR VALIDATE ON SAVE
        IMPORTING keys FOR Connection_2~validatePrice.
ENDCLASS.

CLASS lhc_zr_s4d400_6666_fl IMPLEMENTATION.
  METHOD get_global_authorizations.
  ENDMETHOD.
  METHOD validatePrice.

    DATA failed_record   LIKE LINE OF failed-connection_2.
    DATA reported_record LIKE LINE OF reported-connection_2.

    READ ENTITIES OF zr_s4d400_6666_fl IN LOCAL MODE
        ENTITY Connection_2 FIELDS ( Price ) WITH CORRESPONDING #( keys )
        RESULT DATA(flights).

    LOOP AT flights  INTO DATA(flight).
      IF flight-price <= 0.

        failed_record-%tky = flight-%tky.
        APPEND failed_record TO failed-connection_2.

        reported_record-%tky = flight-%tky.
        reported_record-%msg = new_message(
                      id       = '/LRN/S4D400'
                      number   = '101'
                      severity = ms-error ).
        APPEND reported_record TO reported-connection_2.
      ENDIF.
    ENDLOOP.
  ENDMETHOD.
ENDCLASS.
