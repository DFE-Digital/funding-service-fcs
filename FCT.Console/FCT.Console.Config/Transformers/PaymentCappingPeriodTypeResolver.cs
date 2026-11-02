namespace FCT.Console.Config.Transformers
{
    using System;
    using AutoMapper;
    using SFA.FCT.PaymentManagementDomain.PolicyCache.DataStore.Model;

    internal class PaymentCappingPeriodTypeResolver : ValueResolver<string, PaymentCappingPeriodType?>
    {
        protected override PaymentCappingPeriodType? ResolveCore(string source)
        {
            if (!string.IsNullOrEmpty(source))
            {
                return
                    (PaymentCappingPeriodType)
                        Enum.Parse(typeof(PaymentCappingPeriodType), TransformSheetValue(source), ignoreCase: true);
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
