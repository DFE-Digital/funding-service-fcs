namespace ContractManagementDomain.Endpoint.Xrm.ContractClosure.Services
{
    using System;

    public interface IContractClosureService
    {
        void CloseContractInCrm(string contractNumber, int versionNumber, int subVersionNumber, DateTime closureDate, bool isContractOpenEnded);
    }
}
