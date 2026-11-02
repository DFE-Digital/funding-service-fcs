namespace SFA.FCT.ContractManagementService.Common.Commands
{
    using CrossDomain.Integration.Entities;

    public class AmendLevyContractCommand
    {
        public ContractInformation ContractInformation { get; set; }

        public LevyAmendmentSource AmendmentSource { get; set; }

        public AmendmentType AmendmentType { get; set; }

        public bool ShouldAddPayableNonLevyAllocation { get; set; }

        public bool AllowUnderTermination { get; set; } = true;

        public bool ShouldMergeAmendmentTemplate { get; set; }

        public string OverrideAmendmentTemplate { get; set; }

        public string OverrideTemplateName { get; set; }

        public override string ToString()
        {
            return $"ContractInformation: {ContractInformation}, AmendmentSource: {AmendmentSource}, AmendmentType: {AmendmentType}, " +
                   $"ShouldAddPayableNonLevyAllocation: {ShouldAddPayableNonLevyAllocation}, AllowUnderTermination: {AllowUnderTermination}" +
                   $"ShouldMergeAmendmentTemplate: {ShouldMergeAmendmentTemplate}, OverrideAmendmentTemplate: {OverrideAmendmentTemplate}" +
                   $"OverrideTemplateName: {OverrideTemplateName}";
        }

        public enum LevyAmendmentSource
        {
            Bulk,
            Single
        }
    }
}