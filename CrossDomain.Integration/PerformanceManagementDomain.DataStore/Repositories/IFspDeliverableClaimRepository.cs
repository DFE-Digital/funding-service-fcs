namespace SFA.FCT.PerformanceManagementDomain.DataStore.Repositories
{
    using System.Collections.Generic;
    using Models;

    public interface IFspDeliverableClaimRepository
    {
        List<FspDeliverableClaim> GetFspDeliverablesIncludingClaimDeliverableGroup(string fundingStreamPeriodCode);

        string GetDeliverableName(int deliverableCode, string fundingStreamPeriodCode);
    }
}
