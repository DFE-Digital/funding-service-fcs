namespace SFA.FCT.Contracts.AcceptanceTests.Infrastructure.DTO.Cfs
{
    using System;
    using CrossDomain.Integration.Entities.Xrm;

    public class CrmFundingAllocation
    {
        public CrmFundingAllocation(sfa_fundingallocation sfaFundingAllocation, string providerName, string fundingType, string periodName,
            string fspGroupName, string contractType, string holdReason, string releaseGroupName, DateTime? queuedOn, string queuedDueToContract)
        {
            SfaFundingAllocation = sfaFundingAllocation;
            ProviderName = providerName;
            FundingType = fundingType;
            PeriodName = periodName;
            FspGroupName = fspGroupName;
            ContractType = contractType;
            HoldReason = holdReason;
            ReleaseGroupName = releaseGroupName;
            QueuedOn = queuedOn;
            QueuedDueToContract = queuedDueToContract;
        }

        public sfa_fundingallocation SfaFundingAllocation { get; }

        public string ProviderName { get; }

        public string FundingType { get; }

        public string PeriodName { get; }
        public string FspGroupName { get; }
        public string ContractType { get; }
        public string HoldReason { get; }
        public string ReleaseGroupName { get; }
        public DateTime? QueuedOn { get; }
        public string QueuedDueToContract { get; }
    }
}
