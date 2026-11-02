namespace FundingAllocation.Services
{
    using System.Collections.Generic;
    using System.Threading.Tasks;
    using SFA.FCT.ContractCreateDomain.Common.Messages.Commands;
    using SFA.FCT.CrossDomain.Integration.Messages.FundingAllocation.Commands;

    public interface IValidationOrchestrator
    {
        Task<(IReadOnlyCollection<CreateProvidersIfNecessaryCommand> createProvidersIfNecessaryCommands,
                IReadOnlyCollection<SetBatchToDiscardedCommand> setBatchToDiscardedCommands)>
            ValidateAndProcess(IReadOnlyCollection<string> fundingIds, int readId);

        Task<IReadOnlyCollection<CreateProvidersIfNecessaryCommand>> ValidateAndProcessProviderNotFound(
            IReadOnlyCollection<string> fundingIdsProviderNotFound);
    }
}