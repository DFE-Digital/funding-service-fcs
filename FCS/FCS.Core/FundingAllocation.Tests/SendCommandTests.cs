namespace FundingAllocation.Tests
{
    using System.Collections.Generic;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using NServiceBus;
    using SFA.FCT.CrossDomain.Integration.Messages.Commands;
    using SFA.FCT.CrossDomain.Integration.Messages.FundingAllocation.Commands;

    [TestClass]
    public class SendCommandTests
    {
        [TestMethod, TestCategory("Exploratory")]
        public void SendAdhocCommand()
        {
            IEndpointInstance endpoint = EndpointBuilder.CreateSendOnlyEndpoint<FundingAllocationReleaseGroupCommand>();

            endpoint.Send("FundingAllocation.ReleaseGroup", new FundingAllocationReleaseGroupCommand
            {
                ReleaseGroupNames = new List<string>{"This is a test message"}
            }).Wait();
        }


        [TestMethod, TestCategory("Exploratory")]
        public void SendCheckForReadCompleteCommand_R113b()
        {
            IEndpointInstance endpoint = EndpointBuilder.CreateSendOnlyEndpoint<CheckForReadCompleteCommand>();

            endpoint.Send("FundingAllocation.CheckForReadComplete", new CheckForReadCompleteCommand
            {
                FundingAllocationId = "1619-AS-2223-Contracting-LocalAuthoritySsf-10003987-1_0"
            }).Wait();
        }
    }
}
