namespace SFA.FCT.ContractCreateDomain.Implementation.Persistence
{
    /// <summary>
    /// This holds the entity relationships used in this domain
    /// </summary>
    public static class CrmEntityRelationshipName
    {
        public const string ContractToContract = "sfa_sfa_contract_sfa_contract";
        public const string ContractToAllocation = "sfa_sfa_contract_sfa_contractallocation";
        public const string AllocationToDeliverable = "sfa_sfa_contractallocation_sfa_contractdelive";
        public const string DeliverableToPeriods = "sfa_contractdeliverable_deliverableperiod";
        public const string ContractToWorkflowHistory = "sfa_sfa_contract_sfa_contracttransitionhistory_Contract";
        public const string DeliverableToDeliverable = "sfa_cdeliverable_sfa_cdeliverable";
    }
}