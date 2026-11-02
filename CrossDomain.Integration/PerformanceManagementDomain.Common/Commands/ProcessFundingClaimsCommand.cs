namespace SFA.FCT.PerformanceManagementDomain.Common.Commands
{
    using System;

    public class ProcessFundingClaimsCommand
    {
        public ProcessFundingClaimsCommand()
        {
        }

        public ProcessFundingClaimsCommand(string period, string claimTypeName)
        {
            if (string.IsNullOrEmpty(period) || string.IsNullOrEmpty(claimTypeName))
            {
                throw new ArgumentException("Period and ClaimTypeName must not be null or empty");
            }

            Period = period;
            ClaimTypeName = claimTypeName;
        }

        public string Period { get; set; }
        
        public string ClaimTypeName { get; set; }

        public override string ToString()
        {
            return $"Period: {Period}, ClaimTypeName: {ClaimTypeName}";
        }
    }
}