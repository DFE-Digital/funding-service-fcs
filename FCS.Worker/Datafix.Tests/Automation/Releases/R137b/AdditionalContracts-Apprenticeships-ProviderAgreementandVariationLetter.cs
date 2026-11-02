using System.Collections.Generic;
using System.Linq;
using Datafix.Tests.Repositories;
using Datafix.Tests.Services;
using NServiceBus;
using SFA.FCT.ContractManagementService.Common;
using SFA.FCT.ContractManagementService.Common.Commands;
using SFA.FCT.CrossDomain.Integration.Entities;
using ContractInformation = SFA.FCT.CrossDomain.Integration.Entities.ContractInformation;

namespace Datafix.Tests.Automation.Releases.R137b
{
    public class AdditionalContracts_Apprenticeships_ProviderAgreementandVariationLetter : IApplyDataFix
    {
        public string Release => "R137b";
        public int StoryNumber => 38622;  //story Number 
        public string Name => "APPLEVY - Data Fix for contracts under termination in production (38622)";
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
            AmendunderterminatedContract(approvedUnderTerminationContracts, endpoint);

        }

        private void AmendunderterminatedContract(IEnumerable<ContractInformation> approvedUnderTerminationContracts, IEndpointInstance endpoint)
        {
            var levyContractsForApprovedApproved = approvedUnderTerminationContracts.Where(c => _approvedUnderTerminatedContracts.Contains(c.ContractNumber)).ToList();

            levyContractsForApprovedApproved.ForEach(c =>
            {
                endpoint.Send("ContractManagementDomain.LevyAmendmentEndpoint", new AmendLevyContractCommand
                {
                    ContractInformation = c,
                    AmendmentType = AmendmentType.Variation,
                    AmendmentSource = AmendLevyContractCommand.LevyAmendmentSource.Single,
                    ShouldAddPayableNonLevyAllocation = false,
                    ShouldMergeAmendmentTemplate = true,
                    AllowUnderTermination = true,
                    OverrideTemplateName = "T&C_LEVY_2017-05-01_UT.docx",
                    OverrideAmendmentTemplate = "LEVY1799_Amendment_UnderTerm.docx"
                }).Wait();
            });
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


        //under termination
        private readonly List<string> _approvedUnderTerminatedContracts = new List<string>()
        {
            "APPLEVY-5440",
            "APPLEVY-6268",
            "APPLEVY-6275"
        };

        //approved contact
        private readonly List<string> _approvedApprovedContracts = new List<string>
        {
             "APPLEVY-7033",
             "APPLEVY-7040"
        };
    }
}
