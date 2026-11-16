extern alias Entities;
using AutoMapper;
using SFA.FCT.PaymentManagementDomain.PaymentSchedule.DataStore.Model;
using Entities.SFA.FCT.CrossDomain.Integration.Entities;

namespace ADMonitoringDomain.Endpoint.BusinessLogic
{
    public class AutoProfile : Profile
    {
        public AutoProfile()
        {

            // Allocation -> contractReferenceTYPE
            CreateMap<Allocation, contractReferenceTYPE>()
                .ForMember(dest => dest.contractNumber,
                           opt => opt.MapFrom(src => src.ContractNumber))
                .ForMember(dest => dest.contractVersionNumber,
                           opt => opt.MapFrom(src => src.ContractVersionNumber));

            // Allocation -> AllocationDeliveryPerformanceFundingStreamPeriod
            CreateMap<Allocation, AllocationDeliveryPerformanceFundingStreamPeriod>()
                .ForMember(dest => dest.FundingStreamPeriodCode,
                           opt => opt.MapFrom(src => src.FundingStreamPeriodCode));

        }
    }

}
