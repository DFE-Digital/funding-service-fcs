namespace ContractManagement.DataStore.Model
{
    public enum AtomItemType
    {
        ApprovedContract = 0,
        DraftContract = 1,
        WithdrawnContract = 2,
        ClosedContract = 3,
        ContractTerminationInitiated = 4,
        CancelledContractTermination = 5,
        ContractTerminated = 6,
        ContractTerminationDetailsUpdated = 7,
        ContractModified = 8,
        TerminationModificationDetailsUpdated = 9,
        ContractModificationCancelled = 10
    }
}
