namespace SFA.FCT.CrossDomain.Integration.Entities.PaymentSchedule
{
    using System.Collections.Generic;
    using System.Diagnostics.CodeAnalysis;
    using System.Xml.Serialization;

    [SuppressMessage("ReSharper", "InconsistentNaming")]
    public class Allocation
    {
        public Allocation()
        {
            Organisation = new Organisation();
            ProvisionIdentifiers = new List<ProvisionIdentifier>();
            AllocationDeliverables = new List<AllocationDeliverable>();
            schemaVersion = 1.01m;
        }

        public string AllocationNumber { get; set; }

        public int VersionNumber { get; set; }

        public string FundingStreamPeriodCode { get; set; }

        public string ContractNumber { get; set; }

        public int ContractVersionNumber { get; set; }

        [XmlArrayItem("AllocationDeliverable", IsNullable = false)]
        public List<AllocationDeliverable> AllocationDeliverables { get; set; }

        [XmlArrayItem("ProvisionIdentifier", IsNullable = false)]
        public List<ProvisionIdentifier> ProvisionIdentifiers { get; set; }

        public Organisation Organisation { get; set; }

        public decimal schemaVersion { get; set; }

        public override string ToString()
        {
            return $"Allocation Number: {AllocationNumber} Version: {VersionNumber}";
        }
    }
}
