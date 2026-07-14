@AbapCatalog.sqlViewName: 'ZS_DB_AIRPORT'
@AbapCatalog.compiler.compareFilter: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Value help for airport ID'
@Metadata.ignorePropagatedAnnotations: true
define view ZS_6666_I_AIRPORT_VH
  as select from /dmo/airport
{
      @UI.lineItem: [{ position: 10 , importance: #HIGH }]
  key airport_id as AirportId,
      @UI.lineItem: [{ position: 20 , importance: #HIGH }]
      name       as Name,
      @UI.lineItem: [{ position: 40 , importance: #MEDIUM }]
      city       as City,
      @UI.lineItem: [{ position: 30 , importance: #MEDIUM }]
      @UI.selectionField:[{ position: 30  }]
      country    as Country
}
