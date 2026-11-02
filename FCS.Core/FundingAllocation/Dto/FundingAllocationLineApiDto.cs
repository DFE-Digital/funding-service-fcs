namespace FundingAllocation.Dto
{
    using Extensions;

    public class FundingAllocationLineApiDto
    {
        public string FundingLineCode { get; set; }

        public string Value { get; set; }

        public string Type { get; set; }

        public FundingAllocationProfilePeriodApiDto[] FundingAllocationProfilePeriods { get; set; }

        public bool IsValid()
        {
            return Type == "Payment" && Value.HasValue();
        }
    }
}
