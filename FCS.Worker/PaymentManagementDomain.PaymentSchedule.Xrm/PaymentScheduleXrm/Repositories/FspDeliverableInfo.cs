namespace PaymentManagementDomain.PaymentSchedule.PaymentScheduleXrm.Repositories
{
    using System;

    public class FspDeliverableInfo
    {
        public FspDeliverableInfo(int displayOrder, string deliverableName, Guid fspDeliverableId, int deliverableCode, int? parentDeliverableCode, bool allowProfile)
        {
            DisplayOrder = displayOrder;
            DeliverableName = deliverableName;
            FspDeliverableId = fspDeliverableId;
            DeliverableCode = deliverableCode;
            ParentDeliverableCode = parentDeliverableCode;
            AllowProfile = allowProfile;
        }

        public int DisplayOrder { get; }

        public string DeliverableName { get; }

        public Guid FspDeliverableId { get; }

        public int DeliverableCode { get; }

        public int? ParentDeliverableCode { get; }

        public bool AllowProfile { get; }
    }
}
