namespace SFA.FCT.CrossDomain.Integration.Messages.Commands
{
    public class PreIncrementWithdrawalCommand
    {
        public string MasterContractNumber { get; set; }

        public string ContractNumber { get; set; }

        public int VersionNumber { get; set; }

        public string Ukprn { get; set; }

        public bool ShouldAddPayableNonLevyAllocationToPostWithdrawalAmendment { get; set; }

        public bool ShouldMergeAmendmentTemplate { get; set; }

        public string OverrideAmendmentTemplate { get; set; }

        public string OverrideTemplateName { get; set; }

        public override string ToString()
        {
            return
                $"ContractNumber: {ContractNumber}, ContractVersionNumber: {VersionNumber}, MasterContractNumber: {MasterContractNumber}, " +
                $"Ukprn: {Ukprn}, ShouldAddPayableNonLevyAllocationToPostWithdrawalAmendment: {ShouldAddPayableNonLevyAllocationToPostWithdrawalAmendment}, " +
                $"OverrideAmendmentTemplate: {OverrideAmendmentTemplate}, OverrideTemplateName: {OverrideTemplateName}";
        }
    }
}