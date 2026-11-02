namespace FCT.Console.Config.Transformers
{
    using System.Collections.Generic;
    using System.Linq;
    using ExcelTypes;
    using SFA.FCT.PerformanceManagementDomain.DataStore.Models;

    public class PerfMgmtFundingStreamPeriodTransformer
    {
        private const string PayOnProfile = "PAYONPROFILE";

        public static IEnumerable<FundingStreamPeriod> TransformCollection(
            IEnumerable<FundingStreamPeriodSheetType> configSheetObjects)
        {
            return configSheetObjects.Select(st =>
                new FundingStreamPeriod(st.FundingStreamPeriodCode, GetIsPayOnProfile(st.PaymentMethod)));
        }

        private static bool GetIsPayOnProfile(string paymentMethod)
        {
            return paymentMethod.Replace(" ", string.Empty).ToUpper() == PayOnProfile;
        }
    }
}