namespace Operations.Web.Notifiers
{
    using System.Threading.Tasks;
    using Dtos;

    public interface INotifier
    {
        Task<Notification> GetNotification();
    }
}