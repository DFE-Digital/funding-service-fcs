using System.Collections.Generic;
using System.Linq;
using Datafix.Tests.Repositories;
using Datafix.Tests.Services;
using NServiceBus;
using SFA.FCT.ContractManagementService.Common;
using SFA.FCT.ContractManagementService.Common.Commands;
using ContractInformation = SFA.FCT.CrossDomain.Integration.Entities.ContractInformation;

namespace Datafix.Tests.Automation.Releases.R120
{
    public class PublishApprenticeshipProviderLettersUpdated : IApplyDataFix
    {
        public string Release => "R120";
        public int StoryNumber => 36700;
        public string Name => "Publish Apprenticeships Provider Letters";
        public int Order => 1;

        public void ApplyDataFix()
        {
            const string levyFundingType = "LEVY";
            const string levyFundingPeriod = "LEVY1799";

            var endpoint = EndpointBuilder.CreateSendOnlyEndpoint<AmendLevyContractCommand>();
            var crmRepository = new CrmContractInformationRepository();

            var allLevyContracts = crmRepository.GetLatestContractInformationByFundingTypeAndFundingPeriod(levyFundingType, levyFundingPeriod);
            var levyContractsToUpdate = allLevyContracts.Where(c => _contractsList.Contains(c.ContractNumber)).ToList();

            AmendContracts(levyContractsToUpdate, endpoint);
        }

        private static void AmendContracts(List<ContractInformation> levyContractsToUpdate, IEndpointInstance endpoint)
        {
            levyContractsToUpdate.ForEach(c =>
            {
                endpoint.Send("ContractManagementDomain.LevyAmendmentEndpoint", new AmendLevyContractCommand
                {
                    ContractInformation = c,
                    AmendmentType = AmendmentType.Variation,
                    AmendmentSource = AmendLevyContractCommand.LevyAmendmentSource.Single,
                    ShouldAddPayableNonLevyAllocation = false,
                    ShouldMergeAmendmentTemplate = false
                }).Wait();
            });
        }

        private readonly List<string> _contractsList = new List<string>()
        {
            "APPLEVY-5202",
            "APPLEVY-5396",
            "APPLEVY-5623",
            "APPLEVY-5819",
            "APPLEVY-5833",
            "APPLEVY-5860",
            "APPLEVY-6369",
            "APPLEVY-6604",
            "APPLEVY-6647",
            "APPLEVY-6801",
            "APPLEVY-6827",
            "APPLEVY-6959",
            "APPLEVY-6960",
            "APPLEVY-6962"
        };
    }
}