namespace SFA.FCT.Operations.Common.Repositories
{
    using SFA.FCT.CrossDomain.Integration.Entities.Data;
    using System;
    using System.Threading.Tasks;

    public interface IOverrideDateRepository
    {
        Task<DateTime> GetDate(ConnectionInfo connectionInfo);
    }
}
