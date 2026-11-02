namespace Operations.Web.Notifiers
{
    using System;
    using System.Collections.Generic;
    using System.Data.Entity;
    using System.Linq;
    using System.Threading.Tasks;
    using ContractManagement.DataStore;
    using ContractManagement.DataStore.Model;
    using Dtos;

    public class RunningIntegrityCheckersNotifier : INotifier
    {
        private const string NotificationName = "Running Integrity Checkers";
        private readonly ContractManagementDbContext _context;

        public RunningIntegrityCheckersNotifier(ContractManagementDbContext context)
        {
            _context = context;
        }

        public async Task<Notification> GetNotification()
        {
            DateTime oldestStartDateToRetrieve = DateTime.UtcNow.AddDays(-2);

            IReadOnlyCollection<IntegrityCheck> latestIntegrityChecks = await GetIntegrityChecksStartedSince(oldestStartDateToRetrieve);

            IReadOnlyCollection<string> runningIntegrityCheckers =
                latestIntegrityChecks
                    .GroupBy(i => i.CheckerType)
                    .Select(checkerGroup =>
                    {
                        IntegrityCheck latestIntegrityCheck = checkerGroup.OrderByDescending(i => i.Id).First();

                        return new
                        {
                            CheckerName = checkerGroup.Key,
                            LatestStatus = latestIntegrityCheck.Status
                        };
                    })
                    .Where(latestCheckerResult => latestCheckerResult.LatestStatus == "Running")
                    .Select(latestCheckerResult => latestCheckerResult.CheckerName)
                    .OrderBy(checkerName => checkerName)
                    .ToList();

            Notification notification = runningIntegrityCheckers.Any() ? new Notification(
                description: string.Join(", ", runningIntegrityCheckers),
                notificationName: NotificationName,
                notificationType: NotificationType.Info) : null;

            return notification;
        }

        private async Task<List<IntegrityCheck>> GetIntegrityChecksStartedSince(DateTime oldestStartDateToRetrieve)
            => await _context.IntegrityCheckItems
                    .Where(i => i.StartDate >= oldestStartDateToRetrieve)
                    .ToListAsync()
                    .ConfigureAwait(continueOnCapturedContext: false);

    }
}