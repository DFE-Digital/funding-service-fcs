namespace SFA.FCT.Operations.Integrity.Repositories
{
    using System.Collections.Generic;
    using DTOs;

    public interface IPaasSubnominalAggregationRepository
    {
        IReadOnlyCollection<SubnominalAggregationInfo> GetSubnominalAggregationsForOpenContracts(IReadOnlyCollection<string> fspCodes);
    }
}
