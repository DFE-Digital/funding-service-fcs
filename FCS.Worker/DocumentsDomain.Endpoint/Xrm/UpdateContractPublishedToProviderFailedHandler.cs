namespace DocumentsDomain.Endpoint.Xrm
{
    using System;
    using System.Linq;
    using System.Threading.Tasks;
    using NServiceBus;
    using Services;
    using SFA.FCT.CrossDomain.Integration.Entities.CorporateContract;
    using SFA.FCT.DocumentsDomain.Common;
    using SFA.FCT.DocumentsDomain.Common.Commands;
    using SFA.FCT.Framework.Logging.Interfaces;

    public class UpdateContractPublishedToProviderFailedHandler : IHandleMessages<UpdateContractPublishedToProviderFailedCommand>
    {
        private readonly ILogger _logger;
        private readonly IXrmDocumentManager _xrmDocumentManager;

        public UpdateContractPublishedToProviderFailedHandler(ILogger logger, IXrmDocumentManager xrmDocumentManager)
        {
            _logger = logger;
            _xrmDocumentManager = xrmDocumentManager;
        }

        public Task Handle(UpdateContractPublishedToProviderFailedCommand message, IMessageHandlerContext context)
        {
            contractType contract = message.CorporateContract?.contracts.FirstOrDefault();

            if (contract == null || string.IsNullOrEmpty(message.ReasonForFailure))
            {
                ArgumentNullException e = new ArgumentNullException($"{nameof(message.CorporateContract)}", $"DocumentsDomain handling UpdateContractPublishedToProviderFailedCommand but either the corporate contract or reason for failure are missing.");
                _logger.LogError(DocumentsDomainLoggingEventId.DocPublishToProviderFailureError, e, e.Message);
                throw e;
            }

            int ukprn = contract.contractor.ukprn;
            string contractNumber = contract.contractNumber;

            _logger.LogInformation(DocumentsDomainLoggingEventId.DocumentPublishToProviderFailureStart,
                $"DocumentsDomain 'Published To Provider' failure event START (UKPRN: [{ukprn}]/Contract Number: [{contractNumber}]Reason: [{message.ReasonForFailure}], version: {contract.contractVersionNumber}, sub version: {contract.contractSubVersionNumber})");

            _xrmDocumentManager.UpdateContractPublishedToProviderFailed(contract, message.ReasonForFailure);

            _logger.LogInformation(DocumentsDomainLoggingEventId.DocumentPublishToProviderFailureEnd,
                $"DocumentsDomain 'Published To Provider' failure event END (UKPRN: [{ukprn}]/Contract Number: [{contractNumber}])");

            return Task.CompletedTask;
        }
    }
}
