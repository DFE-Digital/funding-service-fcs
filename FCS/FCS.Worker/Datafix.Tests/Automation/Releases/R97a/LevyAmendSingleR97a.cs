namespace Datafix.Tests.Automation.Releases.R97a
{
    using Services;
    using SFA.FCT.ContractManagementService.Common;

    public class LevyAmendSingleR97a : IApplyDataFix
    {
        public string Release => "R97a";

        public int StoryNumber => 31720;

        public string Name => "Republish latest Apprenticeships Provider Agrmt variation for 1 provider (31720) [19th Aug]";

        public int Order => 1;

        public void ApplyDataFix()
        {
            LevyAmendmentService.AmendSingle(
                ukprn: 10005520,
                amendmentType: AmendmentType.Variation,
                shouldAddPayableNonLevyAllocation: false,
                allowUnderTermination: false,
                shouldMergeAmendmentTemplate: true);
        }
    }
}