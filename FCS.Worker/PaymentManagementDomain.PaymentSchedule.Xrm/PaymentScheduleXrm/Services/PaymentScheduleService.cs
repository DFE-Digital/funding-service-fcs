namespace PaymentManagementDomain.PaymentSchedule.PaymentScheduleXrm.Services
{
    using System.Collections.Generic;
    using System.Linq;
    using Microsoft.Xrm.Sdk;
    using SFA.FCT.CrossDomain.Integration.Entities.Xrm;
    using SFA.FCT.PaymentManagementDomain.PaymentSchedule.Xrm.Integration.Repositories;
    using Repositories;

    public class PaymentScheduleService : IPaymentScheduleService
    {
        private static readonly Relationship DeliverableToPeriodRelationship = new Relationship("sfa_contractdeliverable_deliverableperiod");

        private readonly ICrmFspDeliverableRepository _fspDeliverableRepository;
        private readonly ICrmDeliverableRepository _deliverableRepository;
        private readonly ICrmPeriodTypeRepository _crmPeriodTypeRepository;
        private readonly ICrmTransactionRequestRepository _crmTransactionRequestRepository;

        public PaymentScheduleService(
            ICrmFspDeliverableRepository fspDeliverableRepository,
            ICrmDeliverableRepository deliverableRepository,
            ICrmPeriodTypeRepository crmPeriodTypeRepository,
            ICrmTransactionRequestRepository crmTransactionRequestRepository)
        {
            _fspDeliverableRepository = fspDeliverableRepository;
            _deliverableRepository = deliverableRepository;
            _crmPeriodTypeRepository = crmPeriodTypeRepository;
            _crmTransactionRequestRepository = crmTransactionRequestRepository;
        }

        public static IReadOnlyCollection<DeliverablePeriodYear> GetDeliverablePeriodYearsNotCrm(
            IReadOnlyCollection<DeliverablePeriodYear> deliverablePeriodYearsInCrm,
            IReadOnlyCollection<DeliverablePeriodYear> deliverablePeriodYearsOnPaymentSchedule)
        {
            var deliverablePeriodYearsMissingFromCrm = deliverablePeriodYearsOnPaymentSchedule
                .Where(deliverablePeriodYearsInCrm.Contains)
                .ToList();

            return deliverablePeriodYearsMissingFromCrm;
        }

        public void CreateMissingDeliverablesAndTheirPeriods(
            IReadOnlyCollection<DeliverableInfo> existingDeliverables,
            AllocationInfo allocationInfo,
            string fspCode,
            IReadOnlyCollection<DeliverablePeriodYear> missingDeliverablePeriodYears)
        {
            IReadOnlyCollection<FspDeliverableInfo> fspDeliverables = _fspDeliverableRepository.GetFundingStreamPeriodDeliverables(fspCode);
            ILookup<int, DeliverablePeriodYear> missingDeliverablesWithPeriods = missingDeliverablePeriodYears.ToLookup(dp => int.Parse(dp.DeliverableCode));

            var deliverablesToCreate = GetDeliverablesWithPeriodsToCreate(
                existingDeliverables,
                missingDeliverablesWithPeriods,
                fspDeliverables,
                allocationInfo);

            _crmTransactionRequestRepository.CreateEntities(deliverablesToCreate);
        }

        public void UpdateExistingDeliverablesAndTheirPeriods(
            IReadOnlyCollection<DeliverableInfo> existingDeliverables,
            AllocationInfo allocationInfo,
            string fspCode,
            IReadOnlyCollection<DeliverablePeriodYear> existingDeliverablePeriodYears,
            IReadOnlyCollection<DeliverablePeriodYear> paymentScheduleDeliverablePeriodYears)
        {
            var newDeliverablePeriods = GetNewDeliverablePeriodsIfThereAreAny(
                existingDeliverables,
                existingDeliverablePeriodYears,
                paymentScheduleDeliverablePeriodYears);

            if (newDeliverablePeriods.Any())
            {
                _crmTransactionRequestRepository.CreateEntities(newDeliverablePeriods);
            }

            var updatedPeriods = GetUpdatedDeliverablePeriodsIfThereAreAny(existingDeliverablePeriodYears,
                paymentScheduleDeliverablePeriodYears);

            if (updatedPeriods.Any())
            {
                _crmTransactionRequestRepository.UpdateEntities(updatedPeriods);
            }
        }

        private IReadOnlyCollection<sfa_contractdeliverable> GetDeliverablesWithPeriodsToCreate(
            IReadOnlyCollection<DeliverableInfo> existingDeliverables,
            ILookup<int, DeliverablePeriodYear> missingDeliverablesWithPeriods,
            IReadOnlyCollection<FspDeliverableInfo> fspDeliverables,
            AllocationInfo allocationInfo)
        {
            var missingDeliverables = missingDeliverablesWithPeriods
                .Where(dp => !existingDeliverables.Select(existingD => int.Parse(existingD.DeliverableCode)).Contains(dp.Key))
                .Select(d => new
                { DeliverableCode = d.Key, Info = fspDeliverables.Single(f => f.DeliverableCode == d.Key) })
                .ToList();

            var deliverablesToCreate = missingDeliverables.Select(missingDeliverable =>
            {
                var existingParentDeliverable = existingDeliverables
                    .SingleOrDefault(ed => ed.DeliverableCode == missingDeliverable.Info.ParentDeliverableCode.ToString());

                IEnumerable<DeliverablePeriodYear> missingDeliverablePeriodsForDeliverable = missingDeliverablesWithPeriods[missingDeliverable.DeliverableCode];

                sfa_contractdeliverable deliverableObject = _deliverableRepository.CreateDeliverableObject(
                    missingDeliverable.DeliverableCode,
                    missingDeliverable.Info,
                    allocationInfo.AllocationId,
                    allocationInfo.AllocationNumber,
                    allocationInfo.ContractId,
                    existingParentDeliverable?.Id);

                List<sfa_contractdeliverableperiod> contractDeliverablePeriods = missingDeliverablePeriodsForDeliverable.Select(
                        p => p.ScheduledPayment.ToContractDeliverablePeriod(_crmPeriodTypeRepository.GetCalendarMonthPeriodType()))
                    .ToList();

                EntityCollection entityCollection = new EntityCollection();
                contractDeliverablePeriods.ForEach(dp => entityCollection.Entities.Add(dp));

                deliverableObject.RelatedEntities.Add(DeliverableToPeriodRelationship, entityCollection);

                return deliverableObject;
            }).ToList();

            return deliverablesToCreate;
        }

        private IReadOnlyCollection<sfa_contractdeliverableperiod> GetNewDeliverablePeriodsIfThereAreAny(
            IReadOnlyCollection<DeliverableInfo> existingDeliverables,
            IReadOnlyCollection<DeliverablePeriodYear> existingDeliverablePeriodYears,
            IReadOnlyCollection<DeliverablePeriodYear> paymentScheduleDeliverablePeriodYears)
        {
            var missingPeriods = paymentScheduleDeliverablePeriodYears.Where(psDeliverablePeriod =>
                    !existingDeliverablePeriodYears.Contains(psDeliverablePeriod))
                .ToList();

            var newDeliverablePeriods = missingPeriods.GroupBy(p => p.DeliverableCode).SelectMany(deliverableGroup =>
            {
                var deliverableId = existingDeliverables.Single(d => d.DeliverableCode == deliverableGroup.Key).Id;

                EntityReference deliverableEntityReference = new EntityReference(sfa_contractdeliverable.EntityLogicalName, deliverableId);
                List<sfa_contractdeliverableperiod> contractDeliverablePeriods = deliverableGroup.Select(
                        p =>
                        {
                            var crmCdp = p.ScheduledPayment.ToContractDeliverablePeriod(_crmPeriodTypeRepository.GetCalendarMonthPeriodType());

                            crmCdp.sfa_ContractDeliverableId = deliverableEntityReference;

                            return crmCdp;
                        })
                    .ToList();

                return contractDeliverablePeriods;
            }).ToList();

            return newDeliverablePeriods;
        }

        private IReadOnlyCollection<sfa_contractdeliverableperiod> GetUpdatedDeliverablePeriodsIfThereAreAny(
            IReadOnlyCollection<DeliverablePeriodYear> existingDeliverablePeriodYears,
            IReadOnlyCollection<DeliverablePeriodYear> paymentScheduleDeliverablePeriodYears)
        {
            var updatedPeriods = paymentScheduleDeliverablePeriodYears
                .Where(existingDeliverablePeriodYears.Contains)
                .Select(psDp =>
                {
                    var existingDeliverablePeriodYear = existingDeliverablePeriodYears.Single(existingDp => existingDp.Equals(psDp));

                    return new { ExistingDp = existingDeliverablePeriodYear, PaymentScheduleDp = psDp };
                })
                .Where(dp => dp.PaymentScheduleDp.ScheduledPayment.IsDifferentTo(dp.ExistingDp.CrmDeliverablePeriod))
                .ToList();

            var crmUpdatedPeriods = updatedPeriods.Select(updatedPeriod =>
            {
                var updatedCrmPeriod =
                    updatedPeriod.PaymentScheduleDp.ScheduledPayment.ToContractDeliverablePeriod(
                        _crmPeriodTypeRepository
                            .GetCalendarMonthPeriodType());
                updatedCrmPeriod.sfa_contractdeliverableperiodId =
                    updatedPeriod.ExistingDp.CrmDeliverablePeriod.sfa_contractdeliverableperiodId;

                return updatedCrmPeriod;
            }).ToList();

            return crmUpdatedPeriods;
        }
    }
}