namespace SFA.FCT.ContractCreateDomain.Implementation.Persistence
{
    /// <summary>
    /// This holds the entity names used in this domain
    /// </summary>
    public static class CrmEntityName
    {
        public const string Contract = "sfa_contract";
        public const string ContractAllocation = "sfa_contractallocation";
        public const string ContractDeliverable = "sfa_contractdeliverable";
        public const string ContractDeliverablePeriod = "sfa_contractdeliverableperiod";
        public const string ContractTransitionHistory = "sfa_contracttransitionhistory";
        public const string Team = "team";
        public const string Task = "task";
        public const string PeriodType = "sfa_periodtype";
        public const string FundingPeriod = "sfa_period";
        public const string FundingStreamPeriod = "sfa_period";
        public const string FundingStream = "sfa_fundingstream";
        public const string FundingType = "sfa_fundingtype";
        public const string ContractNumber = "sfa_contractnumber";
        public static string Deliverable = "sfa_deliverable";
        public static string FundingStreamPeriodDeliverable = "sfa_fundingstreamperioddeliverable";

        public const string ClaimType = "sfa_claimtype";
        public const string ClaimReconAllocGroup = "sfa_claimreconallocgroup";
    }
}
