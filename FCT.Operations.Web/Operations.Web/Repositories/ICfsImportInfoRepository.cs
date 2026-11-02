namespace Operations.Web.Repositories
{
    using System.Threading.Tasks;
    using System.Collections.Generic;
    using Dtos;

    public interface ICfsImportInfoRepository
    {
        Task<IReadOnlyCollection<CfsImportInfo>> GetCfsImportInfos(int startRow, int numRows);
    }
}