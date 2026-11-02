namespace SFA.FCT.PMD.PaymentManagment.DataStore
{
    using System;
    using System.Data.Entity;
    using SFA.FCT.PMD.PaymentManagment.DataStore.Model;

    public interface IPaymentManagementDBContext : IDisposable
    {
        IDbSet<ContractApprovedId> ContractApprovedIds { get; set; }

        IDbSet<PaymentAggregationXRMId> PaymentAggregationXrmIds { get; set; }

        IDbSet<PaymentScheduleId> PaymentScheduleIds { get; set; }

        IDbSet<PaymentScheduleXRMId> PaymentScheduleXrmIds { get; set; }

        IDbSet<AllocationActualsId> AllocationActualsIds { get; set; }

        int SaveChanges();
    }
}