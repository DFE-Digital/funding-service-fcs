namespace Operations.Web.Services
{
    using System.Collections.Generic;
    using System.Threading.Tasks;
    using Dtos;

    public interface INotificationsService
    {
        Task<IReadOnlyCollection<Notification>> GetNotifications();
    }
}
