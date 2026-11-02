namespace SFA.FCT.Contracts.AcceptanceTests.Extensions
{
    using System;
    using SFA.FCT.CrossDomain.Integration.Entities.Xrm.OptionSets;

    public static class NewStartsSuspendedReasonExtensions
    {
        public static string ToUserReadableString(this sfa_newstartssuspendedreason value)
        {
            switch (value)
            {
                case sfa_newstartssuspendedreason.InadequateFinancialHealth:
                    return "Inadequate Financial Health";

                case sfa_newstartssuspendedreason.InadequateOfsted:
                    return "Inadequate Ofsted";

                case sfa_newstartssuspendedreason.Other:
                    return "Other";

                case sfa_newstartssuspendedreason.RemovedfromRoATP:
                    return "Removed from RoATP";
            }

            throw new ArgumentException($"No user readable string defined for sfa_newstartssuspendedreason: {value}");
        }
    }
}
