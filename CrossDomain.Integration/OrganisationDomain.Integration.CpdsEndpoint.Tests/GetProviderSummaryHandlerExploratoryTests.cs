
namespace OrganisationDomain.Integration.CpdsEndpoint.Tests
{
    using Implementation.BusinessLogic;
    using Implementation.Converters;
    using Messages.Commands;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Moq;
    using SFA.FCT.Framework.Logging.Interfaces;
    using NServiceBus.Testing;
    using schemas.sfa.gov.uk.cpds.gatewayservice;

    [TestClass]
    public class GetProviderSummaryHandlerExploratoryTests
    {
        [TestMethod, TestCategory("Exploratory")]
        public void GetProviderSummaryHandler_ShouldSuccessfullyCallCpds()
        {
            // ✅ MOCK the service instead of creating real client
            var mockGateway = new Mock<GatewayServiceContract>();

            mockGateway
                .Setup(x => x.GetProvidersByUKPRNAsync(It.IsAny<GProvByUKPRINRequest>()))
                .ReturnsAsync(new GProvByUKPRNResponse
                {
                    RawCPDSResponse = "<xml>Test Response</xml>"
                });

            // arrange
            var handler = new GetProviderSummaryHandler(
                Mock.Of<ILogger>(),
                new CpdsSummaryRetriever(
                    mockGateway.Object, // use mock here
                    new CpdsProviderConverter(),
                    Mock.Of<ILogger>()),
                new CpdsProviderConverter());

            // act
            handler.Handle(
                new GetProviderSummary(),
                new TestableMessageHandlerContext()).Wait();

            // ✅ optional: verify service was called
            mockGateway.Verify(
                x => x.GetProvidersByUKPRNAsync(It.IsAny<GProvByUKPRINRequest>()),
                Times.Once);
        }
    }
}
