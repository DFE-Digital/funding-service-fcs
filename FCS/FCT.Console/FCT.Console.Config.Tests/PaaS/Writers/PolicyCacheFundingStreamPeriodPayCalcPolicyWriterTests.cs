namespace FCT.Console.Config.Tests.PaaS.Writers
{
    using System.Linq;
    using ExcelTypes;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using SFA.FCT.PaymentManagementDomain.PolicyCache.DataStore;
    using SFA.FCT.PaymentManagementDomain.PolicyCache.DataStore.Model;
    using Synchronizers.Writers;
    using Synchronizers.Writers.PAAS;
    using UnitTests.Common;

    [TestClass]
    public class PolicyCacheFundingStreamPeriodPayCalcPolicyWriterTests
    {
        [TestMethod, TestCategory("IntegrationTest")]
        public void PolicyCacheFundingStreamPeriodPayCalcPolicyWriter_ShouldWriteRowToStorage()
        {
            const string fsp = "TEST-FSP";
            const int calcPolicyVersion = 2;

            // arrange
            using (var context = new PaymentManagementPolicyContext())
            {
                context.FundingStreamPeriodPayCalcPolicies.RemoveWhere(f => f.FundingStreamPeriodCode == fsp && f.CalcPolicyVersion == calcPolicyVersion);
                context.PolicyFundingStreamPeriods.RemoveWhere(f => f.FundingStreamPeriod == fsp);
                context.PolicyFundingStreamPeriods.Add(new PolicyFundingStreamPeriod
                {
                    FundingStreamPeriod = fsp
                });
                context.SaveChanges();
            }

            var sheet = new FundingStreamPeriodPayCalcPolicySheetType
            {
                PolicyStatus = PolicyStatus.Approved,
                FundingStreamPeriodCode = fsp,
                CalcPolicyVersion = calcPolicyVersion,
                PaymentCappingPeriod = "Contract Allocation Duration"
            };

            // act
            PolicyCacheFundingStreamPeriodPayCalcPolicyWriter.WriteToPaasDatabase(new[] { sheet }, WriterBehaviour.AddOrUpdate);

            // assert
            using (var context = new PaymentManagementPolicyContext())
            {
                FundingStreamPeriodPayCalcPolicy storedEntity = context.FundingStreamPeriodPayCalcPolicies.SingleOrDefault(f => f.FundingStreamPeriodCode == fsp && f.CalcPolicyVersion == calcPolicyVersion);

                Assert.IsNotNull(storedEntity, "Entity not stored");
                Assert.AreEqual(fsp, storedEntity.FundingStreamPeriodCode, "FundingStreamPeriodCode incorrect");
                Assert.AreEqual(calcPolicyVersion, storedEntity.CalcPolicyVersion, "CalcPolicyVersion incorrect");
                Assert.AreEqual(PaymentCappingPeriodType.ContractDuration, storedEntity.PaymentCappingPeriod, "PaymentCappingPeriod incorrect");

                // clear down
                context.PolicyFundingStreamPeriods.RemoveWhere(f => f.FundingStreamPeriod == fsp);
                context.SaveChanges();
            }
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void PolicyCacheFundingStreamPeriodPayCalcPolicyWriter_ShouldUpdateRowInStorage()
        {
            const string fsp = "TEST-FSP";
            const int calcPolicyVersion = 2;

            // arrange
            using (var context = new PaymentManagementPolicyContext())
            {
                context.PolicyFundingStreamPeriods.RemoveWhere(f => f.FundingStreamPeriod == fsp);
                context.SaveChanges();
                context.PolicyFundingStreamPeriods.Add(new PolicyFundingStreamPeriod
                {
                    FundingStreamPeriod = fsp
                });
                context.FundingStreamPeriodPayCalcPolicies.Add(new FundingStreamPeriodPayCalcPolicy
                {
                    FundingStreamPeriodCode = fsp,
                    CalcPolicyVersion = calcPolicyVersion,
                    PaymentCappingPeriod = PaymentCappingPeriodType.ContractDuration
                });
//                (fsp, calcPolicyVersion, PaymentCappingPeriodType.ContractDuration));
                context.SaveChanges();
            }

            var sheet = new FundingStreamPeriodPayCalcPolicySheetType
            {
                PolicyStatus = PolicyStatus.Approved,
                FundingStreamPeriodCode = fsp,
                CalcPolicyVersion = 2,
                PaymentCappingPeriod = "Financial Year"
            };

            // act
            PolicyCacheFundingStreamPeriodPayCalcPolicyWriter.WriteToPaasDatabase(new[] { sheet }, WriterBehaviour.AddOrUpdate);

            // assert
            using (var context = new PaymentManagementPolicyContext())
            {
                FundingStreamPeriodPayCalcPolicy storedEntity = context.FundingStreamPeriodPayCalcPolicies.SingleOrDefault(f => f.FundingStreamPeriodCode == fsp && f.CalcPolicyVersion == calcPolicyVersion);

                Assert.IsNotNull(storedEntity, "Entity not stored");
                Assert.AreEqual(fsp, storedEntity.FundingStreamPeriodCode, "FundingStreamPeriodCode incorrect");
                Assert.AreEqual(calcPolicyVersion, storedEntity.CalcPolicyVersion, "CalcPolicyVersion incorrect");
                Assert.AreEqual(PaymentCappingPeriodType.FinancialYear, storedEntity.PaymentCappingPeriod, "PaymentCappingPeriod incorrect");

                // clear down
                context.PolicyFundingStreamPeriods.RemoveWhere(f => f.FundingStreamPeriod == fsp);
                context.SaveChanges();
            }
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void PolicyCacheFundingStreamPeriodPayCalcPolicyWriter_ShouldDeleteRowFromStorage()
        {
            const string fsp = "TEST-FSP";
            const int calcPolicyVersion = 2;

            // arrange
            using (var context = new PaymentManagementPolicyContext())
            {
                context.PolicyFundingStreamPeriods.RemoveWhere(f => f.FundingStreamPeriod == fsp);
                context.SaveChanges();
                context.PolicyFundingStreamPeriods.Add(new PolicyFundingStreamPeriod
                {
                    FundingStreamPeriod = fsp
                });
                context.FundingStreamPeriodPayCalcPolicies.Add(new FundingStreamPeriodPayCalcPolicy
                {
                    FundingStreamPeriodCode = fsp,
                    CalcPolicyVersion = calcPolicyVersion,
                    PaymentCappingPeriod = PaymentCappingPeriodType.ContractDuration
                });
//                (fsp, calcPolicyVersion, PaymentCappingPeriodType.ContractDuration));
                context.SaveChanges();
            }

            var sheet = new FundingStreamPeriodPayCalcPolicySheetType
            {
                PolicyStatus = PolicyStatus.Removed,
                FundingStreamPeriodCode = fsp,
                CalcPolicyVersion = calcPolicyVersion,
                PaymentCappingPeriod = "Financial Year"
            };

            // act
            PolicyCacheFundingStreamPeriodPayCalcPolicyWriter.WriteToPaasDatabase(new[] { sheet }, WriterBehaviour.Delete);

            // assert
            using (var context = new PaymentManagementPolicyContext())
            {
                FundingStreamPeriodPayCalcPolicy storedEntity = context.FundingStreamPeriodPayCalcPolicies.SingleOrDefault(f => f.FundingStreamPeriodCode == fsp && f.CalcPolicyVersion == calcPolicyVersion);

                Assert.IsNull(storedEntity, "Entity still present in storage");

                // clear down
                context.PolicyFundingStreamPeriods.RemoveWhere(f => f.FundingStreamPeriod == fsp);
                context.SaveChanges();
            }
        }
    }
}
