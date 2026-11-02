namespace SFA.FCT.Contracts.AcceptanceTests.Infrastructure.Repositories
{
    using ContractRequestDomain.DataStore.Model;
    using ContractRequestDomain.DataStore;
    using Dapper;

    public class ContractRequestFundingAllocationReleaseRepository
    {
        public static void ClearDown()
        {
            using (var context = new ContractRequestDbContext())
            {
                context.Database.Connection.ExecuteScalar<int>("dbo.sp_DynamicClearData @table,@schema,@ReqType", new { Table = "FundingAllocationRelease", Schema = "ContractRequest", ReqType = "Delete" });

            }
        }

        public static void AddFundingAllocationRelease(int releaseGroupGroupId, string fundingTypeCode, string fundingPeriodName, string releaseStatus)
        {
            using (var context = new ContractRequestDbContext())
            {
                context.FundingAllocationReleases.Add(new FundingAllocationRelease(
                    releaseGroupGroupId, fundingTypeCode, fundingPeriodName, releaseStatus));
                context.SaveChanges();
            }
        }
    }
}