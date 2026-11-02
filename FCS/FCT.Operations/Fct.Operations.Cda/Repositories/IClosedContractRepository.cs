namespace FCT.Operations.Cda.Repositories
{
    using System.Collections.Generic;
    using System.Threading.Tasks;
    using SFA.FCT.CrossDomain.Integration.Entities.Data;

    public interface IClosedContractRepository
    {
        Task<IReadOnlyCollection<(string contractNumber, int year)>> GetContractNumbersClosedInPreviousYears(
            IEnumerable<string> fspCodes,
            int lastYear,
            ConnectionInfo connectionInfo);
    }
}