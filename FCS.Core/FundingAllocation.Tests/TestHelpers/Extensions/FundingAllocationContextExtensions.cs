namespace FundingAllocation.Tests.TestHelpers.Extensions
{
    using System;
    using DataStore;
    using FundingAllocation.DataStore.Model;
    using Microsoft.EntityFrameworkCore;

    public static class FundingAllocationContextExtensions
    {
        public static void RemoveAllContractsAndReferences(this FundingAllocationContext context)
        {
            context.FundingAllocationProfilePeriods.RemoveAll();
            context.FundingAllocationLines.RemoveAll();
            context.ProviderFundingAllocations.RemoveAll();
            context.FundingAllocations.RemoveAll();
            context.Contracts.RemoveAll();
            context.ReleaseGroups.RemoveAll();
            context.ProviderFundings.RemoveAll();
            context.SaveChanges();
        }

        public static FundingAllocationContext CreateFeedRead(this FundingAllocationContext context, out int feedReadId, DateTime? jobCompletedDate = null, DateTime? cfsReadCompletedDate = null)
        {
            var feedRead = new FeedRead
            {
                JobCompletedDate = jobCompletedDate,
                CfsReadCompletedDate = cfsReadCompletedDate
            };
            context.FeedReads.Add(feedRead);
            context.SaveChanges();

            feedReadId = feedRead.ReadId;

            return context;
        }

        public static FundingAllocationContext AddContracts(this FundingAllocationContext context, params Contract[] contracts)
        {
            foreach (var contract in contracts)
            {
                context.Add(contract);
            }

            context.SaveChanges();

            return context;
        }

        public static FundingAllocationContext AddFundingAllocations(this FundingAllocationContext context, params FundingAllocation[] fundingAllocations)
        {
            context.AddAllAndSave(fundingAllocations);

            return context;
        }

        public static FundingAllocationContext AddAllAndSave<T>(this FundingAllocationContext context, params T[] items)
        {
            foreach (var item in items)
            {
                context.Add(item);
            }

            context.SaveChanges();

            return context;
        }

        public static DbSet<T> RemoveAll<T>(this DbSet<T> set) where T: class
        {
            set.RemoveRange(set);

            return set;
        }

        public static DbSet<FundingAllocation> RemoveAll(this DbSet<FundingAllocation> set)
        {
            set.RemoveRange(set);

            return set;
        }

        public static DbSet<Contract> RemoveAll(this DbSet<Contract> set)
        {
            set.RemoveRange(set);

            return set;
        }
    }
}