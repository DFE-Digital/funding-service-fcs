namespace SFA.FCT.CrossDomain.Integration.Entities.PerformanceManagement.FundingClaimReconciliation.Infos
{
    using System;
    using System.Collections.Generic;
    using System.Linq;

    public class ContractInfo
    {
        public ContractInfo()
        {
        }

        public ContractInfo(IList<AllocationInfo> allocationInfos, string contractNumber, int contractVersion)
        {
            if (!allocationInfos.Any())
            {
                throw new ArgumentException("There must be at least one allocation");
            }
            
            AllocationInfos = allocationInfos;
            ContractNumber = contractNumber;
            ContractVersion = contractVersion;
        }

        public string ContractNumber { get; set; }

        public int ContractVersion { get; set; }

        public IList<AllocationInfo> AllocationInfos { get; set; } 

        public AllocationInfo FindAllocationInfo(string allocationNumber)
        {
            return AllocationInfos.Single(a => a.AllocationNumber == allocationNumber);
        }

        public override string ToString()
        {
            return $"ContractNumber: {ContractNumber}, ContractVersion: {ContractVersion}";
        }
    }
}
