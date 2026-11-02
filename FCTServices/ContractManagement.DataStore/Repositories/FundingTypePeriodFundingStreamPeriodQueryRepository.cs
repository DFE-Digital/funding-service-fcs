namespace ContractManagement.DataStore.Repositories
{
    using System.Collections.Concurrent;
    using System.Collections.Generic;
    using System.Linq;
    using Model;
    using SFA.FCT.CrossDomain.Integration.Entities.Data;

    public class FundingTypePeriodFundingStreamPeriodQueryRepository : IFundingTypePeriodFundingStreamPeriodQueryRepository
    {
        private readonly IContractManagementDbContext _dbContext;
        private static readonly ConcurrentDictionary<string, IReadOnlyCollection<FundingTypePeriodFundingStreamPeriod>> FundingTypePeriodFundingStreamPeriods = new ConcurrentDictionary<string, IReadOnlyCollection<FundingTypePeriodFundingStreamPeriod>>();
        
        public FundingTypePeriodFundingStreamPeriodQueryRepository(IContractManagementDbContext dbContext)
        {
            _dbContext = dbContext;
        }

        public IReadOnlyCollection<FundingTypePeriodFundingStreamPeriod> GetByFundingType(string fundingTypeCode)
        {
            return FundingTypePeriodFundingStreamPeriods.GetOrAdd(fundingTypeCode, key => _dbContext.FundingTypePeriodFundingStreamPeriodItems.Where(ftpfsp => ftpfsp.FundingTypeCode == key).ToList());
        }

        public IReadOnlyCollection<FundingTypePeriodFundingStreamPeriod> GetByFundingType(string fundingTypeCode, ConnectionInfo connectionInfo)
        {
            using (var context = new ContractManagementDbContext(connectionInfo.Connection, connectionInfo.Transaction))
            {
                return new FundingTypePeriodFundingStreamPeriodQueryRepository(context).GetByFundingType(
                    fundingTypeCode);
            }
        }
    }
}
