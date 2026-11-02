namespace Operations.Web.Tests.Repositories
{

    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Operations.Web.Dtos;
    using Operations.Web.Services;
    using System.Collections.Generic;
    using Web.Repositories;

    [TestClass]
    public class AzureServiceBusQueueServiceRepositoryTests
    {
        [TestMethod, TestCategory("TechnicalExploration")]
        public void AzureServiceBusQueueService_FetchMessagesFromQueue()
        {
            AzureServiceBusQueueService queueService = new AzureServiceBusQueueService();
            queueService.FetchMessagesFromQueue("contractmanagementdomain.confirmpublicationtoprovider.error", 10).Wait();
        }

        [TestMethod, TestCategory("TechnicalExploration")]
        public void AzureServiceBusQueueService_ReRunFailedFetchMessagesFromQueue()
        {
            ErrorQueueContract errorQueueContract = new ErrorQueueContract();
            List<ErrorMessage> clist = new List<ErrorMessage>();
            ErrorMessage errorMessage = new ErrorMessage();
            errorMessage.MessageId = "88572501-8666-4fd6-94d9-b5ee8fc97449";
            errorMessage.MessageBody = "{'ContractNumber' : 'APPLEVY-489' , 'MasterContractNumber':'ESFA-489'}";
            clist.Add(errorMessage);
            errorQueueContract.lstContract = clist;
            errorQueueContract.QueueName = "contractmanagementdomain.confirmpublicationtoprovider";
            AzureServiceBusQueueService queueService = new AzureServiceBusQueueService();
            //queueService.ReRunFailedMessagesFromQueue(errorQueueContract).Wait();
        }




    }
}
