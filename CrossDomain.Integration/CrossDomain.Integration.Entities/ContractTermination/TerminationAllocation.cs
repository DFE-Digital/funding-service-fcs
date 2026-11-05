namespace SFA.FCT.CrossDomain.Integration.Entities.ContractTermination
{
    using System;

    [System.Diagnostics.CodeAnalysis.ExcludeFromCodeCoverage]
    public class TerminationAllocation
    {
        public TerminationAllocation(string allocationNumber, string fundingStreamPeriodCode, DateTime? terminationDate)
        {
            AllocationNumber = allocationNumber;
            TerminationDate = terminationDate;
            FundingStreamPeriodCode = fundingStreamPeriodCode;
        }

        private TerminationAllocation()
        {
        }

        public string AllocationNumber { get; set; }

        public string FundingStreamPeriodCode { get; set; }

        public DateTime? TerminationDate { get; set; }

    }
}