using System.Collections.Generic;

namespace SFA.FCT.PaymentManagementDomain.PolicyCache.DataStore.Model
{
    using System.ComponentModel.DataAnnotations;
    using System.ComponentModel.DataAnnotations.Schema;

    public class CappingGroup
    {
        [Key, Column(Order = 0)]
        [Index("IX_CappingGroupIndex", 1, IsUnique = true)]
        [DatabaseGenerated(DatabaseGeneratedOption.None)]
        public int FundingStreamPeriodCappingGroupId { get; set; }
        
        [Column(Order = 1), Index("IX_FundingStreamPeriodCappingGroupNameIndex", 1, IsUnique = true)]
        public string FundingStreamPeriod { get; set; }

        [Column(Order = 2), Index("IX_FundingStreamPeriodCappingGroupNameIndex", 2, IsUnique = true)]
        public string CappingGroupName { get; set; }

        public bool AllowUnderDeliveryToBeReUsed { get; set; }

        public bool AllowOverDeliveryToBeOffset { get; set; }

        public PolicyFundingStreamPeriod FundingStreamPeriods { get; set; }

        public ICollection<PolicyDeliverable> Deliverables { get; set; }

    }
}
