namespace ContractCreateDomain.Tests.ValidationTests
{
    using System;
    using System.Collections.Generic;
    using System.Linq;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using SFA.FCT.ContractCreateDomain.BusinessLogic.Validation.Rules;
    using SFA.FCT.CrossDomain.Integration.Entities.ContractRequest;

    [TestClass]
    public class ContractStartAndEndDateRuleMandatoryTests
    {
        [TestMethod, TestCategory("UnitTest")]
        public void ContractStartAndEndDateRuleMandatory_ShouldFailRule_WhenStartDateIsNull()
        {
            // arrange
            ContractStartAndEndDateMandatoryRule mandatoryRule = new ContractStartAndEndDateMandatoryRule();
            contractRequestType contract = new contractRequestType
            {
                contract = new contractType
                {
                    contracts = new List<contractType>
                    {
                        new contractType
                        {
                            startDate = null,
                            endDate = new DateTime()
                        }
                    }
                }
            };

            // act
            var failures = mandatoryRule.GetFailuresForItem(contract);

            // assert
            Assert.AreEqual(1, failures.Count());
        }

        [TestMethod, TestCategory("UnitTest")]
        public void ContractStartAndEndDateRuleMandatory_ShouldFailRule_WhenEndDateIsNull()
        {
            // arrange
            ContractStartAndEndDateMandatoryRule mandatoryRule = new ContractStartAndEndDateMandatoryRule();
            contractRequestType contract = new contractRequestType
            {
                contract = new contractType
                {
                    contracts = new List<contractType>
                    {
                        new contractType
                        {
                            startDate = new DateTime(),
                            endDate = null
                        }
                    }
                }
            };

            // act
            var failures = mandatoryRule.GetFailuresForItem(contract);

            // assert
            Assert.AreEqual(1, failures.Count());
        }

        [TestMethod, TestCategory("UnitTest")]
        public void ContractStartAndEndDateRuleMandatory_ShouldPassRule_WhenStartDateAndEndDateAreNotNull()
        {
            // arrange
            ContractStartAndEndDateMandatoryRule mandatoryRule = new ContractStartAndEndDateMandatoryRule();
            contractRequestType contract = new contractRequestType
            {
                contract = new contractType
                {
                    contracts = new List<contractType>
                    {
                        new contractType
                        {
                            startDate = new DateTime(),
                            endDate = new DateTime()
                        }
                    }
                }
            };

            // act
            var failures = mandatoryRule.GetFailuresForItem(contract);

            // assert
            Assert.AreEqual(0, failures.Count());
        }
    }
}
