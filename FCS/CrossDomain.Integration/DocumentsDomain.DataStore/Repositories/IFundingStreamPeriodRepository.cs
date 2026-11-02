namespace SFA.FCT.DocumentsDomain.DataStore.Repositories
{
    using System.Collections.Generic;
    using Models;

    public interface IFundingStreamPeriodRepository
    {
        FundingStreamPeriod GetByKey(string fundingStreamPeriodCode);

        IReadOnlyCollection<FundingStreamPeriod> GetAll();

        IReadOnlyCollection<string> GetFspGroupDisplayNames(IReadOnlyCollection<string> fspCodes);

        IReadOnlyCollection<FSPGroup> GetFspGroups(IReadOnlyCollection<string> fspCodes);

        IReadOnlyCollection<FundingStreamPeriod> GetFspsWithGroups(IEnumerable<string> fspCodes);
    }
}