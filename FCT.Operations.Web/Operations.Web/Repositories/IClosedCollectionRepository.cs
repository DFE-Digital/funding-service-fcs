namespace Operations.Web.Repositories
{
    using System.Collections.Generic;
    using System.Threading.Tasks;
    using Dtos;

    public interface IClosedCollectionRepository
    {
        Task<IReadOnlyCollection<ClosedCollection>> GetClosedCollectionsDesc(int startRow, int numRows);
    }
}