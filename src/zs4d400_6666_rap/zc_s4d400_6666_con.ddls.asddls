@Metadata.allowExtensions: true
@Metadata.ignorePropagatedAnnotations: true
@Endusertext: {
  Label: '###GENERATED Core Data Service Entity'
}
@Objectmodel: {
  Sapobjectnodetype.Name: 'ZS4D400_6666_CON'
}
@AccessControl.authorizationCheck: #MANDATORY
define root view entity ZC_S4D400_6666_CON
  provider contract TRANSACTIONAL_QUERY
  as projection on ZR_S4D400_6666_CON
  association [1..1] to ZR_S4D400_6666_CON as _BaseEntity on $projection.UUID = _BaseEntity.UUID
{
  key UUID,
  CarrierID,
  ConnectionID,
  FlightDate,
  AirportFromID,
  CityFrom,
  CountryFrom,
  AirportToID,
  CityTo,
  CountryTo,
  @Semantics: {
    User.Createdby: true
  }
  LocalCreatedBy,
  @Semantics: {
    Systemdatetime.Createdat: true
  }
  LocalCreatedAt,
  @Semantics: {
    User.Localinstancelastchangedby: true
  }
  LocalLastChangedBy,
  @Semantics: {
    Systemdatetime.Localinstancelastchangedat: true
  }
  LocalLastChangedAt,
  @Semantics: {
    Systemdatetime.Lastchangedat: true
  }
  LastChangedAt,
  _BaseEntity
}
