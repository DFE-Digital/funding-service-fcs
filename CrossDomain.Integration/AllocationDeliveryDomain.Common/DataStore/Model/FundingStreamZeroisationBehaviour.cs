namespace SFA.FCT.AllocationDeliveryDomain.Common.DataStore.Model
{
    public enum FundingStreamZeroisationBehaviour
    {
        NotSet,
        ProcessFutureActuals,
        PersistCurrentViewActualsState,
        ZeroiseMissingActuals,
    }
}
