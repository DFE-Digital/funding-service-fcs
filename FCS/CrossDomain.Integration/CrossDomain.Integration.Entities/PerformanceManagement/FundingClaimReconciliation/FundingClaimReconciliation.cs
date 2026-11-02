namespace SFA.FCT.CrossDomain.Integration.Entities.PerformanceManagement.FundingClaimReconciliation
{
    using System;
    using System.Collections.Generic;
    using System.Linq;
    using Infos;

    public class FundingClaimReconciliation
    {
        public FundingClaimReconciliation()
        {
            Contractor = new Contractor();
            Period = new Period();
            ClaimType = new ClaimType();
            AllocationGroup = new AllocationGroup();
            Amounts = new AmountSummary();
            ContractAllocations = new List<ContractAllocation>();
        }

        public Contractor Contractor { get; set; }

        public Period Period { get; set; }

        public int ClaimVersionNumber { get; set; }

        public ClaimType ClaimType { get; set; }

        public AllocationGroup AllocationGroup { get; set; }

        public ReconciliationStatus Status { get; set; }

        public DateTime StatusLastUpdatedDate { get; set; }

        public AmountSummary Amounts { get; set; }

        public IList<ContractAllocation> ContractAllocations { get; set; }

        public ContractInfo ToContractInfo()
        {
            var allocationInfos = ContractAllocations.Select(a => new AllocationInfo(
                a.ContractAllocationNumber,
                a.Amounts.ReconciliationValue,
                a.AllocationStartDate,
                a.AllocationEndDate,
                a.FundingstreamPeriodCode)).ToList();
            var firstAllocation = ContractAllocations.First();
            return new ContractInfo(allocationInfos, firstAllocation.Contract.ContractNumber, firstAllocation.Contract.ContractVersionNumber);
        }

        public string GetClaimCollectionCode()
        {
            return $"{Period.PeriodYear}-{ClaimType.ClaimTypeName.Replace(" ", string.Empty)}";
        }

        public string GetFundingPeriod()
        {
            return Period.PeriodTypeCode + Period.PeriodYear;
        }
    }
}
