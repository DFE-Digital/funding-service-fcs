namespace FCT.Console.Config.Transformers
{
    using System;
    using AutoMapper;
    using SFA.FCT.PaymentManagementDomain.PolicyCache.DataStore.Model;

    internal class PolicyPaymentMethodResolver : ValueResolver<string, PaymentMethod>
    {
        protected override PaymentMethod ResolveCore(string source)
        {
            return
                (PaymentMethod)Enum.Parse(typeof(PaymentMethod), TransformSheetValue(source), ignoreCase: true);
        }

        private static string TransformSheetValue(string source)
        {
            source = source.Replace(" ", string.Empty);

            switch (source)
            {
                case "PaidExternally":
                    source = "NoPay";
                    break;

                case "NotCalculatedorPaid":
                    source = "NoCalcAndNoPay";
                    break;
            }

            return source;
        }
    }
}
