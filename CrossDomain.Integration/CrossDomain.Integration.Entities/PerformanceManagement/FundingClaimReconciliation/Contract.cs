namespace SFA.FCT.CrossDomain.Integration.Entities.PerformanceManagement.FundingClaimReconciliation
{
    using System;

    [System.Diagnostics.CodeAnalysis.ExcludeFromCodeCoverage]
    public class Contract
    {
        public Contract()
        {
            FundingType = new FundingType();
        }

        public string ContractNumber { get; set; }

        public int ContractVersionNumber { get; set; }

        public int ContractSubVersionNumber { get; set; }

        public FundingType FundingType { get; set; }

        public DateTime? ContractApprovalDate { get; set; }
    }
}