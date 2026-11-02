namespace ContractCreateDomain.Tests.ValidationTests
{
    using System;
    using System.Collections.Generic;
    using System.Linq;
    using ContractManagement.DataStore.Model;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using SFA.FCT.ContractCreateDomain.BusinessLogic.Validation.Rules;
    using SFA.FCT.CrossDomain.Integration.Entities.ContractRequest;

    [TestClass]
    public class InvalidFSCRuleTests : ContractRequestValidationBase
    {
        private InvalidFundingStreamPeriodCodeRule _validator;
        private List<FundingTypePeriodFundingStreamPeriod> _ftpFspLookupData;

        [TestInitialize]
        public void StartUp()
        {
            _ftpFspLookupData = new List<FundingTypePeriodFundingStreamPeriod>
            {
                new FundingTypePeriodFundingStreamPeriod("24+LOANS", "AY1516", "24+ ALLF"),
                new FundingTypePeriodFundingStreamPeriod("24+LOANS", "AY1516", "24+ ALLBC"),
                new FundingTypePeriodFundingStreamPeriod("24+LOANS", "AY1516", "24+ ALLB"),
            };
            _validator = new InvalidFundingStreamPeriodCodeRule(_ftpFspLookupData);
            Contract.FundingConfiguration = new List<FundingConfigurationDataType>
            {
                new FundingConfigurationDataType()
                {
                    FundingTypeCode = "24+LOANS",
                    FundingStreamCode = "24+ ALLF",
                    FundingStreamName = "24+ Advanced Learning Loans Facility",
                    FundingStreamPeriodCode = "24+ALLF1516",
                    Period = "1516",
                    FundingPeriodStartDate = new DateTime(2015, 7, 31),
                    FundingPeriodEndDate = new DateTime(2016, 7, 30),
                    PeriodTypeName = "Academic Year",
                    PeriodTypeCode = "AY"
                },
                new FundingConfigurationDataType()
                {
                    FundingTypeCode = "24+LOANS",
                    FundingStreamCode = "24+ ALLBC",
                    FundingStreamName = "24+ Advanced Learning Loans Bursary (College)",
                    FundingStreamPeriodCode = "24+ALLBC1516",
                    Period = "1516",
                    FundingPeriodStartDate = new DateTime(2015, 7, 31),
                    FundingPeriodEndDate = new DateTime(2016, 7, 30),
                    PeriodTypeName = "Academic Year",
                    PeriodTypeCode = "AY"
                },
                new FundingConfigurationDataType()
                {
                    FundingTypeCode = "24+LOANS",
                    FundingStreamCode = "24+ ALLB",
                    FundingStreamName = "24+ Advanced Learning Loans Bursary",
                    FundingStreamPeriodCode = "24+ALLB1516",
                    Period = "1516",
                    FundingPeriodStartDate = new DateTime(2015, 7, 31),
                    FundingPeriodEndDate = new DateTime(2016, 7, 30),
                    PeriodTypeName = "Academic Year",
                    PeriodTypeCode = "AY"
                }
            };
            Contract.contract.contracts[0].period = new periodType
            {
                period = "1516",
                periodType1 = new periodTypeType
                {
                    periodTypeCode = "AY"
                }
            };
        }

        [TestMethod, TestCategory("UnitTest")]
        public void EnsureAnInvalidFundingTypeCodeIsValidated()
        {
            Contract.contract.fundingTypeCode = "Invalid";

            var expectedErrorCorrelationIds = Contract.contract.contracts.First().contractAllocations.Select(a => a.correlationId).ToList();

            var errorCorrelationIds = _validator.GetFailuresForItem(Contract);

            Assert.IsNotNull(errorCorrelationIds);
            CollectionAssert.AreEquivalent(expectedErrorCorrelationIds, errorCorrelationIds.ToList());
        }

        [TestMethod, TestCategory("UnitTest")]
        public void EnsureAnInvalidFundingStreamCodeIsValidated()
        {
            var allocation = Contract.contract.contracts.First().contractAllocations.First();

            allocation.fundingStreamCode = "Invalid";

            var expectedErrorCorrelationIds = new List<string> {allocation.correlationId};

            var errorCorrelationIds = _validator.GetFailuresForItem(Contract);

            Assert.IsNotNull(errorCorrelationIds);
            CollectionAssert.AreEquivalent(expectedErrorCorrelationIds, errorCorrelationIds.ToList());
        }

        [TestMethod, TestCategory("UnitTest")]
        public void EnsureAnValidFundingStreamCodeIsValidated()
        {
            Assert.IsFalse(_validator.GetFailuresForItem(Contract).Any());
        }

        [TestMethod, TestCategory("UnitTest")]
        public void InvalidFundingStreamPeriodCodeRule_GetFailuresForItem_ShouldReturnFailureForInvalidPeriod()
        {
            var contract = Contract.contract.contracts.First();

            contract.period.period = "Invalid";

            var expectedErrorCorrelationIds = contract.contractAllocations.Select(a => a.correlationId).ToList();

            var errorCorrelationIds = _validator.GetFailuresForItem(Contract);

            Assert.IsNotNull(errorCorrelationIds);
            CollectionAssert.AreEquivalent(expectedErrorCorrelationIds, errorCorrelationIds.ToList());
        }

        [TestMethod, TestCategory("UnitTest")]
        public void InvalidFundingStreamPeriodCodeRule_GetFailuresForItem_ShouldReturnFailureForInvalidPeriodType()
        {
            var contract = Contract.contract.contracts.First();

            contract.period.periodType1.periodTypeCode = "Invalid";

            var expectedErrorCorrelationIds = contract.contractAllocations.Select(a => a.correlationId).ToList();

            var errorCorrelationIds = _validator.GetFailuresForItem(Contract);

            Assert.IsNotNull(errorCorrelationIds);
            CollectionAssert.AreEquivalent(expectedErrorCorrelationIds, errorCorrelationIds.ToList());
        }
    }
}
