namespace ContractManagement.DataStore.Repositories
{
    using System;
    using System.Collections.Generic;
    using System.Linq;
    using Dtos;

    public class CdaReportFundingStreamPeriodQueryRepository : ICdaReportFundingStreamPeriodQueryRepository
    {
        private readonly IContractManagementDbContext _context;

        public CdaReportFundingStreamPeriodQueryRepository(IContractManagementDbContext context)
        {
            _context = context;
        }

        public IReadOnlyCollection<ReportConfig> GetAllWithinPublicationCloseDate(DateTime today)
        {
            DateTime todayDate = today.Date;

            IQueryable<string> extractsWithinPublicationCloseDate =
                _context.CdaExtracts.Where(e => !e.ReportingCloseDate.HasValue || e.ReportingCloseDate >= todayDate)
                        .Select(e => e.ExtractName);

            return _context.CdaReportFundingStreamPeriods
                           .Where(cda => extractsWithinPublicationCloseDate.Contains(cda.ExtractName))
                           .ToLookup(cda => cda.ExtractName)
                           .Select(r => new ReportConfig(r.Key, r.Select(g => g.FundingStreamPeriodCode).ToList()))
                           .ToList();
        }
    }
}