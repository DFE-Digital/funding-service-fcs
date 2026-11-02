namespace FundingAllocation.Tests.Endpoints.ReleaseGroup.Services
{
    using System;
    using System.Collections.Generic;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Moq;
    using SFA.FCT.Framework.Logging.Interfaces;
    using FundingAllocation.Slack;
    using FundingAllocation.Endpoints.ReleaseGroup.Services;
    using FundingAllocation.Endpoints.ReleaseGroup.Repositories;
    using DataStore;
    using Microsoft.EntityFrameworkCore;
    using System.Data.SqlClient;

    [TestClass]
    public class NotificationServiceTests
    {
        [TestMethod, TestCategory("TechnicalExploration")]
        public void NotificationService_ReleaseOfReleaseGroupsPreventedDueToBulkImportBeingInProgress_ShouldSendSlackMessage()
        {
            // arrange 
            const string releaseGroupName1 = "rg_1";
            const string releaseGroupName2 = "rg_2";

            ClearDownReleaseGroups();
            AddReleaseGroup(releaseGroupName1, "ftc_1", "ftp_1");
            AddReleaseGroup(releaseGroupName2, "ftc_2", "ftp_2");
            var releaseGroupNames = new List<string> { releaseGroupName1, releaseGroupName2 };

            var appConfigurationRoot = AppConfiguration.Configuration();

            var service = new SlackNotificationService(
                new SlackMessageSender(appConfigurationRoot),
                Mock.Of<ILogger>(),
                appConfigurationRoot,
                new ReleaseGroupRepository(new FundingAllocationContext(GetContextOptions())));

            // act assert
            service.ReleaseOfReleaseGroupsPreventedDueToBulkImportBeingInProgress(releaseGroupNames).Wait();
        }

        private static void ClearDownReleaseGroups()
        {
            using var context = new FundingAllocationContext(GetContextOptions());
            context.Database.ExecuteSqlRaw($"DELETE FROM FundingAllocation.ReleaseGroup");
        }

        private static void AddReleaseGroup(
            string releaseGroupName,
            string fundingTypeCode,
            string fundingPeriodName)
        {
            const string fspGroupCode = "fgc";
            const string contractType = "ct";

            var connectionString = AppConfiguration.Configuration()["ConnectionStrings:NServiceBus/Persistence"];
            var options = new DbContextOptionsBuilder<FundingAllocationContext>()
                .UseSqlServer(new SqlConnection(connectionString))
                .Options;

            using var context = new FundingAllocationContext(options);

            var releaseGroup = new DataStore.Model.ReleaseGroup(fundingTypeCode,
                fundingPeriodName,
                fspGroupCode,
                contractType,
                Guid.NewGuid(),
                releaseGroupName);

            context.ReleaseGroups.Add(releaseGroup);
            context.SaveChanges();
        }

        private static DbContextOptions<FundingAllocationContext> GetContextOptions()
        {
            var connectionString = AppConfiguration.Configuration()["ConnectionStrings:NServiceBus/Persistence"];

            return new DbContextOptionsBuilder<FundingAllocationContext>()
                .UseSqlServer(new Microsoft.Data.SqlClient.SqlConnection(connectionString))
                .Options;
        }
    }
}