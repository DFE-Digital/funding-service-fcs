namespace SFA.FCT.ContractManagementService.Common
{
    using System;
    using System.Linq;
    using AutoMapper;
    using CorporateContract = CrossDomain.Integration.Entities.CorporateContract;
    using CorporateSchema = CrossDomain.Integration.Entities.CorporateSchema.Contract;

    public class ContractTransformer : IContractTransformer
    {
        private const string SBDFundingType = "SBD";

        [Obsolete]
        static ContractTransformer()
        {
            Mapper.CreateMap<CorporateContract.contract, CorporateSchema.contract>()
                .ForMember(dest => dest.schemaVersion, opt => opt.Ignore())
                .ForMember(dest => dest.TerminationContractAttrs, opt => opt.Ignore());

            Mapper.CreateMap<CorporateContract.contractType, CorporateSchema.contractType>()
                .ForMember(dest => dest.TerminationContractAttrs, opt => opt.Ignore());

            Mapper.CreateMap<CorporateContract.contractAllocationsContractAllocation, CorporateSchema.ProcurementAttrsCT>()
                .ForMember(dest => dest.TenderSpecReference, opt => opt.MapFrom(src => src.tenderSpecificationReference))
                .ForMember(dest => dest.LotReference, opt => opt.MapFrom(src => src.lotReference))
                .ForMember(dest => dest.AwardReference, opt => opt.MapFrom(src => src.tenderAwardReference))
                .ForMember(dest => dest.TenderSpecTitle, opt => opt.MapFrom(src => src.SpecificationTitle))
                .ForMember(dest => dest.LearningRatePremium, opt => opt.MapFrom(src => string.IsNullOrWhiteSpace(src.LearningRatePremium) ? 1m : decimal.Parse(src.LearningRatePremium)))
                .ForMember(dest => dest.LotSpecificationTitle, opt => opt.UseValue(string.Empty));

            Mapper.CreateMap<CorporateContract.contractAllocationsContractAllocation, CorporateSchema.allocationOrganisationRelationships>()
                .ConvertUsing(MapDeliveryOrgIfPresent);
                //.ForMember(dest => dest.Organisation, opt => opt.MapFrom(src => src.DeliveryOrganisationDetail))
                //.ForMember(dest => dest.contractAllocationNumber, opt => opt.MapFrom(src => src.contractAllocationNumber))
                //.ForMember(dest => dest.RelationshipType, opt => opt.UseValue(CorporateSchema.allocationOrganisationRelationshipType.DELIVERYORGANISATION));

            Mapper.CreateMap<CorporateContract.contractAllocationsContractAllocation, CorporateSchema.contractAllocationsContractAllocation>()
                .ForMember(dest => dest.ProcurementAttrs, opt => opt.MapFrom(src => Mapper.Map<CorporateContract.contractAllocationsContractAllocation, CorporateSchema.ProcurementAttrsCT>(src)))
                .ForMember(dest => dest.allocationOrganisationRelationships, opt => opt.MapFrom(src => Mapper.Map<CorporateContract.contractAllocationsContractAllocation, CorporateSchema.allocationOrganisationRelationships>(src)));
                // AllocationDescription from the story will get mapped automatically, equivalent to..
                //.ForMember(dest => dest.description, opt => opt.MapFrom(src => src.description));

            Mapper.CreateMap<CorporateContract.contractDeliverablePeriodsTypeContractDeliverablePeriod, CorporateSchema.contractDeliverablePeriodsTypeContractDeliverablePeriod>();

            Mapper.CreateMap<CorporateContract.contractDeliverablesTypeContractDeliverable, CorporateSchema.contractDeliverablesTypeContractDeliverable>();

            // before AssertConfigurationIsValid (as currently in live), if deliverableOrganisationRelationships were supplied, the mapping would have blown up!
            // it looks like it's never supplied, but we need to add a mapping for the automapper validation to pass
            Mapper.CreateMap<CorporateContract.organisationRelationship, CorporateSchema.organisationRelationship>();

            Mapper.CreateMap<CorporateContract.contractStatusType, CorporateSchema.contractStatusType>()
                .ForMember(dest => dest.status, opt => opt.ResolveUsing(o => MapStatus(o.status)));

            Mapper.CreateMap<CorporateContract.contractor, CorporateSchema.contractor>();

            Mapper.CreateMap<CorporateContract.deliverableType, CorporateSchema.deliverableType>();
            
            Mapper.CreateMap<CorporateContract.fundingType, CorporateSchema.fundingType>();
            Mapper.CreateMap<CorporateContract.fundingStream, CorporateSchema.fundingStream>();

            // Mapper.CreateMap<CorporateContract.fundingStreamPeriods, CorporateSchema.fundingStreamPeriods>();
            Mapper.CreateMap<CorporateContract.fundingStreamPeriodsFundingStreamPeriod, CorporateSchema.fundingStreamPeriodsFundingStreamPeriod>();

            Mapper.CreateMap<CorporateContract.period, CorporateSchema.period>();
            Mapper.CreateMap<CorporateContract.periodTypeType, CorporateSchema.periodTypeType>();

            // we now need to create corp contract derived class
            Mapper.Configuration.AllowNullCollections = true;

            //Mapper.AssertConfigurationIsValid();
        }

        public CorporateSchema.contract TransformToCorporateSchemaContract(CorporateContract.contract contract)
        {
            var corporateSchemaContract = Mapper.Map<CorporateContract.contract, CorporateSchema.contract>(contract);
            corporateSchemaContract.contracts.ForEach(c =>
            {
                var matchingCorpChildContract = contract.contracts.Single(corpChildContract => corpChildContract.contractNumber == c.contractNumber);

                c.contractAllocations.ForEach(a =>
                {
                    var matchingCorpAllocation = matchingCorpChildContract.contractAllocations.Single(corpAllocation =>
                        corpAllocation.contractAllocationNumber == a.contractAllocationNumber);

                    if (c.fundingType.fundingTypeCode == SBDFundingType)
                    {
                        a.ProcurementAttrs.TenderSpecReference = GetNullableString(a.ProcurementAttrs.TenderSpecReference);
                        a.ProcurementAttrs.AgreementNumber = Get11DigitString(a.ProcurementAttrs.AgreementNumber);
                        a.ProcurementAttrs.RegionType = GetNullableString(a.ProcurementAttrs.RegionType);
                        a.ProcurementAttrs.LEPName = GetNullableString(a.ProcurementAttrs.LEPName);
                        a.ProcurementAttrs.LEPCode = GetNullableString(a.ProcurementAttrs.LEPCode);
                        a.ProcurementAttrs.InvestmentPriority = GetNullableString(a.ProcurementAttrs.InvestmentPriority);
                        a.ProcurementAttrs.ActivityDescription = GetNullableString(a.ProcurementAttrs.ActivityDescription);
                        a.ProcurementAttrs.AwardReference = GetNullableString(a.ProcurementAttrs.AwardReference);
                        a.ProcurementAttrs.TenderSpecTitle = GetNullableString(a.ProcurementAttrs.TenderSpecTitle);
                    }

                    a.contractDeliverables = matchingCorpAllocation.contractDeliverables.Select(ToCorporateSchemaDeliverable).ToList();
                });
            });

            PopulateTerminationAttrsIfPresent(corporateSchemaContract, contract);

            return corporateSchemaContract;
        }

        private static string GetNullableString(string s)
        {
            if (string.IsNullOrWhiteSpace(s))
            {
                return "XX";
            }

            return s;
        }

        private static string Get11DigitString(string s)
        {
            if (string.IsNullOrWhiteSpace(s))
            {
                return "xxxxxxxxxxx";
            }

            return s;
        }
        public CorporateSchema.contractDeliverablesTypeContractDeliverable ToCorporateSchemaDeliverable(
            CorporateContract.contractDeliverablesTypeContractDeliverable deliverable)
        {
            return Mapper
                .Map<CorporateContract.contractDeliverablesTypeContractDeliverable,
                    CorporateSchema.contractDeliverablesTypeContractDeliverable>(deliverable);
        }

        private static void PopulateTerminationAttrsIfPresent(CorporateSchema.contract corporateSchemaContract, CorporateContract.contract contract)
        {
            var childCorporateSchemaContracts = corporateSchemaContract.contracts;
            contract.contracts.ForEach(dtoContractType =>
            {
                var childCorporateSchemaContract = childCorporateSchemaContracts.Single(schemaContract =>
                    schemaContract.contractNumber == dtoContractType.contractNumber);

                childCorporateSchemaContract.TerminationContractAttrs.terminationDate = dtoContractType.TerminationDate;
                if (!string.IsNullOrEmpty(dtoContractType.TerminationReason))
                {
                    childCorporateSchemaContract.TerminationContractAttrs.ReasonForTermination =
                        (CorporateSchema.ReasonForTerminationType)Enum.Parse(
                            typeof(CorporateSchema.ReasonForTerminationType), dtoContractType.TerminationReason);
                }

                dtoContractType.contractAllocations.ForEach(dtoAllocation =>
                    {
                        var corpSchemaAllocation = childCorporateSchemaContract.contractAllocations.Single(a =>
                            a.contractAllocationNumber == dtoAllocation.contractAllocationNumber);

                        corpSchemaAllocation.allocationTerminationAttrs.stopNewStartsFromDate = dtoAllocation.StopNewStartsDate;
                        corpSchemaAllocation.allocationTerminationAttrs.newStartsSuspendedReason = dtoAllocation.NewStartsSuspendedReason;
                        corpSchemaAllocation.allocationTerminationAttrs.fundingCessationDate = dtoAllocation.FundingCessationDate;
                    });
            });
        }

        private static CorporateSchema.contractStatusTypeStatus MapStatus(string status)
        {
            return (CorporateSchema.contractStatusTypeStatus)Enum.Parse(typeof(CorporateSchema.contractStatusTypeStatus), status.Replace(" ", "").Replace("-", ""));
        }

        private static CorporateSchema.allocationOrganisationRelationships MapDeliveryOrgIfPresent(CorporateContract.contractAllocationsContractAllocation allocation)
        {
            CorporateSchema.allocationOrganisationRelationships allocationOrganisationRelationships = null;

            if (allocation.HasDeliveryOrganisation())
            {
                allocationOrganisationRelationships = new CorporateSchema.allocationOrganisationRelationships
                {
                    contractAllocationNumber = allocation.contractAllocationNumber,
                    RelationshipType = CorporateSchema.allocationOrganisationRelationshipType.DELIVERYORGANISATION,
                    Organisation = Mapper.Map<CorporateContract.contractor, CorporateSchema.contractor>(allocation.DeliveryOrganisationDetail)
                };
            }

            return allocationOrganisationRelationships;
        }
    }
}