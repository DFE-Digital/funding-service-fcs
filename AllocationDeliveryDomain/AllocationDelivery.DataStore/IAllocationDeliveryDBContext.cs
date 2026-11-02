namespace SFA.FCT.AllocationDelivery.DataStore
{
    using System;
    using System.Data.Entity;
    using Model;

    public interface IAllocationDeliveryDbContext : IDisposable
    {
        IDbSet<AllocationDeliveryEntry> AllocationDeliveryEntries { get; set; }

        IDbSet<AllocationDeliveryEntryData> AllocationDeliveryEntryDataItems { get;}

        IDbSet<ProcessedMessage> ProcessedMessages { get; set; }

        int SaveChanges();
    }
}
