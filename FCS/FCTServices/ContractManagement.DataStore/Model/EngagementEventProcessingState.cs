namespace ContractManagement.DataStore.Model
{
    public enum EngagementEventProcessingState
    {
        InFlight,
        Duplicate,
        InCrm,
        RejectedByRule,
        Invalid,
        ProviderNotFound
    }
}