namespace SFA.FCT.CrossDomain.Integration.Entities.PerformanceManagement.FundingClaim
{
    public class DebatchedFundingClaim : FundingClaim
    {
        public string AllocationGroupCode { get; set; }

        public override string ToString()
        {
            return $"Contractor: {Contractor}, Version Number: {VersionNumber}, Claim Type Name: {ClaimTypeName}, " +
                   $"Period Type Code: {PeriodTypeCode}, Period: {Period}, Allocation Group Code {AllocationGroupCode}";
        }
    }
}