namespace FCT.Console.Config.Transformers
{
    using AutoMapper;
    using FCT.Console.Config.ExcelTypes;
    using SFA.FCT.PaymentManagementDomain.PolicyCache.DataStore.Model;
    using System;

    internal class PaymentCappingLevelTypeResolver
        : IValueResolver<FundingStreamPeriodSheetType, PolicyFundingStreamPeriod, PaymentCappingLevelType?>
    {
        public PaymentCappingLevelType? Resolve(
            FundingStreamPeriodSheetType source,
            PolicyFundingStreamPeriod destination,
            PaymentCappingLevelType? destMember,
            ResolutionContext context)
        {
            var sourceValue = source?.PaymentCappingLevel;

            if (string.IsNullOrWhiteSpace(sourceValue))
            {
                return null;
            }

            var transformed = TransformSheetValue(sourceValue);

            if (Enum.TryParse<PaymentCappingLevelType>(transformed, true, out var result))
            {
                return result;
            }
            return null;

        }

        private string TransformSheetValue(string source)
        {
            source = source.Replace(" ", string.Empty);
            if (source == "DeliverableGroup")
            {
                source = "Group";
            }

            return source;
        }
    }

}
