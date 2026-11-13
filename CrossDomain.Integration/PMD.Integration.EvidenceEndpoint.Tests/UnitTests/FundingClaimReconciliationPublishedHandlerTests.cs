namespace SFA.FCT.PMD.Integration.EvidenceEndpoint.Tests.UnitTests
{
    using System.Diagnostics;
    using Castle.MicroKernel.Lifestyle;
    using Castle.MicroKernel.Registration;
    using Castle.Windsor;
    using CrossDomain.Integration.Entities.Data;
    using CrossDomain.Integration.Events;
    using Framework.Logging;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Newtonsoft.Json;
    using NServiceBus;
    using NServiceBus.Testing;
    using PaymentManagementDomain.Integration.PaymentSchedule.Handlers;
    using PaymentManagementDomain.Integration.PaymentSchedule.Infrastructure;
    using PaymentManagementDomain.Integration.PaymentSchedule.IoC;
    using PaymentManagementDomain.PolicyCache.DataStore;

    [TestClass]
    public class FundingClaimReconciliationPublishedHandlerTests
    {
        [TestMethod, TestCategory("UnitTest")]
        public void FundingClaimReconciliationPublishedHandler_ShouldResolve()
        {
            // arrange
            IWindsorContainer container = new WindsorContainer()
                .Install(new WindsorInstaller(new Microsoft.Extensions.Logging.LoggerFactory()))
                .Register(Component.For<FundingClaimReconciliationPublishedHandler>().LifestyleScoped());

            container.BeginScope();

            // act
            container.Resolve<FundingClaimReconciliationPublishedHandler>();
        }

        [TestMethod, TestCategory("TechnicalExploration")]
        public void FundingClaimReconciliationPublishedHandler_TechnicalExploration()
        {
            // arrange
            IWindsorContainer container = new WindsorContainer()
                .Install(new WindsorInstaller(new Microsoft.Extensions.Logging.LoggerFactory()))
                .Register(Component.For<FundingClaimReconciliationPublishedHandler>().LifestyleScoped())
                .Register(Component.For<ISessionConnectionFactory>().Instance(new MyClassSessionConnectionFactory()).IsDefault());

            container.BeginScope();

            // act
            var handler = container.Resolve<FundingClaimReconciliationPublishedHandler>();
            var message = JsonConvert.DeserializeObject<FundingClaimReconciliationPublishedEvent>(
                "{\"FundingClaimReconciliationId\":\"c4e4760a-ab6d-4a50-b522-9c0cd078f184\",\"FundingClaimReconciliationName\":\"2021_Final_19-24 Traineeships - 2020 Procurement - Learner Support 20/21_10017823\",\"ContractInfo\":{\"ContractNumber\":\"19TR20-823\",\"ContractVersion\":1,\"AllocationInfos\":[{\"AllocationNumber\":\"19TL-823\",\"ReconciliationValue\":-1726.2700000000,\"FundingStreamPeriodCode\":\"19TRN2020-LS2021\",\"StartDate\":\"2021-02-01T00:00:00Z\",\"EndDate\":\"2021-07-31T00:00:00Z\"}]},\"PublishedDate\":\"2021-10-03T00:00:00Z\",\"IsClaimCollectionPayable\":true,\"IsForManualPublication\":false,\"ShouldStaggerPayments\":true}");
            handler.Handle(message, new TestableMessageHandlerContext()).Wait();

        }

        private class MyClassSessionConnectionFactory : ISessionConnectionFactory
        {
            public ConnectionInfo GetConnection(IMessageHandlerContext context)
            {
                return new ConnectionInfo(null, new PaymentManagementPolicyContext().Database.Connection);
            }
        }
    }
}
