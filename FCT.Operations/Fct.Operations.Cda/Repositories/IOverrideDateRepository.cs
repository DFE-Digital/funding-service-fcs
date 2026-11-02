namespace FCT.Operations.Cda.Repositories
{
    using System;
    using System.Threading.Tasks;
    using SFA.FCT.CrossDomain.Integration.Entities.Data;

    public interface IOverrideDateRepository
    {
        Task<DateTime> GetDate(ConnectionInfo connectionInfo);
    }
}