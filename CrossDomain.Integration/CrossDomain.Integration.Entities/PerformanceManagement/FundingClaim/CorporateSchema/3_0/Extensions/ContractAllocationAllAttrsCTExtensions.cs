namespace SFA.FCT.CrossDomain.Integration.Entities.PerformanceManagement.FundingClaim.CorporateSchema._3_0.Extensions
{
    public static class ContractAllocationAllAttrsCTExtensions
    {
        public static string GetFspCode(this ContractAllocationAllAttrsCT allocation)
        {
            return allocation.ContractAllocationNonPKeyAttrs.FundingStreamPeriodCode;
        }
    }
}
