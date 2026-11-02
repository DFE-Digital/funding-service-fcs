namespace OrganisationDomain.Integration.MainEndpoint.Handlers
{
    using System.Collections.Generic;
    using System.Linq;
    using System.Threading.Tasks;
    using Common;
    using Entities;
    using Extensions;
    using Implementation.Services;
    using Messages.Commands;
    using NServiceBus;
    using SFA.FCT.Framework.Logging.Interfaces;

    public class UpdateSupplementaryBatchOfDataCommandHandler : IHandleMessages<UpdateSupplementaryBatchOfDataCommand>
    {
        private readonly ILogger _logger;
        private readonly IOrgSupplementaryChangeService _orgSupplementaryChangeService;

        public UpdateSupplementaryBatchOfDataCommandHandler(ILogger logger, IOrgSupplementaryChangeService orgSupplementaryChangeService)
        {
            _logger = logger;
            _orgSupplementaryChangeService = orgSupplementaryChangeService;
        }

        public async Task Handle(UpdateSupplementaryBatchOfDataCommand message, IMessageHandlerContext context)
        {
            _logger.LogInformation(OrganisationDomainEventLoggingId.UpdateSupplementaryBatchOfDataStart, "Started update Organisation supplementary batch of data process");

            List<OrgSupplementaryData> supplementaryDataBatch =
                message.OrgSupplementaryDataCollection
                    .Select(osd => new OrgSupplementaryData(osd.Ukprn, osd.CompanyNumber, osd.CharityNumber, osd.LegalAddress.ToDomainAddress()))
                    .ToList();

            var orgChangeDataList = _orgSupplementaryChangeService.ChangeOrgSupplementaryData(supplementaryDataBatch);

            foreach (var orgChangeData in orgChangeDataList)
            {
                await ProcessOrgChangedData(orgChangeData, context);
            }

            _logger.LogInformation(OrganisationDomainEventLoggingId.UpdateSupplementaryBatchOfDataEnd, "End update Organisation supplementary batch of data process");
        }

        private async Task ProcessOrgChangedData(OrgChangedData orgChangedData, IMessageHandlerContext context)
        {
            var orgSupplementaryData = orgChangedData.OrgSupplementaryData;

            await context.Send(new UpdateXrmOrganisationCommand
            {
                Ukprn = orgSupplementaryData.Ukprn.ToString(),
                CompanyNumber = orgSupplementaryData.CompanyNumber,
                CharityNumber = orgSupplementaryData.CharityNumber,
                Address = orgSupplementaryData.LegalAddress.ToDtoAddress()
            });

            var sendTasks = orgChangedData.NotificationMessages.Select(notificationMessage =>
            {
                var command = new CreateProviderUpdatedNotificationCommand
                {
                    Ukprn = orgSupplementaryData.Ukprn,
                    Notification = notificationMessage
                };

                return context.Send(command);
            });

            await Task.WhenAll(sendTasks);
        }
    }
}
