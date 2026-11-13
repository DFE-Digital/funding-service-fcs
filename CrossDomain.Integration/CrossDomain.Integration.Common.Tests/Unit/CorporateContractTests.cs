namespace CrossDomain.Integration.Common.Tests.Unit
{
    using System;
    using System.Collections.Generic;
    using System.Linq;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Newtonsoft.Json;
    using Newtonsoft.Json.Linq;
    using SFA.FCT.CrossDomain.Integration.Entities.CorporateContract;

    [TestClass]
    public class CorporateContractTests
    {
        [TestMethod, TestCategory("UnitTest")]
        public void CorporateContract_ShouldGetAllocationNumbers()
        {
            // arrange
            IList<string> allocNumbers = new List<string> {"Alloc 1", "Alloc 2", "Alloc 3", "Alloc 4"};

            Contract contract = new Contract
            {
                contracts = new List<contractType>
                {
                    new contractType
                    {
                        contractAllocations = new List<contractAllocationsContractAllocation>
                        {
                            new contractAllocationsContractAllocation
                            {
                                contractAllocationNumber = allocNumbers[0]
                            },
                            new contractAllocationsContractAllocation
                            {
                                contractAllocationNumber = allocNumbers[1]
                            }
                        }
                    },
                    new contractType
                    {
                        contractAllocations = new List<contractAllocationsContractAllocation>
                        {
                            new contractAllocationsContractAllocation
                            {
                                contractAllocationNumber = allocNumbers[2]
                            },
                            new contractAllocationsContractAllocation
                            {
                                contractAllocationNumber = allocNumbers[3]
                            }
                        }
                    }
                }
            };

            // act
            var allocNumbersReturned = contract.GetAllocationNumbers();

            // assert
            Assert.AreEqual(4, allocNumbersReturned.Count, "the wrong number of allocation numbers");
            Assert.IsTrue(allocNumbers.All(a => allocNumbersReturned.Contains(a)),
                "not all the allocation numbers are present");
        }

        [TestMethod, TestCategory("UnitTest")]
        public void CorporateContract_ToStringShouldBeJson()
        {
            // arrange
            const string contractNumber = "Some Number";
            Contract corporateContract = new Contract
            {
                contracts = new List<contractType>
                {
                    new contractType
                    {
                        contractNumber = contractNumber
                    }
                }
            };

            // act
            var contractString = corporateContract.ToString();

            // assert
            try
            {
                var json = JsonConvert.DeserializeObject<JObject>(contractString);
                JToken token = json["contractNumber"];
                Assert.AreEqual(contractNumber, token.Value<string>(), "The contract number is not correct");
            }
            catch (Exception)
            {
                Assert.Fail("The toString() method does not return json");
            }
        }
    }
}
