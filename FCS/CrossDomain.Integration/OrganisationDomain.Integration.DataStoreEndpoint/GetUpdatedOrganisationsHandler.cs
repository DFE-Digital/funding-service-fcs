namespace OrganisationDomain.Integration.DataStoreEndpoint
{
    using System.Collections.Generic;
    using Entities;
    using Implementation.BusinessLogic;
    using Implementation.Exceptions;
    using Messages.Commands;
    using NServiceBus;
    using Implementation.Converters;
    using System.Threading.Tasks;
    using Common;
    using SFA.FCT.Framework.Logging.Interfaces;

    public class GetUpdatedOrganisationsHandler : IHandleMessages<GetUpdatedOrganisations>
    {
        public ILogger Logger { get; set; }

        public IProviderComparer Comparer { get; set; }

        public ICpdsProviderConverter Converter { get; set; }

        public async Task Handle(GetUpdatedOrganisations message, IMessageHandlerContext context)
        {
            Logger.LogInformation(OrganisationDomainEventLoggingId.GetUpdatedOrganisationsMessageReceived,
                $"{message.GetType()} message received. ProcessId:{message.ProcessId}.");

            Comparer.CpdsProviders = Converter.ConvertBlobToProviderSequenceList(message.ProviderSummaryDatabus);

            List<ProviderSequence> changedUkprnList;
            try
            {
                changedUkprnList = Comparer.GetChanges();
            }
            catch (ProviderSummaryUnavailableException e)
            {
                Logger.LogError(OrganisationDomainEventLoggingId.GetUpdatedOrganisationsError,
                    $"Error trying to obtain Provider Summary for compare: {e.Message}");
                throw;
            }

            var command = new ProcessUpdatedOrganisations
            {
                ProcessId = message.ProcessId,
                ChangedProviderUkprnList = changedUkprnList
            };

            await context.Send(command).ConfigureAwait(false);
        }
    }
}
