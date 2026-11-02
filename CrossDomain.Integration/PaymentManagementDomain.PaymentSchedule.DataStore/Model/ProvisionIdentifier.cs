namespace SFA.FCT.PaymentManagementDomain.PaymentSchedule.DataStore.Model
{
    using System.ComponentModel.DataAnnotations;
    using System.ComponentModel.DataAnnotations.Schema;
    using System;

    public class ProvisionIdentifier
    {
        [Key, Column(Order = 0)]
        public string AllocationNumber { get; set; }

        [Key, Column(Order = 1)]
        public int VersionNumber { get; set; }

        [Key, Column(Order = 2)]
        public string ProvisionIdentifierCode { get; set; }

        public string ProvisionIdentifierName { get; set; }

        //[Column(TypeName = "datetime2")]
        public DateTime? LastModifiedDate { get; set; }

    }
}
