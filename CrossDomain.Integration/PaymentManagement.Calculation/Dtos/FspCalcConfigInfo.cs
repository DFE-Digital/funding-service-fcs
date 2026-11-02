namespace PaymentManagement.Calculation.Dtos
{
    using System.Collections.Generic;
    using SFA.FCT.PaymentManagementDomain.PolicyCache.DataStore.Model;

    public class FspCalcConfigInfo
    {
        public FspCalcConfigInfo(
            PaymentMethod paymentMethod,
            PaymentCappingPeriodType? paymentCappingPeriod,
            PaymentCappingLevelType? paymentCappingLevel,
            bool isPrioritisedApportionment, 
            PaymentCappingPeriodType? overrideCappingPeriod,
            int? calcPolicyVersion,
            IReadOnlyCollection<CappingPeriod> cappingPeriods)
        {
            PaymentMethod = paymentMethod;
            PaymentCappingPeriod = paymentCappingPeriod;
            PaymentCappingLevel = paymentCappingLevel;
            IsPrioritisedApportionment = isPrioritisedApportionment;
            OverrideCappingPeriod = overrideCappingPeriod;
            CalcPolicyVersion = calcPolicyVersion;
            CappingPeriods = cappingPeriods;
        }

        public PaymentMethod PaymentMethod { get; }

        public PaymentCappingLevelType? PaymentCappingLevel { get; }

        public PaymentCappingPeriodType? PaymentCappingPeriod { get; }

        public PaymentCappingPeriodType? OverrideCappingPeriod { get; }

        public bool IsPrioritisedApportionment { get; }

        public int? CalcPolicyVersion { get; }

        public IReadOnlyCollection<CappingPeriod> CappingPeriods { get; }

        public PaymentCappingPeriodType? GetPaymentCappingPeriodType()
        {
            if (OverrideCappingPeriod.HasValue)
            {
                return OverrideCappingPeriod.Value;
            }

            return PaymentCappingPeriod;
        }
    }
}