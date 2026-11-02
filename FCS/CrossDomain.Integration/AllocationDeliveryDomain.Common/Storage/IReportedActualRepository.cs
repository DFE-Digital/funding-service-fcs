namespace SFA.FCT.AllocationDeliveryDomain.Common.Storage
{
    using System.Collections.Generic;

    public interface IReportedActualRepository
    {
        void AddRow(ReportedActual reportedActual, string collectionType, string collectionReturnCode);

        void RemoveRows(string collectionType, string collectionReturnCode);

        void AddRows(IEnumerable<ReportedActual> reportedActuals, string collectionType, string collectionReturnCode);

        IEnumerable<ReportedActual> GetActuals(string collectionType, string collectionReturnCode);
    }
}
