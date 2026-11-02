namespace FundingAllocation.Endpoints.ReleaseGroup
{
    using System;
    using System.Collections.Generic;
    using System.Threading.Tasks;
    using DataStore.Model;
    using SFA.FCT.CrossDomain.Integration.Entities.CorporateContract;
    using SFA.FCT.CrossDomain.Integration.Messages.FundingAllocation.Dtos;

    public interface IFundingAllocationsToContractTransformer
    {
        Task<ExtendedContractType> CreateContractFrom(
            IReadOnlyCollection<FundingAllocation> fundingAllocations,
            string contractNumber,
            string masterContractNumber,
            ContractItemsMappingResult contractItemsMappings,
            int contractVersionNumber,
            Func<(string fundingStream, int deliveryUkprn), int> getAllocationNumberForFundingStream);

        Task<IReadOnlyCollection<ExtendedContractAllocation>> CreateAllocationsFrom(
            int contractingUkprn,
            IReadOnlyCollection<FundingAllocation> fundingAllocations,
            ContractItemsMappingResult contractItemsMappings,
            Func<(string fundingStream, int deliveryUkprn), int> getAllocationNumberForFundingStream);
    }
}