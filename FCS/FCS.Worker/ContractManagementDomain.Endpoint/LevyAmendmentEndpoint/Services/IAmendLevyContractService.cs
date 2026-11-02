namespace ContractManagementDomain.Endpoint.LevyAmendmentEndpoint.Services
{
    using DTOs;
    using SFA.FCT.ContractManagementService.Common;
    using SFA.FCT.CrossDomain.Integration.Entities.Data;
    using ContractInformation = SFA.FCT.CrossDomain.Integration.Entities.ContractInformation;

    public interface IAmendLevyContractService
    {
        AmendBulkComponentLevyContractResult AmendSingleLevyContract(ContractInformation contractInformation, AmendmentType amendmentType,
            bool shouldAddPayableNonLevyAllocation,
            bool allowUnderTermination);

        AmendBulkComponentLevyContractResult AmendBulkComponentLevyContract(ContractInformation contractInformation, AmendmentType amendmentType, 
            bool shouldAddPayableNonLevyAllocation,
            bool allowUnderTermination,
            ConnectionInfo connectionInfo);
    }
}