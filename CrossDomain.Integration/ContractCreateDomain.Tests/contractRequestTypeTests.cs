namespace ContractCreateDomain.Tests
{
    using System.Collections.Generic;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using SFA.FCT.CrossDomain.Integration.Entities.ContractRequest;

    [TestClass]
    public class contractRequestTypeTests
    {
        [TestMethod, TestCategory("UnitTest")]
        public void contractRequestType_HasUnnumberedAllocations_WhenUnnumberedAllocationsExist_ShouldReturnTrue()
        {
            var contractRequestType = new contractRequestType
            {
                contract = new contractType
                {
                    contracts = new List<contractType>
                    {
                        new contractType
                        {
                            contractAllocations = new List<contractAllocation>
                            {
                                new contractAllocation
                                {
                                    contractAllocationNumber = "Alloc-001"
                                },
                                new contractAllocation
                                {
                                    contractAllocationNumber = null
                                }
                            }
                        }
                    }
                }
            };

            Assert.IsTrue(contractRequestType.HasUnnumberedAllocations());
        }

        [TestMethod, TestCategory("UnitTest")]
        public void contractRequestType_HasUnnumberedAllocations_WhenUnnumberedAllocationsDoNotExist_ShouldReturnFalse()
        {
            var contractRequestType = new contractRequestType
            {
                contract = new contractType
                {
                    contracts = new List<contractType>
                    {
                        new contractType
                        {
                            contractAllocations = new List<contractAllocation>
                            {
                                new contractAllocation
                                {
                                    contractAllocationNumber = "Alloc-001"
                                },
                                new contractAllocation
                                {
                                    contractAllocationNumber = "Alloc-002"
                                }
                            }
                        }
                    }
                }
            };

            Assert.IsFalse(contractRequestType.HasUnnumberedAllocations());
        }
    }
}
