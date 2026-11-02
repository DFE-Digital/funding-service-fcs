namespace SFA.FCT.PerformanceManagementDomain.DataStore.Models
{
    using System;
    using System.ComponentModel.DataAnnotations;
    using System.ComponentModel.DataAnnotations.Schema;

    public class FundingClaimDeliverable
    {
        private FundingClaimDeliverable()
        {
        }

        public FundingClaimDeliverable(Guid contractAllocationId, int deliverableCode, 
                                       decimal actualValue, decimal forecastValue, 
                                       decimal adjustmentValue, decimal? totalDelivery)
        {
            ContractAllocationId = contractAllocationId;
            DeliverableCode = deliverableCode;
            ActualValue = actualValue;
            ForecastValue = forecastValue;
            AdjustmentValue = adjustmentValue;
            TotalDelivery = totalDelivery;
        }

        [Key, Column(Order = 1)]
        public Guid ContractAllocationId { get; private set; }

        [ForeignKey("ContractAllocationId")]
        public virtual FundingClaimContractAllocation ContractAllocation{ get; set; }

        [Key, Column(Order = 2)]
        public int DeliverableCode { get; private set; }

        [Required]
        public decimal ActualValue { get; set; }

        [Required]
        public decimal ForecastValue { get; set; }

        [Required]
        public decimal AdjustmentValue { get; set; }

        public decimal? TotalDelivery { get; set; }
    }
}
