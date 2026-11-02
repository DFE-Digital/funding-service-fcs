namespace ContractCreateDomain.Tests
{
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Newtonsoft.Json;
    using SFA.FCT.CrossDomain.Integration.Entities.CorporateContract;

    [TestClass]
    public class ExtendedContractTypeTests
    {
        [TestMethod, TestCategory("UnitTest")]
        public void ExtendedContractType_ShouldDeserializeExtendedContractTypeToBaseType()
        {
            // arrange
            ExtendedContractType extendedContractType = new ExtendedContractType
            {
                ValueVariation = 10
            };
            string json = JsonConvert.SerializeObject(extendedContractType);
            
            // act
            contractType corpContract = JsonConvert.DeserializeObject<contractType>(json);

            // assert
            Assert.IsTrue(corpContract != null);
        }
    }
}
