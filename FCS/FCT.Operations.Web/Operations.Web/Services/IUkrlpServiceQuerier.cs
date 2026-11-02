using System.Threading.Tasks;

namespace Operations.Web.Services
{
    public interface IUkrlpServiceQuerier
    {
        Task<bool> DoesUkprnExistInUkrlp(string[] ukprns);
    }
}
