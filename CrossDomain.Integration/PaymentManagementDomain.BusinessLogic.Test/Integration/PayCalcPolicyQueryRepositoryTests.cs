namespace SFA.FCT.PaymentManagementDomain.BusinessLogic.Test.Integration
{
    using System;
    using System.Collections.Generic;
    using System.Linq;
    using Castle.MicroKernel.Lifestyle;
    using Castle.Windsor;
    using CrossDomain.Integration.Common.Extensions;
    using Framework.Logging;
    using global::UnitTests.Common;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Moq;
    using MoreLinq;
    using PolicyCache.DataStore;
    using PolicyCache.DataStore.Model;
    using PolicyCache.DataStore.Repositories;
    using SFA.FCT.CrossDomain.Integration.Entities.Data;

    [TestClass]
    public class PayCalcPolicyQueryRepositoryTests
    {
        private PayCalcPolicyQueryRepository _payCalcPolicyQueryRepository;
        private ConnectionInfo _connectionInfo;

        [TestInitialize]
        public void TestInitialize()
        {
            IWindsorContainer container = new WindsorContainer()
                .Install(new PaymentManagementDomain.Integration.PaymentSchedule.IoC.WindsorInstaller(new LoggerFactory()));
            container.BeginScope();
            _payCalcPolicyQueryRepository = (PayCalcPolicyQueryRepository)container.Resolve<IPayCalcPolicyQueryRepository>();
            _connectionInfo = ConnectionInfo.CreateFrom(new PaymentManagementPolicyContext().Database.Connection);
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void PayCalcPolicyQueryRepository_ShouldReturnCorrectFundingStreamPeriods()
        {
            // act
            PolicyFundingStreamPeriod fundingStreamPeriod = _payCalcPolicyQueryRepository.GetFundingStreamPeriod("AGE1617", _connectionInfo);

            // assert
            Assert.IsNotNull(fundingStreamPeriod, "Returned entity is null.");
            Assert.AreEqual("AGE1617", fundingStreamPeriod.FundingStreamPeriod, "Incorrect FundingStreamPeriod returned.");
            Assert.AreEqual(PaymentMethod.PayOnActuals, fundingStreamPeriod.PaymentMethod, "Incorrect PaymentMethod returned.");
            Assert.AreEqual(PaymentCappingLevelType.DeliverableLine, fundingStreamPeriod.PaymentCappingLevel, "Incorrect PaymentCappingLevel returned.");
            Assert.AreEqual(PaymentCappingPeriodType.ContractDuration, fundingStreamPeriod.PaymentCappingPeriod, "Incorrect PaymentCappingPeriod returned.");
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void PayCalcPolicyQueryRepository_ShouldReturnNullWhenInvalidFundingStreamPeriodRequested()
        {
            // act
            PolicyFundingStreamPeriod fundingStreamPeriod = _payCalcPolicyQueryRepository.GetFundingStreamPeriod("NOT_EXIST1516", _connectionInfo);

            // assert
            Assert.IsNull(fundingStreamPeriod);
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void PayCalcPolicyQueryRepository_ShouldReturnCorrectFundingStreamPeriodDeliverables()
        {
            // act
            IReadOnlyCollection<PolicyDeliverable> deliverables = _payCalcPolicyQueryRepository.GetFundingStreamPeriodDeliverables("ASTO1516", _connectionInfo);

            // assert
            Assert.IsNotNull(deliverables, "Returned entity is null.");
            Assert.IsTrue(deliverables.All(d => d.FundingStreamPeriod == "ASTO1516"), "Deliverables for incorrect FundingStreamPeriod returned.");
            Assert.AreEqual(19, deliverables.Count, "Incorrect number of deliverables returned.");
            Assert.AreEqual(10, deliverables.Count(d => d.FundingStreamPeriodCappingGroupId == 2), "Incorrect number of capping group id 2 returned.");
            Assert.AreEqual(8, deliverables.Count(d => d.FundingStreamPeriodCappingGroupId == 3), "Incorrect number of capping group id 3 returned.");
            Assert.AreEqual(1, deliverables.Count(d => d.FundingStreamPeriodCappingGroupId == 4), "Incorrect number of capping group id 4 returned.");
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void PayCalcPolicyQueryRepository_ShouldReturnEmptyDeliverablesCollectionWhenInvalidFundingStreamPeriodGiven()
        {
            // act
            IReadOnlyCollection<PolicyDeliverable> deliverables = _payCalcPolicyQueryRepository.GetFundingStreamPeriodDeliverables("NOT_EXIST1516", _connectionInfo);

            // assert
            Assert.IsNotNull(deliverables, "Returned entity is null.");
            Assert.AreEqual(0, deliverables.Count, "Incorrect number of deliverables returned.");
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void PayCalcPolicyQueryRepository_ShouldReturnCorrectFundingStreamPeriodCappingGroups()
        {
            // act
            IReadOnlyCollection<CappingGroup> cappingGroups = _payCalcPolicyQueryRepository.GetFundingStreamPeriodCappingGroups("ASTO1516", _connectionInfo);

            // assert
            Assert.IsNotNull(cappingGroups, "Returned entity is null.");
            Assert.IsTrue(cappingGroups.All(cg => cg.FundingStreamPeriod == "ASTO1516"), "Capping groups for incorrect FundingStreamPeriod returned.");
            Assert.AreEqual(3, cappingGroups.Count, "Incorrect number of capping groups returned.");
            Assert.IsNotNull(cappingGroups.SingleOrDefault(cg => cg.CappingGroupName == "Apprenticeships"), "Capping group missing.");
            Assert.IsNotNull(cappingGroups.SingleOrDefault(cg => cg.CappingGroupName == "Other ASB"), "Capping group missing.");
            Assert.IsNotNull(cappingGroups.SingleOrDefault(cg => cg.CappingGroupName == "Not Applicable"), "Capping group missing.");
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void PayCalcPolicyQueryRepository_ShouldReturnEmptyCappingGroupCollectionWhenInvalidFundingStreamPeriodGiven()
        {
            // act
            IReadOnlyCollection<CappingGroup> cappingGroups = _payCalcPolicyQueryRepository.GetFundingStreamPeriodCappingGroups("NOT_EXIST1516", _connectionInfo);

            // assert
            Assert.IsNotNull(cappingGroups, "Returned entity is null.");
            Assert.AreEqual(0, cappingGroups.Count, "Incorrect number of capping groups returned.");
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void PayCalcPolicyQueryRepository_GetFundingStreamPeriodCensusDates_ShouldReturnCorrectFundingStreamPeriodCensusDates()
        {
            // act
            IReadOnlyCollection<PolicyFundingStreamCensusDate> censusDates = _payCalcPolicyQueryRepository.GetFundingStreamPeriodCensusDates("ASTO1516", _connectionInfo);

            // assert
            Assert.IsNotNull(censusDates, "Returned entity is null.");
            Assert.IsTrue(censusDates.All(cd => cd.FundingStreamPeriod == "ASTO1516"), "Census dates for incorrect FundingStreamPeriod returned.");
            Assert.AreEqual(20, censusDates.Count, "Incorrect number of census dates returned.");
            Assert.AreEqual(5, censusDates.Count(cd => cd.CalendarYear == 2015), "Incorrect number of 2015 census dates returned.");
            Assert.AreEqual(8, censusDates.Count(cd => cd.CalendarYear == 2016), "Incorrect number of 2016 census dates returned.");
            Assert.AreEqual(7, censusDates.Count(cd => cd.CalendarYear == 2017), "Incorrect number of 2017 census dates returned.");
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void PayCalcPolicyQueryRepository_GetFundingStreamPeriodCensusDates_ShouldReturnEmptyCensusDatesCollectionWhenInvalidFundingStreamPeriodGiven()
        {
            // act
            IReadOnlyCollection<PolicyFundingStreamCensusDate> censusDates = _payCalcPolicyQueryRepository.GetFundingStreamPeriodCensusDates("NOT_EXIST1516", _connectionInfo);

            // assert
            Assert.IsNotNull(censusDates, "Returned entity is null.");
            Assert.AreEqual(0, censusDates.Count, "Incorrect number of census dates returned.");
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void PayCalcPolicyQueryRepository_GetFundingStreamPeriodCensusDates_ShouldNotCacheValuesAndShouldReturnLatestCensusDatesInDatabase()
        {
            const string testFspCode = "TEST-FSP";
            DateTime originalCensusDate = DateTime.Parse("2018-03-07 22:00:00.000");
            DateTime amendedCensusDate = DateTime.Parse("2018-03-09 22:00:00.000");

            IWindsorContainer container = new WindsorContainer()
                .Install(new PaymentManagementDomain.Integration.PaymentSchedule.IoC.WindsorInstaller(new LoggerFactory()));

            // clean-up
            using (IPaymentManagementPolicyContext context = new PaymentManagementPolicyContext())
            {
                context.PolicyFundingStreamCensusDates.RemoveWhere(cd => cd.FundingStreamPeriod == testFspCode);
                context.SaveChanges();
            }

            // arrange
            using (IPaymentManagementPolicyContext context = new PaymentManagementPolicyContext())
            {
                context.PolicyFundingStreamCensusDates.Add(new PolicyFundingStreamCensusDate
                {
                    FundingStreamPeriod = testFspCode,
                    CalendarPeriod = 2,
                    CalendarYear = 2018,
                    CensusDate = originalCensusDate
                });
                context.SaveChanges();
            }

            // act
            container.BeginScope();
            IPayCalcPolicyQueryRepository repository1 = container.Resolve<IPayCalcPolicyQueryRepository>();
            PolicyFundingStreamCensusDate originalFspCensusDate = repository1.GetFundingStreamPeriodCensusDates(testFspCode, _connectionInfo).Single();

            // assert
            Assert.AreEqual(originalCensusDate, originalFspCensusDate.CensusDate, "Incorrect original census date returned.");

            // arrange again
            using (IPaymentManagementPolicyContext context = new PaymentManagementPolicyContext())
            {
                PolicyFundingStreamCensusDate fspCensusDate = context.PolicyFundingStreamCensusDates.Single(cd => cd.FundingStreamPeriod == testFspCode);
                fspCensusDate.CensusDate = amendedCensusDate;
                context.SaveChanges();
            }

            // act
            container.BeginScope();
            IPayCalcPolicyQueryRepository repository2 = container.Resolve<IPayCalcPolicyQueryRepository>();
            PolicyFundingStreamCensusDate amendedFspCensusDate = repository2.GetFundingStreamPeriodCensusDates(testFspCode, _connectionInfo).Single();

            // assert
            Assert.AreEqual(amendedCensusDate, amendedFspCensusDate.CensusDate, "Incorrect amended census date returned.");

            // clean-up
            using (IPaymentManagementPolicyContext context = new PaymentManagementPolicyContext())
            {
                context.PolicyFundingStreamCensusDates.RemoveWhere(cd => cd.FundingStreamPeriod == testFspCode);
                context.SaveChanges();
            }
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void PayCalcPolicyQueryRepository_DictionaryOfEntitiesCacheShouldReturnSameObjectInstanceWhenCalledTwiceWithSameBusinessKey()
        {
            // act
            PolicyFundingStreamPeriod first = _payCalcPolicyQueryRepository.GetFundingStreamPeriod("ASTO1516", _connectionInfo);
            PolicyFundingStreamPeriod second = _payCalcPolicyQueryRepository.GetFundingStreamPeriod("ASTO1516", _connectionInfo);

            // assert
            Assert.AreSame(first, second, "Different object instances were returned from cache.");
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void PayCalcPolicyQueryRepository_DictionaryOfCollectionsCacheShouldReturnSameObjectInstancesWhenCalledTwiceWithSameBusinessKey()
        {
            // act
            IReadOnlyCollection<PolicyDeliverable> first = _payCalcPolicyQueryRepository.GetFundingStreamPeriodDeliverables("ASTO1516", _connectionInfo);
            IReadOnlyCollection<PolicyDeliverable> second = _payCalcPolicyQueryRepository.GetFundingStreamPeriodDeliverables("ASTO1516", _connectionInfo);

            // assert
            Assert.AreSame(first, second, "Different object instances were returned from cache.");
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void PayCalcPolicyQueryRepository_DictionaryOfCollectionsCacheShouldReturnSameObjectInstancesWithinReturnedCollectionsWhenCalledTwiceWithSameBusinessKey()
        {
            // act
            IReadOnlyCollection<PolicyDeliverable> first = _payCalcPolicyQueryRepository.GetFundingStreamPeriodDeliverables("ASTO1516", _connectionInfo);
            IReadOnlyCollection<PolicyDeliverable> second = _payCalcPolicyQueryRepository.GetFundingStreamPeriodDeliverables("ASTO1516", _connectionInfo);

            // assert
            Assert.AreSame(first.Single(d => d.DeliverableCode == 19), second.Single(d => d.DeliverableCode == 19), "Different object instances within returned collections were returned from cache.");
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void PayCalcPolicyQueryRepository_ShouldReturnSameEntityInstanceWhenCalledTwiceWithSameBusinessKeyOnDifferentRepositoryInstancesUsingSameEntityCache()
        {
            // arrange
            EntityCache<string, PolicyFundingStreamPeriod> fundingStreamPeriodsEntityCache = new EntityCache<string, PolicyFundingStreamPeriod>();

            // act
            PayCalcPolicyQueryRepository repository1 = new PayCalcPolicyQueryRepository(fundingStreamPeriodsEntityCache, null, null);
            PolicyFundingStreamPeriod entity1 = repository1.GetFundingStreamPeriod("AGE1617", _connectionInfo);

            PayCalcPolicyQueryRepository repository2 = new PayCalcPolicyQueryRepository(fundingStreamPeriodsEntityCache, null, null);
            PolicyFundingStreamPeriod entity2 = repository2.GetFundingStreamPeriod("AGE1617", _connectionInfo);

            // assert
            Assert.AreSame(entity1, entity2, "Different entity instances were returned from the same entity cache.");
            Assert.AreEqual(1, fundingStreamPeriodsEntityCache.Count, "Entity cache does not contain expected number of items.");
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void PayCalcPolicyQueryRepository_DictionaryOfCollectionsCacheShouldReturnSameObjectInstancesWithinReturnedCollectionsWhenCalledTwiceWithSameBusinessKeyOnDifferentRepositoryInstancesUsingSameEntityCache()
        {
            // arrange
            EntityCache<string, IReadOnlyCollection<PolicyDeliverable>> policyDeliverablesEntityCache = new EntityCache<string, IReadOnlyCollection<PolicyDeliverable>>();

            // act
            PayCalcPolicyQueryRepository repository1 = new PayCalcPolicyQueryRepository(null, policyDeliverablesEntityCache, null);
            IReadOnlyCollection<PolicyDeliverable> first = _payCalcPolicyQueryRepository.GetFundingStreamPeriodDeliverables("ASTO1516", _connectionInfo);

            PayCalcPolicyQueryRepository repository12 = new PayCalcPolicyQueryRepository(null, policyDeliverablesEntityCache, null);
            IReadOnlyCollection<PolicyDeliverable> second = _payCalcPolicyQueryRepository.GetFundingStreamPeriodDeliverables("ASTO1516", _connectionInfo);

            // assert
            Assert.AreSame(first, second, "Different collections instances were returned from cache.");
            Assert.AreSame(first.Single(d => d.DeliverableCode == 19), second.Single(d => d.DeliverableCode == 19), "Different object instances within returned collections were returned from cache.");
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void PayCalcPolicyQueryRepository_IsFspContractAllocationCappingWithChildProfileDeliverables_ShouldReturnTrueWhenFspHasAllocationCappingAndChildDivWithProfile()
        {
            // arrange
            const string fspToTest = "FSP_TEST1";
            ClearFspFromDb(fspToTest);
            using (var context = new PaymentManagementPolicyContext())
            {
                context.PolicyFundingStreamPeriods.Add(new PolicyFundingStreamPeriod
                {
                    FundingStreamPeriod = fspToTest,
                    PaymentCappingLevel = PaymentCappingLevelType.ContractAllocation
                });

                context.PolicyDeliverables.Add(
                    new PolicyDeliverable
                    {
                        DeliverableCode = 1,
                        ParentDeliverableCode = null,
                        FundingStreamPeriod = fspToTest
                    });
                
                context.PolicyDeliverables.Add(
                    new PolicyDeliverable
                    {
                        DeliverableCode = 2,
                        AllowProfile = true,
                        ParentDeliverableCode = 1,
                        FundingStreamPeriod = fspToTest
                    });

                context.SaveChanges();
            }

            // act
            bool isAllocationGroupCappingWithChildProfileDels = _payCalcPolicyQueryRepository.IsFspContractAllocationCappingWithChildProfileDeliverables(fspToTest, _connectionInfo); 

            // assert
            Assert.AreEqual(true, isAllocationGroupCappingWithChildProfileDels);
            ClearFspFromDb(fspToTest);
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void PayCalcPolicyQueryRepository_IsFspContractAllocationCappingWithChildProfileDeliverables_ShouldReturnFalseWhenFspHasAllocationCappingWithoutChildDivWithProfile()
        {
            // arrange
            const string fspToTest = "FSP_TEST1";
            ClearFspFromDb(fspToTest);
            using (var context = new PaymentManagementPolicyContext())
            {
                context.PolicyFundingStreamPeriods.Add(new PolicyFundingStreamPeriod
                {
                    FundingStreamPeriod = fspToTest,
                    PaymentCappingLevel = PaymentCappingLevelType.ContractAllocation
                });

                context.PolicyDeliverables.Add(
                    new PolicyDeliverable
                    {
                        DeliverableCode = 1,
                        ParentDeliverableCode = null,
                        FundingStreamPeriod = fspToTest
                    });

                context.PolicyDeliverables.Add(
                    new PolicyDeliverable
                    {
                        DeliverableCode = 2,
                        AllowProfile = false,
                        ParentDeliverableCode = 1,
                        FundingStreamPeriod = fspToTest
                    });

                context.SaveChanges();
            }

            // act
            bool isAllocationGroupCappingWithChildProfileDels = _payCalcPolicyQueryRepository.IsFspContractAllocationCappingWithChildProfileDeliverables(fspToTest, _connectionInfo);

            // assert
            Assert.AreEqual(false, isAllocationGroupCappingWithChildProfileDels);
            ClearFspFromDb(fspToTest);
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void PayCalcPolicyQueryRepository_GetDeliverableCodesWherePlannedValueShouldNotBeUsedInCalc_ShouldReturnAnEmptyCollectionWhenFspHasAllocationCappingWithoutChildDivWithProfile()
        {
            // arrange
            const string fspToTest = "FSP_TEST1";
            ClearFspFromDb(fspToTest);
            using (var context = new PaymentManagementPolicyContext())
            {
                context.PolicyFundingStreamPeriods.Add(new PolicyFundingStreamPeriod
                {
                    FundingStreamPeriod = fspToTest,
                    PaymentCappingLevel = PaymentCappingLevelType.ContractAllocation
                });

                context.PolicyDeliverables.Add(
                    new PolicyDeliverable
                    {
                        DeliverableCode = 1,
                        ParentDeliverableCode = null,
                        FundingStreamPeriod = fspToTest
                    });

                context.PolicyDeliverables.Add(
                    new PolicyDeliverable
                    {
                        DeliverableCode = 2,
                        AllowProfile = false,
                        ParentDeliverableCode = 1,
                        FundingStreamPeriod = fspToTest
                    });

                context.SaveChanges();
            }

            // act
            var deliverables = _payCalcPolicyQueryRepository.GetDeliverableCodesWherePlannedValueShouldNotBeUsedInCalc(fspToTest, _connectionInfo);

            // assert
            Assert.IsTrue(deliverables.Empty());
            ClearFspFromDb(fspToTest);
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void PayCalcPolicyQueryRepository_GetDeliverableCodesWherePlannedValueShouldNotBeUsedInCalc_ShouldReturnACollectionWhenFspHasAllocationCappingWithChildDivWithProfile()
        {
            // arrange
            const string fspToTest = "FSP_TEST1";
            const int parentDeliverableCode = 1;
            ClearFspFromDb(fspToTest);
            using (var context = new PaymentManagementPolicyContext())
            {
                context.PolicyFundingStreamPeriods.Add(new PolicyFundingStreamPeriod
                {
                    FundingStreamPeriod = fspToTest,
                    PaymentCappingLevel = PaymentCappingLevelType.ContractAllocation
                });

                context.PolicyDeliverables.Add(
                    new PolicyDeliverable
                    {
                        DeliverableCode = parentDeliverableCode,
                        ParentDeliverableCode = null,
                        FundingStreamPeriod = fspToTest
                    });

                context.PolicyDeliverables.Add(
                    new PolicyDeliverable
                    {
                        DeliverableCode = 2,
                        AllowProfile = true,
                        ParentDeliverableCode = parentDeliverableCode,
                        FundingStreamPeriod = fspToTest
                    });

                context.SaveChanges();
            }

            // act
            var deliverables = _payCalcPolicyQueryRepository.GetDeliverableCodesWherePlannedValueShouldNotBeUsedInCalc(fspToTest, _connectionInfo);

            // assert
            Assert.AreEqual(1, deliverables.Count, "The collection should have one element");
            Assert.AreEqual(parentDeliverableCode, deliverables.First(), "The first deliverable is the wrong code empty");
            ClearFspFromDb(fspToTest);
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void PayCalcPolicyQueryRepository_GetSubnominal_ShouldReturnExpectedSubnominalWhenGivenValidKey()
        {
            // arrange
            const int subnominalCode = 2200030;
            const PaymentType paymentType = PaymentType.Profile;

            // act
            PolicySubnominal subnominal = _payCalcPolicyQueryRepository.GetSubnominal(subnominalCode, paymentType, _connectionInfo);

            // assert
            Assert.IsNotNull(subnominal);
            Assert.AreEqual(subnominalCode, subnominal.SubnominalCode);
            Assert.AreEqual(paymentType, subnominal.PaymentType);
            Assert.AreEqual("19+ Cont Lnrs Prog", subnominal.PaymentSubnominalDesc);
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void PayCalcPolicyQueryRepository_GetSubnominal_ShouldReturnNullWhenGivenInvalidKey()
        {
            // arrange
            const int subnominalCode = -1;
            const PaymentType paymentType = PaymentType.Profile;

            // act
            PolicySubnominal subnominal = _payCalcPolicyQueryRepository.GetSubnominal(subnominalCode, paymentType, _connectionInfo);

            // assert
            Assert.IsNull(subnominal);
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void PayCalcPolicyQueryRepository_ShouldReturnSameEntityInstanceWhenCalledTwiceWithSameBusinessKeyOnDifferentRepositoryInstancesResolvedUsingPaymentScheduleEndpointContainer()
        {
            using (IWindsorContainer container = new WindsorContainer()
                .Install(new PaymentManagementDomain.Integration.PaymentSchedule.IoC.WindsorInstaller(new LoggerFactory())))
            {
                // act
                IPayCalcPolicyQueryRepository repository1 = container.Resolve<IPayCalcPolicyQueryRepository>();
                PolicyFundingStreamPeriod entity1 = repository1.GetFundingStreamPeriod("AGE1617", _connectionInfo);

                IPayCalcPolicyQueryRepository repository2 = container.Resolve<IPayCalcPolicyQueryRepository>();
                PolicyFundingStreamPeriod entity2 = repository2.GetFundingStreamPeriod("AGE1617", _connectionInfo);

                // assert
                Assert.AreSame(entity1, entity2, "Different entity instances were returned from the PaymentSchedule endpoint container-resolved repositories entity cache.");
            }
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void PaymentScheduleEndpointContainer_ShouldReturnSameSingletonInstanceWhenResolvingEntityCache()
        {
            using (IWindsorContainer container = new WindsorContainer().Install(new PaymentManagementDomain.Integration.PaymentSchedule.IoC.WindsorInstaller(new LoggerFactory())))
            using (container.BeginScope())
            {
                // act
                IEntityCache<string, PolicyFundingStreamPeriod> entityCache1 = container.Resolve<IEntityCache<string, PolicyFundingStreamPeriod>>();
                IEntityCache<string, PolicyFundingStreamPeriod> entityCache2 = container.Resolve<IEntityCache<string, PolicyFundingStreamPeriod>>();

                // assert
                Assert.AreSame(entityCache1, entityCache2, "Different object instances were resolved for IEntityCache from the PaymentSchedule endpoint container.");
            }
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void PaymentScheduleEndpointContainer_GetFundingStreamPeriod_ShouldReturnFsp()
        {
            var fsp = _payCalcPolicyQueryRepository.GetFundingStreamPeriod(_connectionInfo, "AGE1617");

            Assert.IsNotNull(fsp);
        }

        private void ClearFspFromDb(string fspCode)
        {
            using (var context = new PaymentManagementPolicyContext())
            {
                context.PolicyDeliverables.Where(pd => pd.FundingStreamPeriod == fspCode)
                    .ForEach(pd => context.PolicyDeliverables.Remove(pd));

                context.PolicyFundingStreamPeriods.Where(fsp => fsp.FundingStreamPeriod == fspCode)
                   .ForEach(fsp => context.PolicyFundingStreamPeriods.Remove(fsp));

                context.SaveChanges();
            }
        }
    }
}
