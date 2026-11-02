using Microsoft.VisualStudio.TestTools.UnitTesting;

namespace ContractCreateDomain.Tests
{
    using System.IO;
    using System.Runtime.Serialization;
    using System.Runtime.Serialization.Formatters.Binary;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using SFA.FCT.ContractCreateDomain.BusinessLogic;
    using SFA.FCT.CrossDomain.Integration.Entities.ContractRequest;
    using System.Xml.Linq;
    using System.Xml.Serialization;

    [TestClass]
    public class CorpContractValueTypeFieldSetterTest : TestBase
    {
        [TestMethod, TestCategory("UnitTest")]
        public void ShouldTransformContractRequestToCorpContractWithSpecifiedFieldsSetOnContract()
        {
            ContractRequestTransformer transformer = new ContractRequestTransformer();
            contractRequestType contractRequestType = CreateContractRequestType();
            var contract = transformer.TransformToCorpContract(contractRequestType);
            CorpContractValueTypeFieldSetter.SetSpecifiedValuesToTrue(contract);
            foreach (var subContract in contract.contracts)
            {
                Assert.IsTrue(subContract.startDateSpecified);
                Assert.IsTrue(subContract.endDateSpecified);
                Assert.IsTrue(subContract.contractor.ukprnSpecified);
            }
        }

        [TestMethod, TestCategory("UnitTest")]
        public void ShouldTransformContractRequestToCorpContractWithSpecifiedFieldsSetOnAllocations()
        {
            ContractRequestTransformer transformer = new ContractRequestTransformer();
            contractRequestType contractRequestType = CreateContractRequestType();
            var contract = transformer.TransformToCorpContract(contractRequestType);
            CorpContractValueTypeFieldSetter.SetSpecifiedValuesToTrue(contract);
            foreach (var subContract in contract.contracts)
            {
                foreach (var allocation in subContract.contractAllocations)
                {
                    Assert.IsTrue(allocation.startDateSpecified);
                    Assert.IsTrue(allocation.endDateSpecified);
                }
            }
        }


        private contractRequestType CreateContractRequestType()
        {
            XDocument testData = XDocument.Load("Resources\\ContractRequest.xml");
            XmlSerializer xmlSerializer = new XmlSerializer(typeof(contractRequestType));
            return (contractRequestType)xmlSerializer.Deserialize(testData.Root.CreateReader());

            
             Binary deserialize method below
            
            Stream stream = new FileStream("Resources\\ContractRequest.bin", FileMode.Open, FileAccess.Read, FileShare.None);
            IFormatter formatter = new BinaryFormatter();
            return (contractRequestType)formatter.Deserialize(stream); 

        }
    }
}
