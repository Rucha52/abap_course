@AbapCatalog.sqlViewName: 'ZS_6666_CARRID'
@AbapCatalog.compiler.compareFilter: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Value help for carrier ID'
@Metadata.ignorePropagatedAnnotations: true
define view ZS_6666_i_carrier_vh
  as select from /dmo/carrier
{
      @UI.lineItem: [{ position: 10 , importance: #HIGH }]
  key carrier_id as CarrierID,
      @UI.lineItem: [{ position: 20 , importance: #HIGH }]
      name       as Name
}
