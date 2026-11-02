namespace FundingAllocation.Tests.Repositories
{
    using System;
    using System.Data.SqlClient;
    using System.Linq;
    using DataStore;
    using DataStore.Model;
    using FluentAssertions;
    using FundingAllocation.Repositories;
    using Microsoft.EntityFrameworkCore;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Moq;
    using SFA.FCT.Framework.Logging.Interfaces;

    [TestClass]
    public class ProcessedMessageRepositoryTests
    {
        [TestMethod, TestCategory("IntegrationTest")]
        public void ProcessedMessageRepository_ShouldAddMessageToStorage()
        {
            string messageId = Guid.NewGuid().ToString();
            const string endpoint = "FundingAllocation.CreateFundingAllocationInCrm";
            const string messageType = "CreateFundingAllocationInCrmCommand";
            const string businessKey = "1619-AY-2021-Contract-Provider-10017057-2_0";

            // arrange
            var connectionString = AppConfiguration.Configuration()["ConnectionStrings:NServiceBus/Persistence"];
            var options = new DbContextOptionsBuilder<FundingAllocationContext>()
                .UseSqlServer(new SqlConnection(connectionString))
                .Options;

            using var arrangeContext = new FundingAllocationContext(options);

            arrangeContext.Database.ExecuteSqlRaw("DELETE FROM FundingAllocation.ProcessedMessage");

            var repository = new ProcessedMessageRepository(Mock.Of<ILogger>(), new FundingAllocationContext(options));

            // act
            repository.Deduplicate(messageId, endpoint, messageType, businessKey).Wait();

            // assert
            using var assertContext = new FundingAllocationContext(options);
            var storedEntity = assertContext.ProcessedMessages.SingleOrDefault(pm => pm.MessageId == messageId);

            storedEntity.Should().NotBeNull();
            storedEntity.MessageId.Should().Be(messageId);
            storedEntity.Endpoint.Should().Be(endpoint);
            storedEntity.MessageType.Should().Be(messageType);
            storedEntity.BusinessKey.Should().Be(businessKey);
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void ProcessedMessageRepository_ShouldThrowExceptionWhenEntityAlreadyPresentWithSameMessageId()
        {
            string messageId = Guid.NewGuid().ToString();
            const string endpoint = "FundingAllocation.CreateFundingAllocationInCrm";
            const string messageType = "CreateFundingAllocationInCrmCommand";
            const string businessKey = "1619-AY-2021-Contract-Provider-10017057-2_0";

            // arrange
            var connectionString = AppConfiguration.Configuration()["ConnectionStrings:NServiceBus/Persistence"];
            var options = new DbContextOptionsBuilder<FundingAllocationContext>()
                .UseSqlServer(new SqlConnection(connectionString))
                .Options;

            using var arrangeContext = new FundingAllocationContext(options);

            arrangeContext.Database.ExecuteSqlRaw("DELETE FROM FundingAllocation.ProcessedMessage");
            arrangeContext.ProcessedMessages.Add(new ProcessedMessage(messageId, "A", "B", "C"));
            arrangeContext.SaveChanges();

            var repository = new ProcessedMessageRepository(Mock.Of<ILogger>(), new FundingAllocationContext(options));

            // act
            Action act = () => repository.Deduplicate(messageId, endpoint, messageType, businessKey).Wait();

            // assert
            act.Should().Throw<InvalidOperationException>();
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void ProcessedMessageRepository_ShouldThrowExceptionWhenEntityAlreadyPresentWithSameBusinessKey()
        {
            string messageId = Guid.NewGuid().ToString();
            const string endpoint = "FundingAllocation.CreateFundingAllocationInCrm";
            const string messageType = "CreateFundingAllocationInCrmCommand";
            const string businessKey = "1619-AY-2021-Contract-Provider-10017057-2_0";

            // arrange
            var connectionString = AppConfiguration.Configuration()["ConnectionStrings:NServiceBus/Persistence"];
            var options = new DbContextOptionsBuilder<FundingAllocationContext>()
                .UseSqlServer(new SqlConnection(connectionString))
                .Options;

            using var arrangeContext = new FundingAllocationContext(options);

            arrangeContext.Database.ExecuteSqlRaw("DELETE FROM FundingAllocation.ProcessedMessage");
            arrangeContext.ProcessedMessages.Add(new ProcessedMessage(
                Guid.NewGuid().ToString(), endpoint, messageType, businessKey));
            arrangeContext.SaveChanges();

            var repository = new ProcessedMessageRepository(Mock.Of<ILogger>(), new FundingAllocationContext(options));

            // act
            Action act = () => repository.Deduplicate(messageId, endpoint, messageType, businessKey).Wait();

            // assert
            act.Should().Throw<InvalidOperationException>();
        }
    }
}
