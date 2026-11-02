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
    public class PolicyCacheFundingStreamPeriodCappingPeriodPayCalcPolicyWriterTests
    {
        [TestMethod, TestCategory("IntegrationTest")]
        public void PolicyCacheFundingStreamPeriodCappingPeriodPayCalcPolicyWriter_ShouldWriteRow()
        {
            const string fsp = "fsp-CappingPeriodPayCalcAdd";
            const int calcPolicyVersion = 2;
            const int cappingPeriod = 99;
            const decimal overDeliveryLimit = 17.99M;

            // arrange
            using (var context = new PaymentManagementPolicyContext())
            {
                context.FundingStreamPeriodCappingPeriodPayCalcPolicies.RemoveWhere(f => f.FundingStreamPeriodCode == fsp && f.CalcPolicyVersion == calcPolicyVersion);
                context.FundingStreamPeriodPayCalcPolicies.RemoveWhere(f => f.FundingStreamPeriodCode == fsp && f.CalcPolicyVersion == calcPolicyVersion);
                context.PolicyFundingStreamPeriods.RemoveWhere(f => f.FundingStreamPeriod == fsp);
                context.PolicyFundingStreamPeriods.Add(new PolicyFundingStreamPeriod
                {
                    FundingStreamPeriod = fsp
                });

                context.SaveChanges();

                context.FundingStreamPeriodPayCalcPolicies.Add(
                    new FundingStreamPeriodPayCalcPolicy
                    {
                        FundingStreamPeriodCode = fsp,
                        CalcPolicyVersion = calcPolicyVersion,
                        PaymentCappingPeriod = PaymentCappingPeriodType.ContractDuration
                    });

                context.SaveChanges();
            }

            var sheet = new FundingStreamPeriodCappingPeriodPayCalcPolicySheetType
            {
                PolicyStatus = PolicyStatus.Approved,
                FundingStreamPeriodCode = fsp,
                CalcPolicyVersion = calcPolicyVersion,
                CappingPeriod = cappingPeriod,
                OverDeliveryLimit = overDeliveryLimit
            };

            // act
            PolicyCacheFundingStreamPeriodCappingPeriodPayCalcPolicyWriter.WriteToPaasDatabase(new[] { sheet }, WriterBehaviour.AddOrUpdate);

            // assert
            using (var context = new PaymentManagementPolicyContext())
            {
                var storedEntity = 
                    context.FundingStreamPeriodCappingPeriodPayCalcPolicies
                           .SingleOrDefault(f =>
                               f.FundingStreamPeriodCode == fsp &&
                               f.CalcPolicyVersion == calcPolicyVersion &&
                               f.CappingPeriod == cappingPeriod);

                Assert.IsNotNull(storedEntity, "Entity not stored");
                Assert.AreEqual(overDeliveryLimit, storedEntity.OverDeliveryLimit, "OverDeliveryLimit incorrect");

                // clear down 
                context.FundingStreamPeriodCappingPeriodPayCalcPolicies.RemoveWhere(f => f.FundingStreamPeriodCode == fsp && f.CalcPolicyVersion == calcPolicyVersion);
                context.FundingStreamPeriodPayCalcPolicies.RemoveWhere(f => f.FundingStreamPeriodCode == fsp && f.CalcPolicyVersion == calcPolicyVersion);
                context.PolicyFundingStreamPeriods.RemoveWhere(f => f.FundingStreamPeriod == fsp);

                context.SaveChanges();
            }
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void PolicyCacheFundingStreamPeriodCappingPeriodPayCalcPolicyWriter_ShouldUpdateRow()
        {
            const string fsp = "fsp-CappingPeriodPayCalcUpdate";
            const int calcPolicyVersion = 2;
            const int cappingPeriod = 99;
            const decimal overDeliveryLimitBefore = 99.99M;
            const decimal overDeliveryLimitAssert = 11.11M;

            // arrange
            using (var context = new PaymentManagementPolicyContext())
            {
                context.FundingStreamPeriodCappingPeriodPayCalcPolicies.RemoveWhere(f => f.FundingStreamPeriodCode == fsp && f.CalcPolicyVersion == calcPolicyVersion);
                context.FundingStreamPeriodPayCalcPolicies.RemoveWhere(f => f.FundingStreamPeriodCode == fsp && f.CalcPolicyVersion == calcPolicyVersion);
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
                
                context.FundingStreamPeriodCappingPeriodPayCalcPolicies.Add(
                    new FundingStreamPeriodCappingPeriodPayCalcPolicy(fsp,
                        calcPolicyVersion,
                        cappingPeriod,
                        overDeliveryLimitBefore));

                context.SaveChanges();
            }

            var sheet = new FundingStreamPeriodCappingPeriodPayCalcPolicySheetType
            {
                PolicyStatus = PolicyStatus.Approved,
                FundingStreamPeriodCode = fsp,
                CalcPolicyVersion = calcPolicyVersion,
                CappingPeriod = cappingPeriod,
                OverDeliveryLimit = overDeliveryLimitAssert
            };

            // act
            PolicyCacheFundingStreamPeriodCappingPeriodPayCalcPolicyWriter.WriteToPaasDatabase(new[] { sheet }, WriterBehaviour.AddOrUpdate);

            // assert
            using (var context = new PaymentManagementPolicyContext())
            {
                var storedEntity =
                    context.FundingStreamPeriodCappingPeriodPayCalcPolicies
                        .SingleOrDefault(f =>
                            f.FundingStreamPeriodCode == fsp &&
                            f.CalcPolicyVersion == calcPolicyVersion &&
                            f.CappingPeriod == cappingPeriod);

                Assert.IsNotNull(storedEntity, "Entity not stored");
                Assert.AreEqual(overDeliveryLimitAssert, storedEntity.OverDeliveryLimit, "OverDeliveryLimit incorrect");

                // clear down
                context.FundingStreamPeriodCappingPeriodPayCalcPolicies.RemoveWhere(f => f.FundingStreamPeriodCode == fsp && f.CalcPolicyVersion == calcPolicyVersion);
                context.FundingStreamPeriodPayCalcPolicies.RemoveWhere(f => f.FundingStreamPeriodCode == fsp && f.CalcPolicyVersion == calcPolicyVersion);
                context.PolicyFundingStreamPeriods.RemoveWhere(f => f.FundingStreamPeriod == fsp);
                context.SaveChanges();
            }
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void PolicyCacheFundingStreamPeriodCappingPeriodPayCalcPolicyWriter_ShouldDeleteRow()
        {
            const string fsp = "fsp-CappingPeriodPayCalcDelete";
            const int calcPolicyVersion = 2;
            const int cappingPeriod = 99;
            const decimal overDeliveryLimit = 99.99M;

            // arrange
            using (var context = new PaymentManagementPolicyContext())
            {
                context.FundingStreamPeriodCappingPeriodPayCalcPolicies.RemoveWhere(f => f.FundingStreamPeriodCode == fsp && f.CalcPolicyVersion == calcPolicyVersion);
                context.FundingStreamPeriodPayCalcPolicies.RemoveWhere(f => f.FundingStreamPeriodCode == fsp && f.CalcPolicyVersion == calcPolicyVersion);
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

                context.FundingStreamPeriodCappingPeriodPayCalcPolicies.Add(
                    new FundingStreamPeriodCappingPeriodPayCalcPolicy(fsp,
                        calcPolicyVersion,
                        cappingPeriod,
                        overDeliveryLimit));

                context.SaveChanges();
            }

            var sheet = new FundingStreamPeriodCappingPeriodPayCalcPolicySheetType
            {
                PolicyStatus = PolicyStatus.Removed,
                FundingStreamPeriodCode = fsp,
                CalcPolicyVersion = calcPolicyVersion,
                CappingPeriod = cappingPeriod,
                OverDeliveryLimit = overDeliveryLimit
            };

            // act
            PolicyCacheFundingStreamPeriodCappingPeriodPayCalcPolicyWriter.WriteToPaasDatabase(new[] { sheet }, WriterBehaviour.Delete);

            // assert
            using (var context = new PaymentManagementPolicyContext())
            {
                var storedEntity =
                    context.FundingStreamPeriodCappingPeriodPayCalcPolicies
                        .SingleOrDefault(f =>
                            f.FundingStreamPeriodCode == fsp &&
                            f.CalcPolicyVersion == calcPolicyVersion &&
                            f.CappingPeriod == cappingPeriod);

                Assert.IsNull(storedEntity, "Entity still present in storage");

                // clear down
                context.FundingStreamPeriodCappingPeriodPayCalcPolicies.RemoveWhere(f => f.FundingStreamPeriodCode == fsp && f.CalcPolicyVersion == calcPolicyVersion);
                context.FundingStreamPeriodPayCalcPolicies.RemoveWhere(f => f.FundingStreamPeriodCode == fsp && f.CalcPolicyVersion == calcPolicyVersion);
                context.PolicyFundingStreamPeriods.RemoveWhere(f => f.FundingStreamPeriod == fsp);
                context.SaveChanges();
            }
        }
    }
}