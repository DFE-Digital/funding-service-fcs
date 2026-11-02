namespace FundingAllocation.Dto
{
    using System.Collections.Generic;
    using System.Linq;
    using DataStore.Model;

    public class ContractDeliverableInfo
    {
        public ContractDeliverableInfo(int deliverableCode, string deliverableName, int displayOrder, IReadOnlyCollection<FundingAllocationProfilePeriod> periods)
        {
            DeliverableCode = deliverableCode;
            DeliverableName = deliverableName;
            DisplayOrder = displayOrder;
            Periods = periods;
        }

        public int DeliverableCode { get; }

        public string DeliverableName { get; }

        public int DisplayOrder { get; }

        public IReadOnlyCollection<FundingAllocationProfilePeriod> Periods { get; }

        public decimal GetTotalPlannedValue() => Periods.Sum(p => p.PlannedValue);
    }
}