namespace FundingAllocation.Services
{
    using System.Collections.Generic;
    using System.Linq;
    using System.Threading.Tasks;
    using DataStore.Model;
    using Endpoints.CheckForReadComplete;
    using Extensions;
    using SFA.FCT.ContractCreateDomain.Common.Messages.Commands;
    using SFA.FCT.CrossDomain.Integration.Messages.FundingAllocation.Commands;
    using SFA.FCT.Framework.Logging.Interfaces;

    public class ValidationOrchestrator : IValidationOrchestrator
    {
        private readonly ILogger _logger;
        private readonly IPreContractControlService _preContractControlService;
        private readonly ICheckForReadCompleteNotificationService _notificationService;

        public ValidationOrchestrator(
            IPreContractControlService preContractControlService,
            ICheckForReadCompleteNotificationService notificationService,
            ILogger logger)
        {
            _preContractControlService = preContractControlService;
            _notificationService = notificationService;
            _logger = logger;
        }

        public async Task<(IReadOnlyCollection<CreateProvidersIfNecessaryCommand> createProvidersIfNecessaryCommands, IReadOnlyCollection<SetBatchToDiscardedCommand> setBatchToDiscardedCommands)>
            ValidateAndProcess(IReadOnlyCollection<string> fundingIds, int readId)
        {
            _logger.LogInformation(LoggingId.CheckForReadCompleteParkCheck, $"CheckForReadCompleteHandler1 fundingIds: {fundingIds}");

            var parkCheckResult = await _preContractControlService.GetParkCheckResult(fundingIds, readId);
              _logger.LogInformation(LoggingId.CheckForReadCompleteParkCheck, $"CheckForReadCompleteHandler1 ParkCheckResult: {parkCheckResult}");

              var createProvidersIfNecessaryCommands = parkCheckResult
                  .AllFundingAllocations
                  .Select(fa => BuildCreateProvidersIfNecessaryCommand(fa, parkCheckResult.IsValid(fa.FundingId)))
                  .ToList();

              await _preContractControlService.SetStatuses(
                parkCheckResult.FundingIdsForParkingAwaitingOutcome,
                parkCheckResult.FundingIdsForDiscardingNonMaterialUpdate,
                parkCheckResult.FundingIdsAwaitingContractTypeConfig,
                parkCheckResult.FundingIdsAwaitingFundingAllocationConfig,
                parkCheckResult.FundingIdsAwaitingFundingLineConfig,
                parkCheckResult.FundingIdsForContractControl,
                parkCheckResult.MutualExclusiveForAdultFilterCheckResult);

            await _notificationService.NotifySlackRegardingParkedFundingAllocations(readId);

            var setBatchToBeDiscardedTasks = parkCheckResult.GetFundingAllocationNames()
                .GetBatchesOfSize(batchSize: 100)
                .Select(chunkOfFundingNames =>
                    new SetBatchToDiscardedCommand(chunkOfFundingNames, readIdToIgnore: readId))
                .ToList();

            return (createProvidersIfNecessaryCommands, setBatchToBeDiscardedTasks);
        }

        public async Task<IReadOnlyCollection<CreateProvidersIfNecessaryCommand>> ValidateAndProcessProviderNotFound(IReadOnlyCollection<string> fundingIdsProviderNotFound)
        {
            const int readIdNotInSystem = -1;
            _logger.LogInformation(LoggingId.CheckForReadCompleteParkCheck, $"CheckForReadCompleteHandler fundingIds2: {fundingIdsProviderNotFound}");

            var parkCheckResult = await _preContractControlService.GetParkCheckResult(fundingIdsProviderNotFound, readIdNotInSystem);
            _logger.LogInformation(LoggingId.CheckForReadCompleteParkCheck, $"CheckForReadCompleteHandler ParkCheckResult2: {parkCheckResult}");

            var createProvidersIfNecessaryCommands = parkCheckResult
                .AllFundingAllocations
                .Select(fa => BuildCreateProvidersIfNecessaryCommand(fa, parkCheckResult.IsValid(fa.FundingId),
                    parkCheckResult.GetParkedAwaitingConfigSubStatus(fa.FundingId), isProviderNotFoundCheck: true))
                .ToList();

            await _preContractControlService.SetStatuses(
                parkCheckResult.FundingIdsForParkingAwaitingOutcome,
                parkCheckResult.FundingIdsForDiscardingNonMaterialUpdate,
                parkCheckResult.FundingIdsAwaitingContractTypeConfig,
                parkCheckResult.FundingIdsAwaitingFundingAllocationConfig,
                parkCheckResult.FundingIdsAwaitingFundingLineConfig,
                parkCheckResult.FundingIdsForContractControl,
                parkCheckResult.MutualExclusiveForAdultFilterCheckResult);

            return createProvidersIfNecessaryCommands;
        }

        private static CreateProvidersIfNecessaryCommand BuildCreateProvidersIfNecessaryCommand(
            FundingAllocation fundingAllocation, bool passedConfigValidation, string parkedConfigSubStatus = "", bool isProviderNotFoundCheck = false)
        {
            var ukprns = fundingAllocation.ProviderFundingAllocations
                .Select(a => a.ProviderFunding.DeliveryUkprn).ToHashSet();

            ukprns.Add(fundingAllocation.UkprnAsInt());

            return new CreateProvidersIfNecessaryCommand(fundingAllocation.FundingId, ukprns.ToList(), passedConfigValidation: passedConfigValidation, fundingAllocation.ReadId, isProviderNotFoundCheck, parkedConfigSubStatus);
        }
    }
}
