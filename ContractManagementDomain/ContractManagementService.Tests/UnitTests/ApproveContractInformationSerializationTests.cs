namespace SFA.FCT.ContractManagementService.Test.UnitTests
{
    using System.IO;
    using System.Text;
    using System.Xml.Serialization;
    using Common;
    using Microsoft.VisualStudio.TestTools.UnitTesting;

    [TestClass]
    public class ApproveContractInformationSerializationTests
    {
        [TestMethod, TestCategory("UnitTest")]
        public void ApproveContractInformation_ShouldDeserializeFromCrmXmlFormatToPreserveCompatibilityWithCrmPlugin()
        {
            const string crmXml = "<ContractInformation xmlns:xsi =\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\"><ContractNumber>MAIN-5678</ContractNumber><MasterContractNumber>SFA-1234</MasterContractNumber><ContractVersionNumber>5</ContractVersionNumber></ContractInformation>";

            using (MemoryStream stream = new MemoryStream(new UTF8Encoding().GetBytes(crmXml)))
            {
                ContractInformation deserializedInstance = new XmlSerializer(typeof(ContractInformation)).Deserialize(stream) as ContractInformation;

                Assert.IsNotNull(deserializedInstance, "Failed to deserialize CRM XML");
                Assert.AreEqual("MAIN-5678", deserializedInstance.ContractNumber, "Failed to deserialize ContractNumber");
                Assert.AreEqual("SFA-1234", deserializedInstance.MasterContractNumber, "Failed to deserialize MasterContractNumber");
                Assert.AreEqual(5, deserializedInstance.ContractVersionNumber, "Failed to deserialize ContractVersionNumber");
            }
        }
    }
}
