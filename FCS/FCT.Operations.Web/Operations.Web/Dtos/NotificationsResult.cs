namespace Operations.Web.Dtos
{
    using System.Collections.Generic;

    public class NotificationsResult
    {
        public NotificationsResult()
        {
            Notifications = new List<Notification>();
        }

        public List<Notification> Notifications { get; set; }
    }
}