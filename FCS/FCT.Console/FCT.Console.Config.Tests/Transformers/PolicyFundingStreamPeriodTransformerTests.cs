namespace FCT.Console.Config.Tests.Transformers
{
    using System.Collections.Generic;
    using System.Linq;
    using Config.Transformers;
    using ExcelTypes;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using SFA.FCT.PaymentManagementDomain.PolicyCache.DataStore.Model;

    [TestClass]
    public class PolicyFundingStreamPeriodTransformerTests
    {
        [TestMethod, TestCategory("IntegrationTest")]
        public void PolicyFundingStreamPeriodTransformer_ShouldTransformCorrectly()
        {
            // arrange
            IList<FundingStreamPeriodSheetType> configSheetObjects = new List<FundingStreamPeriodSheetType>
            {
                new FundingStreamPeriodSheetType
                {
                    FundingStreamPeriodCode = "16-18APPS1516",
                    Name = "16-18 Apprenticeships",
                    FundingStreamCode = "16-18 APPS",
                    PaymentCappingPeriod = "Financial Year",
                    PaymentCappingLevel = "Deliverable Group",
                    PaymentMethod = "Pay on Actuals"
                },
                new FundingStreamPeriodSheetType
                {
                    FundingStreamPeriodCode = "16-18APPS1516",
                    Name = "16-18 Apprenticeships",
                    FundingStreamCode = "16-18 APPS",
                    PaymentCappingPeriod = "Contract Allocation Duration",
                    PaymentCappingLevel = "Deliverable Group",
                    PaymentMethod = "Paid Externally"
                },
                new FundingStreamPeriodSheetType
                {
                    FundingStreamPeriodCode = "NCS-P1718",
                    Name = "NCS In Custody 17-18",
                    FundingStreamCode = "NCS-P",
                    PaymentMethod = "Not Calculated or Paid"
                }
            };
           
            // act
            PolicyFundingStreamPeriod[] policyFundingStreamPeriods =
                PolicyFundingStreamPeriodTransformer.TransformCollection(configSheetObjects).ToArray();

            // assert
            Assert.IsTrue(policyFundingStreamPeriods.Count() == 3);
            Assert.AreEqual(PaymentMethod.PayOnActuals, policyFundingStreamPeriods[0].PaymentMethod);
            Assert.AreEqual(PaymentMethod.NoPay, policyFundingStreamPeriods[1].PaymentMethod);
            Assert.AreEqual(PaymentMethod.NoCalcAndNoPay, policyFundingStreamPeriods[2].PaymentMethod);
        }
    }
}
