namespace SFA.FCT.AllocationDeliveryDomain.Common.DataStore
{
    using System;
    using System.Data.Entity;
    using Model;
    using System.Linq;

    public interface IMonitoringDeliverablesDbContext : IDisposable
    {
        Database Database { get; }

        // we should be using DBSet rather than IDbSet. see...
        // http://stackoverflow.com/questions/31539750/why-theres-no-addrange-removerange-method-in-idbset-interface-in-entity-6

        DbSet<FundingStreamPeriodDeliverable> FundingStreamPeriodDeliverables { get; set; }

        DbSet<AllocationDeliverablePeriod> AllocationDeliverablePeriods { get; set; }

        DbSet<AllocationDeliverablePeriodActualAudit> AllocationDeliverablePeriodActualAudits { get; set; }

        DbSet<CurrentViewActual> CurrentViewActuals { get; set; }

        DbSet<FundingStreamPeriod> FundingStreamPeriods { get; set; }

        DbSet<EsfAllocationData> ESFAllocationData { get; set; }

        DbSet<PaymentInstructionAudit> PaymentInstructionAudits { get; set; }

        DbSet<InactiveAllocation> InactiveAllocations { get; set; }

        DbSet<HeldReportedActualGroup> HeldReportedActualGroups { get; set; }

        DbSet<HeldFspCollectionConfig> HeldFspCollectionConfigs { get; set; }

        DbSet<AllocationUnderTermination> AllocationsUnderTermination { get; set; }

        IQueryable<AllocationDeliverablePeriod> ActiveAllocationDeliverablePeriods { get; }

        IDbSet<SummarisedActual> SummarisedActuals { get; set; }
        
        int SaveChanges();
    }
}