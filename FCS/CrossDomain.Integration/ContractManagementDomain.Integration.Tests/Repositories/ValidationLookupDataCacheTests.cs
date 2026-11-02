namespace SFA.FCT.ContractManagementDomain.Integration.Tests.Repositories
{
    using System.Collections.Generic;
    using System.Linq;
    using ContractManagement.DataStore.Model;
    using ContractManagement.DataStore.Repositories;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Moq;

    [TestClass]
    public class ValidationLookupDataCacheTests
    {
        [TestMethod, TestCategory("UnitTest")]
        public void ValidationLookupDataCache_ShouldOnlyCallGetFuncOnce()
        {
            // arrange
            List<ContractType> expectedContractTypes = new List<ContractType>
            {
                new ContractType("CT1"),
                new ContractType("CT2"),
            };

            Mock<IPolicyConfigRepository> policyConfigRepoMock = new Mock<IPolicyConfigRepository>();
            policyConfigRepoMock.Setup(m => m.GetAllContractTypes()).Returns(new List<string>());

            // act
            var result = ValidationLookupDataCache.Get<IReadOnlyCollection<string>>(ValidationLookupType.ContractType, 
                () => expectedContractTypes.Select(c => c.ContractTypeName).ToList());

            // assert
            Assert.IsNotNull(result, "No data was returned");
            Assert.AreEqual(2, result.Count, "The wrong number of records were returned");
            expectedContractTypes.ForEach(ect => Assert.IsTrue(result.Any(r => r == ect.ContractTypeName), $"{ect} was not returned"));

            // act #2
            var secondResult = ValidationLookupDataCache.Get(ValidationLookupType.ContractType,
                policyConfigRepoMock.Object.GetAllContractTypes);

            // assert #2
            policyConfigRepoMock.Verify(m => m.GetAllContractTypes(), Times.Never, "Repository GetAll() should not have been called");
            Assert.IsNotNull(secondResult, "No data was returned");
            Assert.AreEqual(2, secondResult.Count, "The wrong number of records were returned");
            expectedContractTypes.ForEach(ect => Assert.IsTrue(secondResult.Any(r => r == ect.ContractTypeName), $"{ect} was not returned"));

        }
    }
}