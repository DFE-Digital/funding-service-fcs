namespace OrganisationDomain.Integration.MainEndpoint
{
    using System;
    using System.Configuration;
    using System.Collections.Generic;
    using System.Linq;
    using System.Threading.Tasks;
    using Entities;
    using Messages.Commands;
    using Messages.Messages;
    using NServiceBus;
    using SFA.FCT.Framework.Logging.Interfaces;
    using SFA.FCT.Framework.Logging.NullObjects;
    using OrganisationDomain.Common;
    using SFA.FCT.CrossDomain.Integration.Entities;
    using SFA.FCT.CrossDomain.Integration.Events;

    public class UpdateOrganisationSaga : Saga<UpdateOrganisationSagaData>,
        IAmStartedByMessages<InitOrganisationUpdate>,
        IHandleMessages<ProcessProviderSummary>,
        IHandleMessages<ProcessUpdatedOrganisations>,
        IHandleMessages<ProcessOrganisationDetails>,
        IHandleMessages<ProcessSavedOrganisation>,
        IHandleTimeouts<UpdateOrganisationTimeout>
    {
        private readonly TimeSpan _timeoutInterval = TimeSpan.FromMinutes(int.Parse(ConfigurationManager.AppSettings["UpdateOrgSagaTimeoutInMinutes"]));

        public UpdateOrganisationSaga()
        {
            Logger = new LoggerNullObject();
        }

        public ILogger Logger { get; set; }

        public async Task Handle(InitOrganisationUpdate message, IMessageHandlerContext context)
        {
            Logger.LogInformation(OrganisationDomainEventLoggingId.UpdateOrganisationSagaOrgUpdateMessageReceived, message.GetType() + " message received. ProcessId:{0}.", message.ProcessId);

            // initialise inital state
            Data.ProcessId = message.ProcessId;
            Data.State = (int)UpdateOrganisationState.Started;
            Data.OrganisationStatus = new Dictionary<int, bool>();

            //// schedule timeout to stop saga from running continiously
            // check it hasn't already been setup by any other handler 
            if (false == Data.IsTimeoutAlreadyScheduled)
            {
                await RequestTimeout<UpdateOrganisationTimeout>(context, _timeoutInterval);
                Data.IsTimeoutAlreadyScheduled = true;
            }

            var command = new GetProviderSummary()
            {
                ProcessId = Data.ProcessId,
            };

            await context.Send(command);
        }

        public async Task Handle(ProcessProviderSummary message, IMessageHandlerContext context)
        {
            Logger.LogInformation(OrganisationDomainEventLoggingId.UpdateOrganisationSagaProviderSummaryMessageReceived, message.GetType() + " message received. ProcessId:{0}.", message.ProcessId);

            Data.State = (int)UpdateOrganisationState.CpdsSummaryLoaded;
            var command = new GetUpdatedOrganisations()
            {
                ProcessId = Data.ProcessId,
                ProviderSummaryDatabus = message.ProviderSummaryDatabus
            };
            
            await context.Send(command);
        }

        public async Task Handle(ProcessUpdatedOrganisations message, IMessageHandlerContext context)
        {
            Logger.LogInformation(OrganisationDomainEventLoggingId.UpdateOrganisationSagaUpdatedOrgsMessageReceived, message.GetType() + " message received. ProcessId:{0}.", message.ProcessId);

            Data.State = (int)UpdateOrganisationState.OrgUpdatesProcessed;
            if (null == message.ChangedProviderUkprnList)
            {
                // no changes detected
                MarkAsComplete();
                return;
            }

            // populate Data.Organisations with list of updated organisations
            var sendTasks = message.ChangedProviderUkprnList.Select(provider =>
            {
                Data.OrganisationStatus.Add(provider.Ukprn, false);

                var command = new GetOrganisationDetails()
                {
                    ProcessId = Data.ProcessId,
                    Ukprn = provider.Ukprn,
                    Upin = provider.Upin
                };

                return context.Send(command);
            });

            await Task.WhenAll(sendTasks);
        }

        public async Task Handle(ProcessOrganisationDetails message, IMessageHandlerContext context)
        {
            Logger.LogInformation(OrganisationDomainEventLoggingId.UpdateOrganisationSagaProcessOrgsMessageReceived, message.GetType() + " message received. ProcessId:{0}.", message.ProcessId);

            // handle one provider at a time
            Data.State = (int)UpdateOrganisationState.OrgDetailsReceived;
            var command = new SaveUpdatedOrganisation
            {
                ProcessId = Data.ProcessId,
                ChangedProvider = message.ChangedProvider
            };

            await context.Send(command);
        }

        public async Task Handle(ProcessSavedOrganisation message, IMessageHandlerContext context)
        {
            Logger.LogInformation(OrganisationDomainEventLoggingId.UpdateOrganisationSagaProcessSavedOrgsMessageReceived, message.GetType() + " message received. ProcessId:{0}.", message.ProcessId);

            Data.State = (int)UpdateOrganisationState.OrgDetailsProcessed;

            // Fetch Organisation using UKPRN           
            int ukprn = int.Parse(message.ChangedOrganisation.organisationIdentifiers
                .Single(x => x.organisationIdentifierType == organisationIdentifierType.UKPROVIDERREFERENCENUMBER)
                .organisationIdentifier);

            // Update Organisation Processed state
            Data.OrganisationStatus[ukprn] = true;

            await context.Publish<OrganisationDetailsChanged>(
                x => { x.ChangedOrganisation = message.ChangedOrganisation; });

            Logger.LogInformation(OrganisationDomainEventLoggingId.UpdateOrganisationSagaProcessSavedOrgsMessageReceived, "The OrganisationDetailsChanged event was published.");

            if (Data.OrganisationStatus.All(x => x.Value))
            {
                MarkAsComplete();
            }
        }

        public Task Timeout(UpdateOrganisationTimeout state, IMessageHandlerContext context)
        {
            // Check Data.State 
            var message = $"Timeout occurred in UpdateOrganisationSaga. Id:{Data.Id}, ProcessId:{Data.ProcessId}, State:{Data.State}," +
                          $" Originator:{Data.Originator}, OriginalMessageId:{Data.OriginalMessageId}";

            Logger.LogInformation(OrganisationDomainEventLoggingId.UpdateOrganisationSagaTimeout, message);

            // Only log Organisations not processed
            Data.OrganisationStatus.Where(os => !os.Value).ToList().ForEach(o =>
            {
                var orgMessage = $"Organisation with UKPRN:{o.Key}, was not processed.";

                Logger.LogInformation(OrganisationDomainEventLoggingId.UpdateOrganisationSagaTimeout, orgMessage);
            });

            MarkAsComplete();

            return Task.CompletedTask;
        }

        protected override void ConfigureHowToFindSaga(SagaPropertyMapper<UpdateOrganisationSagaData> mapper)
        {
            mapper.ConfigureMapping<InitOrganisationUpdate>(msg => msg.ProcessId)
                .ToSaga(data => data.ProcessId);
            mapper.ConfigureMapping<ProcessProviderSummary>(msg => msg.ProcessId)
                .ToSaga(data => data.ProcessId);
            mapper.ConfigureMapping<ProcessUpdatedOrganisations>(msg => msg.ProcessId)
                .ToSaga(data => data.ProcessId);
            mapper.ConfigureMapping<ProcessOrganisationDetails>(msg => msg.ProcessId)
                .ToSaga(data => data.ProcessId);
            mapper.ConfigureMapping<ProcessSavedOrganisation>(msg => msg.ProcessId)
                .ToSaga(data => data.ProcessId);
        }
    }
}
