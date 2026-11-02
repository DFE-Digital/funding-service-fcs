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
    using Messages.Dtos;
    using NServiceBus;
    using SFA.FCT.Framework.Logging.Interfaces;

    public class UpdateSupplementaryDataChangesCommandHandler : IHandleMessages<UpdateSupplementaryDataChangesCommand>
    {
        private readonly ILogger _logger;
        private readonly IOrgSupplementaryDataService _orgSupplementaryDataService;

        public UpdateSupplementaryDataChangesCommandHandler(ILogger logger, IOrgSupplementaryDataService orgSupplementaryDataService)
        {
            _logger = logger;
            _orgSupplementaryDataService = orgSupplementaryDataService;
        }

        public async Task Handle(UpdateSupplementaryDataChangesCommand message, IMessageHandlerContext context)
        {
            const int batchSize = 200;
            const int lastSevenDays = -7;
            _logger.LogInformation(OrganisationDomainEventLoggingId.UpdateSupplementaryOrgDataChangesStart, $"Started update Organisation supplementary data process with this implemententation: {_orgSupplementaryDataService}");

            IReadOnlyCollection<OrgSupplementaryData> supplementaryDataChanges = await _orgSupplementaryDataService.GetSupplementaryDataChanges(numberOfDaysToCheck: lastSevenDays);

            _logger.LogInformation(OrganisationDomainEventLoggingId.UpdateSupplementaryOrgDataChangesRetrievedChanges,
                $"Update Organisation supplementary data process retrieved {supplementaryDataChanges.Count} changes from UKRLP");

            List<OrgSupplementaryDataDto> supplementaryDataDtos = supplementaryDataChanges.Select(sdc =>
                new OrgSupplementaryDataDto
                {
                    Ukprn = sdc.Ukprn,
                    CompanyNumber = sdc.CompanyNumber,
                    CharityNumber = sdc.CharityNumber,
                    LegalAddress = sdc.LegalAddress.ToDtoAddress()
                }).ToList();

            var commands = supplementaryDataDtos.Batch(batchSize)
                .Select(batch => new UpdateSupplementaryBatchOfDataCommand { OrgSupplementaryDataCollection = batch.ToList() });

            var sendTasks = commands.Select(context.Send);

            await Task.WhenAll(sendTasks);

            _logger.LogInformation(OrganisationDomainEventLoggingId.UpdateSupplementaryOrgDataChangesComplete, "Completed update Organisation supplementary data process");
        }
    }
}
