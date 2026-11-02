namespace SFA.FCT.AllocationDeliveryDomain.Common.BusinessLogic.Repository
{
    using System.Collections.Generic;
    using AllocationDelivery.Messages.DTOs;
    using SFA.FCT.AllocationDeliveryDomain.Common.BusinessLogic.Dto;
    using SFA.FCT.CrossDomain.Integration.Entities.Data;

    public interface IHeldReportedActualGroupQueryRepository
    {
        IReadOnlyCollection<AllocationGrpWithCollectionReturns> GetHeldAllocationGrps(ConnectionInfo connectionInfo);

        IReadOnlyCollection<SummarisedActualOrgFspGroupKey> GetSummarisedActualOrgFspGroupKeys(ConnectionInfo connectionInfo, IReadOnlyCollection<string> PartitionKeys);
    }
}