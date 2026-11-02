namespace ADMonitoringDomain.Endpoint.BusinessLogic
{
    using SFA.FCT.CrossDomain.Integration.Entities;
    using SFA.FCT.CrossDomain.Integration.Entities.Data;

    public interface IAtomItemCreator
    {
        AllocationDeliveryPerformance CreateAtomItem(string allocationNumber, int contractVersionNumber, ConnectionInfo connectionInfo);
    }
}
