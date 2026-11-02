namespace PaymentManagement.Calculation.Dtos
{
    public class CappingGroup
    {
        public CappingGroup(int fundingStreamPeriodCappingGroupId, bool allowUnderDeliveryToBeReUsed, bool allowOverDeliveryToBeOffset)
        {
            FundingStreamPeriodCappingGroupId = fundingStreamPeriodCappingGroupId;
            AllowUnderDeliveryToBeReUsed = allowUnderDeliveryToBeReUsed;
            AllowOverDeliveryToBeOffset = allowOverDeliveryToBeOffset;
        }

        public int FundingStreamPeriodCappingGroupId { get; }

        public bool AllowUnderDeliveryToBeReUsed { get; }

        public bool AllowOverDeliveryToBeOffset { get; }
    }
}