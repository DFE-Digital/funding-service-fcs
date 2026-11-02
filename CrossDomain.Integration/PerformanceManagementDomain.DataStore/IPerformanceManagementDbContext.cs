namespace SFA.FCT.PerformanceManagementDomain.DataStore
{
    using System.Data.Entity;
    using System.Linq;
    using Models;
    using Models.Allocation;

    public interface IPerformanceManagementDbContext
    {
        IDbSet<ClaimType> ClaimTypes { get; }

        IDbSet<ClaimCollection> ClaimCollections { get; }

        IDbSet<ClaimReconciliationAllocationGroup> ClaimReconciliationAllocationGroups { get; }

        IDbSet<ClaimReconciliationAllocationGroupFsp> ClaimReconciliationAllocationGroupFsps { get; }

        IDbSet<ClaimReconciliationDeliverableGroup> ClaimReconciliationDeliverableGroups { get; }

        IDbSet<ClaimReconciliationReferenceDataProfile> ClaimReconciliationReferenceDataProfiles { get; }

        IDbSet<ClaimReconciliationBehaviour> ClaimReconciliationBehaviours { get; }

        IDbSet<ClaimReconciliationPublicationException> ClaimReconciliationPublicationExceptions { get; }

        IDbSet<FspDeliverableClaim> FspDeliverableClaims { get; }

        DbSet<FundingClaim> FundingClaims { get; }

        IQueryable<FundingClaim> FundingClaimsWithAllocations { get; }

        IDbSet<FundingClaimContractAllocation> FundingClaimContractAllocations { get; }

        IDbSet<FundingClaimDeliverable> FundingClaimDeliverables { get; }

        IDbSet<FundingClaimCollectionImportInfo> FundingClaimCollectionImportInfos { get; }

        DbSet<ContractAllocationDeliverable> ContractAllocationDeliverables { get; } 

        IDbSet<ContractAllocation> ContractAllocations { get; }

        IDbSet<AtomFeedItem> AtomFeedItems { get; }

        IDbSet<FundingStreamPeriod> FundingStreamPeriods { get; }

        IDbSet<ClaimReconciliationReferenceDataReconProfiling> ClaimReconciliationReferenceDataReconProfilings { get; }

        int SaveChanges();

        int ExecuteSqlCommand(string sql, params object[] parameters);
    }
}