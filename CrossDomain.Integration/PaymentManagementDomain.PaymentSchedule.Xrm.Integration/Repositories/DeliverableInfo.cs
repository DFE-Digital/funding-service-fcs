namespace SFA.FCT.PaymentManagementDomain.PaymentSchedule.Xrm.Integration.Repositories
{
    using System;
    using Microsoft.Xrm.Sdk;

    public class DeliverableInfo
    {
        public DeliverableInfo(Guid id, EntityReference parentEntityReference, string deliverableCode, EntityReference owner)
        {
            Id = id;
            ParentEntityReference = parentEntityReference;
            DeliverableCode = deliverableCode;
            Owner = owner;
        }

        public Guid Id { get; }

        public EntityReference ParentEntityReference { get; }

        public string DeliverableCode { get; }

        public EntityReference Owner { get; }
    }
}
