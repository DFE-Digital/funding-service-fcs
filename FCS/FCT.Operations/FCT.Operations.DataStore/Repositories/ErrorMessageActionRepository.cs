namespace SFA.FCT.Operations.DataStore.Repositories
{
    using Model;

    public class ErrorMessageActionRepository : IErrorMessageActionRepository
    {
        private readonly IOperationsDbContext _dbContext;

        public ErrorMessageActionRepository(IOperationsDbContext dbContext)
        {
            _dbContext = dbContext;
        }

        public void Add(ErrorMessageAction entity)
        {
            _dbContext.ErrorMessageActions.Add(entity);
            _dbContext.SaveChanges();
        }
    }
}
