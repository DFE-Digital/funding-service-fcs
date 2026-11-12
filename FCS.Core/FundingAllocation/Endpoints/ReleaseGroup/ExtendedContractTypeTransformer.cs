namespace FundingAllocation.Endpoints.ReleaseGroup
{
    using System.Linq;
    using AutoMapper;
    using SFA.FCT.CrossDomain.Integration.Entities.CorporateContract;

    public class ExtendedContractTypeTransformer : IExtendedContractTypeTransformer
    {
        public Contract TransformToCorpContract(ExtendedContractType extendedContractType)
        {
            var mapperConfiguration = new MapperConfiguration(cfg =>
            {
                cfg.CreateMap<ExtendedContract, Contract>();
                cfg.CreateMap<ExtendedContractType, contractType>();
                cfg.CreateMap<ExtendedContractAllocation, contractAllocationsContractAllocation>();
                cfg.CreateMap<contractType, Contract>();
            });

            var mapper = new Mapper(mapperConfiguration);

            Contract contract = mapper.Map<Contract>(extendedContractType);
            contract.contractAllocations = extendedContractType.contractAllocations
                .Select(ca => mapper.Map<contractAllocationsContractAllocation>(ca)).ToList();

            return contract;
        }
    }
}