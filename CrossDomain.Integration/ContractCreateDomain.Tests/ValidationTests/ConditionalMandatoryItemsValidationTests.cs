namespace ContractCreateDomain.Tests.ValidationTests
{
    using System.Linq;
    using System.Collections.Generic;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using SFA.FCT.ContractCreateDomain.BusinessLogic;
    using SFA.FCT.ContractCreateDomain.BusinessLogic.Validation.Rules;
    using SFA.FCT.ContractCreateDomain.BusinessLogic.Validation;
    using SFA.FCT.CrossDomain.Integration.Entities;
    using SFA.FCT.CrossDomain.Integration.Entities.ContractRequest;

    [TestClass]
    public class ConditionalMandatoryItemsValidationTests : ContractRequestValidationBase
    {
        [TestMethod, TestCategory("UnitTest")]
        public void ShouldCreateErrorWhenMandatoryFieldOnAllocationIsNotSet()
        {
            const string fundingTypeCode = "FundingTypeCode";
            const string propertyName = "LEPCode";
            ConditionalDataItem conditionalDataItem = new ConditionalDataItem(propertyName, fundingTypeCode, new List<object> { FundingTypes.ESF },
                false, errorInfoTypeLevel.Allocation);

            var contractAllocation = Contract.contract.contracts[0].contractAllocations[0];
            contractAllocation.correlationId = "SOME ID";
            PropertyExtractor propertyExtractor = new PropertyExtractor(contractAllocation, propertyName, "ESF", new List<object> { FundingTypes.ESF });
            ConditionalMandatoryFieldsRule conditionalMandatoryFieldsRule = new ConditionalMandatoryFieldsRule(conditionalDataItem, propertyExtractor, errorInfoTypeLevel.Allocation);

            Assert.IsTrue(conditionalMandatoryFieldsRule.GetFailuresForItem(Contract).Any());
        }

        [TestMethod, TestCategory("UnitTest")]
        public void ShouldNotCreateError_WhenFieldLotReferenceOnAllocationIsNotSet()
        {
            // Arrange
            SetupEsfContract();
            EsfContract.contract.contracts[0].contractAllocations.ForEach(ca => ca.lotReference = null);
            var rules = ConditionalRuleExtractor.CreateConditionalRules(EsfContract);

            // Act
            List<string> failures = new List<string>();
            foreach(var rule in rules.Where(x => x.ErrorLevel == errorInfoTypeLevel.Allocation))
            {
                var testFailures = rule.GetFailuresForItem(EsfContract);
                failures.AddRange(testFailures);
            }

            // Assert
            Assert.IsFalse(failures.Any());
        }

        [TestMethod, TestCategory("UnitTest")]
        public void ShouldNotCreateError_WhenFieldLotReferenceOnAllocationIsSet()
        {
            // Arrange
            SetupEsfContract();
            var rules = ConditionalRuleExtractor.CreateConditionalRules(EsfContract);

            // Act
            List<string> failures = new List<string>();
            foreach (var rule in rules.Where(x => x.ErrorLevel == errorInfoTypeLevel.Allocation))
            {
                var testFailures = rule.GetFailuresForItem(EsfContract);
                failures.AddRange(testFailures);
            }

            // Assert
            Assert.IsFalse(failures.Any());
        }

        private void SetupEsfContract()
        {
            EsfContract.contract.fundingTypeCode = "ESF";
            EsfContract.contract.contracts[0].fundingTypeCode = "ESF";
            EsfContract.contract.contracts[0].contractAllocations.ForEach(ca => ca.lotReference = "lotReference");
            EsfContract.contract.contracts[0].contractAllocations.ForEach(ca => ca.LEPCode = "lepCode");
        }

        [TestMethod, TestCategory("UnitTest")]
        public void ShouldCreateErrorWhenContractIsNumberSetForNewContractIntent()
        {
     
            const string propertyName = "contractNumber";
            const string CrmIntent = "CRMIntent";

            ConditionalDataItem conditionalDataItem = new ConditionalDataItem(propertyName, CrmIntent, new List<object> { intent.New },
                true, errorInfoTypeLevel.Allocation);

            var masterContract = Contract.contract;
            masterContract.CRMIntent = intent.New;
            masterContract.correlationId = "Some XX";
            masterContract.contractNumber = "some number";
            PropertyExtractor propertyExtractor = new PropertyExtractor(masterContract, propertyName, intent.New, new List<object> { intent.New });
            ConditionalMandatoryFieldsRule conditionalMandatoryFieldsRule = new ConditionalMandatoryFieldsRule(conditionalDataItem, propertyExtractor, errorInfoTypeLevel.MasterContract);

            Assert.IsTrue(conditionalMandatoryFieldsRule.GetFailuresForItem(Contract).Any());
        }
    }
}