namespace SFA.FCT.Contracts.AcceptanceTests.Infrastructure.Repositories
{
    using System.Data.Entity;
    using System.Linq;
    using DTO;
    using Extensions;
    using PaymentGenerationDomain.Integration.DataStore;
    using PaymentGenerationDomain.Integration.DataStore.Model;   

    public static class PaymentBatchFeedRepository
    {
        public static PaymentBatchFeedItem GetFeedItemByNaturalKey(PaymentBatchFeedNaturalKey key)
        {
            using (var context = new PaymentGenerationDbContext())
            {
                return context.PaymentBatchFeedItems.SingleOrDefault(fi =>
                    fi.FundingStreamPeriod == key.FundingStreamPeriod
                    && fi.PaymentPeriod == key.PaymentPeriod
                    && DbFunctions.TruncateTime(fi.CensusEndDate) == key.CensusEndDate.Date
                    && fi.LinkCodeSuffix == key.LinkCodeSuffix);
            }
        }

        public static void DeleteItemByNaturalKey(PaymentBatchFeedNaturalKey key)
        {
            using (var context = new PaymentGenerationDbContext())
            {
                context.PaymentBatchFeedItems.RemoveWhere(fi =>
                    fi.FundingStreamPeriod == key.FundingStreamPeriod
                    && fi.PaymentPeriod == key.PaymentPeriod
                    && DbFunctions.TruncateTime(fi.CensusEndDate) == key.CensusEndDate.Date
                    && fi.LinkCodeSuffix == key.LinkCodeSuffix);
                context.SaveChanges();
            }
        }
    }
}