
namespace SFA.FCT.ContractManagementService.Common
{
    using System;
    using AutoMapper;
    using CorporateContractContract = CrossDomain.Integration.Entities.CorporateContract;
    using CorporateSchemaContract = CrossDomain.Integration.Entities.CorporateSchema.Contract;

    public class ContractMappingProfile : Profile
    {
        public ContractMappingProfile()
        {
            CreateMap<CorporateContractContract.Contract, CorporateSchemaContract.Contract>()
                .ForMember(dest => dest.schemaVersion, opt => opt.Ignore())
                .ForMember(dest => dest.TerminationContractAttrs, opt => opt.Ignore());

            CreateMap<CorporateContractContract.contractType, CorporateSchemaContract.contractType>()
                .ForMember(dest => dest.TerminationContractAttrs, opt => opt.Ignore());
            CreateMap<CorporateContractContract.contractAllocationsContractAllocation,
                      CorporateSchemaContract.ProcurementAttrsCT>()
                .ForMember(dest => dest.TenderSpecReference, opt => opt.MapFrom(src => src.tenderSpecificationReference))
                .ForMember(dest => dest.LotReference, opt => opt.MapFrom(src => src.lotReference))
                .ForMember(dest => dest.AwardReference, opt => opt.MapFrom(src => src.tenderAwardReference))
                .ForMember(dest => dest.TenderSpecTitle, opt => opt.MapFrom(src => src.SpecificationTitle))
                .ForMember(dest => dest.LearningRatePremium, opt =>
                    opt.MapFrom(src => string.IsNullOrWhiteSpace(src.LearningRatePremium)
                        ? 1m
                        : decimal.Parse(src.LearningRatePremium)))
                .ForMember(dest => dest.LotSpecificationTitle, opt => opt.MapFrom(_ => string.Empty));
            CreateMap<CorporateContractContract.contractAllocationsContractAllocation,
                      CorporateSchemaContract.allocationOrganisationRelationships>()
                .ConvertUsing((src, dest, ctx) =>
                {
                    if (!src.HasDeliveryOrganisation())
                        return null;

                    return new CorporateSchemaContract.allocationOrganisationRelationships
                    {
                        contractAllocationNumber = src.contractAllocationNumber,
                        RelationshipType = CorporateSchemaContract.allocationOrganisationRelationshipType.DELIVERYORGANISATION,
                        Organisation = ctx.Mapper.Map<
                            CorporateContractContract.Contractor,
                            CorporateSchemaContract.contractor>(src.DeliveryOrganisationDetail)
                    };
                });


            CreateMap<
                CorporateContractContract.contractAllocationsContractAllocation,
                CorporateSchemaContract.contractAllocationsContractAllocation>()
                .ForMember(d => d.ProcurementAttrs,
                           o => o.MapFrom(s => s))   // AutoMapper auto-selects the correct map
                .ForMember(d => d.allocationOrganisationRelationships,
                           o => o.MapFrom(s => s));  // Same here
            CreateMap<
                CorporateContractContract.contractDeliverablePeriodsTypeContractDeliverablePeriod,
                CorporateSchemaContract.contractDeliverablePeriodsTypeContractDeliverablePeriod>();

            CreateMap<
                CorporateContractContract.contractDeliverablesTypeContractDeliverable,
                CorporateSchemaContract.contractDeliverablesTypeContractDeliverable>();

            
            CreateMap<
                CorporateContractContract.organisationRelationship,
                CorporateSchemaContract.organisationRelationship>();

            
            CreateMap<CorporateContractContract.contractStatusType, CorporateSchemaContract.contractStatusType>()
                .ForMember(dest => dest.status,
                    opt => opt.MapFrom(src =>
                        (CorporateSchemaContract.contractStatusTypeStatus)
                            Enum.Parse(typeof(CorporateSchemaContract.contractStatusTypeStatus),
                                       src.status.Replace(" ", "").Replace("-", ""))));

            CreateMap<CorporateContractContract.Contractor, CorporateSchemaContract.contractor>();
            CreateMap<CorporateContractContract.deliverableType, CorporateSchemaContract.deliverableType>();
            CreateMap<CorporateContractContract.fundingType, CorporateSchemaContract.fundingType>();
            CreateMap<CorporateContractContract.fundingStream, CorporateSchemaContract.fundingStream>();

            CreateMap<
                CorporateContractContract.fundingStreamPeriodsFundingStreamPeriod,
                CorporateSchemaContract.fundingStreamPeriodsFundingStreamPeriod>();

            CreateMap<CorporateContractContract.Period, CorporateSchemaContract.Period>();
            CreateMap<CorporateContractContract.periodTypeType, CorporateSchemaContract.periodTypeType>();

           
            AllowNullCollections = true;
        }
    }
}
