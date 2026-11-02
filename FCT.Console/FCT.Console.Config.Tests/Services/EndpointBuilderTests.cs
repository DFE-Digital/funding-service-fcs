namespace FCT.Console.Config.Tests.Services
{
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using FCT.Console.Config.Services;
    using SFA.FCT.CrossDomain.Integration.Messages.Commands;
    using NServiceBus;

    [TestClass]
    public class EndpointBuilderTests
    {
        
        [TestMethod, TestCategory("TechnicalExploration")]
        public void EndpointBuilder_CreateSendOnlyEndpoint_ShouldCreateSendOnlyEndpointAndThenSendMessage()
        {
            IEndpointInstance endpoint = EndpointBuilder.CreateSendOnlyEndpoint<PullFundingAllocationsCommand>();
            endpoint.Send("FundingAllocation.PullFundingAllocation", new PullFundingAllocationsCommand()).Wait();
        }
    }
}