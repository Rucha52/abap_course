CLASS lhc_zr_s4d400_6666_con DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.
    METHODS:
      get_global_authorizations FOR GLOBAL AUTHORIZATION
        IMPORTING
        REQUEST requested_authorizations FOR ZrS4d4006666Con
        RESULT result.

    METHODS CheckSemanticKey FOR VALIDATE ON SAVE
      IMPORTING keys FOR ZrS4d4006666Con~CheckSemanticKey.
    METHODS GetCities FOR DETERMINE ON SAVE
      IMPORTING keys FOR ZrS4d4006666Con~GetCities.
      "!<p> Method to get county from country code</p>
      METHODS getcountry.
ENDCLASS.

CLASS lhc_zr_s4d400_6666_con IMPLEMENTATION.
  METHOD get_global_authorizations.
  ENDMETHOD.

  METHOD checksemantickey.
    DATA read_keys   TYPE TABLE FOR READ IMPORT zr_s4d400_6666_con.
    DATA connections TYPE TABLE FOR READ RESULT zr_s4d400_6666_con.

    read_keys = CORRESPONDING #( keys ).

    READ ENTITIES OF zr_s4d400_6666_con IN LOCAL MODE
         ENTITY ZrS4d4006666Con
         FIELDS ( CarrierID ConnectionID )
         WITH read_keys
         RESULT connections.

    SELECT FROM zs4d400_6666_con
            FIELDS uuid, carrier_id,  connection_id
            UNION
            SELECT FROM zs4d400_6666_c_d
            FIELDS uuid, carrierid AS carrier_id,  connectionid AS connection_id
          INTO  TABLE @DATA(all_records).

    SORT all_records BY uuid.

    SELECT
    FROM /dmo/carrier
    FIELDS carrier_id
    INTO TABLE @DATA(airlines).


    LOOP AT connections INTO DATA(connection).
      READ TABLE all_records ASSIGNING FIELD-SYMBOL(<check_result>)
         WHERE carrier_id     = connection-CarrierID
           AND connection_id  = connection-ConnectionID
           AND uuid          <> connection-Uuid.

      IF sy-subrc IS INITIAL.

        DATA(message) = new_message( id       = 'ZCL_M_RAP_VALI'
                                     number   = '001'
                                     v1       = connection-CarrierID
                                     v2       = connection-ConnectionID
                                     severity = ms-error ).

        DATA reported_record LIKE LINE OF reported-zrs4d4006666con.
        reported_record-%tky = connection-%tky.
        reported_record-%msg = message.
        reported_record-%element-ConnectionID = if_abap_behv=>mk-on.
        reported_record-%element-CarrierID    = if_abap_behv=>mk-on.
        INSERT reported_record INTO TABLE reported-zrs4d4006666con.

        DATA failed_record LIKE LINE OF failed-zrs4d4006666con.
        failed_record-%tky = connection-%tky.
        failed_record-%fail-cause = if_abap_behv=>cause-conflict.
        INSERT failed_record INTO TABLE failed-zrs4d4006666con.
      ENDIF.

      IF connection-AirportFromID = connection-AirportToID.
        DATA(message1) = new_message( id       = 'ZCL_M_RAP_VALI'
                                      number   = '003'
                                      v1       = connection-AirportFromID
                                      v2       = connection-AirportToID
                                      severity = ms-error ).

        reported_record-%tky = connection-%tky.
        reported_record-%msg = message1.
        reported_record-%element-AirportFromID = if_abap_behv=>mk-on.
        reported_record-%element-AirportToID   = if_abap_behv=>mk-on.
        INSERT reported_record INTO TABLE reported-zrs4d4006666con.

        failed_record-%tky = connection-%tky.
        failed_record-%fail-cause = if_abap_behv=>cause-conflict.
        INSERT failed_record INTO TABLE failed-zrs4d4006666con.
      ENDIF.

      IF connection-CarrierID IS INITIAL OR connection-ConnectionID IS INITIAL.
        DATA(message2) = new_message( id       = 'ZCL_M_RAP_VALI'
                                             number   = '005'
                                             v1       = connection-CarrierID
                                             v2       = connection-ConnectionID
                                             severity = ms-error ).

        reported_record-%tky = connection-%tky.
        reported_record-%msg = message2.
        reported_record-%element-carrierid = if_abap_behv=>mk-on.
        reported_record-%element-connectionid   = if_abap_behv=>mk-on.
        INSERT reported_record INTO TABLE reported-zrs4d4006666con.

        failed_record-%tky = connection-%tky.
        failed_record-%fail-cause = if_abap_behv=>cause-conflict.
        INSERT failed_record INTO TABLE failed-zrs4d4006666con.
      ENDIF.


      READ TABLE airlines  WITH  KEY carrier_id = connection-CarrierID
     TRANSPORTING NO FIELDS.

      IF sy-subrc IS NOT INITIAL.
        DATA(message3) = new_message( id       = 'ZCL_M_RAP_VALI'
                                      number   = '002'
                                      severity = ms-error
                                      v1       = connection-CarrierID ).


        reported_record-%tky = connection-%tky.
        reported_record-%msg = message3.
        reported_record-%element-CarrierID    = if_abap_behv=>mk-on.
        INSERT reported_record INTO TABLE reported-zrs4d4006666con.


        failed_record-%tky = connection-%tky.
        failed_record-%fail-cause = if_abap_behv=>cause-conflict.
        INSERT failed_record INTO TABLE failed-zrs4d4006666con.
      ENDIF.


    ENDLOOP.
  ENDMETHOD.

  METHOD GetCities.

    READ ENTITIES OF zr_s4d400_6666_con IN LOCAL MODE
    ENTITY ZrS4d4006666Con
    FIELDS ( AirportFromID AirportToID )
    WITH CORRESPONDING #( keys )
    RESULT DATA(connections).

    LOOP AT connections INTO DATA(connection).
      SELECT SINGLE FROM /dmo/i_airport FIELDS city, countrycode
      WHERE airportid = @connection-AirportFromID
      INTO (  @connection-CityFrom , @connection-CountryFrom ).

      SELECT SINGLE FROM /dmo/i_airport FIELDS city, countrycode
      WHERE airportid = @connection-AirportToID
      INTO (  @connection-CityTo , @connection-Countryto ).

      MODIFY connections FROM connection.
    ENDLOOP.

    DATA connections_upd  TYPE TABLE FOR UPDATE zr_s4d400_6666_con.

    connections_upd = CORRESPONDING #( connections ).

    MODIFY ENTITIES OF zr_s4d400_6666_con IN LOCAL MODE
    ENTITY ZrS4d4006666Con
    UPDATE
    FIELDS ( CityFrom CountryFrom CityTo CountryTo )
    WITH connections_upd
    REPORTED DATA(reported_records).

    reported-zrs4d4006666con = CORRESPONDING #( reported_records-zrs4d4006666con ).

  ENDMETHOD.

  METHOD getcountry.

  ENDMETHOD.

ENDCLASS.
