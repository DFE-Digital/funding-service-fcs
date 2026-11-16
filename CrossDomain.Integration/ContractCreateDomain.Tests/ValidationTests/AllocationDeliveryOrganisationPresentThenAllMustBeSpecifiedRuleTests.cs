namespace ContractCreateDomain.Tests.ValidationTests
{
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using SFA.FCT.ContractCreateDomain.BusinessLogic.Validation.Rules;
    using SFA.FCT.CrossDomain.Integration.Entities.ContractRequest;
    using System.Collections.Generic;
    using System.Linq;

    [TestClass]
    public class AllocationDeliveryOrganisationPresentThenAllMustBeSpecifiedRuleTests
    {
        [TestMethod, TestCategory("UnitTest")]
        public void AllocationDeliveryOrganisationPresentThenAllMustBeSpecifiedRule_ShouldPassWhenNoDeliveryOrganisationsArePresent()
        {
            // arrange
            contractRequestType contractRequest = new contractRequestType
            {
                contract = new contractType
                {
                    contractor = new Contractor
                    {
                        ukprn = 12345678
                    },
                    contracts = new List<contractType>
                    {
                        new contractType
                        {
                            contractAllocations = new List<contractAllocation>
                            {
                                new contractAllocation
                                {
                                    contractAllocationNumber = "ALLOC-123",
                                    DeliveryOrganisation = string.Empty,
                                    correlationId = "CORRID1"
                                },
                                new contractAllocation
                                {
                                    contractAllocationNumber = "ALLOC-456",
                                    DeliveryOrganisation = null,
                                    correlationId = "CORRID2"
                                }
                            }
                        }
                    }
                }
            };

            var rule = new AllocationDeliveryOrganisationPresentThenAllMustBeSpecifiedRule();

            // act
            IEnumerable<string> failures = rule.GetFailuresForItem(contractRequest);

            // assert
            Assert.AreEqual(0, failures.Count());
        }

        [TestMethod, TestCategory("UnitTest")]
        public void AllocationDeliveryOrganisationPresentThenAllMustBeSpecifiedRule_ShouldPassWhenAllDeliveryOrganisationsArePresent()
        {
            // arrange
            contractRequestType contractRequest = new contractRequestType
            {
                contract = new contractType
                {
                    contractor = new Contractor
                    {
                        ukprn = 12345678
                    },
                    contracts = new List<contractType>
                    {
                        new contractType
                        {
                            contractAllocations = new List<contractAllocation>
                            {
                                new contractAllocation
                                {
                                    contractAllocationNumber = "ALLOC-123",
                                    DeliveryOrganisation = "DELORG1",
                                    correlationId = "CORRID1"
                                },
                                new contractAllocation
                                {
                                    contractAllocationNumber = "ALLOC-456",
                                    DeliveryOrganisation = "DELORG2",
                                    correlationId = "CORRID2"
                                }
                            }
                        }
                    }
                }
            };

            var rule = new AllocationDeliveryOrganisationPresentThenAllMustBeSpecifiedRule();

            // act
            IEnumerable<string> failures = rule.GetFailuresForItem(contractRequest);

            // assert
            Assert.AreEqual(0, failures.Count());
        }

        [TestMethod, TestCategory("UnitTest")]
        public void AllocationDeliveryOrganisationPresentThenAllMustBeSpecifiedRule_ShouldFailWhenNotAllDeliveryOrganisationsArePresent()
        {
            // arrange
            contractRequestType contractRequest = new contractRequestType
            {
                contract = new contractType
                {
                    contractor = new Contractor
                    {
                        ukprn = 12345678
                    },
                    contracts = new List<contractType>
                    {
                        new contractType
                        {
                            contractAllocations = new List<contractAllocation>
                            {
                                new contractAllocation
                                {
                                    contractAllocationNumber = "ALLOC-123",
                                    DeliveryOrganisation = "DELORG1",
                                    correlationId = "CORRID1"
                                },
                                new contractAllocation
                                {
                                    contractAllocationNumber = "ALLOC-456",
                                    DeliveryOrganisation = string.Empty,
                                    correlationId = "CORRID2"
                                }
                            }
                        }
                    }
                }
            };

            var rule = new AllocationDeliveryOrganisationPresentThenAllMustBeSpecifiedRule();

            // act
            IEnumerable<string> failures = rule.GetFailuresForItem(contractRequest);

            // assert
            Assert.AreEqual(2, failures.Count());
            Assert.IsTrue(failures.Contains("CORRID1"));
            Assert.IsTrue(failures.Contains("CORRID2"));
        }

        [TestMethod, TestCategory("UnitTest")]
        public void AllocationDeliveryOrganisationPresentThenAllMustBeSpecifiedRule_ErrorMessage_ShouldBeCorrect()
        {
            // arrange
            var rule = new AllocationDeliveryOrganisationPresentThenAllMustBeSpecifiedRule();

            // act
            string errorMessage = rule.ErrorMessage;

            // assert
            Assert.AreEqual("If Delivery Organisations are applicable, they must be specified against all Contract Allocations for the Contract", errorMessage);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void AllocationDeliveryOrganisationPresentThenAllMustBeSpecifiedRule_ErrorLevel_ShouldBeCorrect()
        {
            // arrange
            var rule = new AllocationDeliveryOrganisationPresentThenAllMustBeSpecifiedRule();

            // act
            errorInfoTypeLevel errorLevel = rule.ErrorLevel;

            // assert
            Assert.AreEqual(errorInfoTypeLevel.Allocation, errorLevel);
        }
    }
}
