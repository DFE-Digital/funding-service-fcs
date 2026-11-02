namespace ContractCreateDomain.Tests.ValidationTests
{
    using System.Collections.Generic;
    using System.Linq;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using SFA.FCT.ContractCreateDomain.BusinessLogic.Validation.Rules;
    using SFA.FCT.CrossDomain.Integration.Entities.ContractRequest;

    [TestClass]
    public class MandatoryEntitiesRuleTest : ContractRequestValidationBase
    {
        [TestMethod, TestCategory("UnitTest")]
        public void MandatoryEntitiesRule_ShouldPassValidationWhenContractIsValid()
        {
            MandatoryEntitiesRule validator = new MandatoryEntitiesRule();
            Assert.IsFalse(validator.GetFailuresForItem(Contract).Any());
        }

        [TestMethod, TestCategory("UnitTest")]
        public void MandatoryEntitiesRule_ShouldFailValidationWhenContractsAreMissing()
        {
            Contract.contract.contracts = new List<contractType>();
            MandatoryEntitiesRule validator = new MandatoryEntitiesRule();
            Assert.IsTrue(validator.GetFailuresForItem(Contract).Any());
        }

        [TestMethod, TestCategory("UnitTest")]
        public void MandatoryEntitiesRule_ShouldFailValidationWhenContractsAreMissingAndFundingTypeIsLevy()
        {
            Contract.contract.fundingTypeCode = "LEVY";
            Contract.contract.contracts = new List<contractType>();
            MandatoryEntitiesRule validator = new MandatoryEntitiesRule();
            Assert.IsTrue(validator.GetFailuresForItem(Contract).Any());
        }

        [TestMethod, TestCategory("UnitTest")]
        public void MandatoryEntitiesRule_ShouldFailValidationWhenAllocationsAreMissing()
        {
            foreach (var contract in Contract.contract.contracts)
            {
                contract.contractAllocations = new List<contractAllocation>();
            }
            MandatoryEntitiesRule validator = new MandatoryEntitiesRule();
            Assert.IsTrue(validator.GetFailuresForItem(Contract).Any());
        }

        [TestMethod, TestCategory("UnitTest")]
        public void MandatoryEntitiesRule_ShouldFailValidationWhenAllocationsAreMissingAndFundingTypeIsLevy()
        {
            Contract.contract.fundingTypeCode = "LEVY";
            foreach (var contract in Contract.contract.contracts)
            {
                contract.contractAllocations = new List<contractAllocation>();
            }
            MandatoryEntitiesRule validator = new MandatoryEntitiesRule();
            Assert.IsTrue(validator.GetFailuresForItem(Contract).Any());
        }

        [TestMethod, TestCategory("UnitTest")]
        public void MandatoryEntitiesRule_ShouldFailValidationWhenDeliverablesAreMissing()
        {
            foreach (var contract in Contract.contract.contracts)
            {
                foreach (var allocation in contract.contractAllocations)
                {
                    allocation.contractDeliverables = new List<contractDeliverable>();
                }
            }
            MandatoryEntitiesRule validator = new MandatoryEntitiesRule();
            Assert.IsTrue(validator.GetFailuresForItem(Contract).Any());
        }

        [TestMethod, TestCategory("UnitTest")]
        public void MandatoryEntitiesRule_ShouldFailValidationWhenDeliverablePeriodsAreMissing()
        {
            foreach (var contract in Contract.contract.contracts)
            {
                foreach (var allocation in contract.contractAllocations)
                {
                    foreach (var deliverable in allocation.contractDeliverables)
                    {
                        deliverable.contractDeliverablePeriods = new List<contractDeliverablePeriodType>();
                    }
                }
            }
            MandatoryEntitiesRule validator = new MandatoryEntitiesRule();
            Assert.IsTrue(validator.GetFailuresForItem(Contract).Any());
        }
    }
}
