namespace AllocationDeliveryDomain.Endpoint.Tests.Integration
{
    using SFA.FCT.AllocationDeliveryDomain.Common.Storage;

    public interface IReportedActualStubRepository
    {
        void AddRow(ReportedActual reportedActual, int rowKey);

        void RemoveRows();
    }
}
