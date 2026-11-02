namespace ContractManagement.DataStore.Repositories
{
    using System.Collections.Generic;
    using Model;
    using SFA.FCT.CrossDomain.Integration.Entities.Data;

    public interface IFundingTypeFundingPeriodContractTypeQueryRepository
    {
        IReadOnlyCollection<FundingTypeFundingPeriodContractType> GetFundingTypeFundingPeriodContractTypes(ConnectionInfo connectionInfo);
    }
}