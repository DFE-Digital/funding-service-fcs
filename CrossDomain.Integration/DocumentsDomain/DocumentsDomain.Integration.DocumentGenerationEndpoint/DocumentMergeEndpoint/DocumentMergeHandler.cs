
namespace SFA.FCT.DocumentsDomain.Integration.DocumentGenerationEndpoint.DocumentMergeEndpoint
{
    using AutoMapper;
    using Common;
    using Common.Commands;
    using Common.Exceptions;
    using CrossDomain.Integration.Entities.CorporateContract;
    using CrossDomain.Integration.Entities.Documents;
    using CrossDomain.Integration.Messages.Commands;
    using DocumentGeneration.ContractDocumentMerger;
   // using Framework.Logging.Interfaces;
    using NServiceBus;
    using System;
    using System.Linq;
    using System.Threading.Tasks;
    using Microsoft.Extensions.Logging; // for ILoggerFactory (if needed)

    public class DocumentMergeHandler : IHandleMessages<DocumentMergeCommand>
    {
        private readonly ILogger _logger;
        private readonly IContractDocumentManager _contractDocumentMerger;

        // ---------------------------------------------------------------------
        // STATIC MAPPER FOR YOUR CUSTOM AUTOMAPPER VERSION
        // ---------------------------------------------------------------------
        private static readonly IMapper _mapper = CreateMapper();

        private static IMapper CreateMapper()
        {
            // Build the AutoMapper config expression
            var cfg = new MapperConfigurationExpression();
            cfg.CreateMap<Contract, Contract>();   // your cloning map

            // Your version of AutoMapper requires ILoggerFactory
            // If you do not have one, passing null is permitted.
            ILoggerFactory loggerFactory = null;

            // Use your custom 2‑arg constructor:
            var config = new MapperConfiguration(cfg, loggerFactory);

            // Now create the mapper
            return new Mapper(config);
        }

        public DocumentMergeHandler(IContractDocumentManager contractDocumentMerger, ILogger logger)
        {
            _contractDocumentMerger = contractDocumentMerger;
            _logger = logger;
        }

        public async Task Handle(DocumentMergeCommand message, IMessageHandlerContext context)
        {
            _logger.LogInformation(
                DocumentsDomainLoggingEventId.DocumentMergeStart,
                $"DocumentsDomain handling {nameof(DocumentMergeCommand)} message START, Contract: {message.CorporateContract.contractNumber}");

            var mergeStatus = new MergeStatus
            {
                IsMergeSuccessful = true,
                ReasonForFailure = string.Empty
            };

            try
            {
                ValidateCommand(message);

                // ✔ Uses your updated Transform
                var internalContract =
                    Transform(message.CorporateContract, message.ContractNumberToBeMerged);

                _contractDocumentMerger.MergeContractDocuments(internalContract);
            }
            catch (Exception ex)
            {
                _logger.LogError(
                    DocumentsDomainLoggingEventId.ContractDocumentMergeError,
                    ex,
                    $"Error merging documents for contract '{message.CorporateContract.contractNumber}'");

                if (ex is DocumentMergeException)
                {
                    mergeStatus = new MergeStatus
                    {
                        IsMergeSuccessful = false,
                        ReasonForFailure = ex.Message
                    };
                }
                else
                {
                    throw;
                }
            }

            _logger.LogInformation(
                DocumentsDomainLoggingEventId.ContractDocumentMergeUpdateCrmStatus,
                $"Sending {nameof(UpdateDocumentMergeStatusCommand)} message to XRM Service, Contract: {message.CorporateContract.contractNumber}, IsMergeSuccessful: {mergeStatus.IsMergeSuccessful}, Reason For Failure: {mergeStatus.ReasonForFailure}");

            await context.Send(new UpdateDocumentMergeStatusCommand
            {
                CorporateContract = message.CorporateContract,
                MergeStatus = mergeStatus
            }).ConfigureAwait(false);

            _logger.LogInformation(
                DocumentsDomainLoggingEventId.DocumentMergeEnd,
                $"DocumentsDomain handling {nameof(DocumentMergeCommand)} message END");
        }

        // -----------------------------------------------------
        // TRANSFORM METHOD — NAME AND SIGNATURE KEPT AS-IS
        // -----------------------------------------------------
        private static Contract Transform(Contract sourceContract, string childContractNumber)
        {
            var contractClone = _mapper.Map<Contract>(sourceContract);

            contractClone.contracts.RemoveAll(c =>
                c.contractNumber != childContractNumber);

            return contractClone;
        }

        private static void ValidateCommand(DocumentMergeCommand message)
        {
            if (message.CorporateContract.hierarchyType != hierarchyType.MASTERCONTRACT)
            {
                throw new InvalidOperationException(
                    "DocumentMergeHandler called with child corporate contract.");
            }

            if (string.IsNullOrEmpty(message.ContractNumberToBeMerged))
            {
                throw new ArgumentException(
                    "DocumentMergeCommand.ContractNumberToBeMerged must contain a value.");
            }

            if (message.CorporateContract.contracts
                .Single(c =>
                    c.contractNumber == message.ContractNumberToBeMerged &&
                    c.hierarchyType == hierarchyType.CONTRACT) == null)
            {
                throw new InvalidOperationException(
                    "DocumentMergeCommand.ContractNumberToBeMerged must match a member of the contracts list with a hierarchy type of contract.");
            }
        }
    }
}
