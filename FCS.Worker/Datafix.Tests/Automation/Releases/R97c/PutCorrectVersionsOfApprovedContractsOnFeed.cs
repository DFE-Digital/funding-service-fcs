namespace Datafix.Tests.Automation.Releases.R97c
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

    public class PutCorrectVersionsOfApprovedContractsOnFeed : IApplyDataFix
    {
        public string Release => "R97c";

        public int StoryNumber => 31875;

        public string Name => "SLD unable to identify which providers have Community Learning funding for 19/20";

        public int Order => 1;

        public void ApplyDataFix()
        {
            var contractIdentifiers = new List<ContractIdentifier>
            {
                new ContractIdentifier(contractNumber: "EDSK-1704", 5, 0),
                new ContractIdentifier(contractNumber: "EDSK-2288", 4, 0),
                new ContractIdentifier(contractNumber: "EDSK-1928", 4, 0),
                new ContractIdentifier(contractNumber: "EDSK-1701", 5, 0),
                new ContractIdentifier(contractNumber: "EDSK-2247", 5, 0)
            };

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
