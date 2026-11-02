namespace Operations.Web.Dtos
{
    public class Notification
    {
        public Notification(string description, string notificationName, NotificationType notificationType)
        {
            Description = description;
            NotificationName = notificationName;
            NotificationType = notificationType;
        }

        public string NotificationName { get; }
        
        public string Description { get; }

        public NotificationType NotificationType { get; }
    }

    public enum NotificationType
    {
        Fatal,
        Error,
        Warning,
        Info,
        Debug
    }
}