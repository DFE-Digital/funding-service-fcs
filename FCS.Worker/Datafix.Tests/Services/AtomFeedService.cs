namespace Datafix.Tests.Services
{
    using System;
    using ContractManagement.DataStore.Model;
    using Repositories;
    using SFA.FCT.ContractManagementService.Common;
    using SFA.FCT.ContractManagementService.Common.Services;
    using SFA.FCT.CrossDomain.Integration.Common;
    using SFA.FCT.CrossDomain.Integration.Common.Serializers;

    public static class AtomFeedService
    {
        public static void AddItemToFeed(ContractIdentifier contractIdentifier, AtomItemType atomItemType)
        {
            var contract = ContractService.GetCorpSchemaContract(contractIdentifier);

            var xml = contract.SerializeToXml();
            if (CorporateSchemaContractValidator.IsContractXmlValid(xml))
            {
                var bytes = ZipHelper.ToZippedBytesFromString(xml);
                AtomFeedItemRepository.Insert(
                    atomItemType,
                    contract.GetFirstContractNumber(),
                    bytes);
            }
            else
            {
                throw new ArgumentException($"The xml generated is invalid: {xml}");
            }
        }
    }
}
