using System.Collections.Generic;
using System.Linq;
using Datafix.Tests.Repositories;
using Datafix.Tests.Services;
using NServiceBus;
using SFA.FCT.ContractManagementService.Common;
using SFA.FCT.ContractManagementService.Common.Commands;
using SFA.FCT.CrossDomain.Integration.Entities;
using ContractInformation = SFA.FCT.CrossDomain.Integration.Entities.ContractInformation;

namespace Datafix.Tests.Automation.Releases.R137c
{
    public class APPLEVY_AdditionalContracts_Apprenticeships_ProviderAgreementandVariationLetter : IApplyDataFix
    {
        public string Release => "R137c";
        public int StoryNumber => 38652;  //story Number 
        public string Name => "APPLEVY - Data Fix for contract that is now Approved (38652)";
        public int Order => 1;

        public void ApplyDataFix()
        {
            const string levyFundingType = "LEVY";
            const string levyFundingPeriod = "LEVY1799";


            var endpoint = EndpointBuilder.CreateSendOnlyEndpoint<AmendLevyContractCommand>();
            var crmRepository = new CrmContractInformationRepository();

            var allLevyContracts = crmRepository.GetLatestContractInformationByFundingTypeAndFundingPeriod(levyFundingType, levyFundingPeriod);
            var levyContractsPost5000 = allLevyContracts.Where(c => c.NumberPartOfContractNumber >= 5000).ToList();

            var approvedApprovedContracts = levyContractsPost5000.Where(c => c.ContractStatus == ContractStatus.Approved && c.ContractSubStatus == ContractSubStatus.Approved).ToList();
            var approvedModifiedContracts = levyContractsPost5000.Where(c => c.ContractStatus == ContractStatus.Approved && c.ContractSubStatus == ContractSubStatus.Modified).ToList();
            var approvedUnderTerminationContracts = levyContractsPost5000.Where(c => c.ContractStatus == ContractStatus.Approved && c.ContractSubStatus == ContractSubStatus.UnderTermination).ToList();

            AmendApprovedApproved(approvedApprovedContracts, endpoint);

        }

        private void AmendApprovedApproved(IEnumerable<ContractInformation> approvedApprovedContracts, IEndpointInstance endpoint)
        {
            var levyContractsForApprovedApproved = approvedApprovedContracts.Where(c => _approvedApprovedContracts.Contains(c.ContractNumber)).ToList();

            levyContractsForApprovedApproved.ForEach(c =>
            {
                endpoint.Send("ContractManagementDomain.LevyAmendmentEndpoint", new AmendLevyContractCommand
                {
                    ContractInformation = c,
                    AmendmentType = AmendmentType.Variation,
                    AmendmentSource = AmendLevyContractCommand.LevyAmendmentSource.Single,
                    ShouldAddPayableNonLevyAllocation = false,
                    ShouldMergeAmendmentTemplate = true,
                    OverrideTemplateName = "T&C_LEVY_2017-05-01.docx",
                    OverrideAmendmentTemplate = "LEVY1799_Amendment.docx"
                }).Wait();
            });
        }

        //approved contact
        private readonly List<string> _approvedApprovedContracts = new List<string>
        {
             "APPLEVY-5587"
        };
    }
}
