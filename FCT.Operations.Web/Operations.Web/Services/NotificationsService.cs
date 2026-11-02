namespace Operations.Web.Services
{
    using System.Collections.Generic;
    using System.Linq;
    using System.Threading.Tasks;
    using Dtos;

    public class NotificationsService : INotificationsService
    {
        private readonly INotifierFactory _notifierFactory;

        public NotificationsService(INotifierFactory notifierFactory)
        {
            _notifierFactory = notifierFactory;
        }

        public async Task<IReadOnlyCollection<Notification>> GetNotifications()
        {
            Notification[] notifications = await Task.WhenAll(_notifierFactory.GetNotifiers().Select(getNotificationAsync => getNotificationAsync()));

            return notifications.Where(n => n != null).ToList();
        }
    }
}

