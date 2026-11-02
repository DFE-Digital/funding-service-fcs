namespace SFA.FCT.CrossDomain.Integration.Events
{
    using Entities.ContractWithdrawal;
    using Entities.CorporateContract;

    public class ContractWithdrawnEvent
    {
        public contract CorporateContract { get; set; }
        
        public ContractWithdrawalType ContractWithdrawalType { get; set; }

        public bool IncrementContractVersionNumber { get; set; }

        public string Ukprn { get; set; }

        public bool ShouldAddPayableNonLevyAllocationToPostWithdrawalAmendment { get; set; }

        public bool ShouldMergeAmendmentTemplate { get; set; }

        public string OverrideAmendmentTemplate { get; set; }

        public string OverrideTemplateName { get; set; }

        public override string ToString()
        {
            return $"{CorporateContract}, ContractWithdrawalType {ContractWithdrawalType}, " +
                   $"Ukprn: {Ukprn}, IncrementContractVersionNumber: {IncrementContractVersionNumber}, " +
                   $"ShouldAddPayableNonLevyAllocationToPostWithdrawalAmendment: {ShouldAddPayableNonLevyAllocationToPostWithdrawalAmendment}, " +
                   $"ShouldMergeAmendmentTemplate: {ShouldMergeAmendmentTemplate}, OverrideAmendmentTemplate: {OverrideAmendmentTemplate}, " +
                   $"OverrideTemplateName: {OverrideTemplateName}";
        }
    }
}
