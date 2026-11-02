namespace OrganisationDomain.Integration.CpdsEndpoint
{
    using System;
    using System.Collections.Generic;
    using System.Xml;
    using Entities;
    using Implementation.BusinessLogic;
    using Messages.Commands;
    using NServiceBus;
    using Implementation.Converters;
    using SFA.FCT.Framework.Logging.Interfaces;
    using Common;
    using System.Threading.Tasks;

    public class GetProviderSummaryHandler : IHandleMessages<GetProviderSummary>
    {
        private readonly ILogger _logger;
        private readonly ICpdsSummaryRetriever _cpdsSummaryRetriever;
        private readonly ICpdsProviderConverter _cpdsProviderConverter;

        public GetProviderSummaryHandler(ILogger logger, ICpdsSummaryRetriever cpdsSummaryRetriever, ICpdsProviderConverter cpdsProviderConverter)
        {
            _logger = logger;
            _cpdsSummaryRetriever = cpdsSummaryRetriever;
            _cpdsProviderConverter = cpdsProviderConverter;
        }

        public async Task Handle(GetProviderSummary message, IMessageHandlerContext context)
        {
            _logger.LogInformation(OrganisationDomainEventLoggingId.GetProviderSummaryHandler, message.GetType() + " message received. ProcessId:{0}.", message.ProcessId);

            List<ProviderSequence> summary;
            try
            {
                summary = _cpdsSummaryRetriever.RetrieveSummary();
            }
            catch (Exception e)
            {
                if (e is XmlException
                    || e is NullReferenceException
                    || e is ArgumentNullException
                    || e is FormatException
                    || e is OverflowException)
                {
                    _logger.LogError(OrganisationDomainEventLoggingId.GetProviderSummaryError, "Error trying to process CPDS response {0}.", e.ToString());
                }

                throw;
            }

            var summaryBlob = _cpdsProviderConverter.ConvertProviderSequenceListToBlob(summary);
            var command = new ProcessProviderSummary
            {
                ProcessId = message.ProcessId,
                ProviderSummaryDatabus = summaryBlob
            };

            await context.Send(command).ConfigureAwait(false);
        }
    }
}
