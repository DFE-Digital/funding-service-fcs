namespace PerformanceManagementDomain.ReconciliationPublication.Repositories
{
    using System;
    using System.Threading.Tasks;
    using SFA.FCT.CrossDomain.Integration.Entities.Data;

    public interface IClaimReconciliationBehaviourRepository
    {
        Task<bool> IsClaimCollectionPayable(ConnectionInfo connectionInfo, string claimCollectionCode, string claimReconciliationAllocationGroupCode);

        Task<bool> IsAfterPublicationCloseDate(ConnectionInfo connectionInfo, string claimCollectionCode, string claimReconciliationAllocationGroupCode, DateTime currentDate);
    }
}
