namespace Operations.DataStore.Repositories
{
    using System;
    using System.Threading.Tasks;

    public interface ISessionRepository
    {
        Task<Guid> CreateSessionAsync();

        Task<bool> IsSessionPresentAsync(Guid identifier);
    }
}