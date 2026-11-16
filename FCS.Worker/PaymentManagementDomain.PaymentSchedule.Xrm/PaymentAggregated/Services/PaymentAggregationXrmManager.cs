namespace PaymentManagementDomain.PaymentSchedule.PaymentAggregated.Services
{
    extern alias IntegrationEntities;
    using System;
    using System.Collections.Generic;
    using System.Globalization;
    using System.Linq;
    using System.Threading;
    using Microsoft.Xrm.Sdk;
    using Microsoft.Xrm.Sdk.Messages;
    using Repositories;
    using SFA.FCT.CrossDomain.Integration.Common.Extensions;
    using IntegrationEntities::SFA.FCT.CrossDomain.Integration.Entities.CorporatePaymentAggregation;
    using IntegrationEntities::SFA.FCT.CrossDomain.Integration.Entities.Xrm;
    using IntegrationEntities::SFA.FCT.CrossDomain.Integration.Entities.Xrm.OptionSets;
    using SFA.FCT.Framework.Logging.Interfaces;
    using SFA.FCT.PaymentManagementDomain.BusinessLogic.DTOs;

    /// <summary>
    /// This class creates a 'Sub Nominal' for each 'Deliverable Period' and associates it with the contract allocation and contract deliverable period.
    /// </summary>
    public class PaymentAggregationXrmManager : IPaymentAggregationXrmManager
    {
        private readonly ISubnominalAggregationRepository _subnominalAggregationRepository;
        private readonly IFundingStreamPeriodRepository _fundingStreamPeriodRepository;
        private readonly IOrganisationRepository _organisationRepository;

        public PaymentAggregationXrmManager(
            IOrganizationService organizationService,
            ISubnominalAggregationRepository subnominalAggregationRepository,
            IFundingStreamPeriodRepository fundingStreamPeriodRepository,
            IOrganisationRepository organisationRepository)
        {
            this.OrganizationService = organizationService;
            _subnominalAggregationRepository = subnominalAggregationRepository;
            _fundingStreamPeriodRepository = fundingStreamPeriodRepository;
            _organisationRepository = organisationRepository;
        }

        /// <summary>
        /// Gets or sets the logger to write logs out to 'N-Service' Bus host.
        /// </summary>
        public ILogger Logger { get; set; }

        /// <summary>
        /// Gets or sets access to the metadata and data for an organization
        /// </summary>
        private IOrganizationService OrganizationService { get; set; }

        /// <summary>
        /// Creates a "Sub nominal" record in CRM, then queries CRM to get the associated allocation and deliverable periods and associates the created "Sub nominal" to each.
        /// </summary>
        /// <param name="allocation">Allocation object is passed into this method called from the handler to create 'Sub nominal' in CRM.</param>
        /// <param name="allDeliverablePeriodResults">A collection of Contract Deliverable Periods as found in CRM for a given Allocation</param>
        public void SavePaymentAggregation(Allocation allocation, IReadOnlyCollection<ContractDeliverablePeriodInfo> allDeliverablePeriodResults)
        {
            CultureInfo cultureInfo = Thread.CurrentThread.CurrentCulture;
            TextInfo textInfo = cultureInfo.TextInfo;

            Guid relatedContractAllocationId = allDeliverablePeriodResults.Select(dp => dp.Contractallocation.Id).Distinct().Single();

            IReadOnlyCollection<sfa_subnominalaggregation> relatedSubnominalAggregations = _subnominalAggregationRepository.GetSubnominalsRelatedToSubnominalCodesAndAggregateKeys(
                subnominalCodes: allocation.GetDistinctSubnominalCodes(),
                aggregateKeys: allocation.GetDistinctAggregateKeys());

            Guid providerEntityId = _organisationRepository.GetOrganisationEntityId(allocation.Organisation.GetUkprn());
            var providerEntityReference = new EntityReference("account", providerEntityId);

            var missingSubnominalsJustCreated = CreateMissingSubnominals(relatedSubnominalAggregations, allocation, providerEntityReference);
            var subnominalsInCrmBefore = relatedSubnominalAggregations.ToDictionary(GetSubnominalAggKeyForEntity);
            var subnominalsNewToCrm = missingSubnominalsJustCreated.ToDictionary(GetSubnominalAggKeyForEntity);

            bool HasSubnominalJustBeenCreated(string aggregateKey, int paymentType) => subnominalsNewToCrm.ContainsKey(GetSubnominalAggKey(aggregateKey, paymentType));

            using (XrmServiceContext context = new XrmServiceContext(this.OrganizationService))
            {
                var subnominalToAllocationIds = new List<SubnominalAggregationAllocation>();

                var requestToUpdateCrmRecords = new ExecuteTransactionRequest()
                {
                    Requests = new OrganizationRequestCollection(),
                    ReturnResponses = true
                };

                foreach (AllocationPeriod a in allocation.AllocationPeriods)
                {
                    foreach (Aggregation aggregation in a.Aggregations)
                    {
                        int monthNumber = int.Parse(a.Period.Substring(4, 2));
                        string monthName = new DateTime(2010, monthNumber, 1).ToString("MMM",
                            CultureInfo.InvariantCulture);
                        string paymentPeriod = monthName + "-" + a.Period.Substring(2, 2);

                        int paymentType = (int)Enum.Parse(typeof(sfa_paymenttype), textInfo.ToTitleCase(aggregation.PaymentType.ToString().ToLower()));
                        var aggregateKey = $"{aggregation.SubnominalCode}_{allocation.AllocationNumber}_{paymentPeriod}";

                        IReadOnlyCollection<ContractDeliverablePeriodInfo> deliverablePeriodResults =
                                aggregation.DeliverableDetails.Select(
                                    dd => allDeliverablePeriodResults.SingleOrDefault(dp => dp.DeliverableCode == dd.DeliverableCode.ToString() &&
                                    dp.PeriodName == paymentPeriod)).ToList();
                        Guid subnominalId = Guid.Empty;
                        if (HasSubnominalJustBeenCreated(aggregateKey, paymentType))
                        {
                            // create cdp relationships if we can
                            var subnominal = subnominalsNewToCrm[GetSubnominalAggKey(aggregateKey, paymentType)];
                            if (deliverablePeriodResults.Any(dpr => dpr == null))
                            {
                                // we have a missing deliverablePeriod we can retry later
                                throw new ArgumentException(
                                    $"Cannot create Subnominal Aggregaration as one or more deliverable periods are missing for Allocation: {allocation.AllocationNumber}");
                            }

                            var updateRequests = CreateCdpRelationshipUpdateRequests(
                                subnominalAggregationGuid: subnominal.Id,
                                context: context,
                                deliverablePeriodResults: deliverablePeriodResults,
                                paymentType: aggregation.PaymentType.ToString());
                            subnominalId = subnominal.Id;

                            requestToUpdateCrmRecords.Requests.AddRange(updateRequests);
                        }
                        else
                        {
                            var subnominal = subnominalsInCrmBefore[GetSubnominalAggKey(aggregateKey, paymentType)];
                            // Subnominal record already exists - update value
                            decimal? previousAggregatedValue = subnominal.sfa_AggregatedValue;
                            subnominal.sfa_AggregatedValue = aggregation.AggregatedValue;

                            var deliverablePeriodsRelatedToSubnominals = deliverablePeriodResults.Where(dpr => !dpr.IsRelationShipToSubnominalSet(aggregation.PaymentType))
                                .Select(dpr => AssociateSubnominalToDeliverablePeriod(dpr.Contractdeliverableperiod,
                                subnominal.Id,
                                aggregation.PaymentType.ToString(),
                                context))
                                .Where(cdp => cdp != null)
                                .ToList();

                            var contractDeliverablePeriodsGroupedByDeliverable =
                                deliverablePeriodsRelatedToSubnominals.GroupBy(cdp => cdp.sfa_ContractDeliverableId.Id);

                            contractDeliverablePeriodsGroupedByDeliverable.ToList().ForEach(g =>
                            {
                                sfa_contractdeliverable deliverable = new sfa_contractdeliverable
                                {
                                    Id = g.Key,
                                    sfa_contractdeliverable_deliverableperiod = g
                                };
                                var updateRequest = new UpdateRequest { Target = deliverable };
                                requestToUpdateCrmRecords.Requests.Add(updateRequest);
                            });

                            if (previousAggregatedValue != subnominal.sfa_AggregatedValue)
                            {
                                var updateRequest = new UpdateRequest { Target = subnominal };
                                requestToUpdateCrmRecords.Requests.Add(updateRequest);
                            }

                            subnominalId = subnominal.Id;
                        }

                        subnominalToAllocationIds.Add(new SubnominalAggregationAllocation(subnominalId, relatedContractAllocationId));
                    }
                }
                OrganizationService.Execute(requestToUpdateCrmRecords);

                // find existing related subnominals
                IReadOnlyCollection<sfa_subnominalaggregation> relatedSubnominals = _subnominalAggregationRepository.GetSubnominalsRelatedToAllocationId(relatedContractAllocationId);

                var requestToAssociateRecords = new ExecuteTransactionRequest()
                {
                    Requests = new OrganizationRequestCollection(),
                    ReturnResponses = true
                };

                foreach (var association in subnominalToAllocationIds)
                {
                    if (!relatedSubnominals.Select(rs => rs.Id).Contains(association.SubnominalAggregationId))
                    {
                        // this is not related so relate it
                        var associateRequest = AssociateToContractAllocation(association.AllocationId, association.SubnominalAggregationId);
                        requestToAssociateRecords.Requests.Add(associateRequest);
                    }
                }

                context.Execute(requestToAssociateRecords);
            }
        }

        private static string GetSubnominalAggKeyForEntity(sfa_subnominalaggregation subnominalaggregation)
        {
            return GetSubnominalAggKey(subnominalaggregation.sfa_SubnominalAggregateKey, subnominalaggregation.sfa_PaymentType.Value);
        }

        private static string GetSubnominalAggKey(string subnominalAggKey, int paymentType)
        {
            return $"{subnominalAggKey}_{paymentType}";
        }

        private IReadOnlyCollection<sfa_subnominalaggregation> CreateMissingSubnominals(IReadOnlyCollection<sfa_subnominalaggregation> relatedSubnominalAggregations, Allocation allocation, EntityReference providerEntityRef)
        {
            CultureInfo cultureInfo = Thread.CurrentThread.CurrentCulture;
            TextInfo textInfo = cultureInfo.TextInfo;
            var requestToInsertRecords = new ExecuteTransactionRequest()
            {
                Requests = new OrganizationRequestCollection(),
                ReturnResponses = true
            };

            var aggregationsCreated = allocation.AllocationPeriods.SelectMany(ap =>
            {
                return ap.Aggregations.Select(agg =>
                {
                    int monthNumber = int.Parse(ap.Period.Substring(4, 2));
                    string monthName = new DateTime(2010, monthNumber, 1).ToString("MMM",
                        CultureInfo.InvariantCulture);
                    string paymentPeriod = monthName + "-" + ap.Period.Substring(2, 2);
                    var aggregateKey = $"{agg.SubnominalCode}_{allocation.AllocationNumber}_{paymentPeriod}";
                    int paymentType = (int)Enum.Parse(typeof(sfa_paymenttype), textInfo.ToTitleCase(agg.PaymentType.ToString().ToLower()));
                    if (relatedSubnominalAggregations.None(sa => sa.sfa_SubnominalAggregateKey == aggregateKey && sa.sfa_PaymentType.Value == paymentType))
                    {
                        return CreateSubnominal(aggregateKey, agg, ap.PeriodTypeCode, paymentPeriod,
                            allocation.FundingStreamPeriodCode, providerEntityRef);
                    }

                    return null;
                });
            }).Where(a => a != null).ToList();

            var requests = aggregationsCreated.Select(agg => new UpsertRequest
            {
                Target = agg
            }).ToList();

            requestToInsertRecords.Requests.AddRange(requests);

            OrganizationService.Execute(requestToInsertRecords);

            return aggregationsCreated;
        }

        private IReadOnlyCollection<UpdateRequest> CreateCdpRelationshipUpdateRequests(
            Guid subnominalAggregationGuid,
            XrmServiceContext context,
            IReadOnlyCollection<ContractDeliverablePeriodInfo> deliverablePeriodResults,
            string paymentType)
        {
            
            var deliverablePeriodsRelatedToSubnominals = deliverablePeriodResults.Select(
                dpr => AssociateSubnominalToDeliverablePeriod(dpr.Contractdeliverableperiod,
                    subnominalAggregationGuid,
                    paymentType,
                    context)).Where(cdp => cdp != null).ToList();

            var contractDeliverablePeriodsGroupedByDeliverable =
                deliverablePeriodsRelatedToSubnominals.GroupBy(cdp => cdp.sfa_ContractDeliverableId.Id);

            return contractDeliverablePeriodsGroupedByDeliverable.ToList().Select(g =>
            {
                var deliverable = new sfa_contractdeliverable
                {
                    Id = g.Key,
                    sfa_contractdeliverable_deliverableperiod = g
                };

                return new UpdateRequest { Target = deliverable };

            }).ToList();
        }

        private sfa_subnominalaggregation CreateSubnominal(
            string aggregateKey,
            Aggregation aggregation,
            AllocationPeriodPeriodTypeCode periodTypeCode,
            string paymentPeriod,
            string fundingStreamPeriodCode,
            EntityReference providerEntityReference)
        {
            var subnominal = new sfa_subnominalaggregation
            {
                Id = Guid.NewGuid(),
                sfa_name = aggregation.SubnominalCode,
                sfa_SubnominalAggregateKey = aggregateKey,
                sfa_SubnominalCode = aggregation.SubnominalCode,
                sfa_PaymentType = new OptionSetValue(
                    (int)Enum.Parse(typeof(sfa_paymenttype),
                    Thread.CurrentThread.CurrentCulture.TextInfo.ToTitleCase(aggregation.PaymentType.ToString().ToLower()))),
                sfa_AggregatedValue = aggregation.AggregatedValue,
                sfa_Period = paymentPeriod,
                sfa_PeriodTypeCode = periodTypeCode.ToString(),
                sfa_fundingstreamperiod = _fundingStreamPeriodRepository.GetFundingStreamPeriod(fundingStreamPeriodCode),
                sfa_provider = providerEntityReference
            };

            return subnominal;
        }

        /// <summary>
        /// Associates the deliverable period to a Sub nominal aggregate
        /// </summary>
        /// <param name="deliverablePeriod"> deliverable period</param>
        /// <param name="subnominalAggregationId"></param>
        /// <param name="paymentType">payment type such as Profile, Capping, Balancing, Reconciliation</param>
        /// <param name="context"></param>
        /// <param name="subnominalAggre"> sub nominal aggregate</param>
        private sfa_contractdeliverableperiod AssociateSubnominalToDeliverablePeriod(sfa_contractdeliverableperiod deliverablePeriod, Guid subnominalAggregationId, string paymentType, XrmServiceContext xrmContext)
        {
            if (deliverablePeriod != null)
            {
                sfa_contractdeliverableperiod targetDeliverablePeriod = new sfa_contractdeliverableperiod();
                targetDeliverablePeriod.sfa_ContractDeliverableId = deliverablePeriod.sfa_ContractDeliverableId;
                targetDeliverablePeriod.sfa_contractdeliverableperiodId =
                    deliverablePeriod.sfa_contractdeliverableperiodId;
                targetDeliverablePeriod.Id = new Guid(deliverablePeriod.sfa_contractdeliverableperiodId.ToString());

                switch (paymentType)
                {
                    case "PROFILE":
                        targetDeliverablePeriod.sfa_profilesubnominal =
                            new EntityReference(sfa_subnominalaggregation.EntityLogicalName, subnominalAggregationId);
                        break;
                    case "RECONCILIATION":
                        targetDeliverablePeriod.sfa_reconciliationsubnominal =
                            new EntityReference(sfa_subnominalaggregation.EntityLogicalName, subnominalAggregationId);
                        break;
                    case "CAPPING":
                        targetDeliverablePeriod.sfa_CappingSubnominal =
                            new EntityReference(sfa_subnominalaggregation.EntityLogicalName, subnominalAggregationId);
                        break;
                }

                //xrmContext.Attach(targetDeliverablePeriod);
                //xrmContext.UpdateObject(targetDeliverablePeriod);
                return targetDeliverablePeriod;
            }

            return null;
        }

        /// <summary>
        /// Joins the contract allocation with the sub nominal aggregate entity.
        /// </summary>
        /// <param name="allocationId">The contract allocation to associate the sub nominal to</param>
        /// <param name="subnominalAggregationId">Sub nominal aggregate to associate to the allocation</param>
        /// <param name="context"></param>
        private static AssociateRequest AssociateToContractAllocation(Guid allocationId, Guid subnominalAggregationId)
        {
            return new AssociateRequest
            {
                Target =
                    new EntityReference(
                        sfa_subnominalaggregation.EntityLogicalName,
                        subnominalAggregationId),
                RelatedEntities = new EntityReferenceCollection
                {
                    new EntityReference(
                        sfa_contractallocation.EntityLogicalName,
                        allocationId)
                },
                Relationship = new Relationship("sfa_sfa_subnominalaggregation_sfa_contractall")
            };
        }

        private class SubnominalAggregationAllocation
        {
            public SubnominalAggregationAllocation(Guid subnominalAggregationId, Guid allocationId)
            {
                this.SubnominalAggregationId = subnominalAggregationId;
                AllocationId = allocationId;
            }

            public Guid SubnominalAggregationId { get; }

            public Guid AllocationId { get; }
        }
    }
}
