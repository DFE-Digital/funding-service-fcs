namespace OrganisationDomain.Integration.MainEndpoint.Handlers
{
    using System.Linq;
    using System.Threading.Tasks;
    using Common;
    using Entities;
    using Implementation.Services;
    using Messages.Commands;
    using Messages.Dtos;
    using NServiceBus;
    using SFA.FCT.Framework.Logging.Interfaces;

    public class PopulateSupplementaryDataForUkprnBatchCommandHandler : IHandleMessages<PopulateSupplementaryDataForUkprnBatchCommand>
    {
        private readonly IOrgSupplementaryPopulationService _orgSupplementaryPopulationService;
        private readonly ILogger _logger;

        public PopulateSupplementaryDataForUkprnBatchCommandHandler(ILogger logger, IOrgSupplementaryPopulationService orgSupplementaryPopulationService)
        {
            _logger = logger;
            _orgSupplementaryPopulationService = orgSupplementaryPopulationService;
        }

        public async Task Handle(PopulateSupplementaryDataForUkprnBatchCommand message, IMessageHandlerContext context)
        {
            _logger.LogInformation(OrganisationDomainEventLoggingId.PopulateSupplementaryDataForUkprnBatchStart,
                $"Started batch population of Organisation supplementary data for {message}");

            var orgSupplementaryDataList = await _orgSupplementaryPopulationService.PopulateOrgSupplementaryData(message.UkprnBatch.ToList());

            var sendTasks = orgSupplementaryDataList.Select(o => SendUpdateXrmOrganisationCommand(o, context));

            await Task.WhenAll(sendTasks);

            if (message.ShouldIssueCrmNotifications)
            {
                sendTasks = orgSupplementaryDataList.Select(o =>
                    SendCreateProviderUpdatedNotificationCommand(o, context));

                await Task.WhenAll(sendTasks);
            }

            _logger.LogInformation(OrganisationDomainEventLoggingId.PopulateSupplementaryDataForUkprnBatchComplete,
                $"Completed batch population of Organisation supplementary data for {message}");
        }

        private Task SendUpdateXrmOrganisationCommand(OrgSupplementaryDataExtended orgSupplementaryDataExtended, IMessageHandlerContext context)
        {
            return context.Send(new UpdateXrmOrganisationCommand
            {
                Ukprn = orgSupplementaryDataExtended.Ukprn.ToString(),
                CompanyNumber = orgSupplementaryDataExtended.CompanyNumber,
                CharityNumber = orgSupplementaryDataExtended.CharityNumber,
                Address = new OrgSupplementaryAddressDto
                {
                    Line1 = orgSupplementaryDataExtended.LegalAddress.Line1,
                    Line2 = orgSupplementaryDataExtended.LegalAddress.Line2,
                    Line3 = orgSupplementaryDataExtended.LegalAddress.Line3,
                    Line4 = orgSupplementaryDataExtended.LegalAddress.Line4,
                    Town = orgSupplementaryDataExtended.LegalAddress.Town,
                    County = orgSupplementaryDataExtended.LegalAddress.County,
                    Postcode = orgSupplementaryDataExtended.LegalAddress.Postcode
                }
            });
        }

        private async Task SendCreateProviderUpdatedNotificationCommand(OrgSupplementaryDataExtended orgSupplementaryDataExtended, IMessageHandlerContext context)
        {
            var sendTasks = OrgChangeDataComparer.GetNotificationMessages(orgSupplementaryDataExtended)
                .Select(notification =>
                    context.Send(new CreateProviderUpdatedNotificationCommand
                    {
                        Ukprn = orgSupplementaryDataExtended.Ukprn,
                        Notification = notification
                    }));

            await Task.WhenAll(sendTasks);
        }
    }
}
