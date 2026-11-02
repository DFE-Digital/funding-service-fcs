namespace Operations.Web.Services
{
    using OrganisationDomain.Integration.DataStore;
    using OrganisationDomain.Integration.DataStore.Repositories;
    using System;
    using System.Collections.Generic;
    using System.Threading.Tasks;
    using ContractManagement.DataStore;
    using DataStore.Repositories;
    using Notifiers;
    using Dtos;

    public class NotifierFactory : INotifierFactory
    {
        IReadOnlyCollection<Func<Task<Notification>>> INotifierFactory.GetNotifiers()
        {
            return new List<Func<Task<Notification>>>
            {
                GetErrorQueueNotification,
                GetFailedIntegrityCheckersNotification,
                GetRunningIntegrityCheckersNotification,
                GetProviderNotYetRetrievedFromUkrlpCountNotification,
                GetDuplicateContractNotification,
                GetMonthEndActivityNotification
            };
        }

        private static async Task<Notification> GetErrorQueueNotification()
        {
            return await new ErrorQueueNotifier().GetNotification().ConfigureAwait(false);
        }

        private static async Task<Notification> GetFailedIntegrityCheckersNotification()
        {
            using (var context = new ContractManagementDbContext())
            {
                return await new FailedIntegrityCheckersNotifier(context).GetNotification().ConfigureAwait(false);
            }
        }

        private static async Task<Notification> GetRunningIntegrityCheckersNotification()
        {
            using (var context = new ContractManagementDbContext())
            {
                return await new RunningIntegrityCheckersNotifier(context).GetNotification().ConfigureAwait(false);
            }
        }

        private static async Task<Notification> GetProviderNotYetRetrievedFromUkrlpCountNotification()
        {
            using (var context = new OrganisationDomainDbContext())
            {
                var repository = new OrganisationRepository(context);

                return await new ProviderNotYetRetrievedFromUkrlpNotifier(repository).GetNotification().ConfigureAwait(false);
            }
        }

        private static async Task<Notification> GetDuplicateContractNotification()
        {
            int numDuplicates = await DuplicateContractRepository.AreThereDuplicateContractsInCrm();

            if (numDuplicates > 0)
            {
                return new Notification($"{numDuplicates} duplicate(s) found", "Duplicate Contract(s) in CRM", NotificationType.Error);
            }

            return null;
        }

        private static async Task<Notification> GetMonthEndActivityNotification()
        {
            return await new MonthEndActivityNotifier(new Repositories.MonthEndRepository()).GetNotification().ConfigureAwait(false);
        }
    }
}