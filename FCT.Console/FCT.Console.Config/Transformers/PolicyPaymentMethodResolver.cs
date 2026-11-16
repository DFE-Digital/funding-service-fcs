
namespace FCT.Console.Config.Transformers
{
    using AutoMapper;
    using FCT.Console.Config.ExcelTypes;
    using SFA.FCT.PaymentManagementDomain.PolicyCache.DataStore.Model;
    using System;

    internal class PolicyPaymentMethodResolver
        : IValueResolver<FundingStreamPeriodSheetType, PolicyFundingStreamPeriod, PaymentMethod>
    {
        public PaymentMethod Resolve(
            FundingStreamPeriodSheetType source,
            PolicyFundingStreamPeriod destination,
            PaymentMethod destMember,
            ResolutionContext context)
        {
            var sourceValue = source?.PaymentMethod;

            if (string.IsNullOrWhiteSpace(sourceValue))
            {                
                return default; // safer for pipeline
            }

            return (PaymentMethod)
                Enum.Parse(
                    typeof(PaymentMethod),
                    TransformSheetValue(sourceValue),
                    ignoreCase: true);
        }

        private static string TransformSheetValue(string source)
        {
            source = source.Replace(" ", string.Empty);

            switch (source)
            {
                case "PaidExternally":
                    return "NoPay";

                case "NotCalculatedorPaid":
                    return "NoCalcAndNoPay";
            }

            return source;
        }
    }
}
