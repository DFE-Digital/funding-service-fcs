namespace ContractCreateDomain.Tests.ValidationTests
{
    using System.Collections.Generic;
    using System.Linq;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using SFA.FCT.ContractCreateDomain.BusinessLogic.Validation.Rules;
    using SFA.FCT.CrossDomain.Integration.Entities.ContractRequest;

    [TestClass]
    public class AllocationFundingStreamPeriodMandatoryRuleTests
    {
        [TestMethod, TestCategory("UnitTest")]
        public void AllocationFundingStreamPeriodMandatoryRule_ShouldFailWhenFspIsNotSet()
        {
            AllocationFundingStreamPeriodMandatoryRule rule = new AllocationFundingStreamPeriodMandatoryRule();
            contractRequestType contract = new contractRequestType
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
                                    fundingStreamPeriodCode = string.Empty
                                }
                            }
                        }
                    }
                }
            };

            // act
            var failures = rule.GetFailuresForItem(contract);

            // assert
            Assert.AreEqual(1, failures.Count());
        }

        [TestMethod, TestCategory("UnitTest")]
        public void AllocationFundingStreamPeriodMandatoryRule_ShouldPassWhenFspIsSet()
        {
            AllocationFundingStreamPeriodMandatoryRule rule = new AllocationFundingStreamPeriodMandatoryRule();
            contractRequestType contract = new contractRequestType
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
                                    fundingStreamPeriodCode = "Some fsp"
                                }
                            }
                        }
                    }
                }
            };

            // act
            var failures = rule.GetFailuresForItem(contract);

            // assert
            Assert.AreEqual(0, failures.Count());
        }
    }
}
