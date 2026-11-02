namespace SFA.FCT.Operations.Integrity.Repositories
{
    using System.Collections.Generic;
    using DTOs;
    using LanguageExt;

    public interface IMonitoringDeliverablesRepository
    {
        Option<int> GetMultipleCollectionGroupId(string fundingStreamPeriodCode, string collectionType,
            string collectionReturnCode);

        IReadOnlyCollection<CollectionReturn> GetCollectionReturns(
            int multipleCollectionGroupId,
            string collectionType,
            string collectionReturnCode);
    }
}