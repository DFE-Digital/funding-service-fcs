namespace FundingAllocation.Endpoints.ReleaseGroup.Services
{
    using System.Collections.Generic;
    using SFA.FCT.CrossDomain.Integration.Messages.Dtos;
    using System.Threading.Tasks;
    using SFA.FCT.CrossDomain.Integration.Entities;

    public interface IIntentService
    {
        Task<IntentResult> GetIntent(int ukprn, string fundingTypeCode, string fundingPeriodCode, 
            IReadOnlyCollection<ContractIdentity> contractIdentitiesToIgnore,
            IReadOnlyCollection<ContractAndStatus> overrideStatuses,
            bool isInvokedViaDequeueEvent = false);
    }
}