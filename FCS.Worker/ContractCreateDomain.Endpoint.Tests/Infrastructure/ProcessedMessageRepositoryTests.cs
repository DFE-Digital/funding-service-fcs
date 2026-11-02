namespace ContractCreateDomain.Endpoint.Tests.Infrastructure
{
    using System.Linq;
    using ContractManagement.DataStore;
    using Endpoint.Infrastructure;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using MoreLinq;
    using SFA.FCT.CrossDomain.Integration.Entities.Data;

    [TestClass]
    public class ProcessedMessageRepositoryTests
    {
        [TestMethod, TestCategory("IntegrationTest")]
        public void ProcessedMessageRepository_ShouldAdd()
        {
            // arrange
            const string messageId = "XXX";
            using (var context = new ContractManagementDbContext() )
            {
                context.ProcessedMessages.ForEach(pm => context.ProcessedMessages.Remove(pm));

                context.SaveChanges();
            }

            
            using (var context = new ContractManagementDbContext())
            {
                ProcessedMessageRepository repository = new ProcessedMessageRepository();
                
                // act
                repository.Add(messageId, new ConnectionInfo(null, context.Database.Connection));
            }

            // assert
            using (var context = new ContractManagementDbContext())
            {
                Assert.IsTrue(context.ProcessedMessages.Any(pm => pm.MessageId == messageId));
            }
        }
    }
}
