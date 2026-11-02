namespace FCT.Operations.Cda.Repositories
{
    using System.Collections.Generic;
    using System.Threading.Tasks;
    using Dtos;
    using SFA.FCT.CrossDomain.Integration.Entities.Data;

    public interface ICdaConfigRepository
    {
        Task<IReadOnlyCollection<CdaExtract>> GetAllCdaExtracts(ConnectionInfo connectionInfo);
    }
}