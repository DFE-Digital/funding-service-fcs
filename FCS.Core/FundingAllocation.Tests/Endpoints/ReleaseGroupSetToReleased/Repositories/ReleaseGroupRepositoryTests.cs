namespace FundingAllocation.Tests.Endpoints.ReleaseGroupSetToReleased.Repositories
{
    using System;
    using System.Data.Common;
    using System.Linq;
    using System.Threading.Tasks;
    using Dapper;
    using DataStore;
    using DataStore.Migrations;
    using DataStore.Model;
    using FluentAssertions;
    using FundingAllocation.Endpoints.ReleaseGroupSetToReleased.Repositories;
    using Microsoft.Data.SqlClient;
    using Microsoft.EntityFrameworkCore;
    using Microsoft.EntityFrameworkCore.Infrastructure;
    using Microsoft.VisualStudio.TestTools.UnitTesting;

    [TestClass]
    public class ReleaseGroupRepositoryTests
    {
        [TestMethod, TestCategory("IntegrationTest")]
        public void ReleaseGroupRepository_SetToReleasedIfNotAlready_ShouldSetStatusToReleasedIfNotReleased()
        {
            const string releaseGroupName = "ReleaseGroup to be set to released";

            RemoveReleaseGroup(releaseGroupName);
            var crmEntityId = CreateReleaseGroupAndReturnCrmEntityId(releaseGroupName);

            var releasedReleaseGroupBefore = GetReleaseGroup(releaseGroupName);
            Assert.AreEqual("AwaitingRelease", releasedReleaseGroupBefore.Status, "The status before update is not correct");
            Assert.IsNull(releasedReleaseGroupBefore.ReleasedDate, "The ReleasedDate is not null before update");

            using var context = new FundingAllocationContext(GetContextOptions());
            var repository = new ReleaseGroupRepository(context);

            // act
            var isSet = repository.SetToReleasedIfNotAlready(releaseGroupName).Result;

            // assert
            var releasedReleaseGroupAfter = GetReleaseGroup(releaseGroupName);
            Assert.AreEqual(true, isSet, "The return is not correct");
            releasedReleaseGroupAfter.ReleasedDate.Should().NotBeNull();
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void ReleaseGroupRepository_SetToReleasedIfNotAlready_ShouldNotSetStatusToReleasedIfAlreadyReleased()
        {
            const string releaseGroupName = "ReleaseGroup to be set to released";

            RemoveReleaseGroup(releaseGroupName);
            var crmEntityId = CreateReleaseGroupAndReturnCrmEntityId(releaseGroupName, ReleaseGroupStatus.Released);

            var releasedReleaseGroupBefore = GetReleaseGroup(releaseGroupName);
            Assert.AreEqual("Released", releasedReleaseGroupBefore.Status, "The status before update is not correct");

            using var context = new FundingAllocationContext(GetContextOptions());
            var repository = new ReleaseGroupRepository(context);

            // act
            var isSet = repository.SetToReleasedIfNotAlready(releaseGroupName).Result;

            // assert
            var releasedReleaseGroupAfter = GetReleaseGroup(releaseGroupName);
            Assert.AreEqual(false, isSet, "The return is not correct");
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void ReleaseGroupRepository_GetCrmEntityId_ShouldReturnId()
        {
            const string releaseGroupName = "ReleaseGroup to be set to released";

            RemoveReleaseGroup(releaseGroupName);
            CreateReleaseGroupAndReturnCrmEntityId(releaseGroupName);

            using var context = new FundingAllocationContext(GetContextOptions());
            var repository = new ReleaseGroupRepository(context);

            // act
            var crmId = repository.GetCrmEntityId(releaseGroupName).Result;

            // assert
            crmId.Should().NotBeEmpty();
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void ReleaseGroupRepository_GetFundingTypeFundingPeriod_ShouldReturnAFundingTypeFundingPeriod()
        {
            const string releaseGroupName = "Released ReleaseGroup";
            const string fundingTypeCode = "ftc1";
            const string fundingPeriodCode = "fpc1";

            RemoveReleaseGroup(releaseGroupName);
            CreateReleaseGroupAndReturnCrmEntityId(releaseGroupName, ReleaseGroupStatus.Released, fundingTypeCode, fundingPeriodCode);

            using var context = new FundingAllocationContext(GetContextOptions());
            var repository = new ReleaseGroupRepository(context);

            // act
            var fundingTypeFundingPeriod = repository.GetFundingTypeFundingPeriod(releaseGroupName).Result;

            // assert
            fundingTypeFundingPeriod.Should().NotBeNull();
            fundingTypeFundingPeriod.FundingType.Should().Be(fundingTypeCode);
            fundingTypeFundingPeriod.FundingPeriod.Should().Be(fundingPeriodCode);
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void ReleaseGroupRepository_IsReleaseGroupGroupReleased_ShouldReturnTrueWhenAllReleaseGroupsAreReleased()
        {
            const string releaseGroupNamePrefix = "RG_Prefix";
            const string fundingTypeCode = "EDSK";
            const string fundingPeriodCode = "AY2122";
            RemoveReleaseGroupGroups();
            RemoveReleaseGroupLike(releaseGroupNamePrefix);
            var releaseGroupGroupId = GetNextReleaseGroupGroupId();
            Enumerable.Range(1, 2).ToList().ForEach(i =>
            {
                var rgId = CreateReleaseGroupAndReturnId($"{releaseGroupNamePrefix}{i}", ReleaseGroupStatus.Released, fundingTypeCode, fundingPeriodCode);

                CreateReleaseGroupGroup(new ReleaseGroupGroup(releaseGroupGroupId, rgId));
            });

            using var context = new FundingAllocationContext(GetContextOptions());
            var repository = new ReleaseGroupRepository(context);

            // act
            var isReleaseGroupReleased = repository.IsReleaseGroupGroupReleased($"{releaseGroupNamePrefix}1").Result;

            // assert
            isReleaseGroupReleased.Should().BeTrue();
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void ReleaseGroupRepository_IsReleaseGroupGroupReleased_ShouldReturnFalseWhenOneOrMoreReleaseGroupsAreNotReleased()
        {
            const string releaseGroupNamePrefix = "RG_Prefix";
            const string fundingTypeCode = "EDSK";
            const string fundingPeriodCode = "AY2122";
            RemoveReleaseGroupGroups();
            RemoveReleaseGroupLike(releaseGroupNamePrefix);
            var releaseGroupGroupId = GetNextReleaseGroupGroupId();
            Enumerable.Range(1, 3).ToList().ForEach(i =>
            {
                ReleaseGroupStatus status = ReleaseGroupStatus.Released;
                if (i % 2 == 0)
                {
                    status = ReleaseGroupStatus.ReleaseInProgress;
                }
                var rgId = CreateReleaseGroupAndReturnId($"{releaseGroupNamePrefix}{i}", status, fundingTypeCode, fundingPeriodCode);

                CreateReleaseGroupGroup(new ReleaseGroupGroup(releaseGroupGroupId, rgId));
            });

            using var context = new FundingAllocationContext(GetContextOptions());
            var repository = new ReleaseGroupRepository(context);

            // act
            var isReleaseGroupReleased = repository.IsReleaseGroupGroupReleased($"{releaseGroupNamePrefix}1").Result;

            // assert
            isReleaseGroupReleased.Should().BeFalse();
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void ReleaseGroupRepository_GetReleaseGroupGroupId_ShouldReturnIdOfReleaseGroupGroup()
        {
            const string releaseGroupNamePrefix = "RG_Prefix";
            const string fundingTypeCode = "EDSK";
            const string fundingPeriodCode = "AY2122";
            RemoveReleaseGroupGroups();
            RemoveReleaseGroupLike(releaseGroupNamePrefix);
            var releaseGroupGroupId = GetNextReleaseGroupGroupId();
            Enumerable.Range(1, 3).ToList().ForEach(i =>
            {
                var rgId = CreateReleaseGroupAndReturnId($"{releaseGroupNamePrefix}{i}", ReleaseGroupStatus.Released, fundingTypeCode, fundingPeriodCode);

                CreateReleaseGroupGroup(new ReleaseGroupGroup(releaseGroupGroupId, rgId));
            });

            using var context = new FundingAllocationContext(GetContextOptions());
            var repository = new ReleaseGroupRepository(context);

            // act
            var releaseGroupGroupIdReturned = repository.GetReleaseGroupGroupId($"{releaseGroupNamePrefix}1").Result;

            // assert
            releaseGroupGroupIdReturned.Should().Be(releaseGroupGroupId);
        }

        public static void CreateReleaseGroupGroup(ReleaseGroupGroup releaseGroupGroup)
        {
            using var context = new FundingAllocationContext(GetContextOptions());
            context.ReleaseGroupGroups.Add(releaseGroupGroup);

            context.SaveChanges();
        }

        public static int GetNextReleaseGroupGroupId()
        {
            return new FundingAllocationContext(GetContextOptions()).Database.GetDbConnection().ExecuteScalar<int>($"SELECT NEXT VALUE FOR [FundingAllocation].[ReleaseGroupGroupId_seq]");
        }

        private static void RemoveReleaseGroup(string releaseGroupName)
        {
            using var context = new FundingAllocationContext(GetContextOptions());

            context.ReleaseGroups.Where(rg => rg.ReleaseGroupName == releaseGroupName).ToList().ForEach(rg =>
            {
                context.ReleaseGroups.Remove(rg);
            });

            context.SaveChanges();
        }

        private static void RemoveReleaseGroupGroups()
        {
            using var context = new FundingAllocationContext(GetContextOptions());

            context.ReleaseGroupGroups.ToList().ForEach(rgg =>
            {
                context.ReleaseGroupGroups.Remove(rgg);
            });

            context.SaveChanges();
        }

        private static void RemoveReleaseGroupLike(string releaseGroupNamePrefix)
        {
            using var context = new FundingAllocationContext(GetContextOptions());

            context.ReleaseGroups.Where(rg => rg.ReleaseGroupName.Contains(releaseGroupNamePrefix)).ToList().ForEach(rg =>
            {
                context.ReleaseGroups.Remove(rg);
            });

            context.SaveChanges();
        }

        private static string CreateReleaseGroupAndReturnCrmEntityId(string releaseGroupName, ReleaseGroupStatus status = ReleaseGroupStatus.AwaitingRelease,
            string fundingTypeCode = "fundingTypeCode", string fundingPeriodCode = "fundingPeriodCode")
        {
            var crmEntityId = Guid.NewGuid();

            var releaseGroup = new ReleaseGroup(
                fundingTypeCode,
                fundingPeriodCode,
                "fspGroupCode",
                "contractType",
                crmEntityId,
                releaseGroupName);
            
            using var context = new FundingAllocationContext(GetContextOptions());
            context.ReleaseGroups.Add(releaseGroup);
            releaseGroup.ReleaseGroupStatus = status;
            context.SaveChanges();

            return crmEntityId.ToString();
        }

        private static int CreateReleaseGroupAndReturnId(string releaseGroupName, ReleaseGroupStatus status = ReleaseGroupStatus.AwaitingRelease,
            string fundingTypeCode = "fundingTypeCode", string fundingPeriodCode = "fundingPeriodCode")
        {
            var crmEntityId = Guid.NewGuid();

            var releaseGroup = new ReleaseGroup(
                fundingTypeCode,
                fundingPeriodCode,
                $"fspGroupCode{releaseGroupName}",
                "contractType",
                crmEntityId,
                releaseGroupName);

            using var context = new FundingAllocationContext(GetContextOptions());
            context.ReleaseGroups.Add(releaseGroup);
            releaseGroup.ReleaseGroupStatus = status;
            context.SaveChanges();

            return releaseGroup.Id;
        }

        private static ReleaseGroup GetReleaseGroup(string releaseGroupName)
        {
            using var context = new FundingAllocationContext(GetContextOptions());

            return context.ReleaseGroups.Single(rg => rg.ReleaseGroupName == releaseGroupName);
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