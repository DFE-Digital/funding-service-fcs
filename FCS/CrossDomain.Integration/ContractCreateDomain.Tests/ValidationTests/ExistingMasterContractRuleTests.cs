namespace ContractCreateDomain.Tests.ValidationTests
{
    using System.Collections.Generic;
    using System.Linq;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using SFA.FCT.ContractCreateDomain.BusinessLogic.Validation.Rules;
    using SFA.FCT.CrossDomain.Integration.Entities.ContractRequest;

    [TestClass]
    public class ExistingMasterContractRuleTests
    {
        [TestMethod, TestCategory("UnitTest")]
        public void ExistingMasterContractRule_ShouldNotReturnFailuresWhenMatchingContractIsNotPresentInCrmAndMultipleOverlappingContractsAreNotAllowedForFundingType()
        {
            // arrange
            ExistingMasterContractRule rule = new ExistingMasterContractRule(multipleOverlappingContractsAllowedForFundingType: false);
            contractRequestType contract = new contractRequestType
            {
                contract = new contractType { IsPresentInCrm = false }
            };

            // act
            IEnumerable<string> failures = rule.GetFailuresForItem(contract);

            // assert
            Assert.IsFalse(failures.Any(), "Failures were returned.");
        }

        [TestMethod, TestCategory("UnitTest")]
        public void ExistingMasterContractRule_ShouldNotReturnFailuresWhenMatchingContractIsNotPresentInCrmAndMultipleOverlappingContractsAreAllowedForFundingType()
        {
            // arrange
            ExistingMasterContractRule rule = new ExistingMasterContractRule(multipleOverlappingContractsAllowedForFundingType: true);
            contractRequestType contract = new contractRequestType
            {
                contract = new contractType { IsPresentInCrm = false }
            };

            // act
            IEnumerable<string> failures = rule.GetFailuresForItem(contract);

            // assert
            Assert.IsFalse(failures.Any(), "Failures were returned.");
        }

        [TestMethod, TestCategory("UnitTest")]
        public void ExistingMasterContractRule_ShouldReturnFailuresWhenMatchingContractIsPresentInCrmAndMultipleOverlappingContractsAreNotAllowedForFundingType()
        {
            // arrange
            ExistingMasterContractRule rule = new ExistingMasterContractRule(multipleOverlappingContractsAllowedForFundingType: false);
            contractRequestType contract = new contractRequestType
            {
                contract = new contractType { IsPresentInCrm = true }
            };

            // act
            IEnumerable<string> failures = rule.GetFailuresForItem(contract);

            // assert
            Assert.IsTrue(failures.Any(), "Failures were not returned.");
        }

        [TestMethod, TestCategory("UnitTest")]
        public void ExistingMasterContractRule_ShouldNotReturnFailuresWhenMatchingContractIsPresentInCrmAndMultipleOverlappingContractsAreAllowedForFundingType()
        {
            // arrange
            ExistingMasterContractRule rule = new ExistingMasterContractRule(multipleOverlappingContractsAllowedForFundingType: true);
            contractRequestType contract = new contractRequestType
            {
                contract = new contractType { IsPresentInCrm = true }
            };

            // act
            IEnumerable<string> failures = rule.GetFailuresForItem(contract);

            // assert
            Assert.IsFalse(failures.Any(), "Failures were returned.");
        }
    }
}
