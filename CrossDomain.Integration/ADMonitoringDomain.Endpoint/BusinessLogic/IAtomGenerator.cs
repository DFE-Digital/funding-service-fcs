namespace ADMonitoringDomain.Endpoint.BusinessLogic
{
    using SFA.FCT.AllocationDelivery.DataStore.Model;
    using SFA.FCT.CrossDomain.Integration.Entities.Data;

    public interface IAtomGenerator
    {
        int GenerateAtomFeed(string allocationNumber, int versionNumber, AllocationDeliveryEntryCategory category, ConnectionInfo connectionInfo);
    }
}
