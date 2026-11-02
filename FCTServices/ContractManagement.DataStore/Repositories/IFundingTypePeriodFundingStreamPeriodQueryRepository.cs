namespace ContractManagement.DataStore.Repositories
{
    using System.Collections.Generic;
    using Model;
    using SFA.FCT.CrossDomain.Integration.Entities.Data;

    public interface IFundingTypePeriodFundingStreamPeriodQueryRepository
    {
        IReadOnlyCollection<FundingTypePeriodFundingStreamPeriod> GetByFundingType(string fundingTypeCode);

        IReadOnlyCollection<FundingTypePeriodFundingStreamPeriod> GetByFundingType(string fundingTypeCode,
            ConnectionInfo connectionInfo);
    }
}