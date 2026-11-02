namespace PerformanceManagementDomain.RecalculationInitiated
{
    using System;
    using System.Linq;
    using System.Threading.Tasks;
    using Dto;
    using NServiceBus;
    using Repositories;
    using SFA.FCT.CrossDomain.Integration.Messages.Commands;
    using SFA.FCT.Framework.Logging.Interfaces;
    using SFA.FCT.PerformanceManagementDomain.Common.Commands;
    using SFA.FCT.PerformanceManagementDomain.Common.Logging;

    public class InitiateReCalculationForFcrHandler : IHandleMessages<InitiateReCalculationForFcrCommand>
    {
        private readonly ILogger _logger;
        private readonly IFundingClaimReconciliationRepository _fundingClaimReconciliationRepository;

        public InitiateReCalculationForFcrHandler(ILogger logger, IFundingClaimReconciliationRepository fundingClaimReconciliationRepository)
        {
            _logger = logger;
            _fundingClaimReconciliationRepository = fundingClaimReconciliationRepository;
        }

        public async Task Handle(InitiateReCalculationForFcrCommand message, IMessageHandlerContext context)
        {
            _logger.LogInformation(PerformanceManagementLoggingId.StartInitiateReCalculationForFcrCommand,
                $"Start handler for InitiateReCalculationForFcrCommand {message}");

            FundingClaimReconciliationInfo fcr =
                _fundingClaimReconciliationRepository.GetFundingClaimReconciliationInfo(new Guid(message.FcrId));

            if (fcr.Allocations.Count > 1)
            {
                throw new ArgumentException($"FCR {message.FcrName} has multiple allocations hence claim value cannot be adjusted");
            }

            decimal claimAdjustmentValue = fcr.Allocations.Single().ClaimAdjustmentValue;

            decimal earningBoostValue = fcr.Allocations.Single().EarningsBoostValue;
            
            bool updateFinalReconciliation = !message.HasFinalReconciliationValueChanged;

            RecalculateFcrOnCappedClaimAdjustmentCommand command = new RecalculateFcrOnCappedClaimAdjustmentCommand(
                fcr.OrganisationIdentifier,
                fcr.ClaimVersionNumber,
                fcr.ClaimTypeName,
                fcr.PeriodTypeCode,
                fcr.Period,
                fcr.AllocationGroupCode,
                fcr.FcrId,
                claimAdjustmentValue,
                earningBoostValue,
                updateFinalReconciliation);

            await context.Send(command)
                .ConfigureAwait(false);

            _logger.LogInformation(PerformanceManagementLoggingId.FinishInitiateReCalculationForFcrCommand,
                $"Finished handler for InitiateReCalculationForFcrCommand {message}");
        }
    }
}
