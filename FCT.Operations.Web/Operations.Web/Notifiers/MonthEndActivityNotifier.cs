namespace Operations.Web.Notifiers
{
    using System;
    using System.Threading.Tasks;
    using Dtos;
    using Repositories;
    
    public class MonthEndActivityNotifier : INotifier
    {
        private const string NotificationName = "Month End Activity";
        private const string MonthEndCompletedDescription = "Month End completed: ";
        private const string MonthEndInProgressDescription = "Month End Progressing";

        private readonly IMonthEndRepository _monthEndRepository;

        public MonthEndActivityNotifier(IMonthEndRepository monthEndRepository)
        {
            _monthEndRepository = monthEndRepository;
        }

        public async Task<Notification> GetNotification()
        {
            var latestMonthEndEndTime = await _monthEndRepository.GetLatestEndTime().ConfigureAwait(continueOnCapturedContext: false);

            if (latestMonthEndEndTime.HasValue)
            {
                return HasMonthEndRecentlyFinished(latestMonthEndEndTime.Value)
                    ? new Notification(PutTogetherMonthEndCompletedNotificationDescription(latestMonthEndEndTime.Value.ToLocalTime()), NotificationName, NotificationType.Info)
                    : null;
            }

            return new Notification(MonthEndInProgressDescription, NotificationName, NotificationType.Info);
        }

        private static bool HasMonthEndRecentlyFinished(DateTime latestMonthEndEndTime)
        {
            const double numberOfHoursRegardedAsRecent = 3;

            var currentTime = DateTime.UtcNow;
            var timeElapsed = currentTime.Subtract(latestMonthEndEndTime);
            return timeElapsed <= TimeSpan.FromHours(numberOfHoursRegardedAsRecent);
        }

        private static string PutTogetherMonthEndCompletedNotificationDescription(DateTime latestMonthEndEndTime)
        {
            return MonthEndCompletedDescription + FormattedDateTime(ToLocalTime(latestMonthEndEndTime));
        }

        private static string FormattedDateTime(DateTime dateTime)
        {
            return $"{dateTime:MMMM dd 'at' h:mm tt}";
        }

        private static DateTime ToLocalTime(DateTime latestMonthEndEndTime)
        {
            return TimeZoneInfo.ConvertTime(latestMonthEndEndTime, TimeZoneInfo.FindSystemTimeZoneById("GMT Standard Time"));
        }
    }
}