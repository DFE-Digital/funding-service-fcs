namespace SFA.FCT.CrossDomain.Integration.Entities.PerformanceManagement.FundingClaim
{
    using System;

    public static class ClaimTypeNameExtensions
    {
        public static string GetCode(this ClaimTypeName claimTypeName)
        {
            if (claimTypeName == ClaimTypeName.FINAL)
            {
                return "F";
            }
            else if (claimTypeName == ClaimTypeName.YEAREND)
            {
                return "YE";
            }
            else
            {
                throw new ArgumentException($"We don't support this {claimTypeName}");
            }
        }
    }
}
