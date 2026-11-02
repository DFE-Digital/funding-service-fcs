namespace SFA.FCT.AllocationDeliveryDomain.Common.BusinessLogic.Repository
{
    using System.Collections.Generic;
    using CrossDomain.Integration.Entities.Data;
    using DataStore.Model;

    public interface IHeldReportedActualGroupCommandRepository
    {
        void Add(HeldReportedActualGroup heldReportedActualGroup, ConnectionInfo connectionInfo);

        void SetHeldReportedActualGroupsToProcessed(ConnectionInfo connectionInfo, IReadOnlyCollection<string> partitionKeys);
    }
}