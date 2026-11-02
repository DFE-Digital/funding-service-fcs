namespace ContractCreateDomain.Endpoint.NonFinancialAmendment.Services
{
    using SFA.FCT.ContractManagementService.Common;
    using SFA.FCT.CrossDomain.Integration.Entities.Data;

    public interface INonFinancialAmendmentValidationService
    {
        string IsValid(ContractIdentifier contractIdentifier, ConnectionInfo connectionInfo);
    }
}
