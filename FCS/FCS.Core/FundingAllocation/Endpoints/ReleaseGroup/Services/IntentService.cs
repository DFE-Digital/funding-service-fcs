namespace FundingAllocation.Endpoints.ReleaseGroup.Services
{
    using System.Collections.Generic;
    using System.Linq;
    using System.Threading.Tasks;
    using FundingAllocation.Repositories;
    using Extensions;
    using SFA.FCT.CrossDomain.Integration.Messages.Dtos;
    using SFA.FCT.CrossDomain.Integration.Entities.CorporateContract;
    using Repositories;
    using SFA.FCT.CrossDomain.Integration.Entities;

    public class IntentService : IIntentService
    {
        private readonly ICrmContractRepository _crmContractRepository;
        private readonly IFundingTypeFundingPeriodRepository _fundingTypeFundingPeriodRepository;

        private static readonly IReadOnlyCollection<ContractIntent> IntentsThatDontRequireWeCheckCurrentPeriod =
            new List<ContractIntent>
            {
                ContractIntent.NewAmendment,
                ContractIntent.Queue
            };

        public IntentService(ICrmContractRepository crmContractRepository, IFundingTypeFundingPeriodRepository fundingTypeFundingPeriodRepository)
        {
            _crmContractRepository = crmContractRepository;
            _fundingTypeFundingPeriodRepository = fundingTypeFundingPeriodRepository;
        }

        public async Task<IntentResult> GetIntent(int ukprn, string fundingTypeCode, string fundingPeriodCode, 
            IReadOnlyCollection<ContractIdentity> contractIdentitiesToIgnoreWhenDerivingIntent, IReadOnlyCollection<ContractAndStatus> overrideStatuses,
            bool isInvokedViaDequeueEvent = false)
        {
            var crmContractStatusInfos = await _crmContractRepository.GetContractStatusInfosForUkprn(ukprn, fundingTypeCode);

            crmContractStatusInfos.UpdateStatusSubStatusWhereFound(overrideStatuses);

            var intentFundingTypeFundingPeriod = await _fundingTypeFundingPeriodRepository.GetAmendmentInfo(fundingTypeCode, fundingPeriodCode);

            var contractIntent = crmContractStatusInfos.GetIntent(intentFundingTypeFundingPeriod, fundingPeriodCode, contractIdentitiesToIgnoreWhenDerivingIntent, isInvokedViaDequeueEvent);

            if (contractIntent.DoesNotRequiresExistingContractInfo())
            {
                return new IntentResult(contractIntent, null);
            }

            if (DoesIntentRequireWeOnlyCheckCurrentPeriod(contractIntent))
            {
                crmContractStatusInfos =
                    crmContractStatusInfos.Where(c => c.FundingPeriod == fundingPeriodCode).ToList();
            }

            var crmContractInfo = await crmContractStatusInfos.GetExistingCrmContractInfo(
                ukprn,
                contractIntent,
                fundingPeriodCode,
                crmEntityId => _crmContractRepository.GetAllocationInfosForContractEntityId(crmEntityId));

            return new IntentResult(contractIntent, crmContractInfo);
        }

        private static bool DoesIntentRequireWeOnlyCheckCurrentPeriod(ContractIntent contractIntent)
        {
            return IntentsThatDontRequireWeCheckCurrentPeriod.Contains(contractIntent) == false;
        }
    }
}
