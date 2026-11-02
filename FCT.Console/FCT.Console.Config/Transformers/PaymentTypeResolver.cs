namespace FCT.Console.Config.Transformers
{
    using System;
    using AutoMapper;
    using SFA.FCT.PaymentManagementDomain.PolicyCache.DataStore.Model;

    public class PaymentTypeResolver : ValueResolver<string, PaymentType?>
    {
        protected override PaymentType? ResolveCore(string source)
        {
            if (source != null)
            {
                return
                    (PaymentType)
                        Enum.Parse(typeof(PaymentType), TransformSheetValue(source), ignoreCase: true);
            }

            return null;
        }

        private string TransformSheetValue(string source)
        {
           return source.Replace(" ", string.Empty);
        }
    }
}
