namespace FCT.Console.Config.Tests.Transformers
{
    using System.Collections.Generic;
    using System.Linq;
    using Config.Transformers;
    using ExcelTypes;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using SFA.FCT.AllocationDeliveryDomain.Common.DataStore.Model;

    [TestClass]
    public class MonitoringDeliverablesFundingStreamPeriodTransformerTests
    {
        [TestMethod, TestCategory("UnitTest")]
        public void MonitoringDelsFspTransformer_TransformCollection_CorrectlyTransformsCollection()
        {
            // arrange
            IEnumerable<FundingStreamPeriodSheetType> inputs = new List<FundingStreamPeriodSheetType>()
            {
                CreateFspSheetTypeWithPaymentMethod("Pay on Profile"),
                CreateFspSheetTypeWithPaymentMethod("Pay on Actuals"),
                CreateFspSheetTypeWithPaymentMethod("Pay on Instruction"),
                CreateFspSheetTypeWithPaymentMethod("Paid Externally"),
            };

            // act
            List<FundingStreamPeriod> outputs =
                MonitoringDeliverablesFundingStreamPeriodTransformer.TransformCollection(inputs).ToList();

            // assert
            Assert.AreEqual(outputs[0].PaymentMethod, FundingStreamPeriodPaymentMethod.PayOnProfile);
            Assert.AreEqual(outputs[1].PaymentMethod, FundingStreamPeriodPaymentMethod.PayOnActuals);
            Assert.AreEqual(outputs[2].PaymentMethod, FundingStreamPeriodPaymentMethod.PayOnInstruction);
            Assert.AreEqual(outputs[3].PaymentMethod, FundingStreamPeriodPaymentMethod.PaidExternally);
        }

        private static FundingStreamPeriodSheetType CreateFspSheetTypeWithPaymentMethod(string payMethod)
        {
            return new FundingStreamPeriodSheetType
            {
                FundingStreamPeriodCode = "TEST1617",
                Name = "Test 16-17",
                PeriodTypeCode = "AY",
                Period = "1617",
                StartDate = new System.DateTime(2016,8,1),
                EndDate = new System.DateTime(2017,7,31),
                FundingStreamCode = "TEST",
                AllocationReferencePrefix = "T",
                ProcessFutureActuals = false,
                PersistCurrentActualsState = false,
                PaymentMethod = payMethod,
                PaymentCappingLevel = "Allocation",
                PaymentCappingPeriod = "Financial Year",
                DummyAccountCode = "ZZZZ99",
                Element1DefaultValue = "TST12",
                ControlAccountCode = 1238094,
                PolicyStatus = PolicyStatus.Approved,
                ShouldCapPayments = false,
                ZeroiseMissingActuals = false,
                MultiCollectionReturns = false
            };
        }
    }
}