namespace PaymentManagement.Calculation.Tests.Repositories
{
    using System;
    using System.Collections.Generic;
    using System.Linq;
    using Calculation.Dtos;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using PaymentManagement.Calculation.Repositories;
    using SFA.FCT.CrossDomain.Integration.Entities.Data;
    using SFA.FCT.PaymentManagementDomain.PolicyCache.DataStore;
    using SFA.FCT.PaymentManagementDomain.PolicyCache.DataStore.Model;

    [TestClass]
    public class PolicyFundingStreamPeriodRepositoryTests
    {
        [TestMethod, TestCategory("IntegrationTest")]
        public void PolicyFundingStreamPeriodRepository_GetFspCalcConfigInfo_ShouldReturnIsPrioritisedApportionmentAsTrue()
        {
            // arrange
            const string fundingStreamPeriod = "fspConfigInfo2";
            const PaymentCappingLevelType paymentCappingLevel = PaymentCappingLevelType.DeliverableLine;
            const PaymentCappingPeriodType paymentCappingPeriod = PaymentCappingPeriodType.ContractDuration;

            ClearDownFspFromPolicyFundingStreamPeriods(fundingStreamPeriod);
            CreateFspFromPolicyFundingStreamPeriod(fundingStreamPeriod, paymentCappingLevel, paymentCappingPeriod, true);

            using (var context = new PaymentManagementPolicyContext())
            {
                var repository = new PolicyFundingStreamPeriodRepository();

                // act
                var assertFspCalcConfigInfo = repository.GetFspCalcConfigInfo(fundingStreamPeriod, 202001, ConnectionInfo.CreateFrom(context.Database.Connection));

                // act & assert 
                Assert.IsTrue(assertFspCalcConfigInfo.IsPrioritisedApportionment, "Incorrect IsPrioritisedApportionment returned");
            }
            ClearDownFspFromPolicyFundingStreamPeriods(fundingStreamPeriod);
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void PolicyFundingStreamPeriodRepository_GetFspCalcConfigInfo_ShouldReturnIsPrioritisedApportionmentAsFalse()
        {
            // arrange
            const string fundingStreamPeriod = "fspConfigInfo3";
            const PaymentCappingLevelType paymentCappingLevel = PaymentCappingLevelType.DeliverableLine;
            const PaymentCappingPeriodType paymentCappingPeriod = PaymentCappingPeriodType.ContractDuration;

            ClearDownFspFromPolicyFundingStreamPeriods(fundingStreamPeriod);
            CreateFspFromPolicyFundingStreamPeriod(fundingStreamPeriod, paymentCappingLevel, paymentCappingPeriod, false);

            using (var context = new PaymentManagementPolicyContext())
            {
                var repository = new PolicyFundingStreamPeriodRepository();

                // act
                var assertFspCalcConfigInfo = repository.GetFspCalcConfigInfo(fundingStreamPeriod, 202001, ConnectionInfo.CreateFrom(context.Database.Connection));

                // act & assert 
                Assert.IsFalse(assertFspCalcConfigInfo.IsPrioritisedApportionment, "Incorrect IsPrioritisedApportionment returned");
            }
            ClearDownFspFromPolicyFundingStreamPeriods(fundingStreamPeriod);
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void PolicyFundingStreamPeriodRepository_GetFspDeliverableInfos_ShouldReturnCorrectListOfFspDeliverableInfos()
        {
            // arrange
            const string fundingStreamPeriod = "16-18NLAP2018_test_1";
            const PaymentCappingLevelType paymentCappingLevel = PaymentCappingLevelType.ContractAllocation;
            const PaymentCappingPeriodType paymentCappingPeriod = PaymentCappingPeriodType.FinancialYear;

            ClearDownFspDeliverablesFromPolicyDeliverables(fundingStreamPeriod);
            ClearDownFspFromPolicyFundingStreamPeriods(fundingStreamPeriod);
            CreateFspFromPolicyFundingStreamPeriod(fundingStreamPeriod, paymentCappingLevel, paymentCappingPeriod);

            using (var context = new PaymentManagementPolicyContext())
            {
                context.PolicyDeliverables.Add(new PolicyDeliverable { FundingStreamPeriod = fundingStreamPeriod, DeliverableCode = 1, AllowProfile = true, CappingApportionmentPriorityOrder = null});
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
                var deliverableCodes = repository.GetFspDeliverableInfos(fundingStreamPeriod, ConnectionInfo.CreateFrom(context.Database.Connection));

                // assert 
                Assert.AreEqual(5, deliverableCodes.Count, "Incorrect number of deliverable codes returned");
                
                Assert.AreEqual(4, deliverableCodes.Count(dc => !dc.AllowProfile), 
                    "Incorrect number of deliverableInfos returned where AllowProfile is false");
                Assert.AreEqual(2, deliverableCodes.Count(dc => dc.CappingApportionmentPriorityOrder == 1),
                    "Incorrect number of deliverableInfos returned where CappingApportionmentPriorityOrder is 1");
                Assert.AreEqual(1, deliverableCodes.Count(dc => dc.CappingApportionmentPriorityOrder == null && dc.DeliverableCode == 1),
                    "Incorrect number of deliverableInfos returned where CappingApportionmentPriorityOrder is null and DeliverableCode is 1");
                Assert.AreEqual(1, deliverableCodes.Count(dc => dc.CappingApportionmentPriorityOrder == 2 && dc.DeliverableCode == 4),
                    "Incorrect number of deliverableInfos returned where CappingApportionmentPriorityOrder is 2 and DeliverableCode is 4");
                Assert.AreEqual(1, deliverableCodes.Count(dc => dc.CappingApportionmentPriorityOrder == 3 && dc.DeliverableCode == 5),
                    "Incorrect number of deliverableInfos returned where CappingApportionmentPriorityOrder is 3 and DeliverableCode is 5");
            }
            ClearDownFspDeliverablesFromPolicyDeliverables(fundingStreamPeriod);
            ClearDownFspFromPolicyFundingStreamPeriods(fundingStreamPeriod);
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void PolicyFundingStreamPeriodRepository_GetFspDeliverableInfos_ShouldReturnDataWhenPeriodIsNull()
        {
            // arrange
            const string fspWithoutPaymentTimetable = "ALLF1920";

            using (var context = new PaymentManagementPolicyContext())
            {
                var repository = new PolicyFundingStreamPeriodRepository();

                // act
                var fspConfigInfo = repository.GetFspCalcConfigInfo(fspWithoutPaymentTimetable, null, ConnectionInfo.CreateFrom(context.Database.Connection));

                // assert 
                Assert.AreEqual(PaymentMethod.NoPay, fspConfigInfo.PaymentMethod);
            }
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void PolicyFundingStreamPeriodRepository_GetFspCalcConfigInfo_ShouldGetTheOverridenCappingPeriodWhenPeriodMatches()
        {
            // arrange
            const string fundingStreamPeriodCode = "fspConfigInfo5";
            Period currentPeriod = new Period(202001);
            const int payCalcPolicyVersion = 2;
            const PaymentCappingLevelType paymentCappingLevel = PaymentCappingLevelType.DeliverableLine;
            const PaymentCappingPeriodType paymentCappingPeriod = PaymentCappingPeriodType.ContractDuration;
            const PaymentCappingPeriodType paymentCappingPeriodOverride = PaymentCappingPeriodType.FinancialYear;

            ClearDownFspDeliverablesFromPolicyDeliverables(fundingStreamPeriodCode);
            ClearDownFspFromPolicyFundingStreamPeriods(fundingStreamPeriodCode);
            CreateFspFromPolicyFundingStreamPeriod(fundingStreamPeriodCode, paymentCappingLevel, paymentCappingPeriod);
            CreatePolicyDeliverable(fundingStreamPeriodCode, 1, 2);
            CreatePolicyDeliverable(fundingStreamPeriodCode, 2, null);
            ClearPaymentTimeTableForFSP(fundingStreamPeriodCode);

            var paymentTimetable = new PolicyFundingStreamCensusDate
            {
                FundingStreamPeriod = fundingStreamPeriodCode,
                CalendarPeriod = currentPeriod.Month,
                CalendarYear = currentPeriod.Year,
                CensusDate = DateTime.Now,
                PayCalcPolicyVersion = payCalcPolicyVersion
            };

            InsertPaymentTimetableRow(paymentTimetable);
            ClearDownFundingStreamPeriodPayCalcPolicy(fundingStreamPeriodCode);

            var fspPayCalcPolicy = new FundingStreamPeriodPayCalcPolicy
            {
                FundingStreamPeriodCode = fundingStreamPeriodCode,
                CalcPolicyVersion = payCalcPolicyVersion,
                PaymentCappingPeriod = paymentCappingPeriodOverride
            };

            InsertFspPayCalcPolicy(fspPayCalcPolicy);

            using (var context = new PaymentManagementPolicyContext())
            {
                var repository = new PolicyFundingStreamPeriodRepository();

                // act
                var assertFspCalcConfigInfo = repository.GetFspCalcConfigInfo(fundingStreamPeriodCode, currentPeriod, ConnectionInfo.CreateFrom(context.Database.Connection));

                // act & assert 
                Assert.AreEqual(paymentCappingPeriodOverride, assertFspCalcConfigInfo.GetPaymentCappingPeriodType(), "Incorrect PaymentCappingPeriod returned");
            }

            ClearDownFspDeliverablesFromPolicyDeliverables(fundingStreamPeriodCode);
            ClearDownFspFromPolicyFundingStreamPeriods(fundingStreamPeriodCode);
            ClearPaymentTimeTableForFSP(fundingStreamPeriodCode);
            ClearDownFundingStreamPeriodPayCalcPolicy(fundingStreamPeriodCode);
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void PolicyFundingStreamPeriodRepository_GetPaymentMethod_ShouldGetThePaymentMethodOfAnFsp()
        {
            // arrange
            const string fundingStreamPeriodCode = "fspConfigInfo6";
            const PaymentMethod paymentMethod = PaymentMethod.PayOnActuals;

            ClearDownFspFromPolicyFundingStreamPeriods(fundingStreamPeriodCode);
            CreateFspFromPolicyFundingStreamPeriod(new PolicyFundingStreamPeriod
            {
                FundingStreamPeriod = fundingStreamPeriodCode,
                PaymentMethod = paymentMethod
            });

            using (var context = new PaymentManagementPolicyContext())
            {
                var repository = new PolicyFundingStreamPeriodRepository();

                // act
                var paymentMethodRetrived = repository.GetPaymentMethod(fundingStreamPeriodCode, ConnectionInfo.CreateFrom(context.Database.Connection));

                // assert 
                Assert.AreEqual(paymentMethod, paymentMethodRetrived);
            }
            ClearDownFspFromPolicyFundingStreamPeriods(fundingStreamPeriodCode);
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void PolicyFundingStreamPeriodRepository_GetFspCalcConfigInfo_ShouldGetCappingPeriodsWhenPresent()
        {
            // arrange
            const string fundingStreamPeriodCode = "fspConfigInfo7";
            Period currentPeriod = new Period(202001);
            const int payCalcPolicyVersion = 2;
            const PaymentCappingLevelType paymentCappingLevel = PaymentCappingLevelType.DeliverableLine;
            const PaymentCappingPeriodType paymentCappingPeriod = PaymentCappingPeriodType.ContractDuration;
            const PaymentCappingPeriodType paymentCappingPeriodOverride = PaymentCappingPeriodType.FinancialYear;

            ClearDownFspFromPolicyFundingStreamPeriods(fundingStreamPeriodCode);
            CreateFspFromPolicyFundingStreamPeriod(fundingStreamPeriodCode, paymentCappingLevel, paymentCappingPeriod);
            
            ClearPaymentTimeTableForFSP(fundingStreamPeriodCode);

            var paymentTimetable = new PolicyFundingStreamCensusDate
            {
                FundingStreamPeriod = fundingStreamPeriodCode,
                CalendarPeriod = currentPeriod.Month,
                CalendarYear = currentPeriod.Year,
                CensusDate = DateTime.Now,
                PayCalcPolicyVersion = payCalcPolicyVersion
            };

            InsertPaymentTimetableRow(paymentTimetable);
            ClearDownFundingStreamPeriodPayCalcPolicy(fundingStreamPeriodCode);

            var fspPayCalcPolicy = new FundingStreamPeriodPayCalcPolicy
            {
                FundingStreamPeriodCode = fundingStreamPeriodCode,
                CalcPolicyVersion = payCalcPolicyVersion,
                PaymentCappingPeriod = paymentCappingPeriodOverride
            };

            InsertFspPayCalcPolicy(fspPayCalcPolicy);

            ClearFspPayCalcPeriodPolicies(fundingStreamPeriodCode);
            var cappingPeriods = Enumerable.Range(1, 2);
            var fspCappingPeriodPayCalcPolicies = cappingPeriods.Select(cp =>
                new FundingStreamPeriodCappingPeriodPayCalcPolicy(fundingStreamPeriodCode, payCalcPolicyVersion, cp,
                    cp * 10)).ToList(); ;

            InsertFspCappingPeriodPayCalcPolicies(fspCappingPeriodPayCalcPolicies);

            using (var context = new PaymentManagementPolicyContext())
            {
                var repository = new PolicyFundingStreamPeriodRepository();

                // act
                var config = repository.GetFspCalcConfigInfo(fundingStreamPeriodCode, currentPeriod, ConnectionInfo.CreateFrom(context.Database.Connection));

                // assert 
                Assert.AreEqual(2, config.CappingPeriods.Count, "The number of capping periods is not correct");
                cappingPeriods.ToList().ForEach(cp =>
                {
                    Assert.AreEqual(cp * 10, config.CappingPeriods.Single(p => p.CappingPeriodNumber == cp).OverDeliveryLimit, $"The over delivery is not correct for this capping period {cp}");
                });
            }

            ClearDownFspFromPolicyFundingStreamPeriods(fundingStreamPeriodCode);
            ClearPaymentTimeTableForFSP(fundingStreamPeriodCode);
            ClearDownFundingStreamPeriodPayCalcPolicy(fundingStreamPeriodCode);
            ClearFspPayCalcPeriodPolicies(fundingStreamPeriodCode);
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void PolicyFundingStreamPeriodRepository_GetCappingGroups_ShouldReturnCorrectCappingGroups()
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
                        CappingGroups = new List<SFA.FCT.PaymentManagementDomain.PolicyCache.DataStore.Model.CappingGroup>
                        {
                           new SFA.FCT.PaymentManagementDomain.PolicyCache.DataStore.Model.CappingGroup { CappingGroupName = "Customer Satisfaction", FundingStreamPeriodCappingGroupId = 9000, AllowUnderDeliveryToBeReUsed = true, AllowOverDeliveryToBeOffset = false},
                           new SFA.FCT.PaymentManagementDomain.PolicyCache.DataStore.Model.CappingGroup { CappingGroupName = "Other In the Community", FundingStreamPeriodCappingGroupId = 9001, AllowUnderDeliveryToBeReUsed = false, AllowOverDeliveryToBeOffset = true },
                           new SFA.FCT.PaymentManagementDomain.PolicyCache.DataStore.Model.CappingGroup { CappingGroupName = "Not Applicable", FundingStreamPeriodCappingGroupId = 9002, AllowUnderDeliveryToBeReUsed = false, AllowOverDeliveryToBeOffset = false }
                        }
                    }
                );

                context.SaveChanges();
            }

            using (var context = new PaymentManagementPolicyContext())
            {
                var repository = new PolicyFundingStreamPeriodRepository();

                // act
                var cappingGroups = repository.GetCappingGroups(fundingStreamPeriod, ConnectionInfo.CreateFrom(context.Database.Connection));

                // assert 
                Assert.AreEqual(3, cappingGroups.Count, "Incorrect number of Capping Groups returned");

                var customerSatisfaction = cappingGroups.SingleOrDefault(cg => cg.FundingStreamPeriodCappingGroupId == 9000);
                Assert.IsNotNull(customerSatisfaction, "CappingGroupName 'Customer Satisfaction' was not returned");
                Assert.IsTrue(customerSatisfaction.AllowUnderDeliveryToBeReUsed, "AllowUnderDeliveryToBeReUsed is incorrect for CappingGroupName 'Customer Satisfaction'");
                Assert.IsFalse(customerSatisfaction.AllowOverDeliveryToBeOffset, "AllowOverDeliveryToBeOffset is incorrect for CappingGroupName 'Customer Satisfaction'");

                var otherIntheCommunity = cappingGroups.SingleOrDefault(cg => cg.FundingStreamPeriodCappingGroupId == 9001);
                Assert.IsNotNull(otherIntheCommunity, "CappingGroupName 'Other In the Community' was not returned");
                Assert.IsFalse(otherIntheCommunity.AllowUnderDeliveryToBeReUsed, "AllowUnderDeliveryToBeReUsed is incorrect for CappingGroupName 'Other In the Community'");
                Assert.IsTrue(otherIntheCommunity.AllowOverDeliveryToBeOffset, "AllowOverDeliveryToBeOffset is incorrect for CappingGroupName 'Other In the Community'");

                var notApplicable = cappingGroups.SingleOrDefault(cg => cg.FundingStreamPeriodCappingGroupId == 9002);
                Assert.IsNotNull(notApplicable, "CappingGroupName 'Not Applicable' was not returned");
                Assert.IsFalse(notApplicable.AllowUnderDeliveryToBeReUsed, "AllowUnderDeliveryToBeReUsed is incorrect for CappingGroupName 'Not Applicable'");
                Assert.IsFalse(notApplicable.AllowOverDeliveryToBeOffset, "AllowOverDeliveryToBeOffset is incorrect for CappingGroupName 'Not Applicable'");
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

        private static void CreateFspFromPolicyFundingStreamPeriod(PolicyFundingStreamPeriod fundingStreamPeriod)
        {
            using (var context = new PaymentManagementPolicyContext())
            {
                context.PolicyFundingStreamPeriods.Add(fundingStreamPeriod);
                context.SaveChanges();
            }
        }

        private static void ClearDownFspDeliverablesFromPolicyDeliverables(string fundingStreamPeriod)
        {
            using (var context = new PaymentManagementPolicyContext())
            {
                context.PolicyDeliverables
                    .Where(pd => pd.FundingStreamPeriod == fundingStreamPeriod).ToList()
                    .ForEach(pd=> context.PolicyDeliverables.Remove(pd));

                context.SaveChanges();
            }
        }

        private static void ClearPaymentTimeTableForFSP(string fundingStreamPeriodCode)
        {
            using (var context = new PaymentManagementPolicyContext())
            {
                context.PolicyFundingStreamCensusDates
                    .Where(pt => pt.FundingStreamPeriod == fundingStreamPeriodCode)
                    .ToList()
                    .ForEach(pt => context.PolicyFundingStreamCensusDates.Remove(pt));

                context.SaveChanges();
            }
        }

        private static void InsertPaymentTimetableRow(PolicyFundingStreamCensusDate paymentTimetable)
        {
            using (var context = new PaymentManagementPolicyContext())
            {
                context.PolicyFundingStreamCensusDates.Add(paymentTimetable);
                
                context.SaveChanges();
            }
        }

        private static void ClearDownFundingStreamPeriodPayCalcPolicy(string fundingStreamPeriodCode)
        {
            using (var context = new PaymentManagementPolicyContext())
            {
                context.FundingStreamPeriodPayCalcPolicies
                    .Where(pcp => pcp.FundingStreamPeriodCode == fundingStreamPeriodCode)
                    .ToList()
                    .ForEach(pcp => context.FundingStreamPeriodPayCalcPolicies.Remove(pcp));

                context.SaveChanges();
            }
        }

        private static void InsertFspPayCalcPolicy(FundingStreamPeriodPayCalcPolicy payCalcPolicy)
        {
            using (var context = new PaymentManagementPolicyContext())
            {
                context.FundingStreamPeriodPayCalcPolicies.Add(payCalcPolicy);

                context.SaveChanges();
            }
        }

        private static void InsertFspCappingPeriodPayCalcPolicies(IReadOnlyCollection<FundingStreamPeriodCappingPeriodPayCalcPolicy> policies)
        {
            using (var context = new PaymentManagementPolicyContext())
            {
                policies.ToList().ForEach(p => context.FundingStreamPeriodCappingPeriodPayCalcPolicies.Add(p));
                context.SaveChanges();
            }
        }

        private static void ClearFspPayCalcPeriodPolicies(string fundingStreamPeriodCode)
        {
            using (var context = new PaymentManagementPolicyContext())
            {
                context.FundingStreamPeriodCappingPeriodPayCalcPolicies
                    .Where(p => p.FundingStreamPeriodCode == fundingStreamPeriodCode)
                    .ToList()
                    .ForEach(p => context.FundingStreamPeriodCappingPeriodPayCalcPolicies.Remove(p));

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
    }
}