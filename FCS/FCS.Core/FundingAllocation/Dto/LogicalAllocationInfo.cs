namespace FundingAllocation.Dto
{
    using System;
    public class LogicalAllocationInfo
    {
        public LogicalAllocationInfo(string fspCode, int ukprn)
        {
            FspCode = fspCode;
            Ukprn = ukprn;
        }

        public string FspCode { get; }
        public int Ukprn { get; }

        protected bool Equals(LogicalAllocationInfo other)
        {
            return FspCode == other.FspCode &&
                   Ukprn == other.Ukprn;
        }

        public override bool Equals(object obj)
        {
            if (ReferenceEquals(null, obj)) return false;
            if (ReferenceEquals(this, obj)) return true;
            if (obj.GetType() != this.GetType()) return false;

            return Equals((LogicalAllocationInfo)obj);
        }

        public override int GetHashCode()
        {
            return HashCode.Combine(
                FspCode, Ukprn);
        }

        public override string ToString() => $"FspCode: {FspCode}, Ukprn: {Ukprn}";
    }
}
