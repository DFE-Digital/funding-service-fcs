namespace FCT.Console.Config.Transformers
{
    using System;
    using AutoMapper;
    using SFA.FCT.AllocationDeliveryDomain.Common.DataStore.Model;

    public class PaymentMethodTypeResolver : ValueResolver<string, FundingStreamPeriodPaymentMethod>
    {
        protected override FundingStreamPeriodPaymentMethod ResolveCore(string source)
        {
            return
                (FundingStreamPeriodPaymentMethod)Enum.Parse(typeof(FundingStreamPeriodPaymentMethod), TransformSheetValue(source), ignoreCase: true);
        }

        private static string TransformSheetValue(string source)
        {
            source = source.Replace(" ", string.Empty);

            switch (source)
            {
                case "NotCalculatedorPaid":
                    source = "NoCalcAndNoPay";
                    break;
            }

            return source;
        }
    }
}
