namespace ADMonitoringDomain.Endpoint.BusinessLogic
{
    using System;
    using System.Collections.Generic;
    using System.Linq;
    using System.Xml.Schema;
    using Castle.Core.Internal;
    using ContractManagement.DataStore.Model;
    using ContractManagement.DataStore.Repositories;
    using Logging;
    using SFA.FCT.CrossDomain.Integration.Entities;
    using SFA.FCT.CrossDomain.Integration.Entities.CorporatePaymentAggregation;
    using SFA.FCT.CrossDomain.Integration.Entities.DeliveryAllocation;
    using SFA.FCT.CrossDomain.Integration.Events;
    using SFA.FCT.Framework.Logging.Interfaces;
    using SFA.FCT.CrossDomain.Integration.Common.SchemaValidator;
    using SFA.FCT.CrossDomain.Integration.Common.Serializers;
    using SFA.FCT.CrossDomain.Integration.Entities.Data;

    public class AllocationDeliveryPerformanceMapper : IAllocationDeliveryPerformanceMapper
    {
        private readonly IApprovedContractRepository _approvedContractRepository;

        public AllocationDeliveryPerformanceMapper(IApprovedContractRepository approvedContractRepository)
        {
            _approvedContractRepository = approvedContractRepository;
        }

        public ILogger Logger { get; set; }
        public ISchemaValidator SchemaValidator{ get; set; }

        private const string AssemblyName = "CrossDomain.Integration.Entities.dll";
        private const string EmbeddedResourceName = "SFA.FCT.CrossDomain.Integration.Entities.AllocationDeliveryPerformance.allocation-delivery-performance-schema.xsd";
        private const string SchemaNamespace = "urn:sfa:schemas:allocation-delivery-performance";

        public AllocationDeliveryPerformance Map(AllocationDeliveryCommencedEvent adCommencedEvent, ConnectionInfo connectionInfo)
        {
            return Map(adCommencedEvent, paymentScheduleEvent: null, paymentAggregatedEvent: null, connectionInfo);
        }
        
        public AllocationDeliveryPerformance Map(AllocationDeliveryCommencedEvent adCommencedEvent, PaymentScheduleEvent paymentScheduleEvent, PaymentAggregatedEvent paymentAggregatedEvent,
            ConnectionInfo connectionInfo)
        {
            var adPerformance = new AllocationDeliveryPerformance();
            Map(adCommencedEvent, adPerformance, connectionInfo);

            if (paymentScheduleEvent!= null) MergePaymentScheduleToAllocationDeliveryPerformance(paymentScheduleEvent, adPerformance);

            if (paymentAggregatedEvent != null) MergeAggregatedPaymentsToAllocationDeliveryPerformance(paymentAggregatedEvent, adPerformance);

            string xml = adPerformance.SerializeToXml();
            var validationResult = SchemaValidator.ValidateAgainstSchema(AssemblyName, EmbeddedResourceName, SchemaNamespace, xml);

            if (!validationResult.IsValid)
                throw new XmlSchemaValidationException("Allocation Delivery Performance Xml Validation has failed",
                    new Exception(string.Join(",", validationResult.ValidationErrors)));

            return adPerformance;
        }

        private void Map(AllocationDeliveryCommencedEvent adCommencedEvent, AllocationDeliveryPerformance adPerformance, ConnectionInfo connectionInfo)
        {
            try
            {
                var allocation = adCommencedEvent.Allocation;

                adPerformance.contractAllocationNumber = allocation.contractAllocationNumber;
                adPerformance.UoPCode = allocation.uopCode;
                adPerformance.AllocationPeriodTypeCode = (periodTypeCodeLIST)Enum.Parse(
                    typeof(periodTypeCodeLIST),
                    allocation.fundingStreamPeriod.period.periodType1.periodTypeCode.ToString());

                adPerformance.FundingStreamPeriod = new AllocationDeliveryPerformanceFundingStreamPeriod
                {
                    FundingStreamPeriodCode = allocation.fundingStreamPeriod.fundingStreamPeriodCode
                };

                adPerformance.Contract = new contractReferenceTYPE
                {
                    contractNumber = allocation.contractReference.contractNumber,
                    contractVersionNumber = allocation.contractReference.contractVersionNumber,
                    contractSubVersionNumber = 0 // sub-version is for FCS internal use only
                };

                adPerformance.ContractDeliverables = allocation.contractDeliverables.Select(MapDeliverables).ToList();
                ApprovedContract appovedContract = _approvedContractRepository.GetContractForAllocationNumber(allocation.contractAllocationNumber, connectionInfo);
                
                adPerformance.Contractor = MapOrganisationReference(appovedContract.Ukprn, appovedContract.OrganisationId);

                ApprovedContractAllocation approvedAllocation =
                    appovedContract.ApprovedContractAllocations.Single(a =>
                        a.ContractAllocationNumber == allocation.contractAllocationNumber);

                adPerformance.allocationOrganisationRelationships = MapToAllocationOrgRelationshipType(
                    approvedAllocation.ContractAllocationNumber,
                    approvedAllocation.DeliveryOrganisationUkprn,
                    approvedAllocation.DeliveryOrganisationId);
            }
            catch (Exception e)
            {
                Logger.LogError(AdMonitoringDomainEventLoggingId.MappingError, e, "Error mapping AllocationDeliveryCommencedEvent to AllocationDeliveryPerformance. Allocation no: {0}",
                    adCommencedEvent?.Allocation?.contractAllocationNumber ?? "null");
                throw;
            }
        }

        private static allocationOrganisationRelationshipsTYPE MapToAllocationOrgRelationshipType(string allocationNumber, int? deliveryOrganisationUkprn, string deliveryOrganisationId)
        {
            if (deliveryOrganisationUkprn.HasValue)
            {
                return new allocationOrganisationRelationshipsTYPE
                {
                    contractAllocationNumber = allocationNumber,
                    Organisation = new organisationReferenceTYPE
                    {
                        alternativeOrganisationIdentifiers =
                            new organisationReferenceTYPEAlternativeOrganisationIdentifiers
                            {
                                AlternativeOrganisationIdentifier = new alternativeOrganisationIdentifierTYPE
                                {
                                    OrganisationIdentifier = deliveryOrganisationUkprn.ToString(),
                                    OrganisationIdentifierName =
                                        alternativeOrganisationIdentifierTYPEOrganisationIdentifierName
                                            .UKPROVIDERREFERENCENUMBER
                                },
                            },
                        organisationIdentifier = deliveryOrganisationId
                    },

                    RelationshipType = organisationRelationshipTYPE.DELIVERYORGANISATION
                };
            }

            return new allocationOrganisationRelationshipsTYPE();
        }

        private void MergePaymentScheduleToAllocationDeliveryPerformance(PaymentScheduleEvent paymentScheduleEvent, AllocationDeliveryPerformance adPerformance)
        {
            adPerformance.ScheduledPaymentPeriods = new List<ScheduledPaymentsPeriodTYPE>();

            try
            {
                // Get all payments for all deliverables
                var payments =
                    paymentScheduleEvent.PaymentScheduleAllocation.AllocationDeliverables.SelectMany(
                        d => d.ScheduledPayments, (d, p) => new
                        {
                            // ReSharper disable once RedundantAnonymousTypePropertyName
                            DeliverableCode = d.DeliverableCode,
                            Payment = p
                        });
                //// Group payments by period
                payments.GroupBy(sp => sp.Payment.Period).ToList().ForEach(pgroup =>
                {
                    //// Create a new period for each group
                    var paymentPeriod = new ScheduledPaymentsPeriodTYPE
                    {
                        Period = pgroup.Key,
                        ScheduledPayment = new List<ScheduledPaymentTYPE>()
                    };
                    //// And add payments to the group
                    pgroup.ToList().ForEach(sp => paymentPeriod.ScheduledPayment.Add(new ScheduledPaymentTYPE
                    {
                        BalancingPayment = sp.Payment.BalancingPaymentAmount.GetValueOrDefault(),
                        CappingPayment = sp.Payment.CappedPaymentAmount.GetValueOrDefault(),
                        NetPayment = sp.Payment.NetPaymentAmount,
                        ProfilePayment = sp.Payment.ProfilePaymentAmount.GetValueOrDefault(),
                        ReconciliationPayment = sp.Payment.ReconciliationPaymentAmount.GetValueOrDefault(),
                        DeliverableCode = sp.DeliverableCode
                    }));

                    //// Add all the periods and payments to the target event
                    adPerformance.ScheduledPaymentPeriods.Add(paymentPeriod);
                });

              
            }
            catch (Exception e)
            {
                Logger.LogError(AdMonitoringDomainEventLoggingId.MappingError, e, "Error mapping PaymentScheduleEvent to AllocationDeliveryPerformance. Allocation no: {0}",
                    paymentScheduleEvent != null && paymentScheduleEvent.PaymentScheduleAllocation != null
                    && paymentScheduleEvent.PaymentScheduleAllocation.AllocationNumber != null
                    ? paymentScheduleEvent.PaymentScheduleAllocation.AllocationNumber
                    : "null");
                throw;
            }
        }

        private void MergeAggregatedPaymentsToAllocationDeliveryPerformance(PaymentAggregatedEvent paymentAggregatedEvent, AllocationDeliveryPerformance adPerformance)
        {

            try
            {
                adPerformance.AggregatedPaymentPeriods = new List<AggregatedPaymentPeriodTYPE>();
                
                //// Get periodtypecode for fisrt row of Allocation.AllocationPeriods collection and parse it as Allocation PaymentPeriodTypeCode
                AllocationPeriodPeriodTypeCode? firstPaymentPeriodType = new AllocationPeriodPeriodTypeCode();
                var firstOrDefault = paymentAggregatedEvent.Allocation.AllocationPeriods.FirstOrDefault();
                if (firstOrDefault != null)
                {
                    firstPaymentPeriodType = firstOrDefault.PeriodTypeCode;
                    adPerformance.PaymentPeriodTypeCode =
                        (periodTypeCodeLIST)Enum.Parse(typeof(periodTypeCodeLIST), firstPaymentPeriodType.ToString());
                }

                paymentAggregatedEvent.Allocation.AllocationPeriods.ForEach(p =>
                {
                    // Create a new payment period
                    var paymentPeriod = new AggregatedPaymentPeriodTYPE
                    {

                        Period = p.Period,
                        PaymentPosted = true,
                        AggregatedPayment = new List<AggregatedPaymentTYPE>()
                    };
                    //// And add aggregations to the group
                    p.Aggregations.ForEach(ap =>
                    {
                        //// Update the aggregate posted flag if a payment has not been posted
                        if (!ap.PostedFlag)
                        {
                            paymentPeriod.PaymentPosted = false;
                        }
                        var aggregatedPayment = new AggregatedPaymentTYPE
                        {
                            AggregatedValue = ap.AggregatedValue,
                            PaymentTYPE =
                                (PaymentTypeTYPE)Enum.Parse(typeof(PaymentTypeTYPE), ap.PaymentType.ToString()),
                            SubnominalCode = ap.SubnominalCode,
                            Deliverables = new List<int>(),
                        };
                        //// Add deliverables to the payment aggregation
                        ap.DeliverableDetails.ForEach(d =>
                        {
                            aggregatedPayment.Deliverables.Add(d.DeliverableCode);
                        });

                        paymentPeriod.AggregatedPayment.Add(aggregatedPayment);
                    });


                    //// Add all the payment periods and aggregations and deliverables to the target event
                    adPerformance.AggregatedPaymentPeriods.Add(paymentPeriod);

                    ////through exception if any mixed period iden
                    if (firstPaymentPeriodType != p.PeriodTypeCode)
                    {
                        throw new PaymentPeriodTypeCodeMixedException("Allocation Periods contain mixed PaymentPeriodTypeCode : " + p.Period);
                    }

                });

               
            }
            catch (Exception e)
            {
                Logger.LogError(AdMonitoringDomainEventLoggingId.MappingError, e, "Error mapping PaymentAggregatedEvent to AllocationDeliveryPerformance. Allocation no: {0}",
                    paymentAggregatedEvent?.Allocation?.AllocationNumber ?? "null");
                throw;
            }
        }

        private static organisationReferenceTYPE MapOrganisationReference(int contractUkprn, string contractOrganisationId)
        {
            return new organisationReferenceTYPE
            {
                organisationIdentifier = contractOrganisationId,
                alternativeOrganisationIdentifiers = new organisationReferenceTYPEAlternativeOrganisationIdentifiers
                {
                    AlternativeOrganisationIdentifier = new alternativeOrganisationIdentifierTYPE
                    {
                        OrganisationIdentifier = contractUkprn.ToString(),
                        OrganisationIdentifierName = alternativeOrganisationIdentifierTYPEOrganisationIdentifierName.UKPROVIDERREFERENCENUMBER
                    }
                }
            };
        }

        private static DeliverableTYPE MapDeliverables(contractDeliverableType deliverable)
        {
            return new DeliverableTYPE
            {
                DeliverableCode = deliverable.deliverable.deliverableCode,
                isLegal = deliverable.deliverable.isLegal,
                isMonitoring = deliverable.deliverable.isMonitoring,
                ContractDeliverables = deliverable.contractDeliverables.Select(MapDeliverables).ToList(),
                ContractDeliverablePeriods = deliverable.contractDeliverablePeriods.Select(MapDeliverablePeriod).ToList()
            };
        }

        private static DeliverablePeriodTYPE MapDeliverablePeriod(contractDeliverablePeriodsTypeContractDeliverablePeriod deliverablePeriod)
        {
            return new DeliverablePeriodTYPE
            {
                Period = deliverablePeriod.period.periodValue,
                PlannedValue = deliverablePeriod.plannedValue,
                PlannedVolume = deliverablePeriod.plannedVolume
            };
        }
    }
}
