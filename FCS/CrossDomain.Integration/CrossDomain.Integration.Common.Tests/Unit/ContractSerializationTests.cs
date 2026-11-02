namespace CrossDomain.Integration.Common.Tests.Unit
{
    using System;
    using System.Collections.Generic;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using SFA.FCT.CrossDomain.Integration.Common.Serializers;
    using SFA.FCT.CrossDomain.Integration.Entities.CorporateSchema.Contract;

    [TestClass]
    public class ContractSerializationTests
    {
        private const string TerminationAttrsStart = @"<TerminationContractAttrs";

        [TestMethod, TestCategory("UnitTest")]
        public void Contract_ShouldNotSerializeTerminationAttrsIfContractTerminationAttrsIsNullAndAllAllocationTerminationAttrsAreNull()
        {
            // arrange
            var contract = new contract
            {
                TerminationContractAttrs = null,
                contractAllocations = new List<contractAllocationsContractAllocation>
                {
                    new contractAllocationsContractAllocation
                    {
                        allocationTerminationAttrs = null
                    }
                }
            };

            // act
            string xmlContract = contract.SerializeToXml();
            
            // assert
            Assert.IsFalse(xmlContract.Contains(TerminationAttrsStart), "Serialized Contract contained TerminationContractAttrs");
        }

        [TestMethod, TestCategory("UnitTest")]
        public void Contract_ShouldNotSerializeTerminationAttrsIfContractTerminationDateIsNull()
        {
            // arrange
            var contract = new contract
            {
                TerminationContractAttrs = new TerminationContractAttrsCT
                {
                    terminationDate = null
                },
            };

            // act
            string xmlContract = contract.SerializeToXml();

            // assert
            Assert.IsFalse(xmlContract.Contains(TerminationAttrsStart), "Serialized Contract contained TerminationContractAttrs");
        }

        [TestMethod, TestCategory("UnitTest")]
        public void Contract_ShouldNotSerializeTerminationAttrsIfTerminationDateIsDateTimeMinimum()
        {
            // arrange
            var contract = new contract
            {
                TerminationContractAttrs = new TerminationContractAttrsCT
                {
                    terminationDate = DateTime.MinValue
                }
            };

            // act
            string xmlContract = contract.SerializeToXml();

            // assert
            Assert.IsFalse(xmlContract.Contains(TerminationAttrsStart), "Serialized Contract contained TerminationContractAttrs");
        }

        [TestMethod, TestCategory("UnitTest")]
        public void Contract_ShouldSerializeTerminationAttrsIfContractTerminationDateIsSet()
        {
            // arrange
            var contract = new contract
            {
                TerminationContractAttrs = new TerminationContractAttrsCT
                {
                    terminationDate = DateTime.UtcNow
                }
            };

            // act
            string xmlContract = contract.SerializeToXml();

            // assert
            Assert.IsTrue(xmlContract.Contains(TerminationAttrsStart), "Serialized Contract did not contain TerminationContractAttrs");
        }
    }
}