using System.Collections.Generic;
using System.Linq;
using Datafix.Tests.Repositories;
using Datafix.Tests.Services;
using NServiceBus;
using SFA.FCT.ContractManagementService.Common;
using SFA.FCT.ContractManagementService.Common.Commands;
using SFA.FCT.CrossDomain.Integration.Entities;
using ContractInformation = SFA.FCT.CrossDomain.Integration.Entities.ContractInformation;


namespace Datafix.Tests.Automation.Releases.R174
{
    public class Apprenticeships_Variations_6037 : IApplyDataFix
    {
        public string Release => "R174a";
        public int StoryNumber => 47241;
        public string Name => "Apprenticeships variation letter for APPLEVY6037";
        public int Order => 1;

        public void ApplyDataFix()
        {
            const string levyFundingType = "LEVY";
            const string levyFundingPeriod = "LEVY1799";

            var endpoint = EndpointBuilder.CreateSendOnlyEndpoint<AmendLevyContractCommand>();
            var crmRepository = new CrmContractInformationRepository();

            var allLevyContracts = crmRepository.GetLatestContractInformationByFundingTypeAndFundingPeriod(levyFundingType, levyFundingPeriod);
            var levyContractToUpdate = allLevyContracts.Where(c => c.ContractNumber == "APPLEVY-6037").Single();

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
                OverrideTemplateName = "T&C_LEVY_2017-05-01_APPLEVY-6037.docx",
                OverrideAmendmentTemplate = "LEVY1799_Amendment_APPLEVY-6037.docx"
            }).Wait();
        }

    }
}
