namespace PaymentManagement.Calculation.Dtos
{
    using System;
    public class FspDeliverableInfo
    {
        private int? fundingStreamPeriodCappingGroupId;

        public FspDeliverableInfo(int deliverableCode, bool allowProfile, int? cappingApportionmentPriorityOrder, int fundingStreamPeriodCappingGroupId, bool allowPayment = false)
        {
            DeliverableCode = deliverableCode;
            AllowProfile = allowProfile;
            CappingApportionmentPriorityOrder = cappingApportionmentPriorityOrder;
            FundingStreamPeriodCappingGroupId = fundingStreamPeriodCappingGroupId;
            AllowPayment = allowPayment;
        }

        public FspDeliverableInfo(int deliverableCode, bool allowProfile, int? cappingApportionmentPriorityOrder, int? fundingStreamPeriodCappingGroupId, bool allowPayment)
        {
            DeliverableCode = deliverableCode;
            AllowProfile = allowProfile;
            CappingApportionmentPriorityOrder = cappingApportionmentPriorityOrder;
            FundingStreamPeriodCappingGroupId = fundingStreamPeriodCappingGroupId == null ? 0 : Convert.ToInt32(fundingStreamPeriodCappingGroupId);
            AllowPayment = allowPayment;
        }

        private FspDeliverableInfo()
        {
        }

        public int DeliverableCode { get; }

        public bool AllowProfile { get; }

        public int? CappingApportionmentPriorityOrder { get; }

        public int FundingStreamPeriodCappingGroupId { get; }

        public bool AllowPayment { get; }
    }
}
