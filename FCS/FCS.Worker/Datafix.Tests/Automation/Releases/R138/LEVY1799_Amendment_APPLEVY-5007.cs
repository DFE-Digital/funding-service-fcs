namespace Datafix.Tests.Automation.Releases.R138
{
    using System.Linq;
    using Datafix.Tests.Repositories;
    using Datafix.Tests.Services;
    using NServiceBus;
    using SFA.FCT.ContractManagementService.Common;
    using SFA.FCT.ContractManagementService.Common.Commands;
    using ContractInformation = SFA.FCT.CrossDomain.Integration.Entities.ContractInformation;
    public class LEVY1799_Amendment_APPLEVY_5007 : IApplyDataFix
    {
        public string Release => "R138";

        public int StoryNumber => 38684;

        public string Name => "APPLEVY - Data fix for APPLEVY-5007 using bespoke contract docs";

        public int Order => 1;

        public void ApplyDataFix()
        {
            const string levyFundingType = "LEVY";
            const string levyFundingPeriod = "LEVY1799";

            var endpoint = EndpointBuilder.CreateSendOnlyEndpoint<AmendLevyContractCommand>();
            var crmRepository = new CrmContractInformationRepository();

            var allLevyContracts = crmRepository.GetLatestContractInformationByFundingTypeAndFundingPeriod(levyFundingType, levyFundingPeriod);
            var levyContractToUpdate = allLevyContracts.Where(c => c.ContractNumber == "APPLEVY-5007").Single();

            AmendContracts(levyContractToUpdate, endpoint);
        }

        private static void AmendContracts(ContractInformation levyContractToUpdate, IEndpointInstance endpoint)
        {
            endpoint.Send("ContractManagementDomain.LevyAmendmentEndpoint", new AmendLevyContractCommand
            {
                ContractInformation = levyContractToUpdate,
                AmendmentType = AmendmentType.Variation,
                AmendmentSource = AmendLevyContractCommand.LevyAmendmentSource.Single,
                ShouldAddPayableNonLevyAllocation = false,
                ShouldMergeAmendmentTemplate = true,
                OverrideTemplateName = "T&C_LEVY_2017-05-01_APPLEVY-5007.docx",
                OverrideAmendmentTemplate = "LEVY1799_Amendment_APPLEVY-5007.docx"
            }).Wait();
        }
    }
}
