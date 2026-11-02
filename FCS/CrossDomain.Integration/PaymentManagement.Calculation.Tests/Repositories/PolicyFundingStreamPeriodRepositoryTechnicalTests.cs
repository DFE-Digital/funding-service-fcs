namespace PaymentManagement.Calculation.Tests.Repositories
{
    using System.Collections.Generic;
    using System.Linq;
    using Calculation.Repositories;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using SFA.FCT.CrossDomain.Integration.Entities.Data;
    using SFA.FCT.PaymentManagementDomain.PolicyCache.DataStore;
    using SFA.FCT.PaymentManagementDomain.PolicyCache.DataStore.Model;

    [TestClass]
    public class PolicyFundingStreamPeriodRepositoryTechnicalTests
    {
        [TestMethod, TestCategory("TechnicalExploration")]
        public void PolicyFundingStreamPeriodRepository_GetFspCalcConfigInfo_ShouldOnlyCallDatabaseOnce()
        {
            // arrange
            const string fundingStreamPeriod = "fspConfigInfo1";
            const PaymentCappingLevelType paymentCappingLevel = PaymentCappingLevelType.DeliverableLine;
            const PaymentCappingPeriodType paymentCappingPeriod = PaymentCappingPeriodType.ContractDuration;

            ClearDownFspDeliverablesFromPolicyDeliverables(fundingStreamPeriod);
            ClearDownFspFromPolicyFundingStreamPeriods(fundingStreamPeriod);
            CreateFspFromPolicyFundingStreamPeriod(fundingStreamPeriod, paymentCappingLevel, paymentCappingPeriod);

            using (var context = new PaymentManagementPolicyContext())
            {
                var repository = new PolicyFundingStreamPeriodRepository();

                // act
                var assertFspCalcConfigInfoFirstCall = repository.GetFspCalcConfigInfo(fundingStreamPeriod, 202001, ConnectionInfo.CreateFrom(context.Database.Connection));

                // act & assert 
                var assertFspCalcConfigInfoSecondCall = repository.GetFspCalcConfigInfo(fundingStreamPeriod, 202001, ConnectionInfo.CreateFrom(context.Database.Connection));
            }
        }

        [TestMethod, TestCategory("TechnicalExploration")]
        public void PolicyFundingStreamPeriodRepository_GetFspDeliverableInfos_ShouldOnlyCallDatabaseOnce()
        {
            // arrange
            const string fundingStreamPeriod = "16-18NLAP2018_test_2";
            const PaymentCappingLevelType paymentCappingLevel = PaymentCappingLevelType.ContractAllocation;
            const PaymentCappingPeriodType paymentCappingPeriod = PaymentCappingPeriodType.FinancialYear;

            ClearDownFspDeliverablesFromPolicyDeliverables(fundingStreamPeriod);
            ClearDownFspFromPolicyFundingStreamPeriods(fundingStreamPeriod);
            CreateFspFromPolicyFundingStreamPeriod(fundingStreamPeriod, paymentCappingLevel, paymentCappingPeriod);

            using (var context = new PaymentManagementPolicyContext())
            {
                context.PolicyDeliverables.Add(new PolicyDeliverable { FundingStreamPeriod = fundingStreamPeriod, DeliverableCode = 1, AllowProfile = true, CappingApportionmentPriorityOrder = null });
                context.PolicyDeliverables.Add(new PolicyDeliverable { FundingStreamPeriod = fundingStreamPeriod, DeliverableCode = 2, AllowProfile = false, CappingApportionmentPriorityOrder = 1 });
                context.PolicyDeliverables.Add(new PolicyDeliverable { FundingStreamPeriod = fundingStreamPeriod, DeliverableCode = 3, AllowProfile = false, CappingApportionmentPriorityOrder = 1 });
                context.PolicyDeliverables.Add(new PolicyDeliverable { FundingStreamPeriod = fundingStreamPeriod, DeliverableCode = 4, AllowProfile = false, CappingApportionmentPriorityOrder = 2 });
                context.PolicyDeliverables.Add(new PolicyDeliverable { FundingStreamPeriod = fundingStreamPeriod, DeliverableCode = 5, AllowProfile = false, CappingApportionmentPriorityOrder = 3 });
                context.SaveChanges();
            }

            using (var context = new PaymentManagementPolicyContext())
            {
                var repository = new PolicyFundingStreamPeriodRepository();

                // act
                var assertGetFspDeliverableInfosFirstCall = repository.GetFspDeliverableInfos(fundingStreamPeriod, ConnectionInfo.CreateFrom(context.Database.Connection));

                // act & assert 
                var assertGetFspDeliverableInfosSecondCall = repository.GetFspDeliverableInfos(fundingStreamPeriod, ConnectionInfo.CreateFrom(context.Database.Connection));
            }
            ClearDownFspDeliverablesFromPolicyDeliverables(fundingStreamPeriod);
            ClearDownFspFromPolicyFundingStreamPeriods(fundingStreamPeriod);
        }

        [TestMethod, TestCategory("TechnicalExploration")]
        public void PolicyFundingStreamPeriodRepository_GetCappingGroups_ShouldOnlyCallDatabaseOnce()
        {
            // arrange
            const string fundingStreamPeriod = "NCS-C2021_test_1";
            const PaymentCappingLevelType paymentCappingLevel = PaymentCappingLevelType.ContractAllocation;
            const PaymentCappingPeriodType paymentCappingPeriod = PaymentCappingPeriodType.FinancialYear;

            ClearDownFspFromPolicyFundingStreamPeriods(fundingStreamPeriod);

            using (var context = new PaymentManagementPolicyContext())
            {
                context.PolicyFundingStreamPeriods.Add(
                    new PolicyFundingStreamPeriod
                    {
                        FundingStreamPeriod = fundingStreamPeriod,
                        PaymentMethod = PaymentMethod.PayOnActuals,
                        PaymentCappingLevel = paymentCappingLevel,
                        PaymentCappingPeriod = paymentCappingPeriod,
                        IsPrioritisedApportionment = false,
                        CappingGroups = new List<CappingGroup>
                        {
                           new CappingGroup { CappingGroupName = "Customer Satisfaction", FundingStreamPeriodCappingGroupId = 9000, AllowUnderDeliveryToBeReUsed = true, AllowOverDeliveryToBeOffset = false},
                           new CappingGroup { CappingGroupName = "Other In the Community", FundingStreamPeriodCappingGroupId = 9001, AllowUnderDeliveryToBeReUsed = false, AllowOverDeliveryToBeOffset = true },
                           new CappingGroup { CappingGroupName = "Not Applicable", FundingStreamPeriodCappingGroupId = 9002, AllowUnderDeliveryToBeReUsed = false, AllowOverDeliveryToBeOffset = false }
                        }
                    }
                );

                context.SaveChanges();
            }

            using (var context = new PaymentManagementPolicyContext())
            {
                var repository = new PolicyFundingStreamPeriodRepository();

                // act
                var cappingGroupsFirstCall = repository.GetCappingGroups(fundingStreamPeriod, ConnectionInfo.CreateFrom(context.Database.Connection));

                // act & assert 
                var cappingGroupsSecondCall = repository.GetCappingGroups(fundingStreamPeriod, ConnectionInfo.CreateFrom(context.Database.Connection));
            }
            ClearDownFspFromPolicyFundingStreamPeriods(fundingStreamPeriod);
        }

        private static void ClearDownFspFromPolicyFundingStreamPeriods(string fundingStreamPeriod)
        {
            ClearDownCappingGroups(fundingStreamPeriod);

            using (var context = new PaymentManagementPolicyContext())
            {
                context.PolicyFundingStreamPeriods
                    .Where(pfsp => pfsp.FundingStreamPeriod == fundingStreamPeriod).ToList()
                    .ForEach(pfsp => context.PolicyFundingStreamPeriods.Remove(pfsp));

                context.SaveChanges();
            }
        }

        private static void ClearDownCappingGroups(string fundingStreamPeriod)
        {
            using (var context = new PaymentManagementPolicyContext())
            {
                context.CappingGroups
                    .Where(cp => cp.FundingStreamPeriod == fundingStreamPeriod).ToList()
                    .ForEach(cp => context.CappingGroups.Remove(cp));

                context.SaveChanges();
            }
        }

        private static void CreateFspFromPolicyFundingStreamPeriod(string fundingStreamPeriod, PaymentCappingLevelType paymentCappingLevel,
            PaymentCappingPeriodType paymentCappingPeriod, bool isPrioritisedApportionment = false)
        {
            using (var context = new PaymentManagementPolicyContext())
            {
                context.PolicyFundingStreamPeriods.Add(
                    new PolicyFundingStreamPeriod
                    {
                        FundingStreamPeriod = fundingStreamPeriod,
                        PaymentMethod = PaymentMethod.PayOnActuals,
                        PaymentCappingLevel = paymentCappingLevel,
                        PaymentCappingPeriod = paymentCappingPeriod,
                        IsPrioritisedApportionment = isPrioritisedApportionment
                    }
                );
                context.SaveChanges();
            }
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
    }
}
