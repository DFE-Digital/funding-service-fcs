namespace FCT.Console.Config.Tests.Transformers
{
    using System;
    using System.Collections.Generic;
    using System.Linq;
    using Config.Transformers;
    using ExcelTypes;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using SFA.FCT.PerformanceManagementDomain.DataStore.Models;

    [TestClass]
    public class PerfMgmtFundingStreamPeriodTransformerTests
    {
        [TestMethod, TestCategory("UnitTest")]
        public void PerfMgmtFundingStreamPeriodTransformer_ConvertToPerfMgmtFundingStreamPeriod_IsPayOnProfile()
        {
            // arrange
            List<FundingStreamPeriodSheetType> fspSheetTypes = new List<FundingStreamPeriodSheetType>
            {
                new FundingStreamPeriodSheetType
                {
                    FundingStreamPeriodCode = "TESTCODE1",
                    Name = "Test FSP Code 1",
                    Period = "1516",
                    FundingStreamCode = "TEST",
                    AllocationReferencePrefix = "TST",
                    StartDate = new DateTime(2017, 1, 1),
                    EndDate = new DateTime(2018, 1, 1),
                    DummyAccountCode = "",
                    ControlAccountCode = 1,
                    Element1DefaultValue = "",
                    CreatedDate = new DateTime(2017, 1, 1),
                    PaymentCappingLevel = "",
                    PaymentCappingPeriod = "1516",
                    PaymentMethod = "Pay on Profile",
                    ShouldCapPayments = false,
                    Procurement = "",
                    ProcessFutureActuals = false,
                    PersistCurrentActualsState = false,
                    ZeroiseMissingActuals = false,
                    ActivityCloseDate = null,
                    SummaryOfFundingDisplayName = "",
                    ContractDocumentDisplayOrder = 1,
                    GeneratePayments = false
                }
            };

            IReadOnlyCollection<FundingStreamPeriod> perfMgmtFsps =
                PerfMgmtFundingStreamPeriodTransformer.TransformCollection(fspSheetTypes).ToList();

            Assert.AreEqual(fspSheetTypes.Count, perfMgmtFsps.Count);
            Assert.AreEqual(fspSheetTypes[0].FundingStreamPeriodCode, perfMgmtFsps.First().FundingStreamPeriodCode);
            Assert.IsTrue(perfMgmtFsps.First().IsPayOnProfile);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void PerfMgmtFundingStreamPeriodTransformer_ConvertToPerfMgmtFundingStreamPeriod_IsNotPayOnProfile()
        {
            // arrange
            List<FundingStreamPeriodSheetType> fspSheetTypes = new List<FundingStreamPeriodSheetType>
            {
                new FundingStreamPeriodSheetType
                {
                    FundingStreamPeriodCode = "TESTCODE1",
                    Name = "Test FSP Code 1",
                    Period = "1516",
                    FundingStreamCode = "TEST",
                    AllocationReferencePrefix = "TST",
                    StartDate = new DateTime(2017, 1, 1),
                    EndDate = new DateTime(2018, 1, 1),
                    DummyAccountCode = "",
                    ControlAccountCode = 1,
                    Element1DefaultValue = "",
                    CreatedDate = new DateTime(2017, 1, 1),
                    PaymentCappingLevel = "",
                    PaymentCappingPeriod = "1516",
                    PaymentMethod = "Pay on Actuals",
                    ShouldCapPayments = false,
                    Procurement = "",
                    ProcessFutureActuals = false,
                    PersistCurrentActualsState = false,
                    ZeroiseMissingActuals = false,
                    ActivityCloseDate = null,
                    SummaryOfFundingDisplayName = "",
                    ContractDocumentDisplayOrder = 1,
                    GeneratePayments = false
                }
            };

            IReadOnlyCollection<FundingStreamPeriod> perfMgmtFsps =
                PerfMgmtFundingStreamPeriodTransformer.TransformCollection(fspSheetTypes).ToList();

            Assert.AreEqual(fspSheetTypes.Count, perfMgmtFsps.Count);
            Assert.AreEqual(fspSheetTypes[0].FundingStreamPeriodCode, perfMgmtFsps.First().FundingStreamPeriodCode);
            Assert.IsFalse(perfMgmtFsps.First().IsPayOnProfile);
        }
    }
}