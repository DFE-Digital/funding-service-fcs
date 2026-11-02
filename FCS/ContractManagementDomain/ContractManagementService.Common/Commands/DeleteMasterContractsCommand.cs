namespace SFA.FCT.ContractManagementService.Common.Commands
{
    using System;
    using System.Collections.Generic;

    public class DeleteMasterContractsCommand
    {
        public string RelatedChildContractNumber { get; set; }
        public int RelatedChildContractVersionNumber { get; set; }
        public IReadOnlyCollection<Guid> MasterContractIds { get; set; }

        public override string ToString()
        {
            return $"RelatedChildContractNumber: {RelatedChildContractNumber}, RelatedChildContractVersionNumber: {RelatedChildContractVersionNumber}";
        }
    }
}
