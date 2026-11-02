namespace ContractCreateDomain.IncrementContractVersionEndpoint.Handlers
{
    using NServiceBus;
    using SFA.FCT.ContractManagementService.Common.Commands;
    using SFA.FCT.Framework.Logging.Interfaces;
    using System.Threading.Tasks;
    using SFA.FCT.ContractCreateDomain.BusinessLogic;
    using SFA.FCT.CrossDomain.Integration.Entities.CorporateContract;
    using Services;
    using System.Linq;
    using SFA.FCT.ContractManagementService.Common;
    using SFA.FCT.CrossDomain.Integration.Messages.Commands;
    using System;
    using System.Collections.Generic;
    using Infrastructure;
    using Repositories;
    using SFA.FCT.CrossDomain.Integration.Entities.Data;

    public class IncrementContractVersionHandler : IHandleMessages<IncrementContractVersionCommand>
    {
        private readonly ILogger _logger;
        private readonly IContractVersionIncrementService _contractVersionIncrementService;
        private readonly IContractRequestTransformer _contractRequestTransformer;
        private readonly IContractStorage _contractStorage;
        private readonly ISiblingApprovedContractService _siblingApprovedContractService;
        private readonly ILevyContractAllocationService _levyContractAllocationService;
        private readonly ISessionConnectionFactory _sessionConnectionFactory;
        private readonly ICreatedContractRepository _createdContractRepository;
        private readonly IApprovedContractRepository _approvedContractRepository;
        private readonly ICrmContractRepository _crmContractRepository;

        public IncrementContractVersionHandler(
            ILogger logger,
            IContractVersionIncrementService contractVersionIncrementService,
            IContractRequestTransformer contractRequestTransformer,
            IContractStorage contractStorage,
            ISiblingApprovedContractService siblingApprovedContractService,
            ILevyContractAllocationService levyContractAllocationService,
            ISessionConnectionFactory sessionConnectionFactory, 
            ICreatedContractRepository createdContractRepository,
            IApprovedContractRepository approvedContractRepository, ICrmContractRepository crmContractRepository)
        {
            _logger = logger;
            _contractVersionIncrementService = contractVersionIncrementService;
            _contractRequestTransformer = contractRequestTransformer;
            _contractStorage = contractStorage;
            _siblingApprovedContractService = siblingApprovedContractService;
            _levyContractAllocationService = levyContractAllocationService;
            _sessionConnectionFactory = sessionConnectionFactory;
            _createdContractRepository = createdContractRepository;
            _approvedContractRepository = approvedContractRepository;
            _crmContractRepository = crmContractRepository;
        }

        public async Task Handle(IncrementContractVersionCommand message, IMessageHandlerContext context)
        {
            _logger.LogInformation(ContractCreateDomainEventLoggingId.IncrementContractVersionHandlerStarted, $"IncrementContractVersionCommand arrived - {message}");

            ConnectionInfo connectionInfo = _sessionConnectionFactory.GetConnection(context);

            ExtendedContractType masterContract = _contractVersionIncrementService.CreateAmendedContractVersionIfNotAlreadyCreated(
                new ContractIdentifier(
                    contractNumber: message.ContractNumber,
                    versionNumber: message.VersionNumber,
                    subVersionNumber: message.SubVersionNumber),
                message.AmendmentType, message.IsNonFinancialAmendment);

            if (masterContract != null)
            {
                masterContract.contracts.ForEach(c =>
                {
                    c.IsNonFinancialAmendment = message.IsNonFinancialAmendment;
                    c.CopyTerminationDetailsToProvisionalFields();
                });
                
                ExtendedContractType childContract = masterContract.contracts.First();
                
                if (message.ShouldAddPayableNonLevyAllocation)
                {
                    await _levyContractAllocationService.AddPayableNonLevyContractAllocationIfNotPresent(childContract, connectionInfo)
                        .ConfigureAwait(continueOnCapturedContext: false);
                }

                StoreContract(masterContract);

                contract corpContract = _contractRequestTransformer.TransformToCorpContract(childContract);

                List<ApprovedContractInfo> siblingApprovedContractsForDocumentGeneration = await 
                     _siblingApprovedContractService.GetSiblingApprovedContractsForDocumentGeneration(
                        masterContractNumber: masterContract.contractNumber,
                        currentContractNumber: childContract.contractNumber,
                        fundingTypeCode: corpContract.fundingType.fundingTypeCode,
                        fundingPeriod: corpContract.GetFundingPeriod(),
                        connectionInfo).ConfigureAwait(continueOnCapturedContext: false);

                corpContract.SharedMasterApprovedContracts = siblingApprovedContractsForDocumentGeneration;
                corpContract.SharedMasterApprovedContracts.ForEach(RelatedAllocationEnricher.EnrichWithRelatedAllocationsWhenAppropriate);

                await RelatedAllocationEnricher.EnrichWithRelatedAllocationsWhenAppropriate(corpContract, _logger, _approvedContractRepository, connectionInfo);

                corpContract.IsAmendment = true;
                corpContract.IsNewRevisedNewOrUpdateDraft = false;
                corpContract.OverrideAmendmentTemplate = message.OverrideAmendmentTemplate;
                corpContract.OverrideTemplateName = message.OverrideTemplateName;

                var mostRecentCreatedDateOption = await _createdContractRepository.GetLatestCreatedDateForNonNotificationApprovedContract(corpContract.contractNumber, connectionInfo);

                mostRecentCreatedDateOption.MatchSome(mostRecentCreatedDate =>
                    {
                        corpContract.LatestCreatedDateForNonNotificationApprovedContract = mostRecentCreatedDate;
                    });
                corpContract.IsVariation = message.AmendmentType == AmendmentType.Variation;
                corpContract.ShouldMergeAmendmentTemplate = message.ShouldMergeAmendmentTemplate;
                var optionLastApprovedInfo = _crmContractRepository.GetLastApprovedContractSubStatusAndTerminationDate(message.ContractNumber);
                optionLastApprovedInfo.Match(Some:lastApproved =>
                {
                    corpContract.IsLastApprovedUnderTermination = lastApproved.subStatus == "Under Termination";
                    corpContract.LastApprovedTerminationDate = lastApproved.terminationDate;
                }, None: () => { });

                await SendDocumentGenerationCommand(corpContract: corpContract, masterContractNumber: masterContract.contractNumber, context: context);

                _logger.LogInformation(ContractCreateDomainEventLoggingId.IncrementContractVersionHandlerComplete,
                   $"IncrementContractVersionCommand handled and SendDocumentGenerationCommand sent - {message}");
            }
            else
            {
                _logger.LogInformation(ContractCreateDomainEventLoggingId.ContractHasAlreadyBeenAmended,
                   $"IncrementContractVersionCommand handled - {message} has already been amended");
            }
        }

        private void StoreContract(ExtendedContractType contract)
        {
            ExtendedContractType childContract = contract.contracts.First();

            string storageKey = _contractStorage.GetKey(childContract.contractNumber,
                childContract.contractVersionNumber);

            _contractStorage.UploadContract(storageKey, contract);
        }

        private async Task SendDocumentGenerationCommand(contract corpContract, string masterContractNumber, IMessageHandlerContext context)
        {
            var message = new DocumentGenerationCommand
            {
                CorrelationId = Guid.NewGuid().ToString(),
                CorporateContract = corpContract,
                MasterContractNumber = masterContractNumber
            };

            SendOptions sendOptions = new SendOptions();
            sendOptions.RouteReplyTo("ContractCreateDomain.IncrementContractVersion");

            await context.Send(message, sendOptions).ConfigureAwait(false);
        }
    }
}