namespace FCT.Operations.Cda.Tests.Repositories
{
    using System;
    using System.Linq;
    using Cda.Repositories;
    using FluentAssertions;
    using global::Operations.DataStore;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using ReportGeneration;
    using SFA.FCT.CrossDomain.Integration.Entities.Data;

    [TestClass]
    public class ProcessedMessageRepositoryTests
    {
        [TestMethod, TestCategory("IntegrationTest")]
        public void ProcessedMessageRepository_ShouldAdd()
        {
            // arrange
            ClearDown();
            var messageId = Guid.NewGuid().ToString();
            ProcessedMessageRepository repository = new ProcessedMessageRepository();
            // act
            using (var context = new OperationsDbContext())
            {
                repository.Add(messageId, EndpointConfig.EndpointName,
                    new ConnectionInfo(null, context.Database.Connection));
            }

            // assert
            using (var context = new OperationsDbContext())
            {
                var message = context.ProcessedMessages.SingleOrDefault(pm => pm.MessageId == messageId);
                Assert.AreEqual(messageId, message?.MessageId);
            }
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void ProcessedMessageRepository_Add_ShouldReturnFalseIfRowAlreadyExists()
        {
            // arrange
            ClearDown();
            var messageId = Guid.NewGuid().ToString();
            ProcessedMessageRepository repository = new ProcessedMessageRepository();
            using (var context = new OperationsDbContext())
            {
                repository.Add(messageId, EndpointConfig.EndpointName,
                    new ConnectionInfo(null, context.Database.Connection));
            }
            // act
            using (var context = new OperationsDbContext())
            {
                bool hasAddSucceeded = repository.Add(messageId, EndpointConfig.EndpointName,
                    new ConnectionInfo(null, context.Database.Connection));

                // assert
                hasAddSucceeded.Should().BeFalse();
            }
        }

        private void ClearDown()
        {
            using (var context = new OperationsDbContext())
            {
                context.ProcessedMessages.ToList().ForEach(pm => context.ProcessedMessages.Remove(pm));
                
                context.SaveChanges();
            }
        }
    }
}
