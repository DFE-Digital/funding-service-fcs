namespace ContractCreateDomain.Tests.ValidationTests
{
    using System.Linq;
    using SFA.FCT.ContractCreateDomain.BusinessLogic.Validation.Rules;
    using Microsoft.VisualStudio.TestTools.UnitTesting;

    [TestClass]
    public class ExistingContractRuleTest : ContractRequestValidationBase
    {
        private const string NonOverwriteableFundingType = "FundingType1"; 
        private const string OverwriteableFundingType = "FundingType2";

        [TestMethod, TestCategory("IntegrationTest")]
        public void Ensure_NonOverwriteableFundingType_ContractsExisitngInCrm_FailsValidation()
        {
            Contract.contract.contracts.First().fundingTypeCode = NonOverwriteableFundingType;
            Contract.contract.contracts.ForEach(c => c.IsContractWithMatchingUKPRNPeriodAndFundingTypePresentInCrm = true);
            ExistingContractRule rule = new ExistingContractRule(false);
            Assert.IsTrue(rule.GetFailuresForItem(Contract).Any());
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void Ensure_NonOverwriteableFundingType_ContractsNotExistingInCrm_PassValidation()
        {
            Contract.contract.contracts.First().fundingTypeCode = NonOverwriteableFundingType; 
            Contract.contract.contracts.ForEach(c => c.IsContractWithMatchingUKPRNPeriodAndFundingTypePresentInCrm = false);
            ExistingContractRule rule = new ExistingContractRule(false);
            Assert.IsFalse(rule.GetFailuresForItem(Contract).Any());
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void Ensure_OverwriteableFundingType_ContractsExistingInCrm_PassValidation()
        {
            Contract.contract.contracts.First().fundingTypeCode = OverwriteableFundingType;
            Contract.contract.contracts.ForEach(c => c.IsContractWithMatchingUKPRNPeriodAndFundingTypePresentInCrm = true);
            ExistingContractRule rule = new ExistingContractRule(true);
            Assert.IsFalse(rule.GetFailuresForItem(Contract).Any());
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void Ensure_OverwriteableFundingType_ContractsNotExistingInCrm_PassValidation()
        {
            Contract.contract.contracts.First().fundingTypeCode = OverwriteableFundingType;
            Contract.contract.contracts.ForEach(c => c.IsContractWithMatchingUKPRNPeriodAndFundingTypePresentInCrm = false);
            ExistingContractRule rule = new ExistingContractRule(true);
            Assert.IsFalse(rule.GetFailuresForItem(Contract).Any());
        }
    }
}
