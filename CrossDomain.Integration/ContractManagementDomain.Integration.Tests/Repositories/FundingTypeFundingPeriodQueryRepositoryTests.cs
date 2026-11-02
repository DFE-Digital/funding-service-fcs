namespace SFA.FCT.ContractManagementDomain.Integration.Tests.Repositories
{
    using System;
    using System.Collections.Generic;
    using Castle.MicroKernel.Lifestyle;
    using Castle.MicroKernel.Registration;
    using Castle.Windsor;
    using ContractManagement.DataStore;
    using ContractManagement.DataStore.Model;
    using ContractManagement.DataStore.Repositories;
    using CrossDomain.Integration.Entities.Data;
    using Framework.Logging;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Moq;
    using UnitTests.Common;

    [TestClass]
    public class FundingTypeFundingPeriodQueryRepositoryTests
    {
        private FundingTypeFundingPeriodQueryRepository _fundingTypeFundingPeriodQueryRepository;

        [TestInitialize]
        public void TestInitialize()
        {
            _fundingTypeFundingPeriodQueryRepository = FundingTypeFundingPeriodQueryRepository.CreateInstance(new ContractManagementDbContext());
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void FundingTypeFundingPeriodQueryRepository_Get_ShouldReturnCorrectFundingTypeFundingPeriodForMainstream()
        {
            const string fundingTypeCode = "AGE";
            const string fundingPeriodName = "FY1516";

            // act
            FundingTypeFundingPeriod fundingTypeFundingPeriod = _fundingTypeFundingPeriodQueryRepository.Get(fundingTypeCode, fundingPeriodName);

            // assert
            Assert.IsNotNull(fundingTypeFundingPeriod, "Returned entity is null.");
            Assert.AreEqual(fundingTypeCode, fundingTypeFundingPeriod.FundingTypeCode, "Incorrect FundingTypeCode value returned.");
            Assert.AreEqual(fundingPeriodName, fundingTypeFundingPeriod.FundingPeriodName, "Incorrect FundingPeriodName value returned.");
            Assert.AreEqual(false, fundingTypeFundingPeriod.SkipCaseloadAssignment, "Incorrect SkipCaseloadAssignment value returned.");
            Assert.AreEqual(false, fundingTypeFundingPeriod.SkipReviewAndInternalApproval, "Incorrect SkipReviewAndInternalApproval value returned.");
            //Assert.AreEqual(false, fundingTypeFundingPeriod.SkipDocumentMerge, "Incorrect SkipDocumentMerge value returned.");
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void FundingTypeFundingPeriodQueryRepository_Get_ShouldReturnCorrectIndividualFundingTypeFundingPeriodsWhenFundingTypeCodeIsSame()
        {
            const string fundingTypeCode = "MAIN";
            const string fundingPeriodName1 = "AY1516";
            const string fundingPeriodName2 = "AY1617";

            // act
            FundingTypeFundingPeriod fundingTypeFundingPeriod1 = _fundingTypeFundingPeriodQueryRepository.Get(fundingTypeCode, fundingPeriodName1);
            FundingTypeFundingPeriod fundingTypeFundingPeriod2 = _fundingTypeFundingPeriodQueryRepository.Get(fundingTypeCode, fundingPeriodName2);

            // assert
            Assert.AreEqual(fundingPeriodName1, fundingTypeFundingPeriod1.FundingPeriodName, "Incorrect FundingPeriodName value returned.");
            Assert.AreEqual(fundingPeriodName2, fundingTypeFundingPeriod2.FundingPeriodName, "Incorrect FundingPeriodName value returned.");
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void FundingTypeFundingPeriodQueryRepository_Get_ShouldReturnCorrectFundingTypeFundingPeriodForLevy()
        {
            const string fundingTypeCode = "LEVY";
            const string fundingPeriodName = "LEVY1799";

            // act
            FundingTypeFundingPeriod fundingTypeFundingPeriod = _fundingTypeFundingPeriodQueryRepository.Get(fundingTypeCode, fundingPeriodName);

            // assert
            Assert.IsNotNull(fundingTypeFundingPeriod, "Returned entity is null.");
            Assert.AreEqual(fundingTypeCode, fundingTypeFundingPeriod.FundingTypeCode, "Incorrect FundingTypeCode value returned.");
            Assert.AreEqual(fundingPeriodName, fundingTypeFundingPeriod.FundingPeriodName, "Incorrect FundingPeriodName value returned.");
            Assert.AreEqual(true, fundingTypeFundingPeriod.SkipCaseloadAssignment, "Incorrect SkipCaseloadAssignment value returned.");
            Assert.AreEqual(true, fundingTypeFundingPeriod.SkipReviewAndInternalApproval, "Incorrect SkipReviewAndInternalApproval value returned.");
            Assert.IsTrue(fundingTypeFundingPeriod.DocumentsRequired, "Incorrect DocumentsRequired value returned.");
            //Assert.AreEqual(true, fundingTypeFundingPeriod.SkipDocumentMerge, "Incorrect SkipDocumentMerge value returned.");
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void FundingTypeFundingPeriodQueryRepository_Get_ShouldReturnNullWhenInvalidFundingTypeFundingPeriodRequested()
        {
            const string fundingTypeCode = "INVALID";
            const string fundingPeriodName = "INVALID1516";

            // act
            FundingTypeFundingPeriod fundingTypeFundingPeriod = _fundingTypeFundingPeriodQueryRepository.Get(fundingTypeCode, fundingPeriodName);

            // assert
            Assert.IsNull(fundingTypeFundingPeriod, "Returned entity is not null.");
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void FundingTypeFundingPeriodQueryRepository_Get_ShouldReturnSameObjectInstanceWhenCalledTwiceWithSameBusinessKey()
        {
            const string fundingTypeCode = "MAIN";
            const string fundingPeriodName = "AY1516";

            // act
            FundingTypeFundingPeriod first = _fundingTypeFundingPeriodQueryRepository.Get(fundingTypeCode, fundingPeriodName);
            FundingTypeFundingPeriod second = _fundingTypeFundingPeriodQueryRepository.Get(fundingTypeCode, fundingPeriodName);

            // assert
            Assert.AreSame(first, second, "Different object instances were returned from cache.");
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void FundingTypeFundingPeriodQueryRepository_Get_ShouldReturnSameEntityInstanceWhenCalledTwiceWithSameBusinessKeyOnDifferentRepositoryInstancesUsingSameEntityCache()
        {
            const string fundingTypeCode = "MAIN";
            const string fundingPeriodName = "AY1516";
            EntityCache<(string, string), FundingTypeFundingPeriod> entityCache = new EntityCache<(string, string), FundingTypeFundingPeriod>();

            // act
            FundingTypeFundingPeriodQueryRepository repository1 = new FundingTypeFundingPeriodQueryRepository(new ContractManagementDbContext(), entityCache);
            FundingTypeFundingPeriod entity1 = repository1.Get(fundingTypeCode, fundingPeriodName);

            FundingTypeFundingPeriodQueryRepository repository2 = new FundingTypeFundingPeriodQueryRepository(new ContractManagementDbContext(), entityCache);
            FundingTypeFundingPeriod entity2 = repository2.Get(fundingTypeCode, fundingPeriodName);

            // assert
            Assert.AreSame(entity1, entity2, "Different entity instances were returned from the same entity cache.");
            Assert.AreEqual(1, entityCache.Count, "Entity cache does not contain expected number of items.");
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void FundingTypeFundingPeriodQueryRepository_Get_ShouldReturnSameEntityInstanceWhenCalledTwiceWithSameBusinessKeyOnDifferentRepositoryInstancesResolvedUsingContractCreateDomainContractRequestEndpointContainer()
        {
            const string fundingTypeCode = "MAIN";
            const string fundingPeriodName = "AY1516";

            using (IWindsorContainer container = new WindsorContainer().Install(new ContractCreateDomain.Integration.ContractRequest.IoC.WindsorInstaller(new LoggerFactory())))
            {
                using (container.BeginScope())
                {
                    // act
                    IFundingTypeFundingPeriodQueryRepository repository1 = container.Resolve<IFundingTypeFundingPeriodQueryRepository>();
                    FundingTypeFundingPeriod entity1 = repository1.Get(fundingTypeCode, fundingPeriodName);

                    IFundingTypeFundingPeriodQueryRepository repository2 = container.Resolve<IFundingTypeFundingPeriodQueryRepository>();
                    FundingTypeFundingPeriod entity2 = repository2.Get(fundingTypeCode, fundingPeriodName);

                    // assert
                    Assert.AreSame(entity1, entity2, "Different entity instances were returned from the ContractCreateDomain ContractRequest Endpoint container-resolved repositories entity cache.");
                }
            }
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void ContractCreateDomainContractRequestEndpointContainer_ShouldReturnSameSingletonInstanceWhenResolvingEntityCache()
        {
            using (IWindsorContainer container = new WindsorContainer().Install(new ContractCreateDomain.Integration.ContractRequest.IoC.WindsorInstaller(new LoggerFactory())))
            {
                // act
                IEntityCache<Tuple<string, string>, FundingTypeFundingPeriod> entityCache1 = container.Resolve<IEntityCache<Tuple<string, string>, FundingTypeFundingPeriod>>();
                IEntityCache<Tuple<string, string>, FundingTypeFundingPeriod> entityCache2 = container.Resolve<IEntityCache<Tuple<string, string>, FundingTypeFundingPeriod>>();

                // assert
                Assert.AreSame(entityCache1, entityCache2, "Different object instances were resolved for IEntityCache from the ContractCreateDomain ContractRequest Endpoint container.");
            }
        }

        [TestMethod, TestCategory("UnitTest")]
        public void FundingTypeFundingPeriod_ShouldReturnTrueWhenDateIsGreaterThanFundingTypePeriodContractActivityDate()
        {
            // arrange
            FundingTypeFundingPeriod fundingTypeFundingPeriod = new FundingTypeFundingPeriod
            {
                ContractingActivityCloseDate = new DateTime(2017, 6, 1, 0, 0, 0, DateTimeKind.Utc)
            };

            // act and assert
            Assert.AreEqual(true, fundingTypeFundingPeriod.IsDateAfterContractActivityClose(new DateTime(2017, 6, 2, 0, 0, 0, DateTimeKind.Utc)));
        }

        [TestMethod, TestCategory("UnitTest")]
        public void FundingTypeFundingPeriod_ShouldReturnFalseWhenDateIsLessThanFundingTypePeriodContractActivityDate()
        {
            // arrange
            FundingTypeFundingPeriod fundingTypeFundingPeriod = new FundingTypeFundingPeriod
            {
                ContractingActivityCloseDate = new DateTime(2017, 6, 1, 0, 0, 0, DateTimeKind.Utc)
            };

            // act and assert
            Assert.AreEqual(false, fundingTypeFundingPeriod.IsDateAfterContractActivityClose(new DateTime(2017, 5, 2, 0, 0, 0, DateTimeKind.Utc)));
        }

        [TestMethod, TestCategory("UnitTest")]
        public void FundingTypeFundingPeriod_ShouldReturnFalseWhenContractActivityDateIsNotSet()
        {
            // arrange
            FundingTypeFundingPeriod fundingTypeFundingPeriod = new FundingTypeFundingPeriod();

            // act and assert
            Assert.AreEqual(false, fundingTypeFundingPeriod.IsDateAfterContractActivityClose(new DateTime(2017, 5, 2, 0, 0, 0, DateTimeKind.Utc)));
        }

        [TestMethod, TestCategory("UnitTest")]
        public void FundingTypeFundingPeriodQueryRepository_Get_ShouldInvokeUnderlyingDbSetOnceOnlyWhenCalledRepeatedlyWithSameBusinessKey()
        {
            // arrange
            Mock<IContractManagementDbContext> dbContextMock = new Mock<IContractManagementDbContext>();
            dbContextMock
                .SetupGet(m => m.FundingTypeFundingPeriodItems)
                .Returns(new List<FundingTypeFundingPeriod>
                {
                    new FundingTypeFundingPeriod {FundingTypeCode = "TEST_TYPE_1", FundingPeriodName = "AY1516"},
                    new FundingTypeFundingPeriod {FundingTypeCode = "TEST_TYPE_2", FundingPeriodName = "AY1516"},
                    new FundingTypeFundingPeriod {FundingTypeCode = "TEST_TYPE_3", FundingPeriodName = "AY1516"},
                }.ToMockIDbSet().Object);

            FundingTypeFundingPeriodQueryRepository fundingTypeFundingPeriodQueryRepository = new FundingTypeFundingPeriodQueryRepository(
                dbContextMock.Object, new EntityCache<(string, string), FundingTypeFundingPeriod>());

            // act
            fundingTypeFundingPeriodQueryRepository.Get("TEST_TYPE_1", "AY1516");
            fundingTypeFundingPeriodQueryRepository.Get("TEST_TYPE_1", "AY1516");
            fundingTypeFundingPeriodQueryRepository.Get("TEST_TYPE_1", "AY1516");

            // assert
            dbContextMock.VerifyGet(m => m.FundingTypeFundingPeriodItems, Times.Once, "Underlying DbSet was invoked more than once.");
        }

        [TestMethod, TestCategory("UnitTest")]
        public void FundingTypeFundingPeriodQueryRepository_Get_ShouldInvokeUnderlyingDbSetOnceOnlyWhenCalledRepeatedlyWithSameBusinessKeyOnDifferentRepositoryInstancesUsingSameDbContextAndSameEntityCache()
        {
            // arrange
            Mock<IContractManagementDbContext> dbContextMock = new Mock<IContractManagementDbContext>();
            dbContextMock
                .SetupGet(m => m.FundingTypeFundingPeriodItems)
                .Returns(new List<FundingTypeFundingPeriod>
                {
                    new FundingTypeFundingPeriod {FundingTypeCode = "TEST_TYPE_1", FundingPeriodName = "AY1516"},
                    new FundingTypeFundingPeriod {FundingTypeCode = "TEST_TYPE_2", FundingPeriodName = "AY1516"},
                    new FundingTypeFundingPeriod {FundingTypeCode = "TEST_TYPE_3", FundingPeriodName = "AY1516"},
                }.ToMockIDbSet().Object);

            IEntityCache<(string, string), FundingTypeFundingPeriod> entityCache = new EntityCache<(string, string), FundingTypeFundingPeriod>();

            // act
            FundingTypeFundingPeriodQueryRepository repository1 = new FundingTypeFundingPeriodQueryRepository(dbContextMock.Object, entityCache);

            repository1.Get("TEST_TYPE_1", "AY1516");
            repository1.Get("TEST_TYPE_1", "AY1516");
            repository1.Get("TEST_TYPE_1", "AY1516");

            FundingTypeFundingPeriodQueryRepository repository2 = new FundingTypeFundingPeriodQueryRepository(dbContextMock.Object, entityCache);

            repository2.Get("TEST_TYPE_1", "AY1516");
            repository2.Get("TEST_TYPE_1", "AY1516");
            repository2.Get("TEST_TYPE_1", "AY1516");

            // assert
            dbContextMock.VerifyGet(m => m.FundingTypeFundingPeriodItems, Times.Once, "Underlying DbSet was invoked more than once.");
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void FundingTypeFundingPeriodQueryRepository_IsFundingTypeFundingPeriodAllowedToHaveDeliveryOrg_ShouldReturnTrue_WhenAllowedToHaveDeliveryOrg()
        {
            // arrange
            const string testFundingTypeCode = "TestCode";
            const string testFundingPeriodName = "TestFundingPeriodName";

            CleanUp(testFundingTypeCode, testFundingPeriodName);

            FundingTypeFundingPeriod fundingTypeFundingPeriod = new FundingTypeFundingPeriod()
            {
                AllowUseOfDeliveryOrgs = true,
                FundingTypeCode = testFundingTypeCode,
                FundingPeriodName = testFundingPeriodName
            };

            using (var context = new ContractManagementDbContext())
            {
                context.FundingTypeFundingPeriodItems.Add(fundingTypeFundingPeriod);
                context.SaveChanges();
            }
            
            // act
            using (var context = new ContractManagementDbContext())
            {
                FundingTypeFundingPeriodQueryRepository repository = new FundingTypeFundingPeriodQueryRepository(context, new EntityCache<(string, string), FundingTypeFundingPeriod>());
                bool returned = repository.IsFundingTypeFundingPeriodAllowedToHaveDeliveryOrg(testFundingTypeCode, testFundingPeriodName);

                // assert
                Assert.IsTrue(returned);
            }
            CleanUp(testFundingTypeCode, testFundingPeriodName);
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void FundingTypeFundingPeriodQueryRepository_IsFundingTypeFundingPeriodAllowedToHaveDeliveryOrg_ShouldReturnFalse_WhenNotAllowedToHaveDeliveryOrg()
        {
            // arrange
            const string testFundingTypeCode = "TestCode";
            const string testFundingPeriodName = "TestFundingPeriodName";

            CleanUp(testFundingTypeCode, testFundingPeriodName);

            FundingTypeFundingPeriod fundingTypeFundingPeriod = new FundingTypeFundingPeriod()
            {
                AllowUseOfDeliveryOrgs = false,
                FundingTypeCode = testFundingTypeCode,
                FundingPeriodName = testFundingPeriodName
            };

            using (var context = new ContractManagementDbContext())
            {
                context.FundingTypeFundingPeriodItems.Add(fundingTypeFundingPeriod);
                context.SaveChanges();
            }

            // act
            using (var context = new ContractManagementDbContext())
            {
                FundingTypeFundingPeriodQueryRepository repository = new FundingTypeFundingPeriodQueryRepository(context, new EntityCache<(string, string), FundingTypeFundingPeriod>());
                bool returned = repository.IsFundingTypeFundingPeriodAllowedToHaveDeliveryOrg(testFundingTypeCode, testFundingPeriodName);

                // assert
                Assert.IsFalse(returned);
            }
            CleanUp(testFundingTypeCode, testFundingPeriodName);
        }

        private void CleanUp(string testFundingTypeCode, string testFundingPeriodName)
        {
            using (var context = new ContractManagementDbContext())
            {
                context.FundingTypeFundingPeriodItems.RemoveByKey(testFundingTypeCode, testFundingPeriodName);
                context.SaveChanges();
            }
        }
    }
}
