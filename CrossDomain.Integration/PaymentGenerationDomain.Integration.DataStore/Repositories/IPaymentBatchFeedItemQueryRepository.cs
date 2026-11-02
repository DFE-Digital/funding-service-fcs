namespace PaymentGenerationDomain.Integration.DataStore.Repositories
{
    using System.Threading.Tasks;
    using SFA.FCT.CrossDomain.Integration.Entities.CorporatePaymentGeneration;

    public interface IPaymentBatchFeedItemQueryRepository
    {
        Task<PaymentPeriod> GetPaymentPeriod(int paymentBatchFeedItemId);
    }
}
