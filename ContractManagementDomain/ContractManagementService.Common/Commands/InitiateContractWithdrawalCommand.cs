namespace SFA.FCT.ContractManagementService.Common.Commands
{
    using CrossDomain.Integration.Entities.ContractWithdrawal;

    public class InitiateContractWithdrawalCommand
    {
        public string MasterContractNumber { get; set; }

        public string ContractNumber { get; set; }

        public WithdrawalRequestSource RequestSource { get; set; }

        public ContractWithdrawalType ContractWithdrawalType { get; set; }

        public int ContractVersionNumber { get; set; }

        public bool IncrementContractVersionNumber { get; set; }

        public bool ShouldAddPayableNonLevyAllocationToPostWithdrawalAmendment { get; set; }

        public string Ukprn { get; set; }

        public bool ShouldMergeAmendmentTemplate { get; set; }

        public string OverrideAmendmentTemplate { get; set; }

        public string OverrideTemplateName { get; set; }

        public override string ToString()
        {
            return
                $"MasterContractNumber: {MasterContractNumber}, ContractNumber: {ContractNumber}, RequestSource: {RequestSource}, " +
                $"ContractWithdrawalType: {ContractWithdrawalType}, ContractVersionNumber: {ContractVersionNumber}, " +
                $"IncrementContractVersionNumber: {IncrementContractVersionNumber}, Ukprn: {Ukprn}, " +
                $"ShouldAddPayableNonLevyAllocationToPostWithdrawalAmendment: {ShouldAddPayableNonLevyAllocationToPostWithdrawalAmendment}, " +
                $"ShouldMergeAmendmentTemplate: {ShouldMergeAmendmentTemplate}, OverrideAmendmentTemplate: {OverrideAmendmentTemplate}, " +
                $"OverrideTemplateName: {OverrideTemplateName}";
        }
    }
}
