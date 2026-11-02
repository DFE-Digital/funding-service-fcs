namespace SFA.FCT.DocumentsDomain.Integration.DocumentGenerationEndpoint.DocumentMoveEndpoint
{
    using CrossDomain.Integration.Messages.Messages;
    using AutoMapper;
    using Common.Exceptions;
    using CrossDomain.Integration.Common;
    using CrossDomain.Integration.Entities.CorporateContract;
    using CrossDomain.Integration.Messages.Commands;
    using DocumentGeneration;
    using Framework.Logging.Interfaces;
    using Framework.Logging.NullObjects;
    using NServiceBus;
    using System;
    using System.Linq;
    using System.Threading.Tasks;
    using Common.Commands;
    using LoggingEvents = Common.DocumentsDomainLoggingEventId;

    public class DocumentMoveHandler : IHandleMessages<DocumentMoveCommand>
    {
        private readonly IDocumentMover _docMover;

        public ILogger Logger { get; set; }

        public IDate Date { get; set; }

        public DocumentMoveHandler(IDocumentMover docMover)
        {
            _docMover = docMover;
            Logger = new LoggerNullObject();
            Date = new SystemDate();
        }        

        public async Task Handle(DocumentMoveCommand message, IMessageHandlerContext context)
        {
            ValidateCommand(message);

            var internalContract = Transform(message.CorporateContract, message.ContractNumberToBeMoved);

            bool isContractDocAlreadyPublished = _docMover.IsContractDocumentAlreadyPublished(internalContract);

            bool isMoveComplete = isContractDocAlreadyPublished || await MoveContract(message.CorporateContract, internalContract, context);

            await context.Reply(new DocumentMoveResponse
            {
                IsMoveComplete = isMoveComplete,
                ContractApprovalType = message.ContractApprovalType,
                ContractNumberMoved = message.ContractNumberToBeMoved,
                CorporateContract = message.CorporateContract
            }).ConfigureAwait(false);
            
            Logger.LogInformation(LoggingEvents.DocMoveEnd,
                $"DocumentsDomain handling DocumentMoveCommand message END, [Contract: {internalContract.contracts.First().contractNumber}]");
        }

        private async Task<bool> MoveContract(contract contractOnMessage, contract internalContract, IMessageHandlerContext context)
        {
            try
            {
                Logger.LogInformation(LoggingEvents.DocMoveStart,
                    $"DocumentsDomain handling DocumentMoveCommand message START, [Contract: {internalContract.contracts.First().contractNumber}]");

                 _docMover.MoveContractDocumentToPublishLocation(internalContract);
                return true;

            }
            catch (DocumentMoveException e)
            {
                Logger.LogError(LoggingEvents.DocMoveMoveError, e, $"Error occurred trying to move document to publish location. [Contract: {internalContract.contracts.First().contractNumber}]");

                await context.Send(new UpdateContractPublishedToProviderFailedCommand
                {
                    CorporateContract = contractOnMessage,
                    ReasonForFailure = e.Message
                }).ConfigureAwait(false);

                return false;
            }
        }

        private void ValidateCommand(DocumentMoveCommand message)
        {
            if (message.CorporateContract == null || !message.CorporateContract.contracts.Any())
            {
                var e = new ArgumentNullException($"{nameof(message.CorporateContract)}", $"DocumentsDomain handling {nameof(DocumentMoveCommand)} but it does not contain a corporate contract.");
                Logger.LogError(LoggingEvents.DocMoveBadContract, e, e.Message);
                throw e;
            }
            else if (message.CorporateContract.hierarchyType != hierarchyType.MASTERCONTRACT)
            {
                throw new InvalidOperationException("DocumentMoveHandler called with child corporate contract.");
            }

            if (string.IsNullOrEmpty(message.ContractNumberToBeMoved))
            {
                throw new ArgumentException("DocumentMoveCommand.ContractNumberToBeMoved must contain a value.");
            }

            if (message.CorporateContract.contracts
                .Single(c =>
                    c.contractNumber == message.ContractNumberToBeMoved
                    && c.hierarchyType == hierarchyType.CONTRACT) == null)
            {
                throw new InvalidOperationException("DocumentMergeCommand.ContractNumberToBeMerged must match a member of the contracts list with a hierarchy type of contract.");
            }
        }

        private static contract Transform(contract sourceContract, string childContractNumber)
        {
            // Use Automapper to clone the contract on the message
            Mapper.CreateMap<contract, contract>();
            var contract = Mapper.Map<contract, contract>(sourceContract);
            contract.contracts.RemoveAll(c => c.contractNumber != childContractNumber);
            return contract;
        }
    }
}