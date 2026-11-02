namespace SFA.FCT.Contracts.AcceptanceTests.Infrastructure.Repositories
{
    using System.Collections.Generic;
    using System.Data.Entity;
    using System.Linq;
    using ContractManagement.DataStore;
    using ContractManagement.DataStore.Model;

    public class CdaExtractRepository
    {
        public static IReadOnlyCollection<CdaExtract> GetExtractsForFsp(IEnumerable<string> fspCodes)
        {
            using (ContractManagementDbContext context = new ContractManagementDbContext())
            {
                return context.CdaExtracts.Include(e => e.CdaReportFundingStreamPeriods)
                    .Where(e => e.CdaReportFundingStreamPeriods.Select(f => f.FundingStreamPeriodCode).Any(fspCode => fspCodes.Contains(fspCode)))
                    .AsNoTracking()
                    .ToList();
            }
        }
    }
}
