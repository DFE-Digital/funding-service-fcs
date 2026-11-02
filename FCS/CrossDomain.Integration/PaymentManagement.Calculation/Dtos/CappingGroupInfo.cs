namespace PaymentManagement.Calculation.Dtos
{
    using System.Collections.Generic;
    using System.Linq;

    public class CappingGroupInfo
    {
        public CappingGroupInfo(int fundingStreamPeriodCappingGroupId, decimal plannedValue, decimal actualValue, bool allowUnderDeliveryToBeUsed, bool allowOverDeliveryToBeOffset)
        {
            FundingStreamPeriodCappingGroupId = fundingStreamPeriodCappingGroupId;
            PlannedValue = plannedValue;
            ActualValue = actualValue;
            AllowUnderDeliveryToBeUsed = allowUnderDeliveryToBeUsed;
            AllowOverDeliveryToBeOffset = allowOverDeliveryToBeOffset;
        }

        public int FundingStreamPeriodCappingGroupId { get; }
        
        public decimal PlannedValue { get; }

        public decimal ActualValue { get; }

        public bool AllowUnderDeliveryToBeUsed { get; }

        public bool AllowOverDeliveryToBeOffset { get; }

        public decimal Variance => PlannedValue - ActualValue;

        public bool IsOverDelivery => Variance < 0;

        private decimal UnUsedFunds => Variance > 0 ? Variance : 0;

        private decimal UnUsedFundsAvailable => AllowUnderDeliveryToBeUsed ? UnUsedFunds : 0;

        public static decimal GetAdjustedCapForGroup(IReadOnlyCollection<CappingGroupInfo> cappingGroupInfos, int fundingStreamPeriodCappingGroupId)
        {
            var currentCappingGroupInfo = cappingGroupInfos.Single(cgi => cgi.FundingStreamPeriodCappingGroupId == fundingStreamPeriodCappingGroupId);

            if (cappingGroupInfos.All(cgi => cgi.IsOverDelivery))
            {
                return currentCappingGroupInfo.Variance;
            }

            var otherCappingGroups = cappingGroupInfos
                .Where(cgi => cgi.FundingStreamPeriodCappingGroupId != fundingStreamPeriodCappingGroupId).ToList();

            decimal adjustedCap = 0;
            var availableUnusedFunds = GetAvailableUnusedFunds(otherCappingGroups);

            if (currentCappingGroupInfo.IsOverDelivery)
            {
                if (currentCappingGroupInfo.AllowOverDeliveryToBeOffset && availableUnusedFunds > 0)
                {
                    adjustedCap = currentCappingGroupInfo.Variance + availableUnusedFunds;
                    if (adjustedCap > 0)
                    {
                        adjustedCap = 0;
                    }
                }
                else
                {
                    adjustedCap = currentCappingGroupInfo.Variance;
                }
            }
            
            return adjustedCap;
        }

        private static decimal GetAvailableUnusedFunds(IReadOnlyCollection<CappingGroupInfo> otherCappingGroupInfos)
        {
            return otherCappingGroupInfos.Sum(cgi => cgi.UnUsedFundsAvailable);
        }
    }
}
