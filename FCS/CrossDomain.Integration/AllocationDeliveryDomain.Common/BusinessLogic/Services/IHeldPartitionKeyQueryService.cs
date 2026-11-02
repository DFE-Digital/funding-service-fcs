namespace SFA.FCT.AllocationDeliveryDomain.Common.BusinessLogic.Services
{
    using System.Collections.Generic;
    using SFA.FCT.AllocationDeliveryDomain.Common.BusinessLogic.Dto;
    using SFA.FCT.CrossDomain.Integration.Entities.Data;

    public interface IHeldPartitionKeyQueryService
    {
        IReadOnlyCollection<HeldActualsForAllocationGrpIdentifier> GetPartitionKeyGroups(ConnectionInfo connectionInfo);
    }
}