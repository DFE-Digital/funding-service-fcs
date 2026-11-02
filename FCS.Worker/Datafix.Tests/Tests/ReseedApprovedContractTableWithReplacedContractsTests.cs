namespace Datafix.Tests.Tests
{
    using Automation.Releases.R86;
    using Microsoft.VisualStudio.TestTools.UnitTesting;

    [TestClass]
    public class ReseedApprovedContractTableWithReplacedContractsTests
    {
        [TestMethod, TestCategory("IntegrationTest")]
        public void ReseedApprovedContractTableWithReplacedContracts_ShouldAddReplacedContracts()
        {
            // arrange
            var datafix = new ReseedApprovedContractTableWithReplacedContracts();

            // act
            datafix.ApplyDataFix();
        }
    }
}
