namespace SFA.FCT.DocumentsDomain.Integration.DocumentGenEndpoint.Tests.Integration
{
    using System.Collections.Generic;
    using System.Linq;
    using CrossDomain.Integration.Entities.Data;
    using DataStore;
    using DataStore.Models;
    using DataStore.Repositories;
    using Microsoft.VisualStudio.TestTools.UnitTesting;

    [TestClass]
    public class ProcessedMessageRepositoryTests
    {
        [TestMethod, TestCategory("IntegrationTest")]
        public void ProcessedMessageRepository_ShouldAdd()
        {
            // arrange
            const string messageId = "Id";
            const string processingEndpoint = "PE";
            RemoveAllRows();

            bool isAdded = false;
            using (var context = new DocumentsDomainDbContext())
            {
                ProcessedMessageRepository repository = new ProcessedMessageRepository();

                // act
                isAdded = repository.Add(messageId, processingEndpoint, ConnectionInfo.CreateFrom(context.Database.Connection));
            }

            // assert
            Assert.IsTrue(isAdded, "The Add method should have returned a true");
            var messageInTable = GetProcessedMessages();
            Assert.AreEqual(1, messageInTable.Count, "The number of rows in the table is incorrect");
            Assert.AreEqual(messageId, messageInTable.First().MessageId, "The messageId in the table is incorrect");
            Assert.AreEqual(processingEndpoint, messageInTable.First().ProcessingEndpoint, "The ProcessingEndpoint in the table is incorrect");
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void ProcessedMessageRepository_ShouldNotAddIfMessageAlreadyPresent()
        {
            // arrange
            const string messageId = "Id";
            const string processingEndpoint = "PE";
            RemoveAllRows();

            using (var context = new DocumentsDomainDbContext())
            {
                ProcessedMessageRepository repository = new ProcessedMessageRepository();

                repository.Add(messageId, processingEndpoint, ConnectionInfo.CreateFrom(context.Database.Connection));
            }

            bool isAdded = false;
            using (var context = new DocumentsDomainDbContext())
            {
                ProcessedMessageRepository repository = new ProcessedMessageRepository();

                // act
                isAdded = repository.Add(messageId, processingEndpoint, ConnectionInfo.CreateFrom(context.Database.Connection));
            }

            // assert
            Assert.IsFalse(isAdded, "The Add method should have returned a false");
        }

        private void RemoveAllRows()
        {
            using (var context = new DocumentsDomainDbContext())
            {
                context.ProcessedMessages.ToList()
                    .ForEach(p => context.ProcessedMessages.Remove(p));

                context.SaveChanges();
            }
        }

        private IReadOnlyCollection<ProcessedMessage> GetProcessedMessages()
        {
            using (var context = new DocumentsDomainDbContext())
            {
                return context.ProcessedMessages.ToList();
            }
        }
    }
}
