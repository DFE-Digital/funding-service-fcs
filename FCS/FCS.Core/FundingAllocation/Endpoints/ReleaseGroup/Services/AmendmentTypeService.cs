namespace FundingAllocation.Endpoints.ReleaseGroup.Services
{
    using System.Threading.Tasks;
    using Extensions;
    using LanguageExt;
    using SFA.FCT.CrossDomain.Integration.Common;
    using SFA.FCT.Framework.Logging.Interfaces;

    public class AmendmentTypeService : IAmendmentTypeService
    {
        private readonly IAmendmentTypeServiceChecks _amendmentTypeServiceChecks;
        private readonly ILogger _logger;
        public IDate Date { get; set; }

        public AmendmentTypeService(IAmendmentTypeServiceChecks amendmentTypeServiceChecks, ILogger logger)
        {
            _amendmentTypeServiceChecks = amendmentTypeServiceChecks;
            _logger = logger;
        }

        public async Task<string> GetAmendmentType(GetAmendmentTypeInput getAmendmentTypeInput)
        {
            if (getAmendmentTypeInput.ContractIntent.IsAmendment())
            {
                var isNotification = await DoAmendmentTypeToNotificationOnExpiredContract(getAmendmentTypeInput);

                if (isNotification)
                    return "Notification";
                
                var isVariation =
                    await DoAllAmendmentsRequireSigning(getAmendmentTypeInput)
                        .BindAsync(IsUpdateDraftAmendmentAndLatestVersionIsVariation)
                        .BindAsync(IsUpdateDraftAmendmentAndAtLeastOneContractAllocationNotInLastApprovedContract)
                        .BindAsync(IsAnyUpdateLineGreaterIfMatchingOrPositiveIfNot);

                return await isVariation.MatchAsync(Left: reason =>
                {
                    _logger.LogInformation(LoggingId.UpdateContractAmendmentTypeCheck, $"Reason for variation is: {reason}");
                    return "Variation";
                }, RightAsync: _ => Task.FromResult("Notification"));
            }

            return null;
        }

        private async Task<Either<VariationReason, GetAmendmentTypeInput>> DoAllAmendmentsRequireSigning(GetAmendmentTypeInput input)
        {

            var doAllAmendmentsRequireSigning = await _amendmentTypeServiceChecks.DoAllAmendmentsRequireSigning(input.FundingTypeCode,
                input.FundingPeriodCode);

            if (doAllAmendmentsRequireSigning)
            {
                return new VariationReason("DoAllAmendmentsRequireSigning");
            }

            return input;
        }

        private async Task<Either<VariationReason, GetAmendmentTypeInput>> IsUpdateDraftAmendmentAndLatestVersionIsVariation(GetAmendmentTypeInput input)
        {
            var isUpdateDraftAmendmentAndLatestVersionIsVariation = await
                _amendmentTypeServiceChecks.IsUpdateDraftAmendmentAndLatestVersionIsVariation(input.AmendmentTypeOfLatestContract, input.ContractIntent);

            if (isUpdateDraftAmendmentAndLatestVersionIsVariation)
            {
                return new VariationReason("IsUpdateDraftAmendmentAndLatestVersionIsVariation");
            }

            return input;
        }

        private async Task<Either<VariationReason, GetAmendmentTypeInput>> IsUpdateDraftAmendmentAndAtLeastOneContractAllocationNotInLastApprovedContract(GetAmendmentTypeInput input)
        {
            var IsUpdateDraftAmendmentAndAtLeastOneContractAllocationNotInLastApprovedContract = await
                _amendmentTypeServiceChecks.IsUpdateDraftAmendmentAndAtLeastOneContractAllocationNotInLastApprovedContract(
                    input.ContractIntent,
                    input.UpdateFundingAllocations, input.LastApprovedFundingAllocations);

            if (IsUpdateDraftAmendmentAndAtLeastOneContractAllocationNotInLastApprovedContract)
            {
                return new VariationReason("IsUpdateDraftAmendmentAndAtLeastOneContractAllocationNotInLastApprovedContract");
            }

            return input;
        }

        private async Task<Either<VariationReason, GetAmendmentTypeInput>> IsAnyUpdateLineGreaterIfMatchingOrPositiveIfNot(GetAmendmentTypeInput input)
        {
            var fundingAllocationLinesSumValuesAreDifferent = await
                _amendmentTypeServiceChecks.IsAnyUpdateLineGreaterIfMatchingOrPositiveIfNot(
                input.UpdateFundingAllocations, input.LastApprovedFundingAllocations);

            if (fundingAllocationLinesSumValuesAreDifferent)
            {
                return new VariationReason("FundingAllocationLinesSumValuesAreDifferent");
            }

            return input;
        }

        private async Task<bool> DoAmendmentTypeToNotificationOnExpiredContract(GetAmendmentTypeInput input)
        {

            return await _amendmentTypeServiceChecks.DoAmendmentTypeToNotificationOnExpiredContract(input.FundingTypeCode,
                input.FundingPeriodCode);
        }


        private class VariationReason
        {
            public VariationReason(string message)
            {
                Message = message;
            }

            public string Message { get; }

            public override string ToString() => Message;
        }
    }
}
