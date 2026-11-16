using System.Collections.Generic;
using System.Linq;
using Castle.Core.Internal;
using SFA.FCT.ContractCreateDomain.BusinessLogic.Validation.Rules;
using SFA.FCT.CrossDomain.Integration.Entities.ContractRequest;

namespace ContractCreateDomain.Tests.ValidationTests
{
    using SFA.FCT.ContractCreateDomain.BusinessLogic.Validation;
    using Microsoft.VisualStudio.TestTools.UnitTesting;

    [TestClass]
    public class MasterContractCrmIntentRuleTest : ContractRequestValidationBase
    {

        [TestMethod, TestCategory("UnitTest")]
        public void ShouldPassValidationWhenMasterContractIsValid()
        {
            Contract.contract.IsMasterContractWithMatchingMasterContractNumberPresentInCrm = true;
            MasterContractNewAmendmentRule validator = new MasterContractNewAmendmentRule(dto => true);
            Assert.IsFalse(validator.GetFailuresForItem(Contract).Any());
        }
        
        [TestMethod, TestCategory("UnitTest")]
        public void ShouldFailValidationWhenCrmIntentIsNewAndContractNumberIsProvided()
        {
            Contract.contract.contractNumber = "SFA-TEST";
            MasterContractNewIntentRule validator = new MasterContractNewIntentRule();
            Assert.IsTrue(validator.GetFailuresForItem(Contract).Any());
        }

        [TestMethod, TestCategory("UnitTest")]
        public void ShouldFailValidationWhenCrmIntentIsAmendmentAndContractNumberIsMissing()
        {
            Contract.contract.CRMIntent = Intent.NewAmendment;
            MasterContractNewAmendmentRule validator = new MasterContractNewAmendmentRule(dto => true);
            Assert.IsTrue(validator.GetFailuresForItem(Contract).Any());
        }

        [TestMethod, TestCategory("UnitTest")]
        public void ShouldFailValidationWhenCrmIntentIsNewAmendmentAndMasterContractNumberIsNotInCrm()
        {
            Contract.contract.CRMIntent = Intent.NewAmendment;
            Contract.contract.IsMasterContractWithMatchingMasterContractNumberPresentInCrm = false;

            MasterContractNewAmendmentRule validator = new MasterContractNewAmendmentRule(dto => true);
            Assert.IsTrue(validator.GetFailuresForItem(Contract).Any());
        }
    }
}