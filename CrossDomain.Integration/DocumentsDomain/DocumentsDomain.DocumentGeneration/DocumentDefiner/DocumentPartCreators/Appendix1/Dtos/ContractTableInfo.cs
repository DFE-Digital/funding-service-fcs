namespace SFA.FCT.DocumentsDomain.DocumentGeneration.DocumentDefiner.DocumentPartCreators.Appendix1.Dtos
{
    using System;
    using System.Collections.Generic;
    using Common.Models;

    public class ContractTableInfo
    {
        public ContractTableInfo(List<RowType> allocationRowTypes, string fundingPeriod, string financialEnvelopePeriod1, string financialEnvelopePeriod2, DateTime startDate, decimal contractTotal)
        {
            AllocationRowTypes = allocationRowTypes;
            FundingPeriod = fundingPeriod;
            FinancialEnvelopePeriod1 = financialEnvelopePeriod1;
            FinancialEnvelopePeriod2 = financialEnvelopePeriod2;
            StartDate = startDate;
            ContractTotal = contractTotal;
        }

        public List<RowType> AllocationRowTypes { get; }

        public string FundingPeriod { get; }

        public string FinancialEnvelopePeriod1 { get; }

        public string FinancialEnvelopePeriod2 { get; }

        public DateTime StartDate { get; }

        public decimal ContractTotal { get; }
    }
}
