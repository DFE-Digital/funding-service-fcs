namespace ContractManagementDomain.Endpoint.Tests.ContractApproved
{
    using System.IO;
    using System.Reflection;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using SFA.FCT.ContractManagementService.Common.Services;

    [TestClass]
    public class CorporateSchemaContractValidatorTests
    {
        [TestMethod, TestCategory("UnitTest")]
        public void CorporateSchemaContractValidator_IsContractXmlValid_ShouldReturnTrueWhenValid()
        {
            // arrange
            var contractFromValidXml = GetContractFromValidXml();

            // act
            bool isValid = CorporateSchemaContractValidator.IsContractXmlValid(contractFromValidXml);
            // assert
            Assert.IsTrue(isValid);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void CorporateSchemaContractValidator_IsContractXmlValid_ShouldReturnFalseWhenInvalid()
        {
            // arrange
            var contractFromValidXml = GetContractFromInvalidXml();
            
            // act
            bool isValid = CorporateSchemaContractValidator.IsContractXmlValid(contractFromValidXml);
            // assert
            Assert.IsFalse(isValid);
        }

        private static string GetContractFromValidXml()
        {
            using (Stream stream = Assembly.GetCallingAssembly().GetManifestResourceStream($"ContractManagementDomain.Endpoint.Tests.Resources.valid-corp-schema-contract.xml"))
            using (StreamReader streamReader = new StreamReader(stream))
            {
                return streamReader.ReadToEnd();
            }
        }

        private static string GetContractFromInvalidXml()
        {
            using (Stream stream = Assembly.GetCallingAssembly().GetManifestResourceStream($"ContractManagementDomain.Endpoint.Tests.Resources.invalid-corp-schema-contract.xml"))
            using (StreamReader streamReader = new StreamReader(stream))
            {
                return streamReader.ReadToEnd();
            }
        }
    }
}
