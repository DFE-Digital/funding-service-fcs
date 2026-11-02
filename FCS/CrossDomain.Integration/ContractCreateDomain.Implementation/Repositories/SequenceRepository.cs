namespace SFA.FCT.ContractCreateDomain.Implementation.Repositories
{
    using System.Threading.Tasks;
    using CrossDomain.Integration.Entities.Data;
    using Dapper;

    public class SequenceRepository : ISequenceRepository
    {
        public async Task<int> GetNextNumber(SequenceType sequenceType, string context, ConnectionInfo connectionInfo)
        {
            SequenceName sequenceName = new SequenceName(sequenceType, context);
            int nextNumber = await connectionInfo.Connection.ExecuteScalarAsync<int>($"SELECT NEXT VALUE FOR ContractManagement.{sequenceName}", transaction: connectionInfo.Transaction);

            return nextNumber;
        }
    }
}