namespace Datafix.Tests.Automation.Releases.R100f
{
    using System;
    using System.Collections.Generic;
    using System.Linq;
    using ContractManagement.DataStore.Model;
    using Datafix.Tests.Repositories;
    using Services;
    using SFA.FCT.ContractManagementService.Common;
    using SFA.FCT.ContractManagementService.Common.Services;
    using SFA.FCT.CrossDomain.Integration.Common;
    using SFA.FCT.CrossDomain.Integration.Common.Serializers;
    using SFA.FCT.CrossDomain.Integration.Entities.Xrm.OptionSets;

    public class AddApprovedContractsWithTerminationDetailsOntoFeed : IApplyDataFix
    {
        private static readonly List<ContractIdentifier> ContractIdentifiersToExclude = new List<ContractIdentifier>
        {
            new ContractIdentifier(contractNumber: "APPLEVY-2046", versionNumber: 1, subVersionNumber: 0),
            new ContractIdentifier(contractNumber: "APPLEVY-1960", versionNumber: 1, subVersionNumber: 0),
            new ContractIdentifier(contractNumber: "APPLEVY-2393", versionNumber: 1, subVersionNumber: 0),
            new ContractIdentifier(contractNumber: "APPLEVY-3198", versionNumber: 1, subVersionNumber: 0),
            new ContractIdentifier(contractNumber: "APPLEVY-3210", versionNumber: 1, subVersionNumber: 0),
            new ContractIdentifier(contractNumber: "APPLEVY-3217", versionNumber: 1, subVersionNumber: 0),
            new ContractIdentifier(contractNumber: "MAIN-6935", versionNumber: 1, subVersionNumber: 0)
        };
        public string Release => "R100f";

        public int StoryNumber => 33750;

        public string Name => "Contract Termination Attributes are not being set in the Contract Feed [33750]";

        public int Order => 1;

        public void ApplyDataFix()
        {
            var contractIdentifiers = CrmContractInformationRepository.GetLastApprovedContractInformationByStatusAndSubStatus(
                sfa_contractstatus.Approved, "Under Termination");

            contractIdentifiers = contractIdentifiers.Where(AtomFeedItemRepository.IsLatestPublishedEventAnApprovalIgnoringDraftAndWithdrawn).ToList();

            contractIdentifiers = contractIdentifiers.Where(ci => ContractIdentifiersToExclude.Contains(ci) == false).ToList();

            var corpSchemaContracts = contractIdentifiers.Select(ContractService.GetCorpSchemaContract).ToList();

            corpSchemaContracts.ForEach(masterSchemaContract =>
            {
                var xml = masterSchemaContract.SerializeToXml();
                if (CorporateSchemaContractValidator.IsContractXmlValid(xml))
                {
                    var bytes = ZipHelper.ToZippedBytesFromString(xml);

                    AtomFeedItemRepository.Insert(
                        AtomItemType.ApprovedContract,
                        masterSchemaContract.GetFirstContractNumber(),
                        bytes);
                }
                else
                {
                    throw new ArgumentException($"The xml generated is invalid: {xml}");
                }
            });
        }
    }
}
