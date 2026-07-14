@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AbapCatalog.sqlViewName: 'Z_SQL_DEMO'

@AccessControl.authorizationCheck: #NOT_REQUIRED

@EndUserText.label: 'demo for cds view'

@Metadata.ignorePropagatedAnnotations: true

define view Z_C_S4D400_Demo_1
  as select from /dmo/flight as Flight

  -- Teach students the difference between JOINS and ASSOCIATIONS (On-demand joins)
  association [0..*] to /dmo/booking as _Booking on  $projection.CarrierId    = _Booking.carrier_id
                                                 and $projection.ConnectionId = _Booking.connection_id
                                                 and $projection.FlightDate   = _Booking.flight_date

{
      @EndUserText.label: 'Carrier ID'
      @UI.facet: [ { id: 'FlightDetails', type: #COLLECTION, label: 'Flight Overview' } ]
      @UI.lineItem: [ { position: 10, importance: #HIGH } ]
      @UI.selectionField: [ { position: 10 } ]
  key Flight.carrier_id                           as CarrierId,


      @EndUserText.label: 'Connection ID'
      @UI.lineItem: [ { position: 20, importance: #HIGH } ]
      @UI.selectionField: [ { position: 20 } ]
  key Flight.connection_id                        as ConnectionId,


      @EndUserText.label: 'Flight Date'
      @UI.lineItem: [ { position: 40, importance: #MEDIUM } ]
  key Flight.flight_date                          as FlightDate,


      @EndUserText.label: 'Plane Type'
      @Search.defaultSearchElement: true
      @Search.fuzzinessThreshold: 0.8
      @UI.lineItem: [ { position: 30, importance: #MEDIUM } ]

      /* =======================================================================
     3. SEARCH & FUZZY MATCHING ANNOTATIONS
     =======================================================================
        */
      Flight.plane_type_id                        as PlaneType,

      @EndUserText.label: 'Ticket Price'
      @UI.lineItem: [ { position: 50, importance: #MEDIUM } ]
      @Semantics.amount.currencyCode: 'CurrencyCode'
      Flight.price                                as TicketPrice,

      @EndUserText.label: 'Currency Code'
      @UI.lineItem: [ { position: 60, importance: #MEDIUM } ]
      @Semantics.currencyCode: true
      Flight.currency_code                        as CurrencyCode,


      @Semantics.quantity.unitOfMeasure: 'SeatUnit'
      @EndUserText.label: 'Maximum Seats'
      @UI.lineItem: [ { position: 70, importance: #MEDIUM } ]
      cast(Flight.seats_max as abap.dec( 15, 2 )) as SeatsMax,

      @EndUserText.label: 'Seat Unit'
      @UI.lineItem: [ { position: 80, importance: #MEDIUM } ]
      @Semantics.unitOfMeasure: true
      cast('ST' as msehi)                         as SeatUnit,

      /* Associations */
      _Booking
}
