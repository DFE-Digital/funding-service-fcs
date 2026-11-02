namespace SFA.FCT.ContractCreateDomain.Implementation.Persistence
{
    using System.Collections.Generic;
    using Entities;
    using CrossDomain.Integration.Entities.ContractRequest;
    using CrossDomain.Integration.Entities.Data;

    public interface INumberRequestManager
    {
        contractRequestType GetContractNumbers(contractRequestType numberRequest, ConnectionInfo connectionInfo);

        List<NumberRequest> GetContractNumbers(List<NumberRequest> list, ConnectionInfo connectionInfo);

        void PopulateContractAllocationNumbers(contractRequestType numberRequest, ConnectionInfo connectionInfo);
    }
}
