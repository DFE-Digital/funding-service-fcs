namespace FCT.Console.Config.Transformers
{
    using AutoMapper;
    using FCT.Console.Config.ExcelTypes;
    using SFA.FCT.AllocationDeliveryDomain.Common.DataStore.Model;
    using SFA.FCT.PaymentManagementDomain.PolicyCache.DataStore.Model;
    using System;

    public class PaymentMethodTypeResolver
        : IValueResolver<FundingStreamPeriodSheetType, FundingStreamPeriod, FundingStreamPeriodPaymentMethod>
    {
        public FundingStreamPeriodPaymentMethod Resolve(
            FundingStreamPeriodSheetType source,
            FundingStreamPeriod destination,
            FundingStreamPeriodPaymentMethod destMember,
            ResolutionContext context)
        {
            var sourceValue = source?.PaymentMethod;

            if (string.IsNullOrWhiteSpace(sourceValue))
            {
                return default;
            }

            if (!Enum.TryParse<FundingStreamPeriodPaymentMethod>(
                          TransformSheetValue(sourceValue),
                          true,
                          out var result))
            {
                return default;
            }

            return result;

        }

        private static string TransformSheetValue(string source)
        {
            source = source.Replace(" ", string.Empty);

            switch (source)
            {
                case "NotCalculatedorPaid":
                    return "NoCalcAndNoPay";
            }

            return source;
        }
    }
}
