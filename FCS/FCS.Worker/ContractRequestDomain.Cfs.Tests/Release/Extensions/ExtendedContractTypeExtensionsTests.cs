namespace ContractRequestDomain.Cfs.Tests.Release.Extensions
{
    using System.Collections.Generic;
    using Cfs.Release.Extensions;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using SFA.FCT.CrossDomain.Integration.Entities.CorporateContract;

    [TestClass]
    public class ExtendedContractTypeExtensionsTests
    {
        [TestMethod, TestCategory("UnitTest")]
        public void ExtendedContractTypeExtensions_ToCorporateContract_ShouldTransformExtendedContractTypeToCorporateContract()
        {
            // arrange
            ExtendedContract extendedContract = CreateExtendedContract();

            // act
            contract corpContract = extendedContract.ToCorporateContract();

            // assert
            Assert.IsTrue(corpContract.contracts.Count == extendedContract.contracts.Count, 
                "Contract not transformed");
            Assert.IsTrue(corpContract.contracts[0].contractAllocations.Count == extendedContract.contracts[0].contractAllocations.Count, 
                "Contract Allocations not transformed");
        }

        private static ExtendedContract CreateExtendedContract()
        {
            ExtendedContract extendedContract = new ExtendedContract
            {
                contracts = new List<ExtendedContractType>()
            };
            List<ExtendedContractAllocation> allocations = new List<ExtendedContractAllocation>
            {
                new ExtendedContractAllocation(),
                new ExtendedContractAllocation(),
                new ExtendedContractAllocation()
            };

            extendedContract.contracts.Add(new ExtendedContractType
            {
                contractType1 = "Some Type",
                contractAllocations = allocations
            });

            return extendedContract;
        }
    }
}