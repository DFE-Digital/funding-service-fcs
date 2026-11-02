namespace Datafix.Tests
{
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using NServiceBus;
    using Services;
    using SFA.FCT.CrossDomain.Integration.Messages.Commands;

    [TestClass]
    public class AggregateDeliverableCommandTests
    {
        [TestMethod, TestCategory("SmokeTest_R64a")]
        public void SendAggregateDeliverablesCommandForPostActivityClosureAllocationToEnsureCrmConnectivityFromWorkerRole()
        {
            // arrange
            IEndpointInstance endpoint = EndpointBuilder.CreateSendOnlyEndpoint<HousekeepProcessedMessageTables>();

            AggregateDeliverablesCommand command = new AggregateDeliverablesCommand
            {
                AllocationNumber = "ASC-2462",
                ContractVersionNumber = 5,
                SubVersionNumber = 0,
                FundingStreamPeriodCode = "ASC1516"
            };

            // act
            endpoint.Send("Operations.Maintenance", new HousekeepProcessedMessageTables()).Wait();
        }
    }
}
