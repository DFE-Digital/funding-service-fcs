namespace PaymentGenerationDomain.Integration.DataStore.Repositories
{
    using System.Threading.Tasks;
    using PaymentGenerationDomain.Integration.DataStore.Model;
    using SFA.FCT.CrossDomain.Integration.Entities.Data;

    public interface IPaymentBatchFeedItemCommandRepository
    {
        Task<PaymentBatchFeedItemAddResult> AddItem(PaymentBatchFeedItem paymentBatchFeedItem, ConnectionInfo connectionInfo);
    }
}