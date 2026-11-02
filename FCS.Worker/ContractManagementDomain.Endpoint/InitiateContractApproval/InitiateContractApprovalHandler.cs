namespace ContractManagementDomain.Endpoint.InitiateContractApproval
{
    using System.Linq;
    using System.Threading.Tasks;
    using ContractManagement.DataStore.Repositories;
    using Endpoint.Repositories;
    using Endpoint.Services;
    using Infrastructure;
    using MoreLinq;
    using NServiceBus;
    using Repositories;
    using Services;
    using SFA.FCT.ContractCreateDomain.Implementation.Persistence;
    using SFA.FCT.ContractManagementService.Common;
    using SFA.FCT.ContractManagementService.Common.Commands;
    using SFA.FCT.CrossDomain.Integration.Entities.Data;
    using SFA.FCT.CrossDomain.Integration.OverrideDate.DataStore.Services;
    using SFA.FCT.Framework.Logging.Interfaces;
    using Dtos;

    public class InitiateContractApprovalHandler : InitiateContractApprovalBase, IHandleMessages<InitiateContractApprovalCommand>
    {
        private const string NonLevyFsp = "NONLEVY2019";

        private readonly ILogger _logger;
        private readonly ISessionConnectionFactory _sessionConnectionFactory;
        private readonly IContractCheckerService _contractCheckerService;
        private readonly IDateProvider _dateProvider;
        private readonly ICrmContractDeliverablePeriodRepository _crmContractDeliverablePeriodRepository;
        private readonly ICrmContractRepository _crmContractRepository;
        private readonly ICrmContractAllocationRepository _crmContractAllocationRepository;

        public InitiateContractApprovalHandler(
            ILogger logger,
            ISessionConnectionFactory sessionConnectionFactory,
            IMonthEndHistoryRepository monthEndHistoryRepository,
            IContractCheckerService contractCheckerService,
            IDateProvider dateProvider,
            ICrmContractDeliverablePeriodRepository crmContractDeliverablePeriodRepository,
            ICrmContractRepository crmContractRepository,
            ICrmContractAllocationRepository crmContractAllocationRepository,
            IFundingTypeFundingPeriodService fundingTypeFundingPeriodService,
            IXrmManager xrmManager,
            IContractsManager contractManager)
        : base (logger, monthEndHistoryRepository, fundingTypeFundingPeriodService, xrmManager, contractManager)
        {
            _logger = logger;
            _sessionConnectionFactory = sessionConnectionFactory;
            _contractCheckerService = contractCheckerService;
            _dateProvider = dateProvider;
            _crmContractDeliverablePeriodRepository = crmContractDeliverablePeriodRepository;
            _crmContractRepository = crmContractRepository;
            _crmContractAllocationRepository = crmContractAllocationRepository;
        }

        public async Task Handle(InitiateContractApprovalCommand message, IMessageHandlerContext context)
        {
            _logger.LogInformation(
             ContractManagementLoggingEvents.InitiateContractApprovalCommandReceived,
             $"InitiateContractApprovalCommand received for MasterContractNumber:[{message.MasterContractNumber}] ContractNumber:[{message.ContractNumber}] ContractVersionNumber:[{message.ContractVersionNumber}] RequestSource:[{message.RequestSource}]");

            ConnectionInfo connectionInfo = _sessionConnectionFactory.GetConnection(context);

            if (ShouldDefer(message.ContractVersionNumber, connectionInfo))
            {
                _logger.LogInformation(
                    ContractManagementLoggingEvents.InitiateContractApprovalHandlerDeferDueToMonthEndProcessing,
                    $"InitiateContractApprovalCommand for MasterContractNumber:[{message.MasterContractNumber}] ContractNumber:[{message.ContractNumber}] ContractVersionNumber:[{message.ContractVersionNumber}] deferred due to month-end processing");

                SendOptions sendOptions = new SendOptions();
                sendOptions.DelayDeliveryWith(GetDeferralTimeSpan());
                sendOptions.RouteToThisEndpoint();

                await context.Send(message, sendOptions);
            }
            else
            {
                var contractCheckerServiceResult = 
                    _contractCheckerService.GetContractCheckerServiceResult(message.ContractNumber, message.ContractVersionNumber, NonLevyFsp, connectionInfo);

                if (contractCheckerServiceResult.IsLevy)
                {
                    UpdateLevyStartDates(contractCheckerServiceResult, message.MasterContractNumber, message.ContractNumber, message.ContractVersionNumber, NonLevyFsp, connectionInfo);
                }

                await InitiateApproval(
                    message.MasterContractNumber,
                    message.ContractNumber,
                    message.ContractVersionNumber,
                    message.RequestSource,
                    connectionInfo,
                    context);
            }
        }

        private void UpdateLevyStartDates(ContractCheckerServiceResult contractCheckerServiceResult, string masterContractNumber, string contractNumber, 
            int contractVersionNumber, string fundingStreamPeriodCode, ConnectionInfo connectionInfo)
        {
            if (contractCheckerServiceResult.IsNew)
            {
                UpdateLevyContractStartDate(masterContractNumber, contractNumber, contractVersionNumber, connectionInfo);
            }
            else if (contractCheckerServiceResult.IsAllocationNew)
            {
                UpdateLevyAllocationStartDate(masterContractNumber, contractNumber, contractVersionNumber, fundingStreamPeriodCode, connectionInfo);
            }
        }

        private void UpdateLevyContractStartDate(string masterContractNumber, string contractNumber, int contractVersionNumber, ConnectionInfo connectionInfo)
        {
            var agreementStartDateTime = LevyContractStartDateCalculator.GetStartDate(contractNumber, _dateProvider.GetDate(connectionInfo));

            _logger.LogInformation(
                ContractManagementLoggingEvents.ChangeAgreementStartDateStarted,
                $"InitiateContractApprovalCommand for MasterContractNumber:[{masterContractNumber}] ContractNumber:[{contractNumber}] " +
                $"ContractVersionNumber:[{contractVersionNumber}] started setting agreement start date to {agreementStartDateTime:yyyy-MM-dd} ");

            var contractDeliverablePeriods = _crmContractDeliverablePeriodRepository.GetContractDeliverablePeriods(contractNumber, contractVersionNumber);

            _crmContractRepository.UpdateStartDate(contractDeliverablePeriods.First().ContractId, agreementStartDateTime);

            contractDeliverablePeriods.Select(x => x.ContractAllocationId)
                .Distinct()
                .ForEach(a => _crmContractAllocationRepository.UpdateStartDate(a, agreementStartDateTime));

            contractDeliverablePeriods
                .Select(x => x.Id)
                .Distinct()
                .ForEach(cdp => _crmContractDeliverablePeriodRepository.UpdatePeriod(cdp, agreementStartDateTime.Year, agreementStartDateTime.Month));

            _logger.LogInformation(
                ContractManagementLoggingEvents.ChangeAgreementStartDateCompleted,
                $"InitiateContractApprovalCommand for MasterContractNumber:[{masterContractNumber}] ContractNumber:[{contractNumber}] " +
                $"ContractVersionNumber:[{contractVersionNumber}] completed setting agreement start date to {agreementStartDateTime:yyyy-MM-dd}");
        }

        private void UpdateLevyAllocationStartDate(string masterContractNumber, string contractNumber, int contractVersionNumber, string fundingStreamPeriodCode, ConnectionInfo connectionInfo)
        {
            var agreementStartDateTime = LevyContractStartDateCalculator.GetStartDate(contractNumber, _dateProvider.GetDate(connectionInfo));

            _logger.LogInformation(
                ContractManagementLoggingEvents.ChangeAgreementStartDateStarted,
                $"InitiateContractApprovalCommand for MasterContractNumber:[{masterContractNumber}] ContractNumber:[{contractNumber}] " +
                $"ContractVersionNumber:[{contractVersionNumber}] Allocation FSP:[{fundingStreamPeriodCode}] " +
                $"started setting agreement start date to {agreementStartDateTime:yyyy-MM-dd} ");

            var contractDeliverablePeriods = _crmContractDeliverablePeriodRepository.GetContractDeliverablePeriodsForAllocation(contractNumber, contractVersionNumber, fundingStreamPeriodCode);

            _crmContractAllocationRepository.UpdateStartDate(contractDeliverablePeriods.First().ContractAllocationId, agreementStartDateTime);

            contractDeliverablePeriods
                .Select(x => x.Id)
                .Distinct()
                .ForEach(cdp => _crmContractDeliverablePeriodRepository.UpdatePeriod(cdp, agreementStartDateTime.Year, agreementStartDateTime.Month));

            _logger.LogInformation(
                ContractManagementLoggingEvents.ChangeAgreementStartDateCompleted,
                $"InitiateContractApprovalCommand for MasterContractNumber:[{masterContractNumber}] ContractNumber:[{contractNumber}] " +
                $"ContractVersionNumber:[{contractVersionNumber}] Allocation FSP:[{fundingStreamPeriodCode}] " +
                $"completed setting agreement start date to {agreementStartDateTime:yyyy-MM-dd}");
        }
    }
}
