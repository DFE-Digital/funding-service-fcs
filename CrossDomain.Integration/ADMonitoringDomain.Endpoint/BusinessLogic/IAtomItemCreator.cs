namespace ADMonitoringDomain.Endpoint.BusinessLogic
{
    extern alias Entities;
    using Entities::SFA.FCT.CrossDomain.Integration.Entities;
    using Entities::SFA.FCT.CrossDomain.Integration.Entities.Data;

    public interface IAtomItemCreator
    {
        AllocationDeliveryPerformance CreateAtomItem(string allocationNumber, int contractVersionNumber, ConnectionInfo connectionInfo);
    }
}
