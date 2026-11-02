namespace ContractManagement.DataStore.Repositories
{
    using System.Collections.Generic;
    using Model;
    using SFA.FCT.CrossDomain.Integration.Entities.Data;

    public interface IFundingStreamPeriodLegalDeliverableRepository
    {
        IReadOnlyCollection<int> GetLegalDeliverablesForFsp(string fundingStreamPeriod);

        IReadOnlyCollection<int> GetLegalDeliverablesForFsp(ConnectionInfo connectionInfo, string fundingStreamPeriod);

        IReadOnlyCollection<FundingStreamPeriodLegalDeliverable> GetAllProfileLegalFspDeliverables();

        IReadOnlyCollection<FundingStreamPeriodLegalDeliverable> GetAllProfileLegalFspDeliverables(
            ConnectionInfo connectionInfo);
    }
}