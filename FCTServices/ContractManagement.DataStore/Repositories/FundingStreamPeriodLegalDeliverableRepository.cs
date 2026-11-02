namespace ContractManagement.DataStore.Repositories
{
    using System.Collections.Generic;
    using System.Linq;
    using Model;
    using SFA.FCT.CrossDomain.Integration.Entities.Data;

    public class FundingStreamPeriodLegalDeliverableRepository : IFundingStreamPeriodLegalDeliverableRepository
    {
        private readonly IContractManagementDbContext _contractManagementDbContext;

        public FundingStreamPeriodLegalDeliverableRepository(IContractManagementDbContext contractManagementDbContext)
        {
            _contractManagementDbContext = contractManagementDbContext;
        }

        public IReadOnlyCollection<int> GetLegalDeliverablesForFsp(string fundingStreamPeriod)
        {
            return _contractManagementDbContext.FundingStreamPeriodLegalDeliverables.Where(d => d.FundingStreamPeriodCode == fundingStreamPeriod)
                .Select(d => d.DeliverableCode)
                .ToList();
        }

        public IReadOnlyCollection<int> GetLegalDeliverablesForFsp(ConnectionInfo connectionInfo, string fundingStreamPeriod)
        {
            if (connectionInfo.UseDefault())
            {
                return GetLegalDeliverablesForFsp(fundingStreamPeriod);
            }

            using (var context = new ContractManagementDbContext(connectionInfo.Connection, connectionInfo.Transaction))
            {
                return context.FundingStreamPeriodLegalDeliverables.Where(d => d.FundingStreamPeriodCode == fundingStreamPeriod)
                    .Select(d => d.DeliverableCode)
                    .ToList();
            }
        }

        public IReadOnlyCollection<FundingStreamPeriodLegalDeliverable> GetAllProfileLegalFspDeliverables()
        {
            return _contractManagementDbContext.FundingStreamPeriodLegalDeliverables
                .Where(d => d.AllowProfile)
                .ToList();
        }

        public IReadOnlyCollection<FundingStreamPeriodLegalDeliverable> GetAllProfileLegalFspDeliverables(ConnectionInfo connectionInfo)
        {
            using (var context = new ContractManagementDbContext(connectionInfo.Connection, connectionInfo.Transaction))
            {
                return new FundingStreamPeriodLegalDeliverableRepository(context).GetAllProfileLegalFspDeliverables();
            }
        }
    }
}
