namespace DocumentsDomain.Endpoint.ArchiveDocument.Services
{
    using System.Collections.Generic;
    using System.Data.Entity;
    using System.Linq;
    using System.Threading;
    using System.Threading.Tasks;
    using SFA.FCT.CrossDomain.Integration.Entities.CorporateContract;
    using SFA.FCT.CrossDomain.Integration.Entities.Data;
    using SFA.FCT.DocumentsDomain.DataStore;

    public class PolicyQueryService : IPolicyQueryService
    {
        private IReadOnlyCollection<FundingTypeFundingPeriodInfo> _allFundingTypeFundingPeriods = new List<FundingTypeFundingPeriodInfo>();
        private int _haveCalled;

        public async Task<bool> ShouldGenerateDocumentationForContract(contract masterContract,
            ConnectionInfo connectionInfo)
        {
            contractType childContract = masterContract.contracts.First();
            string fundingTypeCode = childContract.fundingType.fundingTypeCode;
            string fundingPeriodName = childContract.GetFundingPeriod();

            if (IsFirstTimeCalled())
            {
                _allFundingTypeFundingPeriods = await GetFundingTypeFundingPeriodInfosFromDb(connectionInfo).ConfigureAwait(false);
            }

            return _allFundingTypeFundingPeriods.Single(ftfp =>
                    ftfp.FundingTypeCode == fundingTypeCode && ftfp.FundingPeriodName == fundingPeriodName)
                .DocumentsRequired;
        }

        private bool IsFirstTimeCalled()
        {
            return Interlocked.CompareExchange(ref _haveCalled, 1, 0) == 0;
        }

        private async Task<IReadOnlyCollection<FundingTypeFundingPeriodInfo>> GetFundingTypeFundingPeriodInfosFromDb(
            ConnectionInfo connectionInfo)
        {
            using (var context = new DocumentsDomainDbContext(connectionInfo.Connection, connectionInfo.Transaction))
            {
                var allRows = await context.FundingTypeFundingPeriods
                    .AsNoTracking()
                    .Select(ftfp => new {ftfp.FundingTypeCode, ftfp.FundingPeriodName, ftfp.DocumentsRequired})
                    .ToListAsync()
                    .ConfigureAwait(false);

                return allRows.Select(ftfp =>
                        new FundingTypeFundingPeriodInfo(
                            fundingTypeCode: ftfp.FundingTypeCode,
                            fundingPeriodName: ftfp.FundingPeriodName,
                            documentsRequired: ftfp.DocumentsRequired))
                    .ToList();
            }
        }

        private class FundingTypeFundingPeriodInfo
        {
            public FundingTypeFundingPeriodInfo(string fundingTypeCode, string fundingPeriodName,
                bool documentsRequired)
            {
                FundingTypeCode = fundingTypeCode;
                FundingPeriodName = fundingPeriodName;
                DocumentsRequired = documentsRequired;
            }

            public string FundingTypeCode { get; }
            public string FundingPeriodName { get; }
            public bool DocumentsRequired { get; }
        }
    }
}