namespace OrganisationDomain.Integration.CpdsEndpoint.Tests
{
    using Implementation.BusinessLogic;
    using Implementation.Converters;
    using Messages.Commands;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Moq;
    using SFA.FCT.Framework.Logging.Interfaces;
    using NServiceBus.Testing;

    [TestClass]
    public class GetProviderSummaryHandlerExploratoryTests
    {
        [TestMethod, TestCategory("Exploratory")]
        public void GetProviderSummaryHandler_ShouldSuccessfullyCallCpds()
        {
            // arrange
            var handler = new GetProviderSummaryHandler(
                Mock.Of<ILogger>(),
                new CpdsSummaryRetriever(new GatewayServiceContractClient(), new CpdsProviderConverter(), Mock.Of<ILogger>()),
                new CpdsProviderConverter());

            // act
            handler.Handle(new GetProviderSummary(), new TestableMessageHandlerContext()).Wait();
        }
    }
}
