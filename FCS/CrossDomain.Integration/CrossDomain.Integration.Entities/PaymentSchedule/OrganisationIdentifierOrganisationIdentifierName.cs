namespace SFA.FCT.CrossDomain.Integration.Entities.PaymentSchedule
{
    using System.Diagnostics.CodeAnalysis;
    using System.Xml.Serialization;

    [SuppressMessage("ReSharper", "InconsistentNaming")]
    public enum OrganisationIdentifierOrganisationIdentifierName
    {
        UKPRN,

        [XmlEnum("PIMS ORG CODE")]
        PIMSORGCODE,

        [XmlEnum("REGISTERED CHARITY NUMBER ENGLAND AND WALES")]
        REGISTEREDCHARITYNUMBERENGLANDANDWALES,

        [XmlEnum("REGISTERED CHARITY NUMBER SCOTLAND")]
        REGISTEREDCHARITYNUMBERSCOTLAND,

        [XmlEnum("EDRS EMPLOYER NUMBER")]
        EDRSEMPLOYERNUMBER,

        [XmlEnum("HMRC EMPLOYER NUMBER")]
        HMRCEMPLOYERNUMBER,

        [XmlEnum("ORGANISATIONS FORMER FEFC CODE (FE ORGS ONLY)")]
        ORGANISATIONSFORMERFEFCCODEFEORGSONLY,

        [XmlEnum("LEA CODE")]
        LEACODE,

        [XmlEnum("DFE ESTABLISHMENT NUMBER")]
        DFEESTABLISHMENTNUMBER,

        [XmlEnum("DFE UNIQUE REFERENCE NUMBER")]
        DFEUNIQUEREFERENCENUMBER,

        [XmlEnum("LINKED URNS")]
        LINKEDURNS,

        [XmlEnum("OFSTED NON EDUBASE PROVIDER URN")]
        OFSTEDNONEDUBASEPROVIDERURN,

        [XmlEnum("LOCAL AUTHORITY CODE")]
        LOCALAUTHORITYCODE,

        [XmlEnum("LA AND SCHOOL ESTABLISHMENT CODE")]
        LAANDSCHOOLESTABLISHMENTCODE,

        [XmlEnum("DCFT ORGANISATION IDENTIFIER")]
        DCFTORGANISATIONIDENTIFIER,

        [XmlEnum("ISSUING AUTHORITY")]
        ISSUINGAUTHORITY,

        [XmlEnum("SECTOR LEAD BODY")]
        SECTORLEADBODY,

        [XmlEnum("OFQUAL RECOGNITION NUMBER")]
        OFQUALRECOGNITIONNUMBER,

        [XmlEnum("DENI NUMBER")]
        DENINUMBER,

        [XmlEnum("REGISTERED COMPANY NUMBER")]
        REGISTEREDCOMPANYNUMBER,
    }
}