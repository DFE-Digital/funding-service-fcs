namespace PerformanceManagementDomain.Tests.ReconciliationCalculationEndpoint.Handlers
{
    using System.IO;
    using System.Linq;
    using System.Reflection;
    using Infrastructure;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Moq;
    using Newtonsoft.Json;
    using NServiceBus;
    using NServiceBus.Testing;
    using PerformanceManagementDomain.ReconciliationCalculationEndpoint.Handlers;
    using PerformanceManagementDomain.ReconciliationCalculationEndpoint.Repositories;
    using PerformanceManagementDomain.ReconciliationCalculationEndpoint.Services;
    using SFA.FCT.CrossDomain.Integration.Entities.Data;
    using SFA.FCT.CrossDomain.Integration.Events;
    using SFA.FCT.Framework.Logging.Interfaces;
    using SFA.FCT.PerformanceManagementDomain.DataStore;

    [TestClass]
    public class ContractApprovedEventHandlerDeliveryOrgTests
    {
        [TestMethod, TestCategory("IntegrationTest")]
        public void ContractApprovedEventHandler_ShouldChooseDeliveryOrg_WhenPersistContractToPaas()
        {
            // arrange
            ContractApprovedEvent contractApprovedEvent =
                FromJson<ContractApprovedEvent>("PerformanceManagementDomain.Tests",
                    "ReconciliationCalculationEndpoint.TestResources.ContractApprovedEventDeliveryOrg.json");

            var allocationNumbers = contractApprovedEvent.CorporateContract.contracts
                .SelectMany(c => c.contractAllocations.Select(ca => ca.contractAllocationNumber)).ToList();

            using (var context = new PerformanceManagementDbContext())
            {
                context.ContractAllocations.Where(ca => allocationNumbers.Contains(ca.AllocationNumber))
                    .ToList().ForEach(a => context.ContractAllocations.Remove(a));

                context.SaveChanges();
            }

            Mock<ISessionConnectionFactory> sessionFactoryMock = new Mock<ISessionConnectionFactory>();

            using (var context = new PerformanceManagementDbContext())
            {
                sessionFactoryMock.Setup(s => s.GetConnection(It.IsAny<IMessageHandlerContext>()))
                    .Returns(new ConnectionInfo(null, context.Database.Connection));

                ContractApprovedEventHandler handler = new ContractApprovedEventHandler(
                    Mock.Of<ILogger>(),
                    new PerformanceManagementDomain.ReconciliationCalculationEndpoint.Repositories.ContractAllocationRepository(),
                    new PerformanceManagementDomain.ReconciliationCalculationEndpoint.Repositories.FundingStreamPeriodQueryRepository(),
                    Mock.Of<IContractAllocationDeliverableRepository>(),
                    Mock.Of<IFcrRecalculationRequiredChecker>(),
                    sessionFactoryMock.Object);

                // act
                handler.Handle(contractApprovedEvent, new TestableMessageHandlerContext()).Wait();
            }

            // assert
            using (var context = new PerformanceManagementDbContext())
            {
                int ukprn = context.ContractAllocations.Single(ca => ca.AllocationNumber == "AEC-5551").Contractor.UKPRN;

                Assert.AreEqual(10021585, ukprn, "The ukprn is not correct");
            }
        }

        public static T FromJson<T>(string nameSpace, string resourceName)
        {
            using (Stream stream = Assembly.GetCallingAssembly().GetManifestResourceStream($"{nameSpace}.{resourceName}"))
            using (StreamReader streamReader = new StreamReader(stream))
            {
                return JsonConvert.DeserializeObject<T>(streamReader.ReadToEnd());
            }
        }
    }
}
