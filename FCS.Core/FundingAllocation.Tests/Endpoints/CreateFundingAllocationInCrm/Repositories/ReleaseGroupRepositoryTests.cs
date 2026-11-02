namespace FundingAllocation.Tests.Endpoints.CreateFundingAllocationInCrm.Repositories
{
    using System;
    using System.Collections.Generic;
    using System.Linq;
    using DataStore;
    using DataStore.Model;
    using FundingAllocation.Repositories;
    using Microsoft.Data.SqlClient;
    using Microsoft.EntityFrameworkCore;
    using Microsoft.VisualStudio.TestTools.UnitTesting;

    [TestClass]
    public class ReleaseGroupRepositoryTests
    {
        [TestMethod, TestCategory("IntegrationTest")]
        public void ReleaseGroupRepository_GetAwaitingReleaseGroup_ShouldGetGroupWhenThereIsOneWithNoReleasedDate()
        {
            // arrange
            using var context = new FundingAllocationContext(GetContextOptions());
            const string fundingType = "ft";
            const string fundingPeriod = "fp";
            const string fspGroupCode = "fspGrpCode";
            const string contractType = "ct";
            const string releaseGroupName1 = "RG100888";
            const string releaseGroupName2 = "RG100999";
            RemoveReleaseGroups(fundingType, fundingPeriod, fspGroupCode, contractType);
            InsertReleaseGroup(fundingType, fundingPeriod, fspGroupCode, contractType, releaseGroupName1, status: ReleaseGroupStatus.Released);
            int awaitingReleaseGroupId = InsertReleaseGroup(fundingType, fundingPeriod, fspGroupCode, contractType, releaseGroupName2);
            ReleaseGroupRepository repository = new ReleaseGroupRepository(context);
            
            // act
            var codeOption = repository.GetAwaitingReleaseGroup(fundingType, fundingPeriod, fspGroupCode, contractType)
                .Result;

            // assert
            Assert.IsTrue(codeOption.IsSome, "We should have returned a value");
            codeOption.Match(Some: id => Assert.AreEqual(awaitingReleaseGroupId, id.PaaSId),
                None: () => Assert.Fail("We have not returned an id"));
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void ReleaseGroupRepository_GetAwaitingReleaseGroup_ShouldGetNoneWhenThereArentAny()
        {
            // arrange
            using var context = new FundingAllocationContext(GetContextOptions());
            const string fundingType = "ft";
            const string fundingPeriod = "fp";
            const string fspGroupCode = "fspGrpCode";
            const string contractType = "ct";
            RemoveReleaseGroups(fundingType, fundingPeriod, fspGroupCode, contractType);
            ReleaseGroupRepository repository = new ReleaseGroupRepository(context);

            // act
            var codeOption = repository.GetAwaitingReleaseGroup(fundingType, fundingPeriod, fspGroupCode, contractType)
                .Result;

            // assert
            Assert.IsTrue(codeOption.IsNone, "We should not have returned a value");
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void ReleaseGroupRepository_GetAwaitingReleaseGroup_ShouldGetNoneWhenTheyAreAllInProgress()
        {
            // arrange
            using var context = new FundingAllocationContext(GetContextOptions());
            const string fundingType = "EDSK";
            const string fundingPeriod = "AY2122";
            const string fspGroupCode = "fspGrpCode";
            const string contractType = "ct";
            const string releaseGroupName1 = "RG100888";
            RemoveReleaseGroups(fundingType, fundingPeriod, fspGroupCode, contractType);
            InsertReleaseGroup(fundingType, fundingPeriod, fspGroupCode, contractType, releaseGroupName1, ReleaseGroupStatus.ReleaseInProgress);
            ReleaseGroupRepository repository = new ReleaseGroupRepository(context);

            // act
            var codeOption = repository.GetAwaitingReleaseGroup(fundingType, fundingPeriod, fspGroupCode, contractType)
                .Result;

            // assert
            Assert.IsTrue(codeOption.IsNone, "We should not have returned a value");
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void ReleaseGroupRepository_CreateReleaseGroup_ShouldInsert()
        {
            // arrange
            using var context = new FundingAllocationContext(GetContextOptions());
            const string fundingType = "ft";
            const string fundingPeriod = "fp";
            const string fspGroupCode = "fspGrpCode";
            const string contractType = "ct";
            string releaseGroupName = "RG100999";
            const string expectedStatus = "AwaitingRelease";
            Guid crmEntityId = Guid.NewGuid();
            RemoveReleaseGroups(fundingType, fundingPeriod, fspGroupCode, contractType);
            ReleaseGroupRepository repository = new ReleaseGroupRepository(context);

            // act
            repository.CreateReleaseGroup(fundingType, fundingPeriod, fspGroupCode, contractType, crmEntityId, releaseGroupName).Wait();
            // assert
            var releaseGroups = GetReleaseGroups(fundingType, fundingPeriod, fspGroupCode, contractType);
            Assert.AreEqual(1, releaseGroups.Count, "The number created is not correct");
            var releaseGroup = releaseGroups.Single();
            Assert.AreEqual(fundingType, releaseGroup.FundingTypeCode, "The FundingTypeCode is not correct");
            Assert.AreEqual(fundingPeriod, releaseGroup.FundingPeriodCode, "The FundingPeriodCode is not correct");
            Assert.AreEqual(fspGroupCode, releaseGroup.FSPGroupCode, "The FSPGroupCode is not correct");
            Assert.AreEqual(contractType, releaseGroup.ContractType, "The ContractType is not correct");
            Assert.AreEqual(crmEntityId, releaseGroup.CrmEntityId, "The CrmEntityId is not correct");
            Assert.AreEqual(releaseGroupName, releaseGroup.ReleaseGroupName, "The ReleaseGroupName is not correct");
            Assert.AreEqual(expectedStatus, releaseGroup.Status, "The status is not correct");
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void ReleaseGroupRepository_GetNextReleaseGroupName_ShouldReturnStringPrefixedWithRGThenNumber()
        {
            // arrange
            using var context = new FundingAllocationContext(GetContextOptions());
            ReleaseGroupRepository repository = new ReleaseGroupRepository(context);

            // act
            var releaseGroupName = repository.GetNextReleaseGroupName().Result;

            // assert
           Assert.AreEqual(releaseGroupName[..2], "RG", "The first 2 characters are not correct");
           Assert.IsTrue(int.TryParse(releaseGroupName[2..], out int i), "The section after RG should be a number");
        }

        private void RemoveReleaseGroups(string fundingType, string fundingPeriod, string fspGroupCode, string contractType)
        {
            using var context = new FundingAllocationContext(GetContextOptions());
            context.ReleaseGroups.Where(rg => rg.FundingTypeCode == fundingType && rg.FundingPeriodCode == fundingPeriod && rg.FSPGroupCode == fspGroupCode
            && rg.ContractType == contractType).ToList()
                .ForEach(rg => context.ReleaseGroups.Remove(rg));

            context.SaveChanges();
        }

        private int InsertReleaseGroup(string fundingType, string fundingPeriod, string fspGroupCode,
            string contractType, string releaseGroupName, ReleaseGroupStatus status = ReleaseGroupStatus.AwaitingRelease)
        {
            using var context = new FundingAllocationContext(GetContextOptions());
            ReleaseGroup releaseGroup = new ReleaseGroup(fundingType, fundingPeriod, fspGroupCode, 
                contractType, Guid.NewGuid(), releaseGroupName);
            releaseGroup.ReleaseGroupStatus = status;
            if (status == ReleaseGroupStatus.Released)
            {
                releaseGroup.ReleasedDate = DateTime.Now;
            }
            context.ReleaseGroups.Add(releaseGroup);
            context.SaveChanges();

            return releaseGroup.Id;
        }

        private IReadOnlyCollection<ReleaseGroup> GetReleaseGroups(string fundingType, string fundingPeriod, string fspGroupCode,
            string contractType)
        {
            using var context = new FundingAllocationContext(GetContextOptions());

            return context.ReleaseGroups.Where(rg =>
                rg.FundingTypeCode == fundingType && rg.FundingPeriodCode == fundingPeriod &&
                rg.FSPGroupCode == fspGroupCode && rg.ContractType == contractType)
                .ToList();
        }

        private static DbContextOptions<FundingAllocationContext> GetContextOptions()
        {
            var connectionString = AppConfiguration.Configuration()["ConnectionStrings:NServiceBus/Persistence"];

            return new DbContextOptionsBuilder<FundingAllocationContext>()
                .UseSqlServer(new SqlConnection(connectionString))
                .Options;
        }
    }
}
