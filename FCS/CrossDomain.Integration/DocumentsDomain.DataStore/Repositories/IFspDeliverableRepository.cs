namespace SFA.FCT.DocumentsDomain.DataStore.Repositories
{
    using System.Collections.Generic;
    using Models;

    public interface IFspDeliverableRepository
    {
        FSPDeliverable GetFspDeliverable(string fspCode, int deliverableCode);

        IReadOnlyCollection<FSPDeliverable> GetFspDeliverablesForFundingStreamPeriod(string fspCode);
    }
}