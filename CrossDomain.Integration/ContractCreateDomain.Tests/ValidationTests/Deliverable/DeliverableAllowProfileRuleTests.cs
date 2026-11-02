namespace ContractCreateDomain.Tests.ValidationTests.Deliverable
{
    using System;
    using System.Collections.Generic;
    using System.Linq;
    using ContractManagement.DataStore.Model;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using SFA.FCT.ContractCreateDomain.BusinessLogic.Validation.Rules.Deliverable;
    using SFA.FCT.CrossDomain.Integration.Entities.ContractRequest;

    /// <summary>
    /// Rule DBR-015
    /// </summary>
    [TestClass]
    public class DeliverableAllowProfileRuleTests : ContractRequestValidationBase
    {
        private const string FundingStreamPeriodCode = "16-18APPS1516";

        [TestMethod, TestCategory("UnitTest")]
        public void DeliverableAllowProfileRule_ShouldFailIfADeliverableIsNotProfile()
        {
            // Arrange
            var contract = new contractType();

            Contract.contract.startDate = new DateTime(2014, 7, 1);
            Contract.contract.endDate = new DateTime(2015, 6, 1);

            var allocation = new contractAllocation()
            {
                startDate = new DateTime(2014, 7, 1),
                endDate = new DateTime(2015, 6, 1),
                fundingStreamCode = "16-18 APPS",
                fundingStreamPeriodCode = FundingStreamPeriodCode // "16-18APPS1516"
            };

            var deliverableA = new contractDeliverable()
            {
                deliverable = new deliverableType()
                {
                    deliverableCode = 1
                }
            };
            for (DateTime periodDate = (DateTime)Contract.contract.startDate; periodDate <= Contract.contract.endDate; periodDate = periodDate.AddMonths(1))
            {
                deliverableA.contractDeliverablePeriods.Add(new contractDeliverablePeriodType()
                {
                    aggregate = false,
                    period = periodDate.Month,
                    year = periodDate.Year,
                    plannedValue = 20
                });
            }
            allocation.contractDeliverables.Add(deliverableA);

            var deliverableB = new contractDeliverable()
            {
                deliverable = new deliverableType()
                {
                    deliverableCode = 4
                }
            };
            for (DateTime periodDate = (DateTime)Contract.contract.startDate; periodDate <= Contract.contract.endDate; periodDate = periodDate.AddMonths(1))
            {
                deliverableB.contractDeliverablePeriods.Add(new contractDeliverablePeriodType()
                {
                    aggregate = false,
                    period = periodDate.Month,
                    year = periodDate.Year,
                    plannedValue = 20
                });
            }
            allocation.contractDeliverables.Add(deliverableB);

            contract.contractAllocations.Add(allocation);

            Contract.contract.contracts.Clear();
            Contract.contract.contracts.Add(contract);

            IReadOnlyCollection<FundingStreamPeriodLegalDeliverable> validFspDeliverables =
                new List<FundingStreamPeriodLegalDeliverable>
                {
                    new FundingStreamPeriodLegalDeliverable(allocation.fundingStreamPeriodCode, deliverableB.deliverable.deliverableCode, true, "", 0)
                };

            DeliverableAllowProfileRule rule = new DeliverableAllowProfileRule(validFspDeliverables);

            Assert.IsTrue(rule.GetFailuresForItem(Contract).Any(), "Validation Rule captured profile the is not allowed");
        }

        [TestMethod, TestCategory("UnitTest")]
        public void DeliverableAllowProfileRule_ShouldPassIfAllDeliverablesAllowProfile()
        {
            // Arrange
            var contract = new contractType();

            Contract.contract.startDate = new DateTime(2014, 7, 1);
            Contract.contract.endDate = new DateTime(2015, 6, 1);

            var allocation = new contractAllocation()
            {
                startDate = new DateTime(2014, 7, 1),
                endDate = new DateTime(2015, 6, 1),
                fundingStreamCode = "16-18 APPS",
                fundingStreamPeriodCode = FundingStreamPeriodCode // "16-18APPS1516"
            };

            var deliverableA = new contractDeliverable()
            {
                deliverable = new deliverableType()
                {
                    deliverableCode = 1
                }
            };
            for (DateTime periodDate = (DateTime)Contract.contract.startDate; periodDate <= Contract.contract.endDate; periodDate = periodDate.AddMonths(1))
            {
                deliverableA.contractDeliverablePeriods.Add(new contractDeliverablePeriodType()
                {
                    aggregate = false,
                    period = periodDate.Month,
                    year = periodDate.Year,
                    plannedValue = 20
                });
            }
            allocation.contractDeliverables.Add(deliverableA);

            var deliverableB = new contractDeliverable()
            {
                deliverable = new deliverableType()
                {
                    deliverableCode = 4
                }
            };
            for (DateTime periodDate = (DateTime)Contract.contract.startDate; periodDate <= Contract.contract.endDate; periodDate = periodDate.AddMonths(1))
            {
                deliverableB.contractDeliverablePeriods.Add(new contractDeliverablePeriodType()
                {
                    aggregate = false,
                    period = periodDate.Month,
                    year = periodDate.Year,
                    plannedValue = 20
                });
            }
            allocation.contractDeliverables.Add(deliverableB);

            contract.contractAllocations.Add(allocation);

            Contract.contract.contracts.Clear();
            Contract.contract.contracts.Add(contract);

            IReadOnlyCollection<FundingStreamPeriodLegalDeliverable> validFspDeliverables =
                new List<FundingStreamPeriodLegalDeliverable>
                {
                    new FundingStreamPeriodLegalDeliverable(allocation.fundingStreamPeriodCode, deliverableB.deliverable.deliverableCode, true, "", 0),
                    new FundingStreamPeriodLegalDeliverable(allocation.fundingStreamPeriodCode, deliverableA.deliverable.deliverableCode, true, "", 0)
                };

            DeliverableAllowProfileRule rule = new DeliverableAllowProfileRule(validFspDeliverables);

            Assert.IsFalse(rule.GetFailuresForItem(Contract).Any(), "Validation Rule should pass when all deliverables are allow profile");
        }
    }
}