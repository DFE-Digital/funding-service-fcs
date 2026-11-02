namespace FCT.Operations.Cda.Repositories
{
    using System.Collections.Generic;
    using System.Threading.Tasks;
    using Dtos;

    public interface ICrmCdaRepository
    {
        Task<IReadOnlyCollection<CdaRow>> GetRows(IEnumerable<string> fsps, bool isLatestVersion);
    }
}