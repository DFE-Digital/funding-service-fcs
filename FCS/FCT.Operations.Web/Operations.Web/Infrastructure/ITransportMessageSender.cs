namespace Operations.Web.Infrastructure
{
    using System.Threading.Tasks;

    public interface ITransportMessageSender
    {
        Task Send<T>(T command, string destination);
    }
}