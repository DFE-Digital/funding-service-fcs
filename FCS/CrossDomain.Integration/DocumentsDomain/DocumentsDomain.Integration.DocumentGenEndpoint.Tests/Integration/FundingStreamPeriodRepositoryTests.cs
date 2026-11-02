namespace SFA.FCT.DocumentsDomain.Integration.DocumentGenEndpoint.Tests.Integration
{
    using System.Linq;
    using Castle.Core.Internal;
    using Castle.MicroKernel.Lifestyle;
    using Castle.MicroKernel.Registration;
    using Castle.Windsor;
    using DataStore;
    using DataStore.Repositories;
    using Framework.Logging;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using DataStore.Models;
    using System.Collections.Generic;

    [TestClass]
    public class FundingStreamPeriodRepositoryTests
    {
        [TestMethod, TestCategory("IntegrationTest")]
        public void FundingStreamPeriodRepository_GetByKey_ShouldGetFundingStreamPeriod()
        {
            // arrange
            const string fspForTest = "FSP1";
            RemoveFundingStreamPeriod(fspForTest);
            CreateFundingStreamPeriod(fspForTest);

            using (var context = new DocumentsDomainDbContext())
            {
                var repository = new FundingStreamPeriodRepository(context);

                // act
                var fsp = repository.GetByKey(fspForTest);

                // assert
                Assert.IsNotNull(fsp);
            }
            RemoveFundingStreamPeriod(fspForTest);
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void FundingStreamPeriodRepository_GetByKey_EnsureCacheIsCalled()
        {
            // arrange
            const string fspForTest = "FSP1";
            RemoveFundingStreamPeriod(fspForTest);
            CreateFundingStreamPeriod(fspForTest);

            using (var context = new DocumentsDomainDbContext())
            {
                var repository = new FundingStreamPeriodRepository(context);

                // populate cache
                repository.GetByKey(fspForTest);
            }

            RemoveFundingStreamPeriod(fspForTest);
            
            using (var context = new DocumentsDomainDbContext())
            {
                var repository = new FundingStreamPeriodRepository(context);

                // act
                var fsp = repository.GetByKey(fspForTest);

                // assert
                Assert.IsNotNull(fsp, "FSP was not retrieved from the cache");
            }
            RemoveFundingStreamPeriod(fspForTest);
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void FundingStreamPeriodRepository_GetAll_ShouldGetAllFundingStreamPeriods()
        {
            // arrange
            const string fspForTest = "FSP1";

            RemoveFundingStreamPeriod(fspForTest);
            CreateFundingStreamPeriod(fspForTest);
 
            using (var context = new DocumentsDomainDbContext())
            {
                var allFspsCount = context.FundingStreamPeriods.Count();

                var repository = new FundingStreamPeriodRepository(context);

                // act
                var assertAllFsps = repository.GetAll();

                // assert
                Assert.AreEqual(allFspsCount, assertAllFsps.Count, "Not all FSPs were retrieved");
            }
            RemoveFundingStreamPeriod(fspForTest);
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void FundingStreamPeriodRepository_GetAll_EnsureCacheIsCalled()
        {
            // arrange
            const string fspForTest = "FSP1";
            int allFspsCount;

            RemoveFundingStreamPeriod(fspForTest);
            CreateFundingStreamPeriod(fspForTest);

            using (var context = new DocumentsDomainDbContext())
            {
                allFspsCount = context.FundingStreamPeriods.Count();

                var repository = new FundingStreamPeriodRepository(context);

                // populate cache
                repository.GetAll();
            }

            RemoveFundingStreamPeriod(fspForTest);

            using (var context = new DocumentsDomainDbContext())
            {
                var repository = new FundingStreamPeriodRepository(context);

                // act
                var assertAllFsps = repository.GetAll();

                // assert
                Assert.AreEqual(allFspsCount, assertAllFsps.Count, "FSPs were not retrieved from the cache");
            }
            RemoveFundingStreamPeriod(fspForTest);
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void FundingStreamPeriodRepository_ShouldResolve()
        {
            // act
            var repository = GetContainer().Resolve<IFundingStreamPeriodRepository>();

            // assert
            Assert.IsNotNull(repository);
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void FundingStreamPeriodRepository_GetFspGroupDisplayNames_ShouldGetFspGroupDisplayNames()
        {
            // arrange
            const string fsp1CodeForTest = "FSP1";
            const string fspGroup1CodeForTest = "FSPGroup1";
            const string fspGroup1DisplayNameForTest = "FSPGroup1 display name";

            const string fsp2CodeForTest = "FSP2";
            const string fspGroup2CodeForTest = "FSPGroup2";
            const string fspGroup2DisplayNameForTest = "FSPGroup2 display name";

            const string fsp3CodeForTest = "FSP3";

            const string fsp4CodeForTest = "FSP4";
            const string fspGroup4CodeForTest = "FSPGroup4";
            const string fspGroup4DisplayNameForTest = "FSPGroup4 display name";
            
            RemoveFundingStreamPeriods(new List<string> { fsp1CodeForTest, fsp2CodeForTest, fsp3CodeForTest, fsp4CodeForTest });
            RemoveFspGroups(new List<string>{ fspGroup1CodeForTest , fspGroup2CodeForTest , fspGroup4CodeForTest });
            
            using (var context = new DocumentsDomainDbContext())
            {
                var fspGroup1 = new FSPGroup(fspGroup1CodeForTest, fspGroup1DisplayNameForTest, displayOrder: 100);
                var fspGroup2 = new FSPGroup(fspGroup2CodeForTest, fspGroup2DisplayNameForTest, displayOrder: 400);
                var fspGroup4 = new FSPGroup(fspGroup4CodeForTest, fspGroup4DisplayNameForTest, displayOrder: 200);
                context.FSPGroups.Add(fspGroup1);
                context.FSPGroups.Add(fspGroup2);
                context.FSPGroups.Add(fspGroup4);

                var fsp1 = new FundingStreamPeriod(fundingStreamPeriodCode: fsp1CodeForTest,
                    summaryOfFundingDisplayName: fsp1CodeForTest + "_DisplayName", displayOrder: 1, shouldGenerateFundingAgreement: true,
                    shouldUseContractAllocationDescription: true, template: string.Empty, extraPagesTemplate: string.Empty, fspGroupCode: null, fundingAgreementDisplayName: null);
                fsp1.FspGroup = fspGroup1;
                context.FundingStreamPeriods.Add(fsp1);

                var fsp2 = new FundingStreamPeriod(fundingStreamPeriodCode: fsp2CodeForTest,
                    summaryOfFundingDisplayName: fsp2CodeForTest + "_DisplayName", displayOrder: 1, shouldGenerateFundingAgreement: true,
                    shouldUseContractAllocationDescription: true, template: string.Empty, extraPagesTemplate: string.Empty, fspGroupCode: null, fundingAgreementDisplayName: null);
                fsp2.FspGroup = fspGroup2;
                context.FundingStreamPeriods.Add(fsp2);

                var fsp3 = new FundingStreamPeriod(fundingStreamPeriodCode: fsp3CodeForTest,
                    summaryOfFundingDisplayName: fsp3CodeForTest + "_DisplayName", displayOrder: 1, shouldGenerateFundingAgreement: true,
                    shouldUseContractAllocationDescription: true, template: string.Empty, extraPagesTemplate: string.Empty, fspGroupCode: null, fundingAgreementDisplayName: null);
                context.FundingStreamPeriods.Add(fsp3);

                var fsp4 = new FundingStreamPeriod(fundingStreamPeriodCode: fsp4CodeForTest,
                    summaryOfFundingDisplayName: fsp4CodeForTest + "_DisplayName", displayOrder: 1, shouldGenerateFundingAgreement: true,
                    shouldUseContractAllocationDescription: true, template: string.Empty, extraPagesTemplate: string.Empty, fspGroupCode: null, fundingAgreementDisplayName: null);
                fsp4.FspGroup = fspGroup4;
                context.FundingStreamPeriods.Add(fsp4);

                context.SaveChanges();
            }

            using (var context = new DocumentsDomainDbContext())
            {
                var repository = new FundingStreamPeriodRepository(context);

                // act
                var fspGroupDisplayNames = repository.GetFspGroupDisplayNames(new List<string> { fsp1CodeForTest, fsp1CodeForTest, fsp2CodeForTest, fsp4CodeForTest });

               // assert
               Assert.IsNotNull(fspGroupDisplayNames, "Null returned");
               Assert.AreEqual(3,fspGroupDisplayNames.Count, "Incorrect number of FspGroupDisplayNames returned. Duplicate FspGroupDisplayName not removed ");
               Assert.AreEqual(fspGroup1DisplayNameForTest, fspGroupDisplayNames.First(), "Incorrect order for the first FspGroupDisplayName returned");
               Assert.AreEqual(fspGroup4DisplayNameForTest, fspGroupDisplayNames.ElementAt(1), "Incorrect order for the 2nd FspGroupDisplayName returned");
               Assert.AreEqual(fspGroup2DisplayNameForTest, fspGroupDisplayNames.Last(), "Incorrect order for the last FspGroupDisplayName returned");
            }
            RemoveFundingStreamPeriods(new List<string> { fsp1CodeForTest, fsp2CodeForTest, fsp3CodeForTest, fsp4CodeForTest });
            RemoveFspGroups(new List<string> { fspGroup1CodeForTest, fspGroup2CodeForTest, fspGroup4CodeForTest });
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void FundingStreamPeriodRepository_GetFspGroupDisplayNames_ShouldNotErrorWhenThereAreNoCorrespondingFspGroupDisplayNames()
        {
            // arrange
            const string fsp10CodeForTest = "FSP10";
            const string fsp20CodeForTest = "FSP20";

            RemoveFundingStreamPeriods(new List<string> { fsp10CodeForTest, fsp20CodeForTest});

            using (var context = new DocumentsDomainDbContext())
            {

                var fsp10 = new FundingStreamPeriod(fundingStreamPeriodCode: fsp10CodeForTest,
                    summaryOfFundingDisplayName: fsp10CodeForTest + "_DisplayName", displayOrder: 1, shouldGenerateFundingAgreement: true,
                    shouldUseContractAllocationDescription: true, template: string.Empty, extraPagesTemplate: string.Empty, fspGroupCode: null, fundingAgreementDisplayName: null);
                context.FundingStreamPeriods.Add(fsp10);

                var fsp20 = new FundingStreamPeriod(fundingStreamPeriodCode: fsp20CodeForTest,
                    summaryOfFundingDisplayName: fsp20CodeForTest + "_DisplayName", displayOrder: 1, shouldGenerateFundingAgreement: true,
                    shouldUseContractAllocationDescription: true, template: string.Empty, extraPagesTemplate: string.Empty, fspGroupCode: null, fundingAgreementDisplayName: null);
                context.FundingStreamPeriods.Add(fsp20);

                context.SaveChanges();
            }
            
            using (var context = new DocumentsDomainDbContext())
            {
                var repository = new FundingStreamPeriodRepository(context);

                // act
                var fspGroupDisplayNames = repository.GetFspGroupDisplayNames(new List<string> { fsp10CodeForTest, fsp20CodeForTest });

                // assert
                Assert.IsNotNull(fspGroupDisplayNames, "Null returned");
                Assert.AreEqual(0, fspGroupDisplayNames.Count, "Incorrect number of FspGroupDisplayNames returned ");
            }
            RemoveFundingStreamPeriods(new List<string> { fsp10CodeForTest, fsp20CodeForTest });
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void FundingStreamPeriodRepository_GetFspGroupDisplayNames_ShouldReturnCorrectFspGroupWhenOneFspCodeDoesNotHaveAFspGroup()
        {
            // arrange
            const string fsp30CodeForTest = "FSP30";
            const string fsp40CodeForTest = "FSP40";
            const string fsp50CodeForTest = "FSP50";

            const string fspGroup40CodeForTest = "FSPGroup40";
            const string fspGroup40DisplayNameForTest = "FSPGroup40 display name";
            const string fspGroup50CodeForTest = "FSPGroup50";
            const string fspGroup50DisplayNameForTest = "FSPGroup50 display name";

            RemoveFundingStreamPeriods(new List<string> { fsp30CodeForTest, fsp40CodeForTest, fsp50CodeForTest });
            RemoveFspGroups(new List<string> { fspGroup40CodeForTest, fspGroup50CodeForTest });

            using (var context = new DocumentsDomainDbContext())
            {
                var fspGroup40 = new FSPGroup(fspGroup40CodeForTest, fspGroup40DisplayNameForTest, displayOrder: 200);
                var fspGroup50 = new FSPGroup(fspGroup50CodeForTest, fspGroup50DisplayNameForTest, displayOrder: 100);
                context.FSPGroups.Add(fspGroup40);
                context.FSPGroups.Add(fspGroup50);

                var fsp30 = new FundingStreamPeriod(fundingStreamPeriodCode: fsp30CodeForTest,
                    summaryOfFundingDisplayName: fsp30CodeForTest + "_DisplayName", displayOrder: 1, shouldGenerateFundingAgreement: true,
                    shouldUseContractAllocationDescription: true, template: string.Empty, extraPagesTemplate: string.Empty, fspGroupCode: null, fundingAgreementDisplayName: null);
                context.FundingStreamPeriods.Add(fsp30);

                var fsp40 = new FundingStreamPeriod(fundingStreamPeriodCode: fsp40CodeForTest,
                    summaryOfFundingDisplayName: fsp40CodeForTest + "_DisplayName", displayOrder: 1, shouldGenerateFundingAgreement: true,
                    shouldUseContractAllocationDescription: true, template: string.Empty, extraPagesTemplate: string.Empty, fspGroupCode: null, fundingAgreementDisplayName: null);
                fsp40.FspGroup = fspGroup40;
                context.FundingStreamPeriods.Add(fsp40);

                var fsp50 = new FundingStreamPeriod(fundingStreamPeriodCode: fsp50CodeForTest,
                    summaryOfFundingDisplayName: fsp50CodeForTest + "_DisplayName", displayOrder: 1, shouldGenerateFundingAgreement: true,
                    shouldUseContractAllocationDescription: true, template: string.Empty, extraPagesTemplate: string.Empty, fspGroupCode: null, fundingAgreementDisplayName: null);
                fsp50.FspGroup = fspGroup50;
                context.FundingStreamPeriods.Add(fsp50);

                context.SaveChanges();
            }

            using (var context = new DocumentsDomainDbContext())
            {
                var repository = new FundingStreamPeriodRepository(context);

                // act
                var fspGroupDisplayNames = repository.GetFspGroupDisplayNames(new List<string> { fsp30CodeForTest, fsp40CodeForTest, fsp50CodeForTest });

                // assert
                Assert.IsNotNull(fspGroupDisplayNames, "Null returned");
                Assert.AreEqual(2, fspGroupDisplayNames.Count, "Incorrect number of FspGroupDisplayNames returned ");

                Assert.AreEqual(fspGroup50DisplayNameForTest, fspGroupDisplayNames.ElementAt(0), "Incorrect order for the first FspGroupDisplayName returned");
                Assert.AreEqual(fspGroup40DisplayNameForTest, fspGroupDisplayNames.ElementAt(1), "Incorrect order for the second FspGroupDisplayName returned");
            }
            RemoveFundingStreamPeriods(new List<string> { fsp30CodeForTest, fsp40CodeForTest, fsp50CodeForTest });
            RemoveFspGroups(new List<string> { fspGroup40CodeForTest, fspGroup50CodeForTest });
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void FundingStreamPeriodRepository_GetFspGroupDisplayNames_ShouldGetFspGroupDisplayNamesCorrectlyAccountingForCache()
        {
            // arrange
            const string fsp100CodeForTest = "FSP100";
            const string fspGroup100CodeForTest = "FSPGroup100";
            const string fspGroup100DisplayNameForTest = "FSPGroup100 display name";

            const string fsp200ForCodeTest = "FSP200";
            const string fspGroup200CodeForTest = "FSPGroup200";
            const string fspGroup200DisplayNameForTest = "FSPGroup200 display name";

            const string fsp300CodeForTest = "FSP300";

            const string fsp400CodeForTest = "FSP400";
            const string fspGroup400CodeForTest = "FSPGroup400";
            const string fspGroup400DisplayNameForTest = "FSPGroup400display name";
            
            RemoveFundingStreamPeriods(new List<string> { fsp100CodeForTest, fsp200ForCodeTest, fsp300CodeForTest, fsp400CodeForTest });
            RemoveFspGroups(new List<string> { fspGroup100CodeForTest, fspGroup200CodeForTest, fspGroup400CodeForTest });

            using (var context = new DocumentsDomainDbContext())
            {
                var fspGroup100 = new FSPGroup(fspGroup100CodeForTest, fspGroup100DisplayNameForTest, displayOrder: 100);
                var fspGroup200 = new FSPGroup(fspGroup200CodeForTest, fspGroup200DisplayNameForTest, displayOrder: 400);
                var fspGroup400 = new FSPGroup(fspGroup400CodeForTest, fspGroup400DisplayNameForTest, displayOrder: 200);
                context.FSPGroups.Add(fspGroup100);
                context.FSPGroups.Add(fspGroup200);
                context.FSPGroups.Add(fspGroup400);

                var fsp100 = new FundingStreamPeriod(fundingStreamPeriodCode: fsp100CodeForTest,
                    summaryOfFundingDisplayName: fsp100CodeForTest + "_DisplayName", displayOrder: 1, shouldGenerateFundingAgreement: true,
                    shouldUseContractAllocationDescription: true, template: string.Empty, extraPagesTemplate: string.Empty, fspGroupCode: null, fundingAgreementDisplayName: null);
                fsp100.FspGroup = fspGroup100;
                context.FundingStreamPeriods.Add(fsp100);

                var fsp200 = new FundingStreamPeriod(fundingStreamPeriodCode: fsp200ForCodeTest,
                    summaryOfFundingDisplayName: fsp200ForCodeTest + "_DisplayName", displayOrder: 1, shouldGenerateFundingAgreement: true,
                    shouldUseContractAllocationDescription: true, template: string.Empty, extraPagesTemplate: string.Empty, fspGroupCode: null, fundingAgreementDisplayName: null);
                fsp200.FspGroup = fspGroup200;
                context.FundingStreamPeriods.Add(fsp200);

                var fsp300 = new FundingStreamPeriod(fundingStreamPeriodCode: fsp300CodeForTest,
                    summaryOfFundingDisplayName: fsp300CodeForTest + "_DisplayName", displayOrder: 1, shouldGenerateFundingAgreement: true,
                    shouldUseContractAllocationDescription: true, template: string.Empty, extraPagesTemplate: string.Empty, fspGroupCode: null, fundingAgreementDisplayName: null);
                context.FundingStreamPeriods.Add(fsp300);

                var fsp400 = new FundingStreamPeriod(fundingStreamPeriodCode: fsp400CodeForTest,
                    summaryOfFundingDisplayName: fsp400CodeForTest + "_DisplayName", displayOrder: 1, shouldGenerateFundingAgreement: true,
                    shouldUseContractAllocationDescription: true, template: string.Empty, extraPagesTemplate: string.Empty, fspGroupCode: null, fundingAgreementDisplayName: null);
                fsp400.FspGroup = fspGroup400;
                context.FundingStreamPeriods.Add(fsp400);

                context.SaveChanges();
            }

            using (var context = new DocumentsDomainDbContext())
            {
                var repository = new FundingStreamPeriodRepository(context);

                var fspGroupDisplayNamesFirst = repository.GetFspGroupDisplayNames(new List<string> { fsp100CodeForTest, fsp100CodeForTest, fsp200ForCodeTest, fsp400CodeForTest });

                // remove rows from data tables to ensure the cache is called and not the database
                RemoveFundingStreamPeriods(new List<string> { fsp100CodeForTest, fsp200ForCodeTest, fsp300CodeForTest, fsp400CodeForTest });
                RemoveFspGroups(new List<string> { fspGroup100CodeForTest, fspGroup200CodeForTest, fspGroup400CodeForTest });

                // act
                var fspGroupDisplayNamesSecond = repository.GetFspGroupDisplayNames(new List<string> {fsp100CodeForTest, fsp100CodeForTest, fsp200ForCodeTest, fsp400CodeForTest});

                // assert
                Assert.AreEqual(3, fspGroupDisplayNamesFirst.Count, 
                    "Incorrect number of FspGroupDisplayNames returned. Duplicate FspGroupDisplayName not removed ");

                Assert.AreEqual(fspGroupDisplayNamesFirst.Count, fspGroupDisplayNamesSecond.Count,
                    "The count of fspGroupDisplayNames is different between the 1st and 2nd method calls");
                Assert.AreEqual(fspGroupDisplayNamesSecond.First(), fspGroupDisplayNamesFirst.First(),
                    "The 1st FspGroupDisplayName is different between the 1st and 2nd method calls");
                Assert.AreEqual(fspGroupDisplayNamesSecond.ElementAt(1), fspGroupDisplayNamesFirst.ElementAt(1),
                    "The 2nd FspGroupDisplayName is different between the 1st and 2nd method calls");
                Assert.AreEqual(fspGroupDisplayNamesSecond.Last(), fspGroupDisplayNamesFirst.Last(),
                    "The last FspGroupDisplayName is different between the 1st and 2nd method calls");
            }
            RemoveFundingStreamPeriods(new List<string> { fsp100CodeForTest, fsp200ForCodeTest, fsp300CodeForTest, fsp400CodeForTest });
            RemoveFspGroups(new List<string> { fspGroup100CodeForTest, fspGroup200CodeForTest, fspGroup400CodeForTest });
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void FundingStreamPeriodRepository_GetFspsWithGroups_ShouldGetGetFspsWithGroups()
        {
            // arrange
            const string fsp100CodeForTest = "FSP100";
            const string fspGroup100CodeForTest = "FSPGroup100";
            const string fspGroup100DisplayNameForTest = "FSPGroup100 display name";

            const string fsp200ForCodeTest = "FSP200";
            const string fspGroup200CodeForTest = "FSPGroup200";
            const string fspGroup200DisplayNameForTest = "FSPGroup200 display name";

            const string fsp300CodeForTest = "FSP300";

            const string fsp400CodeForTest = "FSP400";
            const string fspGroup400CodeForTest = "FSPGroup400";
            const string fspGroup400DisplayNameForTest = "FSPGroup400display name";

            RemoveFundingStreamPeriods(new List<string> { fsp100CodeForTest, fsp200ForCodeTest, fsp300CodeForTest, fsp400CodeForTest });
            RemoveFspGroups(new List<string> { fspGroup100CodeForTest, fspGroup200CodeForTest, fspGroup400CodeForTest });

            using (var context = new DocumentsDomainDbContext())
            {
                var fspGroup100 = new FSPGroup(fspGroup100CodeForTest, fspGroup100DisplayNameForTest, displayOrder: 100);
                var fspGroup200 = new FSPGroup(fspGroup200CodeForTest, fspGroup200DisplayNameForTest, displayOrder: 400);
                var fspGroup400 = new FSPGroup(fspGroup400CodeForTest, fspGroup400DisplayNameForTest, displayOrder: 200);
                context.FSPGroups.Add(fspGroup100);
                context.FSPGroups.Add(fspGroup200);
                context.FSPGroups.Add(fspGroup400);

                var fsp100 = new FundingStreamPeriod(fundingStreamPeriodCode: fsp100CodeForTest,
                    summaryOfFundingDisplayName: fsp100CodeForTest + "_DisplayName", displayOrder: 1, shouldGenerateFundingAgreement: true,
                    shouldUseContractAllocationDescription: true, template: string.Empty, extraPagesTemplate: string.Empty, fspGroupCode: null, fundingAgreementDisplayName: null);
                fsp100.FspGroup = fspGroup100;
                context.FundingStreamPeriods.Add(fsp100);

                var fsp200 = new FundingStreamPeriod(fundingStreamPeriodCode: fsp200ForCodeTest,
                    summaryOfFundingDisplayName: fsp200ForCodeTest + "_DisplayName", displayOrder: 1, shouldGenerateFundingAgreement: true,
                    shouldUseContractAllocationDescription: true, template: string.Empty, extraPagesTemplate: string.Empty, fspGroupCode: null, fundingAgreementDisplayName: null);
                fsp200.FspGroup = fspGroup200;
                context.FundingStreamPeriods.Add(fsp200);

                var fsp300 = new FundingStreamPeriod(fundingStreamPeriodCode: fsp300CodeForTest,
                    summaryOfFundingDisplayName: fsp300CodeForTest + "_DisplayName", displayOrder: 1, shouldGenerateFundingAgreement: true,
                    shouldUseContractAllocationDescription: true, template: string.Empty, extraPagesTemplate: string.Empty, fspGroupCode: null, fundingAgreementDisplayName: null);
                context.FundingStreamPeriods.Add(fsp300);

                var fsp400 = new FundingStreamPeriod(fundingStreamPeriodCode: fsp400CodeForTest,
                    summaryOfFundingDisplayName: fsp400CodeForTest + "_DisplayName", displayOrder: 1, shouldGenerateFundingAgreement: true,
                    shouldUseContractAllocationDescription: true, template: string.Empty, extraPagesTemplate: string.Empty, fspGroupCode: null, fundingAgreementDisplayName: null);
                fsp400.FspGroup = fspGroup400;
                context.FundingStreamPeriods.Add(fsp400);

                context.SaveChanges();
            }

            using (var context = new DocumentsDomainDbContext())
            {
                // act
                var fspsRetrieved = new FundingStreamPeriodRepository(context)
                    .GetFspsWithGroups(new List<string> { fsp100CodeForTest, fsp200ForCodeTest, fsp300CodeForTest, fsp400CodeForTest });

                // assert
                Assert.AreEqual(3, fspsRetrieved.Count(f => f.FspGroup != null));
            }
            RemoveFundingStreamPeriods(new List<string> { fsp100CodeForTest, fsp200ForCodeTest, fsp300CodeForTest, fsp400CodeForTest });
            RemoveFspGroups(new List<string> { fspGroup100CodeForTest, fspGroup200CodeForTest, fspGroup400CodeForTest });
        }

        private static IWindsorContainer GetContainer()
        {
            IWindsorContainer container = DocumentGeneration.IoC.WindsorInstallerForDocumentGenerator.Container;

            container.BeginScope();

            return container;
        }

        private static void RemoveFundingStreamPeriod(string fundingStreamPeriodCode)
        {
            using (var context = new DocumentsDomainDbContext())
            {
                context.FundingStreamPeriods.Where(fsp => fsp.FundingStreamPeriodCode == fundingStreamPeriodCode)
                    .ToList()
                    .ForEach(fsp => context.FundingStreamPeriods.Remove(fsp));

                context.SaveChanges();
            }
        }

        private static void RemoveFundingStreamPeriods(IReadOnlyCollection<string> fundingStreamPeriodCodes)
        {
            using (var context = new DocumentsDomainDbContext())
            {
                context.FundingStreamPeriods.Where(fsp => fundingStreamPeriodCodes.Contains(fsp.FundingStreamPeriodCode))
                    .ToList()
                    .ForEach(fsp => context.FundingStreamPeriods.Remove(fsp));

                context.SaveChanges();
            }
        }

        private static void RemoveFspGroups(IReadOnlyCollection<string> fspGroupCodes)
        {
            using (var context = new DocumentsDomainDbContext())
            {
                context.FSPGroups.Where(fg => fspGroupCodes.Contains(fg.FSPGroupCode))
                    .ToList()
                    .ForEach(fg => context.FSPGroups.Remove(fg));

                context.SaveChanges();
            }
        }

        private static void CreateFundingStreamPeriod(string fundingStreamPeriodCode)
        {
            using (var context = new DocumentsDomainDbContext())
            {
                context.FundingStreamPeriods.Add(new FundingStreamPeriod(fundingStreamPeriodCode,
                    "D_Name", 1, true,
                    true, string.Empty, string.Empty, 
                    null, string.Empty));
                context.SaveChanges();
            }
        }
    }
}
