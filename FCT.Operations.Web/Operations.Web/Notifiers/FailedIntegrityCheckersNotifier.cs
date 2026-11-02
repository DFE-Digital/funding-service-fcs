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

    public class FailedIntegrityCheckersNotifier : INotifier
    {
        private const string NotificationName = "Failed Integrity Checkers";
        private readonly IContractManagementDbContext _context;

        public FailedIntegrityCheckersNotifier(IContractManagementDbContext context)
        {
            _context = context;
        }

        public async Task<Notification> GetNotification()
        {
            DateTime oldestDateToRetrieve = DateTime.UtcNow.AddDays(-4);

            IReadOnlyCollection<IntegrityCheck> latestIntegrityChecks = await GetLatestIntegrityChecks(oldestDateToRetrieve);

            IReadOnlyCollection<string> failedIntegrityCheckers =
                latestIntegrityChecks
                    .GroupBy(i => i.CheckerType)
                    .Select(checkerGroup =>
                        {
                            IntegrityCheck latestIntegrityCheck = checkerGroup.OrderByDescending(i => i.Id).First();

                            return new
                            {
                                CheckerName = checkerGroup.Key,
                                LatestStatus = latestIntegrityCheck.Status,
                                LatestResult = latestIntegrityCheck.Outcome
                            };
                        })
                    .Where(latestCheckerResult => latestCheckerResult.LatestStatus == "Error" || latestCheckerResult.LatestResult == "Failed")
                    .Select(latestCheckerResult => latestCheckerResult.CheckerName)
                    .OrderBy(checkerName => checkerName)
                    .ToList();

            Notification notification = failedIntegrityCheckers.Any() ? new Notification(
                description: string.Join(", ", failedIntegrityCheckers),
                notificationName: NotificationName,
                notificationType: NotificationType.Warning) : null; 

            return notification;
        }

        private async Task<List<IntegrityCheck>> GetLatestIntegrityChecks(DateTime oldestDateToRetrieve)
            => await _context.IntegrityCheckItems
                    .Where(i => i.FinishDate >= oldestDateToRetrieve || i.FinishDate == null)
                    .ToListAsync()
                    .ConfigureAwait(continueOnCapturedContext: false);
    }
}