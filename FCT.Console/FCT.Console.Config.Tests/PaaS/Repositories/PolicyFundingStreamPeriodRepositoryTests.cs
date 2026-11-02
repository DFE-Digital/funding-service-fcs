namespace FCT.Console.Config.Tests.PaaS.Repositories
{
    using System.Linq;
    using Dapper;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using SFA.FCT.PaymentManagementDomain.PolicyCache.DataStore;
    using SFA.FCT.PaymentManagementDomain.PolicyCache.DataStore.Model;
    using Synchronizers.PaaS.Repositories;

    [TestClass]
    public class PolicyFundingStreamPeriodRepositoryTests
    {
        [TestMethod, TestCategory("IntegrationTest")]
        public void PolicyFundingStreamPeriodRepository_UpdateIsPrioritisedApportionment_ShouldSetIsPrioritisedApportionmentToTrue()
        {
            // arrange
            const string fundingStreamPeriod = "IsPrioritisedApportionment1";
            ClearDownFspDeliverablesFromPolicyDeliverables(fundingStreamPeriod);
            ClearDownFspFromPolicyFundingStreamPeriods(fundingStreamPeriod);
            CreateFspFromPolicyFundingStreamPeriod(fundingStreamPeriod, false);
            CreatePolicyDeliverable(fundingStreamPeriod, 1, 1);
            CreatePolicyDeliverable(fundingStreamPeriod, 2, 2);

            using (var context = new PaymentManagementPolicyContext())
            {
                // act
                PolicyFundingStreamPeriodRepository.UpdateIsPrioritisedApportionment(context.Database.Connection);
            }

            // assert
            var policyFundingStreamPeriod = GetPolicyFundingStreamPeriod(fundingStreamPeriod);
            Assert.IsNotNull(policyFundingStreamPeriod, $"The fundingStreamPeriod '{fundingStreamPeriod}'does not exist");
            Assert.AreEqual(true, policyFundingStreamPeriod.IsPrioritisedApportionment, "The IsPrioritisedApportionment has not been set correctly");

            // clear down
            ClearDownFspDeliverablesFromPolicyDeliverables(fundingStreamPeriod);
            ClearDownFspFromPolicyFundingStreamPeriods(fundingStreamPeriod);
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void PolicyFundingStreamPeriodRepository_UpdateIsPrioritisedApportionment_ShouldSetIsPrioritisedApportionmentToFalse()
        {
            // arrange
            const string fundingStreamPeriod = "IsPrioritisedApportionment2";
            ClearDownFspDeliverablesFromPolicyDeliverables(fundingStreamPeriod);
            ClearDownFspFromPolicyFundingStreamPeriods(fundingStreamPeriod);
            CreateFspFromPolicyFundingStreamPeriod(fundingStreamPeriod, true);
            CreatePolicyDeliverable(fundingStreamPeriod, 1, 1);
            CreatePolicyDeliverable(fundingStreamPeriod, 2, null);

            using (var context = new PaymentManagementPolicyContext())
            {
                // act
                PolicyFundingStreamPeriodRepository.UpdateIsPrioritisedApportionment(context.Database.Connection);
            }

            // assert
            var policyFundingStreamPeriod = GetPolicyFundingStreamPeriod(fundingStreamPeriod);
            Assert.IsNotNull(policyFundingStreamPeriod, $"The fundingStreamPeriod '{fundingStreamPeriod}'does not exist");
            Assert.AreEqual(false, policyFundingStreamPeriod.IsPrioritisedApportionment, "The IsPrioritisedApportionment has not been set correctly");

            // clear down
            ClearDownFspDeliverablesFromPolicyDeliverables(fundingStreamPeriod);
            ClearDownFspFromPolicyFundingStreamPeriods(fundingStreamPeriod);
        }

        private static void ClearDownFspDeliverablesFromPolicyDeliverables(string fundingStreamPeriod)
        {
            using (var context = new PaymentManagementPolicyContext())
            {
                context.PolicyDeliverables
                    .Where(pd => pd.FundingStreamPeriod == fundingStreamPeriod).ToList()
                    .ForEach(pd => context.PolicyDeliverables.Remove(pd));

                context.SaveChanges();
            }
        }

        private static void ClearDownFspFromPolicyFundingStreamPeriods(string fundingStreamPeriod)
        {
            using (var context = new PaymentManagementPolicyContext())
            {
                context.PolicyFundingStreamPeriods
                    .Where(pfsp => pfsp.FundingStreamPeriod == fundingStreamPeriod).ToList()
                    .ForEach(pfsp => context.PolicyFundingStreamPeriods.Remove(pfsp));

                context.SaveChanges();
            }
        }

        private static void CreateFspFromPolicyFundingStreamPeriod(string fundingStreamPeriod, bool isPrioritisedApportionment)
        {
            using (var context = new PaymentManagementPolicyContext())
            {
                context.PolicyFundingStreamPeriods.Add(
                    new PolicyFundingStreamPeriod
                    {
                        FundingStreamPeriod = fundingStreamPeriod,
                        IsPrioritisedApportionment = isPrioritisedApportionment
                    }
                );
                context.SaveChanges();
            }
        }

        private static void CreatePolicyDeliverable(string fundingStreamPeriod, int deliverableCode, int? cappingApportionmentPriorityOrder)
        {
            using (var context = new PaymentManagementPolicyContext())
            {
                context.PolicyDeliverables.Add(
                    new PolicyDeliverable
                    {
                        FundingStreamPeriod = fundingStreamPeriod,
                        DeliverableCode = deliverableCode,
                        CappingApportionmentPriorityOrder = cappingApportionmentPriorityOrder
                    }
                );
                context.SaveChanges();
            }
        }

        private PolicyFundingStreamPeriod GetPolicyFundingStreamPeriod(string fundingStreamPeriod)
        {
            using (var context = new PaymentManagementPolicyContext())
            {
                string sql = @"SELECT  [FundingStreamPeriod]
                                      ,[PaymentMethod]
                                      ,[PaymentCappingLevel]
                                      ,[PaymentCappingPeriod]
                                      ,[CreatedDate]
                                      ,[ShouldCapPayments]
                                      ,[ActivityCloseDate]
                                      ,[IsPrioritisedApportionment]
                              FROM [PolicyCache].[PolicyFundingStreamPeriod]
                              WHERE [FundingStreamPeriod] = @fundingStreamPeriod";

                return context.Database.Connection.QuerySingleOrDefault<PolicyFundingStreamPeriod>(sql, new { fundingStreamPeriod });
            }
        }
    }
}