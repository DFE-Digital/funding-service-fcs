namespace FCT.Operations.Maintenance.Endpoint.Tests.Services
{
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using SFA.FCT.Operations.Maintenance.Endpoint.Services;

    [TestClass]
    public class AzureServiceBusQueueServiceTests
    {
        [TestMethod, TestCategory("TechnicalExploration")]
        public void AzureServiceBusQueueService_GetQueueSizeInBytes()
        {
            AzureServiceBusQueueService queueService = new AzureServiceBusQueueService(new LocalConfig());
            var size = queueService.GetQueueSizeInBytes("Audit").Result;

            Assert.IsTrue(size > 0);
        }

        [TestMethod, TestCategory("TechnicalExploration")]
        public void AzureServiceBusQueueService_DeleteMessagesFromQueue()
        {
            AzureServiceBusQueueService queueService = new AzureServiceBusQueueService(new LocalConfig());
            queueService.DeleteMessagesFromQueue("Audit", 10).Wait();
        }
    }
}
