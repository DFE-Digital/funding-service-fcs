namespace SFA.FCT.PaymentManagementDomain.PaymentSchedule.DataStore.Model
{
    using System.ComponentModel.DataAnnotations;
    using System.ComponentModel.DataAnnotations.Schema;
    using System;

    public enum OrganisationIdentifierName
    {
        UKPRN,
        PIMSORGCODE,
        REGISTEREDCHARITYNUMBERENGLANDANDWALES,
        REGISTEREDCHARITYNUMBERSCOTLAND,
        EDRSEMPLOYERNUMBER,
        HMRCEMPLOYERNUMBER,
        ORGANISATIONSFORMERFEFCCODEFEORGSONLY,
        LEACODE,
        DFEESTABLISHMENTNUMBER,
        DFEUNIQUEREFERENCENUMBER,
        LINKEDURNS,
        OFSTEDNONEDUBASEPROVIDERURN,
        LOCALAUTHORITYCODE,
        LAANDSCHOOLESTABLISHMENTCODE,
        DCFTORGANISATIONIDENTIFIER,
        ISSUINGAUTHORITY,
        SECTORLEADBODY,
        OFQUALRECOGNITIONNUMBER,
        DENINUMBER,
        REGISTEREDCOMPANYNUMBER,
    }

    public class OrganisationIdentifer
    {
        [Key, Column(Order = 0)]
        public string AllocationNumber { get; set; }

        [Key, Column(Order = 1)]
        public int VersionNumber { get; set; }

        [Key, Column(Order = 2)]
        public string MainOrganisationIdentifier { get; set; }

        [Key, Column(Order = 3)]
        public string OrganisationId { get; set; }

        public OrganisationIdentifierName OrganisationIdentifierName { get; set; }

        //[Column(TypeName = "datetime2")]
        public DateTime? LastModifiedDate { get; set; }

    }
}