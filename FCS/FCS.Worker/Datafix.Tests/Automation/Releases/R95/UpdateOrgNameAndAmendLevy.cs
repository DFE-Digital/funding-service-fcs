namespace Datafix.Tests.Automation.Releases.R95
{
    using Datafix.Tests.Repositories;
    using Services;
    using SFA.FCT.ContractManagementService.Common;

    public class UpdateOrgNameAndAmendLevy : IApplyDataFix
    {
        private const string ProviderName = "ALLIANCE LEARNING";
        private const int Ukprn = 10000238;

        public string Release => "R95";
        public int StoryNumber => 31392;
        public string Name => $"Update Org name for {Ukprn} and Amend Levy";
        public int Order => 1;

        public void ApplyDataFix()
        {
            CrmAccountRepository.UpdateName(Ukprn, ProviderName);

            OrganisationRepository.UpdateOrgName(Ukprn, ProviderName);

            LevyAmendmentService.AmendSingle(
                ukprn:Ukprn,
                amendmentType: AmendmentType.Variation,
                shouldAddPayableNonLevyAllocation:false,
                allowUnderTermination:false,
                shouldMergeAmendmentTemplate:true);
        }
    }
}
