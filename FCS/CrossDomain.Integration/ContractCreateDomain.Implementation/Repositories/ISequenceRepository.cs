namespace SFA.FCT.ContractCreateDomain.Implementation.Repositories
{
    using System.Threading.Tasks;
    using CrossDomain.Integration.Entities.Data;

    public interface ISequenceRepository
    {
        Task<int> GetNextNumber(SequenceType sequenceType, string context, ConnectionInfo connectionInfo);
    }
}