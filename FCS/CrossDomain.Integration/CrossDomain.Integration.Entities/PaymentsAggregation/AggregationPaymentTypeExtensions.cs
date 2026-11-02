namespace SFA.FCT.CrossDomain.Integration.Entities.PaymentsAggregation
{
    using System;
    using System.Diagnostics.CodeAnalysis;
    using CorporatePaymentAggregation;

    [SuppressMessage("ReSharper", "InconsistentNaming")]
    public static class AggregationPaymentTypeExtensions
    {
        public static PaymentTypeTYPE GetPaymentTypeTYPE(this AggregationPaymentType aggregationPaymentType)
        {
            switch (aggregationPaymentType)
            {
                case AggregationPaymentType.CAPPING:
                    return PaymentTypeTYPE.CAPPING;
                case AggregationPaymentType.PROFILE:
                    return PaymentTypeTYPE.PROFILE;
                case AggregationPaymentType.RECONCILIATION:
                    return PaymentTypeTYPE.RECONCILIATION;
                default:
                    throw new ArgumentException($"AggregationPaymentType not supported: {aggregationPaymentType}");
            }
        }
    }
}
