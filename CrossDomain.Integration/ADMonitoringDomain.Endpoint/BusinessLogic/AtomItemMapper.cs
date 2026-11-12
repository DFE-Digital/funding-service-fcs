namespace ADMonitoringDomain.Endpoint.BusinessLogic
{
    extern alias Entities;
    using AutoMapper;
    using SFA.FCT.PaymentManagementDomain.PaymentSchedule.DataStore.Model;
    using System.Collections.Generic;
    using System.Linq;
    using Entities::SFA.FCT.CrossDomain.Integration.Entities;
    using SFA.FCT.AllocationDeliveryDomain.Common.DataStore.Model;
    using Microsoft.Extensions.Logging;

    public static class AtomItemMapper
    {
        private static readonly Lazy<IMapper> _mapper = new Lazy<IMapper>(() =>
        {           
            var expr = new MapperConfigurationExpression();
            expr.AddProfile(new AutoProfile());
            ILoggerFactory loggerFactory = null;
            var config = new MapperConfiguration(expr, loggerFactory);

            return config.CreateMapper();
        });


        private static IMapper Mapper => _mapper.Value;

        // === Your original methods, now static and using the mapper instance ===

        public static contractReferenceTYPE MapAllocations(Allocation allocation)
        {
            // null-checks are optional but often helpful in shared utilities
            if (allocation == null) return null;
            return Mapper.Map<contractReferenceTYPE>(allocation);
        }

        public static AllocationDeliveryPerformanceFundingStreamPeriod MapAllocationsForFspCode(Allocation allocation)
        {
            if (allocation == null) return null;
            return Mapper.Map<AllocationDeliveryPerformanceFundingStreamPeriod>(allocation);
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
