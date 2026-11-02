namespace Operations.Web.Tests.Infrastructure
{
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Operations.Web.Infrastructure;
    using SFA.FCT.ContractManagementService.Common.Commands;

    [TestClass]
    public class NServiceBusSenderTests
    {
        [TestMethod, TestCategory("TechnicalExploration")]
        public void ShouldSendMessage()
        {
            NServiceBusSender serviceBusSender = new NServiceBusSender();

            serviceBusSender.Send(new DeleteContractCommand(), "ContractManagementDomain.Integration").Wait();
        }
    }
}
