namespace ContractManagementDomain.Termination.DTOs
{
    using SFA.FCT.ContractManagementService.Common;
    using SFA.FCT.CrossDomain.Integration.Entities.CorporateContract;

    public class UpdateSubStatusAndAddContractToFeedResult
    {
        public UpdateSubStatusAndAddContractToFeedResult(AtomItemCreationResult atomItemCreationResult, Contract corporateContract)
        {
            AtomItemCreationResult = atomItemCreationResult;
            CorporateContract = corporateContract;
        }

        public AtomItemCreationResult AtomItemCreationResult { get; }

        public Contract CorporateContract { get; }
    }
}