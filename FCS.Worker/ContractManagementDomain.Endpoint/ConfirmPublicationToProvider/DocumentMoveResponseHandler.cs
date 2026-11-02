namespace ContractManagementDomain.Endpoint.ConfirmPublicationToProvider
{
    using System;
    using System.Linq;
    using System.Threading.Tasks;
    using Infrastructure;
    using NServiceBus;
    using SFA.FCT.ContractManagementService.Common;
    using SFA.FCT.CrossDomain.Integration.Entities.ContractApproval;
    using SFA.FCT.CrossDomain.Integration.Entities.CorporateSchema.Contract;
    using SFA.FCT.CrossDomain.Integration.Entities.Data;
    using SFA.FCT.CrossDomain.Integration.Events;
    using SFA.FCT.CrossDomain.Integration.Messages.Messages;
    using SFA.FCT.CrossDomain.Integration.OverrideDate.DataStore.Services;
    using SFA.FCT.Framework.Logging.Interfaces;
    using contract = SFA.FCT.CrossDomain.Integration.Entities.CorporateContract.contract;
    using contractType = SFA.FCT.CrossDomain.Integration.Entities.CorporateContract.contractType;

    public class DocumentMoveResponseHandler : IHandleMessages<DocumentMoveResponse>
    {
        private readonly ILogger _logger;
        private readonly ISessionConnectionFactory _sessionConnectionFactory;
        private readonly IDateProvider _dateProvider;

        public DocumentMoveResponseHandler(ILogger logger, ISessionConnectionFactory sessionConnectionFactory, IDateProvider dateProvider)
        {
            _logger = logger;
            _sessionConnectionFactory = sessionConnectionFactory;
            _dateProvider = dateProvider;
        }

        public async Task Handle(DocumentMoveResponse message, IMessageHandlerContext context)
        {
            _logger.LogInformation(
                ContractManagementLoggingEvents.DocumentMoveResponseReceived,
                $"{nameof(DocumentMoveResponse)} received for MasterContractNumber:{message.CorporateContract.contractNumber} ContractNumber:{message.ContractNumberMoved}");

            if (message.IsMoveComplete)
            {
                contractType childContract = GetChildContract(message.CorporateContract, message.ContractNumberMoved);

                ConnectionInfo connectionInfo = _sessionConnectionFactory.GetConnection(context);

                UpdateContractStatus(childContract, connectionInfo);

                await PublishContractReadyToPublishEvent(message.CorporateContract, message.ContractApprovalType, context)
                    .ConfigureAwait(false);
            }
        }

        private async Task PublishContractReadyToPublishEvent(contract masterContract, ContractApprovalType approvalType, IMessageHandlerContext context)
        {
            await context.Publish(new ContractReadyToPublishEvent
            {
                CorporateContract = masterContract,
                ContractApprovalType = approvalType
            }).ConfigureAwait(false);

            _logger.LogInformation(
                ContractManagementLoggingEvents.PublishContractReadyToPublishEventPublished,
                $"ContractReadyToPublishEvent published for MasterContractNumber:{masterContract.contractNumber}");

        }

        private void UpdateContractStatus(contractType childContract, ConnectionInfo connectionInfo)
        {
            // Get Now DateTime, real or override
            DateTime publishedDate = _dateProvider.GetDate(connectionInfo);

            // Note: Using the type of the v10 corporate schema
            string status = contractStatusTypeStatus
                .PublishedToProvider.ToString();

            // Update Corporate Contract with Published info
            childContract.StatusLastUpdatedDate = publishedDate;
            childContract.contractStatus.status = status;
        }

        private static contractType GetChildContract(contract masterContract, string contractNumber)
        {
            return masterContract.contracts.SingleOrDefault(c => c.contractNumber == contractNumber);
        }
    }
}
