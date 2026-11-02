namespace SFA.FCT.DocumentsDomain.DocumentGeneration.DocumentDefiner.DocumentConfiguration
{
    using System;
    using System.Collections.Concurrent;
    using DataStore.Models;

    public static class DocumentConfigurationCache
    {
        private static readonly ConcurrentDictionary<FspDeliverableKey, FSPDeliverable> FspDeliverableCache = new ConcurrentDictionary<FspDeliverableKey, FSPDeliverable>();
        private static readonly ConcurrentDictionary<string, DataStore.Models.FundingStreamPeriod> FspCache = new ConcurrentDictionary<string, DataStore.Models.FundingStreamPeriod>();

        public static DataStore.Models.FundingStreamPeriod GetFundingStreamPeriod(string fspCode, Func<string, DataStore.Models.FundingStreamPeriod> getFundingStreamPeriod)
        {
            return FspCache.GetOrAdd(fspCode, getFundingStreamPeriod);
        }

        public static FSPDeliverable GetFspDeliverable(FspDeliverableKey fspDeliverableKey, Func<FspDeliverableKey, FSPDeliverable> getFspDeliverable)
        {
            return FspDeliverableCache.GetOrAdd(fspDeliverableKey, getFspDeliverable);
        }
    }

    public class FspDeliverableKey
    {
        public FspDeliverableKey(string fundingStreamPeriodCode, int deliverableCode)
        {
            FundingStreamPeriodCode = fundingStreamPeriodCode;
            DeliverableCode = deliverableCode;
        }

        public string FundingStreamPeriodCode { get; }

        public int DeliverableCode { get; }

        protected bool Equals(FspDeliverableKey other)
        {
            return string.Equals(FundingStreamPeriodCode, other.FundingStreamPeriodCode) && DeliverableCode == other.DeliverableCode;
        }

        public override bool Equals(object obj)
        {
            if (ReferenceEquals(null, obj)) return false;
            if (ReferenceEquals(this, obj)) return true;
            if (obj.GetType() != this.GetType()) return false;
            return Equals((FspDeliverableKey) obj);
        }

        public override int GetHashCode()
        {
            unchecked
            {
                return ((FundingStreamPeriodCode != null ? FundingStreamPeriodCode.GetHashCode() : 0) * 397) ^ DeliverableCode;
            }
        }
    }
}