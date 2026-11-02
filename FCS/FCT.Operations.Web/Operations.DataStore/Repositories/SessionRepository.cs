namespace Operations.DataStore.Repositories
{
    using System;
    using System.Threading.Tasks;
    using Dapper;

    public class SessionRepository : ISessionRepository
    {
        private readonly OperationsDbContext _context;

        public SessionRepository(OperationsDbContext context)
        {
            _context = context;
        }

        public async Task<Guid> CreateSessionAsync()
        {
            Guid sessionId = Guid.NewGuid();
            const string sql = @"
                        insert into [Operations].[Session] (Identifier) 
                        values (@guid);
";
            await _context.Database.Connection.ExecuteAsync(sql, new {guid = sessionId});

            return sessionId;
        }

        public async Task<bool> IsSessionPresentAsync(Guid sessionId)
        {
            const string sql = @"select count(1) from [Operations].[Session] where Identifier = @guid";

            return await _context.Database.Connection.ExecuteScalarAsync<int>(sql, new { guid = sessionId }) == 1;
        }
    }
}
