namespace SFA.FCT.PerformanceManagementDomain.DataStore.Repositories
{
    using Models;

    public interface IClaimReconciliationBehaviourRepository
    {
        ClaimReconciliationBehaviour Find(string claimCollectionCode, string claimAllocationGroup);

        bool DoesClaimCollectionCodeExist(string closedCollectionKey);
    }
}
