namespace SFA.FCT.Contracts.AcceptanceTests.Infrastructure.DTO
{
    using System;

    public class PaymentBatchFeedNaturalKey
    {
        public PaymentBatchFeedNaturalKey(string fundingStreamPeriod, string paymentPeriod, DateTime censusEndDate, string linkCodeSuffix)
        {
            FundingStreamPeriod = fundingStreamPeriod;
            PaymentPeriod = paymentPeriod;
            CensusEndDate = censusEndDate;
            LinkCodeSuffix = linkCodeSuffix;
        }

        public string FundingStreamPeriod { get; }

        public string PaymentPeriod { get; }

        public DateTime CensusEndDate { get; }

        public string LinkCodeSuffix { get; }

        protected bool Equals(PaymentBatchFeedNaturalKey other)
        {
            return string.Equals(FundingStreamPeriod, other.FundingStreamPeriod) && string.Equals(PaymentPeriod, other.PaymentPeriod) && CensusEndDate.Equals(other.CensusEndDate) && string.Equals(LinkCodeSuffix, other.LinkCodeSuffix);
        }

        public override bool Equals(object obj)
        {
            if (ReferenceEquals(null, obj)) return false;
            if (ReferenceEquals(this, obj)) return true;
            if (obj.GetType() != this.GetType()) return false;
            return Equals((PaymentBatchFeedNaturalKey) obj);
        }

        public override int GetHashCode()
        {
            unchecked
            {
                int hashCode = (FundingStreamPeriod != null ? FundingStreamPeriod.GetHashCode() : 0);
                hashCode = (hashCode * 397) ^ (PaymentPeriod != null ? PaymentPeriod.GetHashCode() : 0);
                hashCode = (hashCode * 397) ^ CensusEndDate.GetHashCode();
                hashCode = (hashCode * 397) ^ (LinkCodeSuffix != null ? LinkCodeSuffix.GetHashCode() : 0);
                return hashCode;
            }
        }

        public override string ToString()
        {
            return
                $"FSP: {FundingStreamPeriod}, PaymentPeriod: {PaymentPeriod}, CensusEndDate: {CensusEndDate:yyyy-MM-dd}, LinkCodeSuffix: {LinkCodeSuffix}";
        }
    }
}