namespace PaymentGenerationDomain.Integration.DataStore.Tests
{
    using System.Threading.Tasks;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using PaymentGenerationDomain.Integration.DataStore.Repositories;
    using SFA.FCT.CrossDomain.Integration.Entities.CorporatePaymentGeneration;

    [TestClass]
    public class PaymentBatchFeedItemRepositoryTechnicalExplorationTests
    {
        [TestMethod, TestCategory("TechnicalExploration")]
        public async Task PaymentBatchFeedItemRepository_GetPaymentPeriod_ShouldReturnPaymentPeriod()
        {
            using (var context = new PaymentGenerationDbContext())
            {
                PaymentBatchFeedItemRepository repository = new PaymentBatchFeedItemRepository(new LocalConfig());

                // act
                PaymentPeriod paymentPeriod = await repository.GetPaymentPeriod(22);

                // assert
                Assert.IsNotNull(paymentPeriod, "The payment period is not null");
            }
        }
    }
}
