namespace FCT.Console.Config.Transformers
{
    using AutoMapper;
    using FCT.Console.Config.ExcelTypes;
    using SFA.FCT.PaymentManagementDomain.PolicyCache.DataStore.Model;
    using System;

    internal class PaymentCappingPeriodTypeResolver
        : IValueResolver<FundingStreamPeriodSheetType, PolicyFundingStreamPeriod, PaymentCappingPeriodType?>
    {
        public PaymentCappingPeriodType? Resolve(
            FundingStreamPeriodSheetType source,
            PolicyFundingStreamPeriod destination,
            PaymentCappingPeriodType? destMember,
            ResolutionContext context)
        {
            var sourceValue = source?.PaymentCappingPeriod;

            if (string.IsNullOrWhiteSpace(sourceValue))
            {
                return null;
            }
            var transformed = TransformSheetValue(sourceValue);

            if (Enum.TryParse<PaymentCappingPeriodType>(transformed, true, out var result))
            {
                return result;
            }
            return null;
        }

        private string TransformSheetValue(string source)
        {
            source = source.Replace(" ", string.Empty);

            if (source == "ContractAllocationDuration")
            {
                source = "ContractDuration";
            }

            return source;
        }
    }
}
