namespace ContractCreateDomain.Tests.ValidationTests.Deliverable
{
    using System.Linq;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using SFA.FCT.ContractCreateDomain.BusinessLogic.Validation.Rules.Deliverable;

    /// <summary>
    /// Rule DBR-002
    /// </summary>
    [TestClass]
    public class DeliverableNotValidForFundingTypeRuleTests : ContractRequestValidationBase
    {
        private DeliverableNotValidForFundingStreamPeriodRule _validator;

        [TestInitialize]
        public void Startup()
        {
            _validator = new DeliverableNotValidForFundingStreamPeriodRule(DeliverableMetaData);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void Ensure_AValid_Deliverable_With_ValidFsp_CanBeValidated()
        {
            Assert.IsFalse(_validator.GetFailuresForItem(Contract).Any());
        }

        [TestMethod, TestCategory("UnitTest")]
        public void Ensure_AnInvalid_Deliverable_With_NoFsp_FailsValidation()
        {
            Contract.GetAllocations().First().fundingStreamPeriodCode = "Invalid";
            Assert.IsTrue(_validator.GetFailuresForItem(Contract).Any());
        }

    }
}
