namespace PaymentManagementDomain.PaymentSchedule.PaymentScheduleXrm.Repositories
{
    extern alias IntegrationEntities;
    using System;
    using IntegrationEntities::SFA.FCT.CrossDomain.Integration.Entities.Xrm;
    using SFA.FCT.PaymentManagementDomain.PaymentSchedule.Xrm.Integration.Repositories;

    public interface ICrmDeliverableRepository
    {
        DeliverableInfo CreateDeliverable(
            int deliverableCode,
            FspDeliverableInfo fspDeliverable,
            Guid allocationId,
            string allocationNumber,
            Guid contractId,
            Guid? parentDeliverableId);

        sfa_contractdeliverable CreateDeliverableObject(
            int deliverableCode,
            FspDeliverableInfo fspDeliverable,
            Guid allocationId,
            string allocationNumber,
            Guid contractId,
            Guid? parentDeliverableId);
    }
}