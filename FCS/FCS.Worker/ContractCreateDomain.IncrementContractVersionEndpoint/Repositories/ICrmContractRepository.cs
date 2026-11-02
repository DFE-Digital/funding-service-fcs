namespace ContractCreateDomain.IncrementContractVersionEndpoint.Repositories
{
    using System;
    using LanguageExt;

    public interface ICrmContractRepository
    {
        Option<(string subStatus, DateTime? terminationDate)> GetLastApprovedContractSubStatusAndTerminationDate(string contractNumber);
    }
}