namespace DocumentsDomain.Endpoint.Xrm
{
    using System.Linq;
    using System.Threading.Tasks;
    using NServiceBus;
    using Services;
    using SFA.FCT.CrossDomain.Integration.Entities.ContractApproval;
    using SFA.FCT.CrossDomain.Integration.Entities.CorporateContract;
    using SFA.FCT.CrossDomain.Integration.Events;
    using SFA.FCT.DocumentsDomain.Common;
    using SFA.FCT.Framework.Logging.Interfaces;

    public class ContractReadyToPublishHandler : IHandleMessages<ContractReadyToPublishEvent>
    {
        private readonly ILogger _logger;
        private readonly IXrmDocumentManager _xrmDocumentManager;

        public ContractReadyToPublishHandler(ILogger logger, IXrmDocumentManager xrmDocumentManager)
        {
            _logger = logger;
            _xrmDocumentManager = xrmDocumentManager;
        }

        public async Task Handle(ContractReadyToPublishEvent message, IMessageHandlerContext context)
        {
            contractType contract = message.CorporateContract.contracts.First();

            int ukprn = contract.contractor.ukprn;
            string contractNumber = contract.contractNumber;

            _logger.LogInformation(DocumentsDomainLoggingEventId.DocumentUpdateStatusToPublishToProviderStart, $"DocumentsDomain updating document status to 'Published To Provider' START (UKPRN: [{ukprn}]/Contract Number: [{contractNumber}])");

            if (contract.amendmentType == SFA.FCT.CrossDomain.Integration.Entities.ContractRequest.amendmentType.Notification.ToString())
            {
                _xrmDocumentManager.UpdateContractPublishedToProviderForAutoApproval(contract);

                await context.Publish(new ContractNotificationPublishedToProviderEvent
                {
                    CorporateContract = message.CorporateContract
                });
            }
            else if (message.ContractApprovalType == ContractApprovalType.Electronic)
            {
                _xrmDocumentManager.UpdateContractPublishedToProviderForElectronicApproval(contract);
            }
            else
            {
                _xrmDocumentManager.UpdateContractPublishedToProviderManualApproval(contract);
            }

            _logger.LogInformation(DocumentsDomainLoggingEventId.DocumentUpdateStatusToPublishToProviderEnd, $"DocumentsDomain updating document status to 'Published To Provider' END (UKPRN: [{ukprn}]/Contract Number: [{contractNumber}])");
        }
    }
}
