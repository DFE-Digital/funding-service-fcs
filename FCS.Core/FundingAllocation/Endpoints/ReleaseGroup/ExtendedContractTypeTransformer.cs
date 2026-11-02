namespace FundingAllocation.Endpoints.ReleaseGroup
{
    using System.Linq;
    using AutoMapper;
    using SFA.FCT.CrossDomain.Integration.Entities.CorporateContract;

    public class ExtendedContractTypeTransformer : IExtendedContractTypeTransformer
    {
        public contract TransformToCorpContract(ExtendedContractType extendedContractType)
        {
            var mapperConfiguration = new MapperConfiguration(cfg =>
            {
                cfg.CreateMap<ExtendedContract, contract>();
                cfg.CreateMap<ExtendedContractType, contractType>();
                cfg.CreateMap<ExtendedContractAllocation, contractAllocationsContractAllocation>();
                cfg.CreateMap<contractType, contract>();
            });

            var mapper = new Mapper(mapperConfiguration);

            contract contract = mapper.Map<contract>(extendedContractType);
            contract.contractAllocations = extendedContractType.contractAllocations
                .Select(ca => mapper.Map<contractAllocationsContractAllocation>(ca)).ToList();

            return contract;
        }
    }
}