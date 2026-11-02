namespace FctServices.Deds
{
    using System.Collections.Generic;
    using Entities;

    public interface IReportedActualRepository
    {
        IEnumerable<ReportedActual> GetRows(int pageNumber, int pageSize, string collectionType, string collectionReturnCode);

        int GetTotal(string collectionType, string collectionReturnCode);

        IList<CollectionGroup> GetCollectionGroups();
    }
}
