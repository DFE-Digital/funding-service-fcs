namespace ContractRequestDomain.Cfs.Release.Extensions
{
    using System.Collections.Generic;
    using System.Linq;
    using AutoMapper;
    using SFA.FCT.ContractCreateDomain.Implementation.Persistence.Entities;
    using SFA.FCT.CrossDomain.Integration.Entities.CorporateContract;

    public static class ExtendedContractTypeExtensions
    {
        public static contract ToCorporateContract(this ExtendedContractType extendedContractType)
        {
            Mapper.CreateMap<ExtendedContract, contract>();
            Mapper.CreateMap<ExtendedContractType, contractType>();
            Mapper.CreateMap<ExtendedContractAllocation, contractAllocationsContractAllocation>();
            var contractType = Mapper.Map<ExtendedContractType, contractType>(extendedContractType);

            // we now need to create corp contract derived class
            Mapper.CreateMap<contractType, contract>();
            return Mapper.Map<contractType, contract>(contractType);
        }

        public static List<NumberRequest> ToNumberRequests(this ExtendedContractType extendedContractType)
        {
            List<NumberRequest> numberRequests = new List<NumberRequest>();

            var childContract = extendedContractType.contracts.First();

            string fundingTypeCode = childContract.fundingType.fundingTypeCode;

            periodTypeType periodType = childContract.period.periodType;

            numberRequests.Add(new MasterContractNumberRequest(hierarchyType.MASTERCONTRACT.ToString(), fundingTypeCode));

            numberRequests.Add(new ContractNumberRequest(hierarchyType.CONTRACT.ToString(), fundingTypeCode));

            var allocationNumberRequests = childContract.contractAllocations.Select(a =>
            {
                string periodTypeCode = a.period?.periodType?.periodTypeCode.ToString() ?? periodType.periodTypeCode.ToString();
                string period = a.period?.period1 ?? childContract.period.period1;

                return new AllocationNumberRequest(
                    contractType: "CONTRACT ALLOCATION",
                    fundingtype: fundingTypeCode,
                    fundingStreamCode: a.fundingStream.fundingStreamCode,
                    period: period,
                    periodTypeCode: periodTypeCode,
                    fundingStreamPeriodCode: a.fundingStreamPeriodCode);
            });

            numberRequests.AddRange(allocationNumberRequests);

            return numberRequests;
        }
    }
}