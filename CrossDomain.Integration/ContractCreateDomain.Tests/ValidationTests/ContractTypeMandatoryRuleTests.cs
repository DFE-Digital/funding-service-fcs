namespace ContractCreateDomain.Tests.ValidationTests
{
    using System.Collections.Generic;
    using System.Linq;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using SFA.FCT.ContractCreateDomain.BusinessLogic.Validation.Rules;
    using SFA.FCT.CrossDomain.Integration.Entities.ContractRequest;

    [TestClass]
    public class ContractTypeMandatoryRuleTests
    {
        [TestMethod, TestCategory("UnitTest")]
        public void ContractTypeMandatoryRule_ShouldFailWhenContractTypeNotSet()
        {
            // arrange
            ContractTypeMandatoryRule rule = new ContractTypeMandatoryRule();
            contractRequestType contract = new contractRequestType
            {
                contract = new contractType
                {
                    contracts = new List<contractType>
                    {
                        new contractType
                        {
                            contractType1 = string.Empty
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
        public void ContractTypeMandatoryRule_ShouldPassWhenContractTypeSet()
        {
            // arrange
            ContractTypeMandatoryRule rule = new ContractTypeMandatoryRule();
            contractRequestType contract = new contractRequestType
            {
                contract = new contractType
                {
                    contracts = new List<contractType>
                    {
                        new contractType
                        {
                            contractType1 = "Some val"
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
