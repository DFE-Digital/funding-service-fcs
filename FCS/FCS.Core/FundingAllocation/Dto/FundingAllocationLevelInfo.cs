namespace FundingAllocation.Dto
{
    using System;

    public class FundingAllocationLevelInfo
    {
        public FundingAllocationLevelInfo(string contractingUkprn, string allocationPeriod, string allocationFundingStreamCode)
        {
            ContractingUkprn = contractingUkprn;
            AllocationPeriod = allocationPeriod;
            AllocationFundingStreamCode = allocationFundingStreamCode;
        }
        public string ContractingUkprn { get; }
        public string AllocationPeriod { get; }
        public string AllocationFundingStreamCode { get; }

        public override string ToString()
        {
            return
                $"ContractingUkprn: {ContractingUkprn}, AllocationPeriod: {AllocationPeriod}, AllocationFundingStreamCode:{AllocationFundingStreamCode}";
        }

        public override bool Equals(object obj)
        {
            if (obj is FundingAllocationLevelInfo other)
            {
                return ContractingUkprn == other.ContractingUkprn &&
                       AllocationPeriod == other.AllocationPeriod &&
                       AllocationFundingStreamCode == other.AllocationFundingStreamCode;
            }

            return false;
        }

        public override int GetHashCode()
        {
            return HashCode.Combine(ContractingUkprn, AllocationPeriod, AllocationFundingStreamCode);
        }
    }
}
