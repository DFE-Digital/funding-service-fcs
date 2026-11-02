namespace Datafix.Tests.Tests
{
    using Automation.Releases.R85;
    using Microsoft.VisualStudio.TestTools.UnitTesting;

    [TestClass]
    public class ReseedCreatedContractTableDataFixTests
    {
        [TestMethod, TestCategory("TechnicalExploration")]
        public void ReseedCreatedContractTableDataFix_ShouldReseedTable()
        {
            // arrange
            var datafix = new ReseedCreatedContractTableDataFix();

            // act
            datafix.ApplyDataFix();
        }
    }
}
