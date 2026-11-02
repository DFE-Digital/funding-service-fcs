namespace Datafix.Tests.Automation.Repositories
{
    using Operations.DataStore.Model;
    using SFA.FCT.CrossDomain.Integration.Entities.Data;
    using System.Threading.Tasks;

    public interface IDataFixHistoryRepository
    {
        Task Add(DataFixHistory dataFixHistory);
    }
}