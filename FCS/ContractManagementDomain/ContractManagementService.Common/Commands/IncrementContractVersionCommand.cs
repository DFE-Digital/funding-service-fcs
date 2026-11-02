namespace SFA.FCT.ContractManagementService.Common.Commands
{
    public class IncrementContractVersionCommand
    {
        public string ContractNumber { get; set; }

        public int VersionNumber { get; set; }

        public int SubVersionNumber { get; set; }

        public AmendmentType AmendmentType { get; set; }

        public bool IsNonFinancialAmendment { get; set; }

        public bool ShouldAddPayableNonLevyAllocation { get; set; }

        public bool ShouldMergeAmendmentTemplate { get; set; }

        public string OverrideAmendmentTemplate { get; set; }

        public string OverrideTemplateName { get; set; }

        public override string ToString()
        {
            return $"ContractNumber: {ContractNumber}, VersionNumber: {VersionNumber}, SubVersionNumber: {SubVersionNumber}, AmendmentType: {AmendmentType}, " +
                   $"ShouldAddPayableNonLevyAllocation: {ShouldAddPayableNonLevyAllocation}, ShouldMergeAmendmentTemplate {ShouldMergeAmendmentTemplate}, " +
                   $"OverrideAmendmentTemplate: {OverrideAmendmentTemplate}, OverrideTemplateName: {OverrideTemplateName}"; 
        }
    }
}