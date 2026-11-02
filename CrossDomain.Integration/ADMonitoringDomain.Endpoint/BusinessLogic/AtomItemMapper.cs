namespace ADMonitoringDomain.Endpoint.BusinessLogic
{
    using AutoMapper;
    using SFA.FCT.PaymentManagementDomain.PaymentSchedule.DataStore.Model;
    using System.Collections.Generic;
    using System.Linq;
    using SFA.FCT.CrossDomain.Integration.Entities;
    using SFA.FCT.AllocationDeliveryDomain.Common.DataStore.Model;

    public static class AtomItemMapper
    {
        public static contractReferenceTYPE MapAllocations(Allocation allocations)
        {
            Mapper.CreateMap<Allocation, contractReferenceTYPE>()
                .ForMember(dest => dest.contractNumber, opt => opt.MapFrom(src => src.ContractNumber))
                .ForMember(dest => dest.contractVersionNumber, opt => opt.MapFrom(src => src.ContractVersionNumber));

            return Mapper.Map<Allocation, contractReferenceTYPE>(allocations);
        }

        public static organisationReferenceTYPE MapOrganisationIdentifiers(OrganisationIdentifer results)
        {
            organisationReferenceTYPE contractor = new organisationReferenceTYPE
            {
                organisationIdentifier = results.MainOrganisationIdentifier,
                alternativeOrganisationIdentifiers = new organisationReferenceTYPEAlternativeOrganisationIdentifiers
                {
                    AlternativeOrganisationIdentifier = new alternativeOrganisationIdentifierTYPE { OrganisationIdentifier = results.OrganisationId }
                }
            };

            return contractor;
        }

        public static List<ScheduledPaymentsPeriodTYPE> MapDeliverablePayments(IQueryable<DeliverablePayment> results)
        {
            List<ScheduledPaymentsPeriodTYPE> scheduledPaymentsPeriodTypes = new List<ScheduledPaymentsPeriodTYPE>();
            
            var queryGrp = (from r in results
                            group r by r.Period
                                into newGroup
                                orderby newGroup.Key
                                select newGroup).ToList();

            foreach (var nameGroup in queryGrp)
            {
                ScheduledPaymentsPeriodTYPE scheduledPaymentsPeriodType = new ScheduledPaymentsPeriodTYPE();

                List<ScheduledPaymentTYPE> scheduledPaymentTypes = nameGroup.Select(item => new ScheduledPaymentTYPE
                {
                    BalancingPayment = item.BalancingPaymentAmount ?? 0,
                    CappingPayment = item.CappedPaymentAmount ?? 0,
                    DeliverableCode = item.DeliverableCode,
                    NetPayment = item.NetPaymentAmount,
                    ProfilePayment = item.ProfilePaymentAmount ?? 0,
                    ReconciliationPayment = item.ReconciliationPaymentAmount ?? 0
                }).ToList();

                scheduledPaymentsPeriodType.Period = nameGroup.Key;
                scheduledPaymentsPeriodType.ScheduledPayment = scheduledPaymentTypes;
                scheduledPaymentsPeriodTypes.Add(scheduledPaymentsPeriodType);
            }
            
            return scheduledPaymentsPeriodTypes;
        }

        public static AllocationDeliveryPerformanceActualsPeriods MapActualsForCollectionReturnPeriod(IReadOnlyCollection<AllocationDeliverablePeriodActualAudit> audits)
        {
            return new AllocationDeliveryPerformanceActualsPeriods
            {
                CollectionReturnCode = audits.First().CollectionReturnCode,
                ActualsPeriod =
                    audits
                    .GroupBy(a => a.Period)
                    .Select(g => new ActualsPeriodTYPE
                    {
                        Period = g.Key,
                        Actual = g.Select(a => new ActualTYPE
                        {
                            DeliverableCode = a.DeliverableCode,
                            ActualValue = (decimal)a.ActualValue,
                            ActualVolume = (int)a.ActualVolume
                        }).ToList()
                    }).ToList()
            };
        }

        public static AllocationDeliveryPerformanceFundingStreamPeriod MapAllocationsForFspCode(Allocation allocations)
        {
            Mapper.CreateMap<Allocation, AllocationDeliveryPerformanceFundingStreamPeriod>()
                .ForMember(dest => dest.FundingStreamPeriodCode, opt => opt.MapFrom(src => src.FundingStreamPeriodCode));

            return Mapper.Map<Allocation, AllocationDeliveryPerformanceFundingStreamPeriod>(allocations);
        }

        public static List<DeliverableTYPE> MapDeliverablesTypes(IEnumerable<DeliverablePeriodSummary> results)
        {
            List<DeliverableTYPE> deliverableTypes = new List<DeliverableTYPE>();

            var groupQuery = results.GroupBy(r => r.DeliverableCode);

            foreach (var group in groupQuery)
            {
                DeliverablePeriodSummary firstItem = group.First();
                DeliverableTYPE deliverableType = new DeliverableTYPE
                {
                    isLegal = firstItem.FundingStreamPeriodDeliverable?.AllowProfile ?? true,
                    isMonitoring = firstItem.FundingStreamPeriodDeliverable != null,
                    DeliverableCode = firstItem.DeliverableCode,
                    ContractDeliverablePeriods = group.Select(MapDeliverablePeriod).ToList()
                };
                
                deliverableTypes.Add(deliverableType);    
            }

            return deliverableTypes;
        }

        private static DeliverablePeriodTYPE MapDeliverablePeriod(DeliverablePeriodSummary deliverablePeriodSummary)
        {
            return new DeliverablePeriodTYPE
            {
                Period = deliverablePeriodSummary.Period,
                PlannedValue = deliverablePeriodSummary.PlannedValue.GetValueOrDefault(),
                PlannedVolume = deliverablePeriodSummary.PlannedVolumne.GetValueOrDefault()
            };
        }
    }
}
