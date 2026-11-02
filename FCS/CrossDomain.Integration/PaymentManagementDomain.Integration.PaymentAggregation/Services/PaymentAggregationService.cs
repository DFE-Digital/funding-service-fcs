namespace SFA.FCT.PaymentManagementDomain.Integration.PaymentAggregation.Services
{
    using System;
    using System.Collections.Generic;
    using System.Linq;
    using BusinessLogic;
    using BusinessLogic.Services;
    using Common;
    using CrossDomain.Integration.Entities.Data;
    using Framework.Logging.Interfaces;
    using PolicyCache.DataStore.Model;
    using PolicyCache.DataStore.Repositories;
    using paymentAggregation = CrossDomain.Integration.Entities.CorporatePaymentAggregation;
    using paymentSchedule = CrossDomain.Integration.Entities.PaymentSchedule;

    public class PaymentAggregationService : IPaymentAggregationService
    {
        private readonly ILogger _logger;
        private readonly IDeliverableToSubnominalService _deliverableToSubnominalService;
        private readonly IPayCalcPolicyQueryRepository _payCalcPolicyQueryRepository;

        public PaymentAggregationService(
            ILogger logger,
            IDeliverableToSubnominalService deliverableToSubnominalService,
            IPayCalcPolicyQueryRepository payCalcPolicyQueryRepository)
        {
            _logger = logger;
            _deliverableToSubnominalService = deliverableToSubnominalService;
            _payCalcPolicyQueryRepository = payCalcPolicyQueryRepository;
        }

        public paymentAggregation.Allocation CalculateAggregatedPayments(paymentSchedule.Allocation paymentSchedule, ConnectionInfo connectionInfo)
        {
            paymentAggregation.Allocation paymentAggregationAllocation = CreatePaymentAggregationAllocation(paymentSchedule);

            string fundingStreamPeriodCode = paymentSchedule.FundingStreamPeriodCode;
            string allocationNumber = paymentSchedule.AllocationNumber;
            string contractNumber = paymentSchedule.ContractNumber;

            // Run through the list of deliverables in the allocation then the scheduled payments in the deliverable
            foreach (paymentSchedule.AllocationDeliverable deliverable in paymentSchedule.AllocationDeliverables)
            {
                SubnominalValue subnominalValue =
                    _deliverableToSubnominalService.GetSubnominalValue(fundingStreamPeriodCode, deliverable.DeliverableCode, allocationNumber, contractNumber);

                int profileSubnominal = subnominalValue.Profile;
                int reconciliationSubnominal = subnominalValue.Reconciliation;
                int cappingSubnominal = subnominalValue.Capping;

                if (profileSubnominal == 0 && reconciliationSubnominal == 0 && cappingSubnominal == 0)
                {
                    continue;
                }

                PolicySubnominal profileSubnominalPolicy = null;
                PolicySubnominal reconciliationSubnominalPolicy = null;
                PolicySubnominal cappingSubnominalPolicy = null;

                if (profileSubnominal != 0)
                {
                    profileSubnominalPolicy = GetPolicySubnominal(profileSubnominal, PaymentType.Profile, connectionInfo);
                }

                if (reconciliationSubnominal != 0)
                {
                    reconciliationSubnominalPolicy = GetPolicySubnominal(reconciliationSubnominal, PaymentType.Reconciliation, connectionInfo);
                }

                if (cappingSubnominal != 0)
                {
                    cappingSubnominalPolicy = GetPolicySubnominal(cappingSubnominal, PaymentType.Capping, connectionInfo);
                }

                if (profileSubnominalPolicy == null && reconciliationSubnominalPolicy == null && cappingSubnominalPolicy == null)
                {
                    _logger.LogVerbose(
                        PaymentManagementLoggingEvents.PaymentsAggregationNoSubnominalCodeFound,
                        "Payment Aggregation: No Subnominal Policy found for ProfileSubnominalCode:{0} ReconcilliationSubnominalCode:{1} CappingSubnominalCode:{2} DeliverableCode:{3} FSPC:{4}",
                        profileSubnominal,
                        reconciliationSubnominal,
                        cappingSubnominal,
                        deliverable.DeliverableCode,
                        paymentSchedule.FundingStreamPeriodCode);

                    continue;
                }

                foreach (paymentSchedule.ScheduledPayment scheduledPayment in deliverable.ScheduledPayments)
                {
                    // Work out the period from the scheduled payment - if it is not in the target aggregate structure, create it.
                    var aggregatedPeriod =
                        paymentAggregationAllocation.AllocationPeriods.FirstOrDefault(
                            m =>
                                m.Period == scheduledPayment.Period &&
                                m.PeriodTypeCode == GetCorpSchemaPeriodTypeCode(scheduledPayment.PeriodTypeCode));
                    if (aggregatedPeriod == null)
                    {
                        aggregatedPeriod = new paymentAggregation.AllocationPeriod()
                        {
                            PeriodTypeCode = GetCorpSchemaPeriodTypeCode(scheduledPayment.PeriodTypeCode),
                            Period = scheduledPayment.Period
                        };
                        paymentAggregationAllocation.AllocationPeriods.Add(aggregatedPeriod);
                    }

                    // Work out the aggregate object to hold the payment value - if it is not there create it
                    if (profileSubnominalPolicy != null)
                    {
                        CalculateAndAddAggregation(
                            aggregatedPeriod,
                            profileSubnominalPolicy,
                            scheduledPayment,
                            deliverable.DeliverableCode,
                            SubnominalType.Profile);
                    }

                    if (reconciliationSubnominalPolicy != null)
                    {
                        CalculateAndAddAggregation(
                            aggregatedPeriod,
                            reconciliationSubnominalPolicy,
                            scheduledPayment,
                            deliverable.DeliverableCode,
                            SubnominalType.Reconciliation);
                    }

                    if (cappingSubnominalPolicy != null)
                    {
                        CalculateAndAddAggregation(
                            aggregatedPeriod,
                            cappingSubnominalPolicy,
                            scheduledPayment,
                            deliverable.DeliverableCode,
                            SubnominalType.Capping);
                    }
                }
            }

            return paymentAggregationAllocation;
        }

        private PolicySubnominal GetPolicySubnominal(int subnominalCode, PaymentType paymentType, ConnectionInfo connectionInfo)
        {
            return _payCalcPolicyQueryRepository.GetSubnominal(subnominalCode, paymentType, connectionInfo);
        }

        private void CalculateAndAddAggregation(
            paymentAggregation.AllocationPeriod aggregatedPeriod,
            PolicySubnominal policySubnominal,
            paymentSchedule.ScheduledPayment scheduledPayment,
            int deliverableCode,
            SubnominalType subnominalType)
        {
            // Check to see if the scheduled payment carries anything which can be added to the aggregation (ie. if it is not null)
            if ((subnominalType == SubnominalType.Capping && scheduledPayment.CappedPaymentAmount == null) ||
                (subnominalType == SubnominalType.Reconciliation && scheduledPayment.ReconciliationPaymentAmount == null))
            {
                // Don't bother to continue processing this aggregation
                return;
            }

            paymentAggregation.Aggregation aggregation =
                aggregatedPeriod.Aggregations.FirstOrDefault(
                    m => m.SubnominalCode == policySubnominal.SubnominalCode.ToString()
                         &&
                         ((m.PaymentType == paymentAggregation.AggregationPaymentType.CAPPING &&
                           policySubnominal.PaymentType == PaymentType.Capping)
                          ||
                          (m.PaymentType == paymentAggregation.AggregationPaymentType.PROFILE &&
                           policySubnominal.PaymentType == PaymentType.Profile)
                          ||
                          (m.PaymentType == paymentAggregation.AggregationPaymentType.RECONCILIATION &&
                           policySubnominal.PaymentType == PaymentType.Reconciliation)));

            if (aggregation == null)
            {
                aggregation = new paymentAggregation.Aggregation
                {
                    SubnominalCode = policySubnominal.SubnominalCode.ToString(),
                    PaymentType = GetCorpSchemaPaymentType(policySubnominal.PaymentType),
                    DeliverableDetails = new List<paymentAggregation.DeliverableDetail>
                    {
                        new paymentAggregation.DeliverableDetail()
                        {
                            DeliverableCode = deliverableCode
                        }
                    }
                };
                aggregatedPeriod.Aggregations.Add(aggregation);
            }
            else
            {
                aggregation.DeliverableDetails.Add(new paymentAggregation.DeliverableDetail
                {
                    DeliverableCode = deliverableCode
                });
            }

            // Add the net payment amount (this takes into account balancing payments) from the scheduled payment to the aggregated total
            switch (subnominalType)
            {
                case SubnominalType.Profile:
                    decimal profilePluBalancing = scheduledPayment.ProfilePaymentAmount.GetValueOrDefault() +
                                                  scheduledPayment.BalancingPaymentAmount.GetValueOrDefault();
                    aggregation.AggregatedValue += profilePluBalancing;
                    _logger.LogVerbose(
                        PaymentManagementLoggingEvents.PaymentsAggregationPaymentAggregationCalculated,
                        "Payment Aggregation: Subnominal Aggregations Added for Period:{0} NetPaymentAmount:{1}",
                        scheduledPayment.Period,
                        scheduledPayment.NetPaymentAmount.ToString());
                    break;

                case SubnominalType.Reconciliation:
                    if (scheduledPayment.ReconciliationPaymentAmount.HasValue)
                    {
                        aggregation.AggregatedValue += scheduledPayment.ReconciliationPaymentAmount.Value;
                        _logger.LogVerbose(
                            PaymentManagementLoggingEvents.PaymentsAggregationPaymentAggregationCalculated,
                            "Payment Aggregation: Subnominal Aggregations Added for Period:{0} ReconcilliationPaymentAmount:{1}",
                            scheduledPayment.Period,
                            scheduledPayment.ReconciliationPaymentAmount.ToString());
                    }
                    break;

                case SubnominalType.Capping:
                    if (scheduledPayment.CappedPaymentAmount.HasValue)
                    {
                        aggregation.AggregatedValue += scheduledPayment.CappedPaymentAmount.Value;
                        _logger.LogVerbose(
                            PaymentManagementLoggingEvents.PaymentsAggregationPaymentAggregationCalculated,
                            "Payment Aggregation: Subnominal Aggregations Added for Period:{0} CappedPaymentAmount:{1}",
                            scheduledPayment.Period,
                            scheduledPayment.CappedPaymentAmount.ToString());
                    }
                    break;
            }
        }

        private static paymentAggregation.AllocationPeriodPeriodTypeCode GetCorpSchemaPeriodTypeCode(string periodTypeCode)
        {
            paymentAggregation.AllocationPeriodPeriodTypeCode parsedValue;

            if (Enum.TryParse(periodTypeCode, out parsedValue))
            {
                return parsedValue;
            }

            throw new Exception("Invalid periodTypeCode supplied");
        }

        private static paymentAggregation.AggregationPaymentType GetCorpSchemaPaymentType(PaymentType paymentType)
        {
            switch (paymentType)
            {
                case PaymentType.Profile:
                    return paymentAggregation.AggregationPaymentType.PROFILE;

                case PaymentType.Reconciliation:
                    return paymentAggregation.AggregationPaymentType.RECONCILIATION;

                case PaymentType.Capping:
                    return paymentAggregation.AggregationPaymentType.CAPPING;
            }

            throw new Exception("Invalid paymentType supplied");
        }

        private static paymentAggregation.OrgainsationIdentifierOrganisationIdentifierName GetOrgIdNameFromCorpSchema(
            paymentSchedule.OrganisationIdentifierOrganisationIdentifierName sourceName)
        {
            switch (sourceName)
            {
                case paymentSchedule.OrganisationIdentifierOrganisationIdentifierName.UKPRN:
                    return paymentAggregation.OrgainsationIdentifierOrganisationIdentifierName.UKPROVIDERREFERENCENUMBER;
            }

            throw new Exception("Unable to translate OrgIdentifierName");
        }

        private static paymentAggregation.Allocation CreatePaymentAggregationAllocation(paymentSchedule.Allocation paymentSchedule)
        {
            paymentAggregation.Allocation paymentAggregationAllocation = new paymentAggregation.Allocation
            {
                AllocationNumber = paymentSchedule.AllocationNumber,
                VersionNumber = paymentSchedule.VersionNumber,
                FundingStreamPeriodCode = paymentSchedule.FundingStreamPeriodCode
            };

            if (paymentSchedule.Organisation != null)
            {
                paymentAggregationAllocation.Organisation = new paymentAggregation.Organisation
                {
                    MainOrganisationIdentifier = paymentSchedule.Organisation.MainOrganisationIdentifier
                };

                if (paymentSchedule.Organisation.OrganisationIdentifiers != null)
                {
                    foreach (paymentSchedule.OrganisationIdentifier orgId in paymentSchedule.Organisation.OrganisationIdentifiers)
                    {
                        paymentAggregationAllocation.Organisation.AlternativeOrganisationIdentifiers.Add(new paymentAggregation.OrgainsationIdentifier
                        {
                            OrganisationId = orgId.OrganisationId,
                            OrganisationIdentifierName = GetOrgIdNameFromCorpSchema(orgId.OrganisationIdentifierName)
                        });
                    }
                }
            }

            return paymentAggregationAllocation;
        }

        private enum SubnominalType
        {
            Profile,
            Reconciliation,
            Capping
        }
    }
}