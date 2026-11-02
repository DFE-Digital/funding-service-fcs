namespace SFA.FCT.PaymentManagementDomain.PaymentSchedule.DataStore
{
    using System;
    using System.Data.Entity;
    using Model;

    public interface IPaymentSchedulePolicyContext : IDisposable
    {
        IDbSet<Allocation> Allocations { get; set; }

        IDbSet<DeliverablePayment> DeliverablePayments { get; set; }

        IDbSet<OrganisationIdentifer> OrganisationIdentifiers { get; set; }

        IDbSet<ProvisionIdentifier> ProvisionIdentifiers { get; set; }

        IDbSet<PublishedPayableFcrAllocation> PublishedPayableFcrAllocations { get; set; }

        int SaveChanges();

        void UpdateEntry<TEntity>(TEntity entityInDb, TEntity entity) where TEntity : class;
    }
}
