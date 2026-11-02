namespace PerformanceManagementDomain.Tests.PullFundingClaim.Handlers
{
    using System.Configuration;
    using System.Data.SqlClient;
    using System.Linq;
    using Castle.MicroKernel.Lifestyle;
    using Castle.MicroKernel.Registration;
    using Castle.Windsor;
    using Dapper;
    using Infrastructure;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Microsoft.WindowsAzure.Storage.Table;
    using Moq;
    using NServiceBus;
    using NServiceBus.Testing;
    using PerformanceManagementDomain.PullFundingClaim;
    using PerformanceManagementDomain.PullFundingClaim.Handlers;
    using SFA.FCT.CrossDomain.Integration.Common.Storage;
    using SFA.FCT.CrossDomain.Integration.Entities.Data;
    using SFA.FCT.CrossDomain.Integration.Messages.Commands;
    using SFA.FCT.Framework.Logging;
    using SFA.FCT.PerformanceManagementDomain.Common.Commands;

    [TestClass]
    public class PullPageForPeriodClaimTypeHandlerTests
    {
        [TestMethod, TestCategory("UnitTest")]
        public void PullPageForPeriodClaimTypeHandler_ShouldResolve()
        {
            // arrange
            IWindsorContainer container = new WindsorContainer()
                .Install(new WindsorInstaller(new LoggerFactory()))
                .Register(Component.For<PullPageForPeriodClaimTypeHandler>().LifestyleScoped());

            container.BeginScope();

            // act, assert
            container.Resolve<PullPageForPeriodClaimTypeHandler>();
        }

        [TestMethod, TestCategory("TechnicalExploration")]
        public void SldFundingClaimsPull_ShouldRunAllThreeHandlersTogetherSuccessfully()
        {
            // arrange
            using (var connection = new SqlConnection(ConfigurationManager.ConnectionStrings["PerformanceManagementDbContext"].ConnectionString))
            {
                connection.Execute("DELETE FROM PerformanceManagement.FundingClaimCollectionImportInfo");
                connection.Execute("DELETE FROM PerformanceManagement.FundingClaim");
            }

            var azureTableStore = new AzureTableStore();
            var stubTableName = $"FundingClaimApiStub{ConfigurationManager.AppSettings["StorageTableSuffix"]}";
            azureTableStore.DeleteAllRows<FundingClaimApiEntity>(stubTableName);
            azureTableStore.InsertOrReplace(stubTableName, new FundingClaimApiEntity
            {
                PartitionKey = "1718-YEAREND",
                RowKey = "00000001",
                Json = "{\"fundingClaimId\":null,\"organisationIdentifier\":\"ORG0017786\",\"ukprn\":\"10017786\",\"versionNumber\":1,\"claimTypeName\":\"YEAREND\",\"periodTypeCode\":\"AY\",\"period\":\"1718\",\"hasBeenSigned\":\"False\",\"contractAllocations\":[{\"contractAllocationNumber\":\"ALLC-786\",\"fundingStreamPeriodCode\":\"ALLBC1718\",\"maximumContractValue\":0.0,\"DeliverableCodes\":[{\"deliverableCodeValue\":13,\"actualVolume\":0,\"actualValue\":1786.49,\"forecastValue\":29.79,\"adjustmentValue\":18.32,\"totalDelivery\":1834.60},{\"deliverableCodeValue\":14,\"actualVolume\":0,\"actualValue\":1128.65,\"forecastValue\":58.62,\"adjustmentValue\":7.70,\"totalDelivery\":1194.97},{\"deliverableCodeValue\":15,\"actualVolume\":0,\"actualValue\":1345.39,\"forecastValue\":47.63,\"adjustmentValue\":20.36,\"totalDelivery\":1413.38},{\"deliverableCodeValue\":16,\"actualVolume\":0,\"actualValue\":3592.42,\"forecastValue\":68.51,\"adjustmentValue\":13.77,\"totalDelivery\":3674.70}]},{\"contractAllocationNumber\":\"16LR-786\",\"fundingStreamPeriodCode\":\"1619LR1718\",\"maximumContractValue\":0.0,\"DeliverableCodes\":[{\"deliverableCodeValue\":1001,\"actualVolume\":0,\"actualValue\":4066.65,\"forecastValue\":48.94,\"adjustmentValue\":13.57,\"totalDelivery\":4129.16},{\"deliverableCodeValue\":1002,\"actualVolume\":0,\"actualValue\":1264.36,\"forecastValue\":44.27,\"adjustmentValue\":18.89,\"totalDelivery\":1327.52},{\"deliverableCodeValue\":1003,\"actualVolume\":0,\"actualValue\":5547.02,\"forecastValue\":63.44,\"adjustmentValue\":5.45,\"totalDelivery\":5615.91},{\"deliverableCodeValue\":1004,\"actualVolume\":0,\"actualValue\":3602.64,\"forecastValue\":69.14,\"adjustmentValue\":13.60,\"totalDelivery\":3685.38},{\"deliverableCodeValue\":1005,\"actualVolume\":0,\"actualValue\":4309.23,\"forecastValue\":40.17,\"adjustmentValue\":15.27,\"totalDelivery\":4364.67}]}]}"
            });
            azureTableStore.InsertOrReplace(stubTableName, new FundingClaimApiEntity
            {
                PartitionKey = "1718-YEAREND",
                RowKey = "00000002",
                Json = "{\"fundingClaimId\":null,\"organisationIdentifier\":\"ORG0017787\",\"ukprn\":\"10017787\",\"versionNumber\":1,\"claimTypeName\":\"YEAREND\",\"periodTypeCode\":\"AY\",\"period\":\"1718\",\"hasBeenSigned\":\"False\",\"contractAllocations\":[{\"contractAllocationNumber\":\"16LR-787\",\"fundingStreamPeriodCode\":\"1619LR1718\",\"maximumContractValue\":0.0,\"DeliverableCodes\":[{\"deliverableCodeValue\":1001,\"actualVolume\":0,\"actualValue\":4066.65,\"forecastValue\":48.94,\"adjustmentValue\":13.57,\"totalDelivery\":4129.16},{\"deliverableCodeValue\":1002,\"actualVolume\":0,\"actualValue\":1264.36,\"forecastValue\":44.27,\"adjustmentValue\":18.89,\"totalDelivery\":1327.52},{\"deliverableCodeValue\":1003,\"actualVolume\":0,\"actualValue\":5547.02,\"forecastValue\":63.44,\"adjustmentValue\":5.45,\"totalDelivery\":5615.91},{\"deliverableCodeValue\":1004,\"actualVolume\":0,\"actualValue\":3602.64,\"forecastValue\":69.14,\"adjustmentValue\":13.60,\"totalDelivery\":3685.38},{\"deliverableCodeValue\":1005,\"actualVolume\":0,\"actualValue\":4309.23,\"forecastValue\":40.17,\"adjustmentValue\":15.27,\"totalDelivery\":4364.67},{\"deliverableCodeValue\":1006,\"actualVolume\":0,\"actualValue\":3180.64,\"forecastValue\":29.74,\"adjustmentValue\":13.10,\"totalDelivery\":3223.48},{\"deliverableCodeValue\":1007,\"actualVolume\":0,\"actualValue\":2166.09,\"forecastValue\":8.89,\"adjustmentValue\":9.87,\"totalDelivery\":2184.85},{\"deliverableCodeValue\":1008,\"actualVolume\":0,\"actualValue\":5890.16,\"forecastValue\":9.26,\"adjustmentValue\":12.80,\"totalDelivery\":5912.22},{\"deliverableCodeValue\":1009,\"actualVolume\":0,\"actualValue\":2666.22,\"forecastValue\":39.29,\"adjustmentValue\":8.11,\"totalDelivery\":2713.62},{\"deliverableCodeValue\":1010,\"actualVolume\":0,\"actualValue\":3240.91,\"forecastValue\":23.01,\"adjustmentValue\":17.58,\"totalDelivery\":3281.50},{\"deliverableCodeValue\":1011,\"actualVolume\":0,\"actualValue\":3595.87,\"forecastValue\":15.94,\"adjustmentValue\":23.78,\"totalDelivery\":3635.59},{\"deliverableCodeValue\":1012,\"actualVolume\":0,\"actualValue\":4186.12,\"forecastValue\":40.43,\"adjustmentValue\":12.81,\"totalDelivery\":4239.36},{\"deliverableCodeValue\":1013,\"actualVolume\":0,\"actualValue\":1313.72,\"forecastValue\":59.88,\"adjustmentValue\":14.19,\"totalDelivery\":1387.79},{\"deliverableCodeValue\":1014,\"actualVolume\":0,\"actualValue\":4706.87,\"forecastValue\":46.73,\"adjustmentValue\":21.66,\"totalDelivery\":4775.26},{\"deliverableCodeValue\":1015,\"actualVolume\":0,\"actualValue\":848.48,\"forecastValue\":19.72,\"adjustmentValue\":6.47,\"totalDelivery\":874.67},{\"deliverableCodeValue\":1016,\"actualVolume\":0,\"actualValue\":1303.62,\"forecastValue\":28.22,\"adjustmentValue\":7.56,\"totalDelivery\":1339.40},{\"deliverableCodeValue\":1017,\"actualVolume\":0,\"actualValue\":751.26,\"forecastValue\":42.58,\"adjustmentValue\":18.14,\"totalDelivery\":811.98},{\"deliverableCodeValue\":1018,\"actualVolume\":0,\"actualValue\":3606.07,\"forecastValue\":62.92,\"adjustmentValue\":6.63,\"totalDelivery\":3675.62},{\"deliverableCodeValue\":1019,\"actualVolume\":0,\"actualValue\":1757.59,\"forecastValue\":52.53,\"adjustmentValue\":14.08,\"totalDelivery\":1824.20},{\"deliverableCodeValue\":1020,\"actualVolume\":0,\"actualValue\":2624.37,\"forecastValue\":15.50,\"adjustmentValue\":19.09,\"totalDelivery\":2658.96},{\"deliverableCodeValue\":1021,\"actualVolume\":0,\"actualValue\":5626.13,\"forecastValue\":42.12,\"adjustmentValue\":6.79,\"totalDelivery\":5675.04},{\"deliverableCodeValue\":1022,\"actualVolume\":0,\"actualValue\":4728.08,\"forecastValue\":33.13,\"adjustmentValue\":14.24,\"totalDelivery\":4775.45},{\"deliverableCodeValue\":1023,\"actualVolume\":0,\"actualValue\":3333.87,\"forecastValue\":19.53,\"adjustmentValue\":11.59,\"totalDelivery\":3364.99},{\"deliverableCodeValue\":1024,\"actualVolume\":0,\"actualValue\":1251.00,\"forecastValue\":46.29,\"adjustmentValue\":8.39,\"totalDelivery\":1305.68},{\"deliverableCodeValue\":1025,\"actualVolume\":0,\"actualValue\":5619.99,\"forecastValue\":11.85,\"adjustmentValue\":13.88,\"totalDelivery\":5645.72}]}]}"
            });

            ConfigurationManager.AppSettings["DCT:FundingClaims:UseStub"] = "true";

            var sessionConnectionFactoryMock = new Mock<ISessionConnectionFactory>();
            sessionConnectionFactoryMock
                .Setup(m => m.GetConnection(It.IsAny<IMessageHandlerContext>()))
                .Returns(new ConnectionInfo(null, new SqlConnection(ConfigurationManager.ConnectionStrings["PerformanceManagementDbContext"].ConnectionString)));

            var container = new WindsorContainer()
                .Install(new WindsorInstaller(new LoggerFactory()))
                .Register(Component.For<ISessionConnectionFactory>().Instance(sessionConnectionFactoryMock.Object).IsDefault())
                .Register(Component.For<BeginFundingClaimPullHandler>().LifestyleScoped())
                .Register(Component.For<BeginPullOfFundingClaimsForClosedCollectionHandler>().LifestyleScoped())
                .Register(Component.For<PullPageForPeriodClaimTypeHandler>().LifestyleScoped());

            container.BeginScope();

            var handler1 = container.Resolve<BeginFundingClaimPullHandler>();
            var handler2 = container.Resolve<BeginPullOfFundingClaimsForClosedCollectionHandler>();
            var handler3 = container.Resolve<PullPageForPeriodClaimTypeHandler>();

            var handler1Context = new TestableMessageHandlerContext();
            var handler2Context = new TestableMessageHandlerContext();
            var handler3Context = new TestableMessageHandlerContext();

            // act
            handler1.Handle(new BeginFundingClaimPullCommand(), handler1Context).Wait();

            var handler2Commands =
                handler1Context.SentMessages
                    .Select(sm => sm.Message)
                    .OfType<BeginPullOfFundingClaimsForClosedCollectionCommand>()
                    .ToList();

            handler2Commands.ForEach(cmd => handler2.Handle(cmd, handler2Context).Wait());

            var handler3Commands =
                handler2Context.SentMessages
                    .Select(sm => sm.Message)
                    .OfType<PullPageForPeriodClaimTypeCommand>()
                    .ToList();

            handler3Commands.ForEach(cmd => handler3.Handle(cmd, handler3Context).Wait());

            var triggerCommands =
                handler3Context.SentMessages
                    .Select(sm => sm.Message)
                    .OfType<ProcessFundingClaimsCommand>()
                    .ToList();

            Assert.IsTrue(triggerCommands.Any());
        }

        private class FundingClaimApiEntity : TableEntity
        {
            public string Json { get; set; }
        }
    }
}
