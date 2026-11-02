namespace DocumentsDomain.Endpoint.Xrm
{
    using System;
    using System.Linq;
    using System.Threading.Tasks;
    using NServiceBus;
    using Services;
    using SFA.FCT.DocumentsDomain.Common;
    using SFA.FCT.DocumentsDomain.Common.Commands;
    using SFA.FCT.Framework.Logging.Interfaces;

    public class UpdateDocumentMergeStatusHandler : IHandleMessages<UpdateDocumentMergeStatusCommand>
    {
        private readonly ILogger _logger;
        private readonly IXrmDocumentManager _xrmDocumentManager;

        public UpdateDocumentMergeStatusHandler(ILogger logger, IXrmDocumentManager xrmDocumentManager)
        {
            _logger = logger;
            _xrmDocumentManager = xrmDocumentManager;
        }

        public async Task Handle(UpdateDocumentMergeStatusCommand message, IMessageHandlerContext context)
        {
            var contract = message.CorporateContract.contracts.First();

            var ukprn = contract.contractor.ukprn;
            var contractNumber = contract.contractNumber;

            _logger.LogInformation(DocumentsDomainLoggingEventId.UpdateDocumentMergeStatusHandlerMsgReceived, $"{nameof(UpdateDocumentMergeStatusCommand)} was received by the Document specific Xrm Service (UKPRN: [{ukprn}]/Contract Number: [{contractNumber}])");

            try
            {
                _xrmDocumentManager.UpdateContractWithDocumentMergeStatus(contract, message.MergeStatus);

                _logger.LogInformation(DocumentsDomainLoggingEventId.UpdateDocumentMergeStatusHandlerUpdateSuccessful, $"CRM updated the contract (UKPRN: [{ukprn}]/Contract Number: [{contractNumber}]) with the Merge Status.");

                if (message.MergeStatus.IsMergeSuccessful)
                {
                    await context.Send(new GetDocumentsForDeleteCommand
                    {
                        Contract = contract
                    });

                    _logger.LogInformation(DocumentsDomainLoggingEventId.UpdateDocumentMergeStatusHandlerReplying, $"Sending {nameof(GetDocumentsForDeleteCommand)} because the Merge for (UKPRN: [{ukprn}]/Contract Number: [{contractNumber}]) was successful.");
                }
            }
            catch (Exception exception)
            {
                _logger.LogError(DocumentsDomainLoggingEventId.UpdateDocumentMergeStatusHandlerUpdateFailed, $"The update to CRM with Merge Status for (UKPRN: [{ukprn}]/Contract Number: [{contractNumber}]) was unsuccessful.", exception);
                throw;
            }
        }
    }
}
