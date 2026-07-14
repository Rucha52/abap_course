@AbapCatalog.sqlViewName: 'ZSQL_S4D400_DEMO'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'CDS Training View for S4D400 Course'
@Metadata.ignorePropagatedAnnotations: true

/* =======================================================================
  HEADER / VIEW-LEVEL ANNOTATIONS
  =======================================================================
  These annotations define metadata for the entire CDS view entity.
*/

-- Virtual Data Model (VDM) Classification
@VDM.viewType: #BASIC



-- Client Handling
@ClientHandling.algorithm: #AUTOMATED

-- Analytics Metadata
@Analytics.dataCategory: #DIMENSION

define view Z_C_S4D400_Demo
  as select from /dmo/flight as Flight

  -- Teach students the difference between JOINS and ASSOCIATIONS (On-demand joins)
  association [0..*] to /dmo/booking as _Booking on  $projection.CarrierId    = _Booking.carrier_id
                                                 and $projection.ConnectionId = _Booking.connection_id
                                                 and $projection.FlightDate   = _Booking.flight_date
{
      /* =======================================================================
         2. KEY FIELDS, SELECTION & FIORI UI ANNOTATIONS
         =======================================================================
      */
      @EndUserText.label: 'Airline ID'
      @EndUserText.quickInfo: 'Unique Code for Carrier Airline'
      @UI.facet: [ { id: 'FlightDetails', type: #COLLECTION, label: 'Flight Overview' } ]
      @UI.lineItem: [{ position: 10, importance: #HIGH }]
      @UI.selectionField: [{ position: 10 }]
  key Flight.carrier_id                           as CarrierId,

      @EndUserText.label: 'Connection Number'
      @UI.lineItem: [{ position: 20, importance: #HIGH }]
      @UI.selectionField: [{ position: 20 }]
  key Flight.connection_id                        as ConnectionId,

      @EndUserText.label: 'Flight Date'
      @UI.lineItem: [{ position: 30, importance: #MEDIUM }]
  key Flight.flight_date                          as FlightDate,

      /* =======================================================================
         3. SEARCH & FUZZY MATCHING ANNOTATIONS
         =======================================================================
      */
      @Search.defaultSearchElement: true
      @Search.fuzzinessThreshold: 0.8
      @EndUserText.label: 'Aircraft Model'
      @UI.lineItem: [{ position: 40, importance: #MEDIUM }]
      Flight.plane_type_id                        as PlaneType,

      /* =======================================================================
         4. SEMANTICS (CURRENCIES & QUANTITIES)
         =======================================================================
         Crucial Lesson: Demonstrates data type linking so Fiori and ALV
         can display units and calculate currency conversions correctly.
      */
      @Semantics.amount.currencyCode: 'CurrencyCode'
      @UI.lineItem: [{ position: 50, importance: #HIGH }]
      @EndUserText.label: 'Ticket Price'
      Flight.price                                as TicketPrice,

      @Semantics.currencyCode: true
      @EndUserText.label: 'Currency'
      Flight.currency_code                        as CurrencyCode,

      @Semantics.quantity.unitOfMeasure: 'SeatUnit'
      @EndUserText.label: 'Max Seating Capacity'
      @UI.lineItem: [{ position: 60, importance: #LOW }]
      cast(Flight.seats_max as abap.dec( 15, 2 )) as SeatsMax,

      @Semantics.unitOfMeasure: true
      @EndUserText.label: 'Seat Unit'
      @Consumption.valueHelpDefinition: [{ entity: { name: 'I_UnitOfMeasure', element: 'UnitOfMeasure' } }]
      cast('ST' as msehi)                         as SeatUnit,

      /* =======================================================================
         5. ASSOCIATIONS EXPOSURE
         =======================================================================
      */
      _Booking // Exposing the association to allow UI drilldown
}
