namespace SFA.FCT.ContractManagementService.Test.UnitTests
{
    using System.Reflection;
    using System.Xml.Linq;
    using ContractManagementService.Utils;
    using Microsoft.VisualStudio.TestTools.UnitTesting;

    [TestClass]
    public class ContractXmlSearchHelperTests
    {
        [TestMethod, TestCategory("UnitTest")]
        public void ContractXmlSearchHelper_ShouldExtractCorrectContractNumber()
        {
            // arrange
            const string namespaceString = "urn:sfa:schemas:contract";
            string xmlContract = GetCorpContractXmlString();
            ContractXmlSearchHelper contractXmlSearchHelper = new ContractXmlSearchHelper(xmlContract, namespaceString);

            // act
            string contractNumber = contractXmlSearchHelper.GetFirstContractNumber();

            // assert
            Assert.AreEqual("XXX10", contractNumber);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void ContractXmlSearchHelper_ShouldExtractCorrectContractVersionNumber()
        {
            // arrange
            const string namespaceString = "urn:sfa:schemas:contract";
            string xmlContract = GetCorpContractXmlString();
            ContractXmlSearchHelper contractXmlSearchHelper = new ContractXmlSearchHelper(xmlContract, namespaceString);

            // act
            string contractVersionNumber = contractXmlSearchHelper.GetFirstContractVersionNumber();

            // assert
            Assert.AreEqual("1", contractVersionNumber);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void ContractXmlSearchHelper_ShouldExtractCorrectElementValue()
        {
            // arrange
            const string namespaceString = "urn:sfa:schemas:contract";
            string xmlContract = GetCorpContractXmlString();
            ContractXmlSearchHelper contractXmlSearchHelper = new ContractXmlSearchHelper(xmlContract, namespaceString);

            // act
            string ukprn = contractXmlSearchHelper.GetElementValue("ukprn");

            // assert
            Assert.AreEqual("12345678", ukprn);
        }

        private string GetCorpContractXmlString()
        {
            using var stream = Assembly.GetExecutingAssembly().GetManifestResourceStream("ContractManagementService.Tests.Resources.CorpSchemaContract.xml");
            var document = XDocument.Load(stream);
            
            return document.Root.ToString();
        }
    }
}
