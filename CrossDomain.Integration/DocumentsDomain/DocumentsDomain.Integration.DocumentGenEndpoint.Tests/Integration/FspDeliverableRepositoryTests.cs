namespace SFA.FCT.DocumentsDomain.Integration.DocumentGenEndpoint.Tests.Integration
{
    using System.Linq;
    using DataStore;
    using DataStore.Models;
    using DataStore.Repositories;
    using Microsoft.VisualStudio.TestTools.UnitTesting;

    [TestClass]
    public class FspDeliverableRepositoryTests
    {
        [TestMethod, TestCategory("IntegrationTest")]
        public void FspDeliverableRepository_ShouldGetFspDeliverableByKey()
        {
            // arrange
            const int delCode = 1;
            const string fspCode = "TESTFSP123";
            const string fspGroupCode = "TESTFSPGROUP123";
            var fspGroup = new FSPGroup(fspGroupCode, contractDocumentDisplayName: "TEST DISPLAY NAME", displayOrder: 1);

            ClearDown(fspCode, fspGroupCode);

            FundingStreamPeriod fsp = new FundingStreamPeriod(
                fundingStreamPeriodCode: fspCode,
                summaryOfFundingDisplayName: string.Empty, 
                displayOrder: 0,
                shouldGenerateFundingAgreement: true,
                shouldUseContractAllocationDescription: true, 
                template: string.Empty, 
                extraPagesTemplate: string.Empty,
                fspGroupCode: string.Empty,
                fundingAgreementDisplayName: string.Empty);
            fsp.FspGroup = fspGroup;

            FSPDeliverable fspDeliverable = new FSPDeliverable(
                deliverableCode: delCode,
                fundingStreamPeriodCode: fspCode,
                allowProfile: true,
                displayOnFundingAgreement: true,
                mandatoryOnFundingAgreement: true,
                displayOrderOnFundingAgreement: 1,
                allowCustomDescription: false,
                shouldDisplayValue: true,
                shouldDisplayVolumeAndUnitCost: false,
                displayNameOnSummaryOfFunding: "Test Fsp",
                displayNameOnFundingAgreement: "Test Fsp",
                displayOnSummaryOfFunding: false)
            {
                FundingStreamPeriod = fsp
            };

            using (var context = new DocumentsDomainDbContext())
            {
                context.FundingStreamPeriods.Add(fsp);

                context.FSPDeliverables.Add(fspDeliverable);
                context.SaveChanges();
            }

            using (var context = new DocumentsDomainDbContext())
            {
                var repository = new FspDeliverableRepository(context);

                // act
                var fspDelFromRepository = repository.GetFspDeliverable(fspCode, delCode);

                // assert
                Assert.IsNotNull(fspDelFromRepository);
            }
            ClearDown(fspCode, fspGroupCode);
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void FspDeliverableRepository_ShouldGetFspDeliverablesByFspCode()
        {
            // arrange
            const int expectedCount = 5;
            const string fspCode = "TESTFSP123";
            const string fspGroupCode = "TESTFSPGROUP123";
            var fspGroup = new FSPGroup(fspGroupCode, contractDocumentDisplayName: "TEST DISPLAY NAME", displayOrder: 1);

            ClearDown(fspCode, fspGroupCode);

            FundingStreamPeriod fsp = new FundingStreamPeriod(
                fundingStreamPeriodCode: fspCode,
                summaryOfFundingDisplayName: string.Empty,
                displayOrder: 0,
                shouldGenerateFundingAgreement: true,
                shouldUseContractAllocationDescription: true,
                template: string.Empty,
                extraPagesTemplate: string.Empty,
                fspGroupCode: string.Empty,
                fundingAgreementDisplayName: string.Empty);
            fsp.FspGroup = fspGroup;


            using (var context = new DocumentsDomainDbContext())
            {
                context.FundingStreamPeriods.Add(fsp);

                Enumerable.Range(1, expectedCount)
                    .Select(i => new FSPDeliverable(
                        deliverableCode: i,
                        fundingStreamPeriodCode: fspCode,
                        allowProfile: true,
                        displayOnFundingAgreement: true,
                        mandatoryOnFundingAgreement: true,
                        displayOrderOnFundingAgreement: i,
                        allowCustomDescription: false,
                        shouldDisplayValue: true,
                        shouldDisplayVolumeAndUnitCost: false,
                        displayNameOnSummaryOfFunding: "Test Fsp",
                        displayNameOnFundingAgreement: "Test Fsp",
                        displayOnSummaryOfFunding: false)
                    {
                        FundingStreamPeriod = fsp
                    })
                    .ToList()
                    .ForEach(fspd => context.FSPDeliverables.Add(fspd));

                context.SaveChanges();
            }

            using (var context = new DocumentsDomainDbContext())
            {
                var repository = new FspDeliverableRepository(context);

                // act
                var fspDeliverablesForFundingStreamPeriod = repository.GetFspDeliverablesForFundingStreamPeriod(fspCode);

                // assert
                Assert.IsNotNull(fspDeliverablesForFundingStreamPeriod);
                Assert.AreEqual(expectedCount, fspDeliverablesForFundingStreamPeriod.Count);
            }
            ClearDown(fspCode, fspGroupCode);
        }

        private static void ClearDown(string fspCode, string fspGroupCode)
        {
            using (var context = new DocumentsDomainDbContext())
            {
                context.FSPDeliverables
                    .Where(fspd => fspd.FundingStreamPeriodCode == fspCode)
                    .ToList()
                    .ForEach(fspd => context.FSPDeliverables.Remove(fspd));

                context.SaveChanges();

                var fspToRemove = context.FundingStreamPeriods.Find(fspCode);

                if (fspToRemove != null)
                {
                    context.FundingStreamPeriods.Remove(fspToRemove);
                    context.SaveChanges();
                }

                var fspGroupToRemove = context.FSPGroups.Find(fspGroupCode);

                if (fspGroupToRemove != null)
                {
                    context.FSPGroups.Remove(fspGroupToRemove);
                    context.SaveChanges();
                }
            }

        }
    }
}