namespace ContractCreateDomain.IncrementContractVersionEndpoint.Services
{
    using SFA.FCT.ContractManagementService.Common;
    using SFA.FCT.CrossDomain.Integration.Entities.CorporateContract;

    public interface IContractVersionIncrementService
    {
        ExtendedContractType CreateAmendedContractVersionIfNotAlreadyCreated(ContractIdentifier contractIdentifier, AmendmentType amendmentType, bool isNonFinancialAmendment);
    }
}