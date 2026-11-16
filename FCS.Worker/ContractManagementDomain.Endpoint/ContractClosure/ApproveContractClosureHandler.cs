namespace ContractManagementDomain.Endpoint.ContractClosure
{
    using System;
    using System.Linq;
    using System.Threading.Tasks;
    using ContractManagement.DataStore.Model;
    using ContractManagement.DataStore.Repositories;
    using ContractManagement.DataStore.Services;
    using Infrastructure;
    using MoreLinq;
    using NServiceBus;
    using Repositories;
    using Services;
    using SFA.FCT.ContractCreateDomain.Implementation.Persistence;
    using SFA.FCT.ContractManagementService.Common;
    using SFA.FCT.ContractManagementService.Common.Commands;
    using SFA.FCT.CrossDomain.Integration.Entities.CorporateContract;
    using SFA.FCT.CrossDomain.Integration.Entities.Data;
    using SFA.FCT.CrossDomain.Integration.Entities.Xrm.OptionSets;
    using SFA.FCT.CrossDomain.Integration.Events;
    using SFA.FCT.CrossDomain.Integration.Messages.Commands;
    using SFA.FCT.CrossDomain.Integration.OverrideDate.DataStore.Services;
    using SFA.FCT.Framework.Logging.Interfaces;

    public class ApproveContractClosureHandler : IHandleMessages<ApproveContractClosureCommand>
    {
        private readonly ILogger _logger;
        private readonly ISessionConnectionFactory _sessionConnectionFactory;
        private readonly IApprovedContractRepository _approvedContractRepository;
        private readonly IApprovedContractAllocationRepository _approvedContractAllocationRepository;
        private readonly IValidationService _validationService;
        private readonly IDateProvider _dateProvider;
        private readonly ICrmContractRepository _crmContractRepository;
        private readonly IContractsManager _contractsManager;
        private readonly IApprovalOnwardsContractAtomFeedService _approvalOnwardsContractAtomFeedItemCreator;
        private readonly ILegalDeliverableService _legalDeliverableService;

        public ApproveContractClosureHandler(
            ILogger logger,
            ISessionConnectionFactory sessionConnectionFactory,
            IApprovedContractRepository approvedContractRepository,
            IApprovedContractAllocationRepository approvedContractAllocationRepository,
            IValidationService validationService,
            IDateProvider dateProvider,
            ICrmContractRepository crmContractRepository,
            IContractsManager contractsManager,
            IApprovalOnwardsContractAtomFeedService approvalOnwardsContractAtomFeedItemCreator,
            ILegalDeliverableService legalDeliverableService)
        {
            _logger = logger;
            _sessionConnectionFactory = sessionConnectionFactory;
            _approvedContractRepository = approvedContractRepository;
            _approvedContractAllocationRepository = approvedContractAllocationRepository;
            _validationService = validationService;
            _dateProvider = dateProvider;
            _crmContractRepository = crmContractRepository;
            _contractsManager = contractsManager;
            _approvalOnwardsContractAtomFeedItemCreator = approvalOnwardsContractAtomFeedItemCreator;
            _legalDeliverableService = legalDeliverableService;
        }

        public async Task Handle(ApproveContractClosureCommand message, IMessageHandlerContext context)
        {
            _logger.LogInformation(ContractManagementLoggingEvents.ApproveContractClosureCommandReceived, $"ApproveContractClosureCommand handler started - {message}");

            ConnectionInfo connectionInfo = _sessionConnectionFactory.GetConnection(context);

            string firstFailureMessage = _validationService.GetFirstFailureMessageForApproveContractClosure(
                new ContractIdentifier(message.ContractNumber, message.VersionNumber, message.SubVersionNumber),
                connectionInfo);

            if (firstFailureMessage != null)
            {
                _crmContractRepository.UpdateServiceResponseOnContract(message.ContractNumber, message.VersionNumber, message.SubVersionNumber, sfa_serviceresponse.ContractClosureFailed);

                IssueCrmNotificationCommand issueCrmNotificationCommand = new IssueCrmNotificationCommand
                {
                    ContractNumber = message.ContractNumber,
                    VersionNumber = message.VersionNumber,
                    SubVersionNumber = message.SubVersionNumber,
                    NotificationText = firstFailureMessage,
                    NotificationType = NotificationType.ApproveContractClosureFailed
                };

                await context.Send(issueCrmNotificationCommand)
                    .ConfigureAwait(false);
            }
            else
            {
                string masterContractNumber = _crmContractRepository.GetMasterContractNumber(message.ContractNumber, message.VersionNumber, message.SubVersionNumber);

                Contract corporateContract = _contractsManager.GetCorporateContractForSpecificVersion(message.ContractNumber, message.VersionNumber, message.SubVersionNumber);

                DateTime closureDate = _dateProvider.GetDate(connectionInfo);

                SetContractStatuses(corporateContract);
                SetEmptyContractEndDates(corporateContract, closureDate);

                _legalDeliverableService.RemoveNonLegalDeliverablesFromContract(connectionInfo, corporateContract);

                AtomItemCreationResult result = _approvalOnwardsContractAtomFeedItemCreator.AddClosedContract(corporateContract, new Guid(context.MessageId), connectionInfo);

                if (result == AtomItemCreationResult.Added || result == AtomItemCreationResult.AlreadyPresentWithSameFeedItemId)
                {
                    FundingTypeFundingPeriod fundingTypeFundingPeriod = _approvedContractRepository.GetFundingTypeFundingPeriodForContract(
                        message.ContractNumber,
                        message.VersionNumber,
                        message.SubVersionNumber,
                        connectionInfo);

                    ContractClosedEvent contractClosedEvent = new ContractClosedEvent
                    {
                        ContractNumber = message.ContractNumber,
                        VersionNumber = message.VersionNumber,
                        SubVersionNumber = message.SubVersionNumber,
                        IsContractOpenEnded = fundingTypeFundingPeriod.AreContractsOpenEnded,
                        ClosureDate = closureDate,
                        AllocationNumbers = _approvedContractAllocationRepository.GetAllocationNumbersForApprovedContract(
                            message.ContractNumber,
                            message.VersionNumber,
                            message.SubVersionNumber,
                            connectionInfo).ToList()
                    };

                    await context.Publish(contractClosedEvent)
                        .ConfigureAwait(false);

                    _logger.LogInformation(ContractManagementLoggingEvents.PublishContractClosedEventSuccessful, $"ContractClosedEvent published for - {message}");
                }
                else
                {
                    _logger.LogInformation(ContractManagementLoggingEvents.PublishContractClosedEventFailed, $"ContractClosedEvent not published as contract already exists on the atom feed for {message}");
                }
            }

            _logger.LogInformation(ContractManagementLoggingEvents.ApproveContractClosureCommandCompleted, $"ApproveContractClosureCommand handler completed - {message}");
        }

        private static void SetContractStatuses(Contract corporateMasterContract)
        {
            corporateMasterContract.contracts.ForEach(c =>
            {
                c.contractStatus.parentStatus = "Closed"; // parent status is actually the status of the contract
                c.contractStatus.status = GetSubStatus(c);
            });
        }
        
        private static void SetEmptyContractEndDates(Contract corporateMasterContract, DateTime closureDate)
        {
            corporateMasterContract.contracts
                .Where(c => !c.endDate.HasValue)
                .ForEach(c => c.endDate = closureDate);

            corporateMasterContract.contracts
                .SelectMany(c => c.contractAllocations)
                .Where(a => !a.endDate.HasValue)
                .ForEach(a => a.endDate = closureDate);
        }

        private static bool IsContractUnderTermination(contractType contract)
        {
            return !string.IsNullOrEmpty(contract.TerminationReason);
        }

        private static string GetSubStatus(contractType contract)
        {
            if (IsContractUnderTermination(contract))
            {
                return "Under Termination";
            }

            return contract.IsModified ? "Modified" : "Closed";
        }
    }
}
