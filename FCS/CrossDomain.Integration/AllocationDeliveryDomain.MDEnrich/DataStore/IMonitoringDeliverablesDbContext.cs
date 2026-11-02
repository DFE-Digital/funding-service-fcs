namespace SFA.FCT.AllocationDeliveryDomain.MDEnrich.DataStore
{
    using System;
    using System.Data.Entity;
    using Model;

    public interface IMonitoringDeliverablesDbContext : IDisposable
    {
        Database Database { get;}
        IDbSet<FundingStreamPeriodDeliverable> FundingStreamPeriodDeliverables { get; set; }

        IDbSet<AllocationDeliverablePeriod> AllocationDeliverablePeriods { get; set; }

        int SaveChanges();


    }
}
