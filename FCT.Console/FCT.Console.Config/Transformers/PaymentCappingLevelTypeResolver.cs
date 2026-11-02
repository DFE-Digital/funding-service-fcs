namespace FCT.Console.Config.Transformers
{
    using System;
    using AutoMapper;
    using SFA.FCT.PaymentManagementDomain.PolicyCache.DataStore.Model;

    internal class PaymentCappingLevelTypeResolver : ValueResolver<string, PaymentCappingLevelType?>
    {
        protected override PaymentCappingLevelType? ResolveCore(string source)
        {
            if (!string.IsNullOrEmpty(source))
            {
                return
                    (PaymentCappingLevelType)
                        Enum.Parse(typeof(PaymentCappingLevelType), TransformSheetValue(source), ignoreCase: true);
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
