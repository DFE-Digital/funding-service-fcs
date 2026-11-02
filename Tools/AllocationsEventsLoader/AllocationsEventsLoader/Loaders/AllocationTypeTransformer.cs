using SFA.FCT.AllocationDeliveryDomain.Common.DataStore;
using SFA.FCT.AllocationDeliveryDomain.Common.DataStore.Model;
using SFA.FCT.CrossDomain.Integration.Entities.DeliveryAllocation;
using SFA.FCT.PaymentManagementDomain.PaymentSchedule.DataStore;
using SFA.FCT.PaymentManagementDomain.PaymentSchedule.DataStore.Model;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace AllocationsEventsLoader.Loaders
{
    public class AllocationTypeTransformer : IDisposable
    {
        private readonly IPaymentSchedulePolicyContext PaymentSchedulePolicyContext = new PaymentSchedulePolicyContext();
        private readonly IMonitoringDeliverablesDbContext MonitoringDeliverablesDbContext = new MonitoringDeliverablesDbContext();
        private readonly IDictionary<string, bool> _isLegalDeliverableResults = new Dictionary<string, bool>();
        private int _numAllocationsStartedProcessing = 0;
        private int _totalNumAllocations;
        private IDictionary<string, bool> _isMonitoringDeliverableResults = new Dictionary<string, bool>(); 

        public  IEnumerable<allocationType> TransformToAllocationTypeList(IList<AllocationDeliverablePeriod> allocationDeliverablePeriods)
        {
            var allocationGroups = allocationDeliverablePeriods.GroupBy(adp => new
            {
                adp.ContractAllocationNumber,
                adp.ContractVersionNumber,
                adp.UopCode,
                adp.OrganisationId,
                adp.AllocationEndDate,
                adp.AllocationStartDate,
                adp.ContractNumber,
                adp.ContractSubVersionNumber,
                adp.FundingStreamPeriodCode,
                adp.Ukprn
            });

            return allocationGroups.Select(allocationGroup => new allocationType
            {
                contractReference = new contractReferenceType
                {
                    contractNumber = allocationGroup.Key.ContractNumber,
                    contractVersionNumber = allocationGroup.Key.ContractVersionNumber,
                    contractSubVersionNumber = allocationGroup.Key.ContractSubVersionNumber
                },
                contractorReference = new organisationReferenceType
                {
                    organisationIdentifier = allocationGroup.Key.OrganisationId,
                    alternativeOrganisationIdentifiers = new List<alternativeOrganisationIdentifierType>
                    {
                        new alternativeOrganisationIdentifierType
                        {
                            OrganisationIdentifier = allocationGroup.Key.Ukprn, OrganisationIdentifierName = alternativeOrganisationIdentifierTypeOrganisationIdentifierName.UKPROVIDERREFERENCENUMBER,
                        }
                    }
                },
                contractAllocationNumber = allocationGroup.Key.ContractAllocationNumber,
                startDate = allocationGroup.Key.AllocationStartDate,
                endDate = allocationGroup.Key.AllocationEndDate,
                fundingStreamPeriod = new allocationTypeFundingStreamPeriod
                {
                    fundingStreamPeriodCode = allocationGroup.Key.FundingStreamPeriodCode
                },
                uopCode = allocationGroup.Key.UopCode,
                contractDeliverables = CreateDeliverables(allocationGroup, allocationGroup.Key.FundingStreamPeriodCode, allocationGroup.Key.ContractAllocationNumber, allocationGroup.Key.ContractVersionNumber)
            }).ToList();
        }

        private List<contractDeliverableType> CreateDeliverables(IEnumerable<AllocationDeliverablePeriod> periodsForAllocation, string fundingStreamPeriodCode, string allocationNumber, int versioNumber)
        {
            var deliverableGroups = periodsForAllocation.GroupBy(pfa => pfa.DeliverableCode);

            return deliverableGroups.Select(deliverableGroup => new contractDeliverableType
            {
                contractDeliverablePeriods = CreateDeliverablePeriods(deliverableGroup, fundingStreamPeriodCode, allocationNumber, versioNumber),

                deliverable = new deliverableType
                {
                    deliverableCode = deliverableGroup.Key,
                    isLegal = IsLegal(fundingStreamPeriodCode, deliverableGroup.Key),
                    isMonitoring = IsMonitoring(fundingStreamPeriodCode, deliverableGroup.Key)
                }
            }).ToList();
        }

        private DeliverablePayment GetDeliverablePayment(string allocationNumber, int contractVersion, int deliverableCode, string period)
        {
            return PaymentSchedulePolicyContext.DeliverablePayments.SingleOrDefault(
                 ps => ps.AllocationNumber == allocationNumber && ps.VersionNumber == contractVersion &&
                       ps.DeliverableCode == deliverableCode && ps.Period == period);
        }

        private bool IsMonitoring(string fundingStreamPeriodCode, int deliverableCode)
        {
            string concatenatedKey = fundingStreamPeriodCode + deliverableCode;
            if (!_isMonitoringDeliverableResults.ContainsKey(concatenatedKey))
            {
                FundingStreamPeriodDeliverable fundingStreamPeriodDeliverable = MonitoringDeliverablesDbContext.FundingStreamPeriodDeliverables.SingleOrDefault(
                    fsdp => fsdp.FundingStreamPeriodCode == fundingStreamPeriodCode &&
                            fsdp.DeliverableCode == deliverableCode);
                _isMonitoringDeliverableResults[concatenatedKey] = fundingStreamPeriodDeliverable != null;

                _isLegalDeliverableResults[concatenatedKey] = fundingStreamPeriodDeliverable == null ||
                                                              fundingStreamPeriodDeliverable.AllowProfile;
            }

            return _isMonitoringDeliverableResults[concatenatedKey];
        }

        private bool IsLegal(string fundingStreamPeriodCode, int deliverableCode)
        {
            // if the data is not in the table FundingStreamPeriodDeliverables or it is in the table and 
            // the Allowprofile is set
            string concatenatedKey = fundingStreamPeriodCode + deliverableCode;
            if (!_isLegalDeliverableResults.ContainsKey(concatenatedKey))
            {
                FundingStreamPeriodDeliverable fundingStreamPeriodDeliverable = MonitoringDeliverablesDbContext.FundingStreamPeriodDeliverables.SingleOrDefault(
                    fsdp => fsdp.FundingStreamPeriodCode == fundingStreamPeriodCode &&
                            fsdp.DeliverableCode == deliverableCode);
                _isMonitoringDeliverableResults[concatenatedKey] = fundingStreamPeriodDeliverable != null;

                _isLegalDeliverableResults[concatenatedKey] = fundingStreamPeriodDeliverable == null ||
                                                              fundingStreamPeriodDeliverable.AllowProfile;
            }

            return _isLegalDeliverableResults[concatenatedKey];
        }

        private List<contractDeliverablePeriodsTypeContractDeliverablePeriod> CreateDeliverablePeriods(IGrouping<int, AllocationDeliverablePeriod> deliverableGroupPeriods, string fundingStreamPeriodCode, string allocationNumber, int versionNumber)
        {
            List<contractDeliverablePeriodsTypeContractDeliverablePeriod> deliverablePeriods = deliverableGroupPeriods.Select(dgp => new contractDeliverablePeriodsTypeContractDeliverablePeriod
            {
                period = new periodType
                {
                    periodValue = dgp.Period
                }
            }).ToList();

            AddPlannedValuesToDeliverablePeriods(deliverablePeriods, allocationNumber, versionNumber,
                deliverableGroupPeriods.Key);
            return deliverablePeriods;
        }

        private void AddPlannedValuesToDeliverablePeriods(List<contractDeliverablePeriodsTypeContractDeliverablePeriod> deliverablePeriods, string allocationNumber, int versionNumber, int deliverableCode)
        {
            foreach (var deliverablePeriod in deliverablePeriods)
            {
                DeliverablePayment deliverablePayment = GetDeliverablePayment(allocationNumber, versionNumber, deliverableCode,
                    deliverablePeriod.period.periodValue);
                if (deliverablePayment != null)
                {
                    deliverablePeriod.plannedValue = deliverablePayment.PlannedValue ?? 0;
                    deliverablePeriod.plannedVolume = deliverablePayment.PlannedVolumne ?? 0;
                }
            }
        }

        public void Dispose()
        {
            PaymentSchedulePolicyContext.Dispose();
            MonitoringDeliverablesDbContext.Dispose();
        }
    }
}
