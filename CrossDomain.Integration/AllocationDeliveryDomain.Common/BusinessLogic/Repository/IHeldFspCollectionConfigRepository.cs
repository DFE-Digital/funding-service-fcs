namespace SFA.FCT.AllocationDeliveryDomain.Common.BusinessLogic.Repository
{
    using System.Collections.Generic;
    using System.Threading.Tasks;
    using Dto;
    using SFA.FCT.CrossDomain.Integration.Entities.Data;

    public interface IHeldFspCollectionConfigRepository
    {
        Task<IReadOnlyCollection<IReadOnlyCollection<CollectionReturn>>> GetCollectionReturns(ConnectionInfo connectionInfo, string fundingStreamPeriodCode);
    }
}