namespace ADMonitoringDomain.Endpoint.BusinessLogic
{
    extern alias Entities;
    using SFA.FCT.AllocationDeliveryDomain.Common.DataStore.Model;
    using System.Linq;
    using System.Collections.Generic;
    using DataStore;
    using PaymentGenerationDomain.BusinessLogic;
    using SFA.FCT.PaymentManagementDomain.PaymentSchedule.DataStore;
    using Entities::SFA.FCT.CrossDomain.Integration.Entities;
    using SFA.FCT.AllocationDeliveryDomain.Common.DataStore;
    using Entities::SFA.FCT.CrossDomain.Integration.Entities.CorporatePaymentAggregation;
    using SFA.FCT.PaymentManagementDomain.PaymentSchedule.DataStore.Model;
    using Entities::SFA.FCT.CrossDomain.Integration.Entities.PaymentsAggregation;
    using SFA.FCT.CrossDomain.Integration.Events;
    using Allocation = Entities::SFA.FCT.CrossDomain.Integration.Entities.CorporatePaymentAggregation.Allocation;
    using ContractManagement.DataStore.Repositories;
    using ContractManagement.DataStore.Model;
    using Repositories;
    using Entities::SFA.FCT.CrossDomain.Integration.Entities.Data;

    public class AtomItemCreator : IAtomItemCreator
    {
        private string _uopCode;
        private readonly IDataAccessManager _paymentGenerationDataManager;
        private readonly IApprovedContractRepository _approvedContractRepository;
        private readonly IAllocationDeliverablePeriodActualAuditRepository _allocationDeliverablePeriodActualAuditRepository;

        public AtomItemCreator(
            IDataAccessManager paymentGenerationDataManager,
            IApprovedContractRepository approvedContractRepository,
            IAllocationDeliverablePeriodActualAuditRepository allocationDeliverablePeriodActualAuditRepository)
        {
            _paymentGenerationDataManager = paymentGenerationDataManager;
            _approvedContractRepository = approvedContractRepository;
            _allocationDeliverablePeriodActualAuditRepository = allocationDeliverablePeriodActualAuditRepository;
        }

        public string AllocationNumber { get; set; }

        public int ContractVersionNumber { get; set; }

        public AllocationDeliveryPerformance CreateAtomItem(string allocationNumber, int contractVersionNumber, ConnectionInfo connectionInfo)
        {
            AllocationNumber = allocationNumber;
            ContractVersionNumber = contractVersionNumber;

            ApprovedContract contract = _approvedContractRepository.GetContractForAllocationNumber(allocationNumber, connectionInfo);

            AllocationDeliveryPerformance allocationDeliveryPerformance = new AllocationDeliveryPerformance
            {
                AggregatedPaymentPeriods = GetAggregatedPaymentPeriods(connectionInfo),
                contractAllocationNumber = AllocationNumber,
                Contract = MapContract(contract),
                Contractor = MapContractor(contract.OrganisationId, contract.Ukprn),
                ScheduledPaymentPeriods = GetScheduledPaymentPeriods(connectionInfo),
                ActualsPeriods = GetActualsPeriodsForLatestReturnPeriod(connectionInfo),
                FundingStreamPeriod = GetFundingStreamPeriod(connectionInfo),
                ContractDeliverables = GetDeliverables(connectionInfo),
                UoPCode = _uopCode,
                allocationOrganisationRelationships = GetDeliveryOrganisation(contract.GetAllocationByNumber(allocationNumber))
            };

            return allocationDeliveryPerformance;
        }

        private List<AggregatedPaymentPeriodTYPE> GetAggregatedPaymentPeriods(ConnectionInfo connectionInfo)
        {
            Allocation allocation = GetCorporatePaymentAggregationAllocation(connectionInfo);

            return allocation?.AllocationPeriods?
                .Where(ap => ap.Aggregations.Any())
                .Select(ap => TransformAllocationPeriod(allocation.AllocationNumber, ap, allocation.FundingStreamPeriodCode, connectionInfo)).ToList();
        }

        private AggregatedPaymentPeriodTYPE TransformAllocationPeriod(string allocationNumber, AllocationPeriod allocationPeriod, string fundingStreamPeriodCode, ConnectionInfo connectionInfo)
        {
            Aggregation aggregation = allocationPeriod.Aggregations.First();
            return new AggregatedPaymentPeriodTYPE
            {
                PaymentPosted = _paymentGenerationDataManager.IsPaymentPosted(aggregation.SubnominalCode, aggregation.PaymentType, allocationNumber, fundingStreamPeriodCode, allocationPeriod.Period, connectionInfo),
                Period = allocationPeriod.Period,
                AggregatedPayment = TransformAggregations(allocationPeriod.Aggregations)
            };
        }

        private List<AggregatedPaymentTYPE> TransformAggregations(List<Aggregation> aggregations)
        {
            return aggregations.Select(TransformAggregation).ToList();
        }

        private AggregatedPaymentTYPE TransformAggregation(Aggregation aggregation)
        {
            AggregatedPaymentTYPE aggregatedPaymentType = new AggregatedPaymentTYPE
            {
                AggregatedValue = aggregation.AggregatedValue,
                PaymentTYPE = aggregation.PaymentType.GetPaymentTypeTYPE(),
                SubnominalCode = aggregation.SubnominalCode,
                Deliverables = aggregation.DeliverableDetails.Select(d => d.DeliverableCode).ToList()
            };

            return aggregatedPaymentType;
        }

        private Allocation GetCorporatePaymentAggregationAllocation(ConnectionInfo connectionInfo)
        {
            using (var context = new AllocationDeliveryMonitoringDbContext(connectionInfo))
            {
                var allocationDeliveryEventReceived = context.AllocationDeliveryEventsReceived.FirstOrDefault(
                    a => a.AllocationNumber == AllocationNumber
                         && a.VersionNumber == ContractVersionNumber
                         && a.EventName == typeof(PaymentAggregatedEvent).Name);

                if (allocationDeliveryEventReceived == null)
                {
                    allocationDeliveryEventReceived =
                        context.AllocationDeliveryEventsReceived.Where(
                            a =>
                                a.AllocationNumber == AllocationNumber &&
                                a.EventName == typeof(PaymentAggregatedEvent).Name)
                            .OrderByDescending(x => x.VersionNumber).ThenBy(x => x.EventReceived)
                            .FirstOrDefault();
                }

                if (allocationDeliveryEventReceived != null)
                {
                    allocationDeliveryEventReceived.Deserialize<PaymentAggregatedEvent>();
                    return ((PaymentAggregatedEvent)allocationDeliveryEventReceived.Object).Allocation;
                }

                return null;
            }
        }
        
        private contractReferenceTYPE MapContract(ApprovedContract contract)
        {
            return new contractReferenceTYPE
            {
                contractNumber = contract.ContractNumber,
                contractVersionNumber = contract.ContractVersionNumber,
                contractSubVersionNumber = contract.ContractSubVersionNumber
            };
        }

        private organisationReferenceTYPE MapContractor(string organisationId, int ukprn)
        {
            return new organisationReferenceTYPE
            {
                organisationIdentifier = organisationId,
                alternativeOrganisationIdentifiers = new organisationReferenceTYPEAlternativeOrganisationIdentifiers
                {
                    AlternativeOrganisationIdentifier = new alternativeOrganisationIdentifierTYPE
                    {
                        OrganisationIdentifierName = alternativeOrganisationIdentifierTYPEOrganisationIdentifierName.UKPROVIDERREFERENCENUMBER,
                        OrganisationIdentifier = ukprn.ToString()
                    }
                }
            };
        }

        private List<ScheduledPaymentsPeriodTYPE> GetScheduledPaymentPeriods(ConnectionInfo connectionInfo)
        {
            using (var context = new PaymentSchedulePolicyContext(connectionInfo))
            {
                var results = new List<DeliverablePayment>();

                var deliverablePayments = context.DeliverablePayments.Where(
                    a => a.AllocationNumber == AllocationNumber)
                    .OrderByDescending(x => x.VersionNumber);

                foreach (var deliverablePayment in deliverablePayments)
                {
                    if (results.Any(x => x.DeliverableCode == deliverablePayment.DeliverableCode && x.Period == deliverablePayment.Period))
                    {
                        continue;
                    }
                    results.Add(deliverablePayment);
                }

                return results.Any() ? AtomItemMapper.MapDeliverablePayments(results.AsQueryable()) : null;
            }
        }

        private AllocationDeliveryPerformanceFundingStreamPeriod GetFundingStreamPeriod(ConnectionInfo connectionInfo)
        {
            using (var context = new PaymentSchedulePolicyContext(connectionInfo))
            {
                var results =
                  context.Allocations.FirstOrDefault(a => a.AllocationNumber == AllocationNumber &&
                                                         a.ContractVersionNumber == ContractVersionNumber);

                return results != null ? AtomItemMapper.MapAllocationsForFspCode(results) : null;
            }
        }

        private AllocationDeliveryPerformanceActualsPeriods GetActualsPeriodsForLatestReturnPeriod(ConnectionInfo connectionInfo)
        {
            IReadOnlyCollection<AllocationDeliverablePeriodActualAudit> actuals =
                _allocationDeliverablePeriodActualAuditRepository.GetLatestCollectionReturn(AllocationNumber, connectionInfo);

            // The uop code lives on the audit table so we will grab it from there is necessary
            if (actuals.Any())
            {
                UpdateUopCodeIfNecessary(actuals);
                return AtomItemMapper.MapActualsForCollectionReturnPeriod(actuals.ToList());
            }

            return null;
        }

        private void UpdateUopCodeIfNecessary(
            IEnumerable<AllocationDeliverablePeriodActualAudit> allocationDeliverablePeriodActualAudits)
        {
            if (_uopCode == null)
            {
                _uopCode = allocationDeliverablePeriodActualAudits.FirstOrDefault()?.UopCode;
            }
        }

        public List<DeliverableTYPE> GetDeliverables(ConnectionInfo connectionInfo)
        {
            using (var context = new PaymentSchedulePolicyContext(connectionInfo))
            {
                var results = from d in context.DeliverablePayments
                              join a in context.Allocations on
                                  new { d.AllocationNumber, d.VersionNumber } equals
                                  new { a.AllocationNumber, a.VersionNumber }
                              where d.AllocationNumber == AllocationNumber && d.VersionNumber == ContractVersionNumber
                              select new
                              {
                                  a.FundingStreamPeriodCode,
                                  a.ContractNumber,
                                  a.ContractVersionNumber,
                                  d.DeliverableCode,
                                  d.PlannedValue,
                                  d.PlannedVolume,
                                  d.Period
                              };

                var resultsJoin = results.ToList().Select(r => new DeliverablePeriodSummary
                {
                    FundingStreamPeriodDeliverable = GetFsc(r.FundingStreamPeriodCode, r.DeliverableCode, connectionInfo),
                    FundingStreamPeriodCode = r.FundingStreamPeriodCode,
                    ContractNumber = r.ContractNumber,
                    ContractVersionNumber = r.ContractVersionNumber,
                    DeliverableCode = r.DeliverableCode,
                    Period = r.Period,
                    PlannedValue = r.PlannedValue,
                    PlannedVolumne = r.PlannedVolume
                });

                var resultsCombined = resultsJoin.ToList().Distinct();

                return resultsCombined.Any() ? AtomItemMapper.MapDeliverablesTypes(resultsCombined) : null;
            }
        }

        private FundingStreamPeriodDeliverable GetFsc(string fundingStreamPeriodCode, int deliverableCode, ConnectionInfo connectionInfo)
        {
            using (var context = new MonitoringDeliverablesDbContext(connectionInfo))
            {
                var results =
                    context.FundingStreamPeriodDeliverables.FirstOrDefault(
                        a => a.FundingStreamPeriodCode == fundingStreamPeriodCode && a.DeliverableCode == deliverableCode);
                return results;
            }
        }

        private allocationOrganisationRelationshipsTYPE GetDeliveryOrganisation(ApprovedContractAllocation allocation)
        {
            allocationOrganisationRelationshipsTYPE deliveryOrg = null;

            if (allocation.HasDeliveryOrg())
            {
                deliveryOrg = new allocationOrganisationRelationshipsTYPE
                {
                    contractAllocationNumber = AllocationNumber,
                    Organisation = new organisationReferenceTYPE
                    {
                        organisationIdentifier = allocation.DeliveryOrganisationId,
                        alternativeOrganisationIdentifiers = new organisationReferenceTYPEAlternativeOrganisationIdentifiers
                        {
                            AlternativeOrganisationIdentifier = new alternativeOrganisationIdentifierTYPE
                            {
                                OrganisationIdentifierName = alternativeOrganisationIdentifierTYPEOrganisationIdentifierName.UKPROVIDERREFERENCENUMBER,
                                OrganisationIdentifier = allocation.DeliveryOrganisationUkprn.ToString()
                            }
                        }
                    },
                    RelationshipType = organisationRelationshipTYPE.DELIVERYORGANISATION
                };
            }

            return deliveryOrg;
        }
    }
}
