namespace ADMonitoringDomain.Endpoint.BusinessLogic
{
    extern alias Entities;
    using SFA.FCT.AllocationDelivery.DataStore.Model;
    using Entities::SFA.FCT.CrossDomain.Integration.Entities.Data;

    public interface IAtomGenerator
    {
        int GenerateAtomFeed(string allocationNumber, int versionNumber, AllocationDeliveryEntryCategory category, ConnectionInfo connectionInfo);
    }
}
