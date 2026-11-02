namespace AllocationDeliveryDomain.Endpoint.Services
{
    using System;
    using System.Collections.Generic;
    using SFA.FCT.AllocationDeliveryDomain.Common;
    using SFA.FCT.AllocationDeliveryDomain.Common.Storage;

    public interface IDedsService
    {
        Guid GetLatestPublishedDataSetVersionId();

        IEnumerable<ClosedCollectionEventItem> GetClosedCollections(Guid dataSetVersionId, DateTime dateTime);

        int GetCountForCollectionType(Guid dataSetVersionId, string collectionType, string collectionReturnCode);

        IEnumerable<ReportedActual> GetReportedActuals(Guid dataSetVersionId, string collectionType, string collectionReturnCode, int pageNumber, int pageSize);
    }
}
