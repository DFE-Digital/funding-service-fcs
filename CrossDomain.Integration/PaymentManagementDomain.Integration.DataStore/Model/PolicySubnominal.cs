namespace SFA.FCT.PaymentManagementDomain.PolicyCache.DataStore.Model
{
    using System.Collections.Generic;
    using System.ComponentModel.DataAnnotations;
    using System.ComponentModel.DataAnnotations.Schema;

    public enum PaymentType
    {
        Profile = 0,
        Reconciliation = 1,
        Capping = 2
    }

    /// <summary>
    /// Entity reporesenting a Subnominal type
    /// </summary>
    public class PolicySubnominal
    {
        [Key, Column(Order = 0)]
        [Index("IX_PolicySubnominal", 1, IsUnique = true)]
        public int SubnominalCode { get; set; }

        [Key, Column(Order = 1)]
        [Index("IX_PolicySubnominal", 2, IsUnique = true)]
        public PaymentType PaymentType { get; set; }

        public string PaymentSubnominalDesc { get; set; }

        public ICollection<PolicyDeliverableToSubnominals> PolicyDelirablesToSubnominals { get; set; }
    }
}