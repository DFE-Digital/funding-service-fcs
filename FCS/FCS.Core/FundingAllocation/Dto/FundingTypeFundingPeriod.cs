namespace FundingAllocation.Dto
{
    using System;

    public class FundingTypeFundingPeriod
    {
        public FundingTypeFundingPeriod(string fundingType, string fundingPeriod)
        {
            FundingType = fundingType;
            FundingPeriod = fundingPeriod;
        }

        public string FundingType { get; }

        public string FundingPeriod { get; }

        protected bool Equals(FundingTypeFundingPeriod other)
        {
            return FundingType == other.FundingType &&
                   FundingPeriod == other.FundingPeriod;
        }

        public override bool Equals(object obj)
        {
            if (ReferenceEquals(null, obj)) return false;
            if (ReferenceEquals(this, obj)) return true;
            if (obj.GetType() != this.GetType()) return false;

            return Equals((FundingTypeFundingPeriod)obj);
        }

        public override int GetHashCode()
        {
            return HashCode.Combine(
                FundingType,
                FundingPeriod);
        }

        public override string ToString() => $"(FundingType: {FundingType}, FundingPeriod: {FundingPeriod})";
    }
}