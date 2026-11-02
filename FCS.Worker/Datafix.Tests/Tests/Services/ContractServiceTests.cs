namespace Datafix.Tests.Tests.Services
{
    using Datafix.Tests.Services;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using SFA.FCT.ContractManagementService.Common;

    [TestClass]
    public class ContractServiceTests
    {
        [TestMethod, TestCategory("TechnicalExploration")]
        public void ContractService_ShouldGetCorpSchemaContract()
        {
            // act
            var contract = ContractService.GetCorpSchemaContract(new ContractIdentifier("MAIN-073", 1, 0));
            Assert.IsNotNull(contract);
        }
    }
}
