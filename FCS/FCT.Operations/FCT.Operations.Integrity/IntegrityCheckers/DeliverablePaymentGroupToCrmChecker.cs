namespace SFA.FCT.Operations.Integrity.IntegrityCheckers
{
    using System;
    using System.Collections.Concurrent;
    using System.Collections.Generic;
    using System.Linq;
    using System.Text;
    using DTOs;
    using Repositories;
    using PaymentValueDifferenceItem = Entities.PaymentValueDifferenceItem;

    public class DeliverablePaymentGroupToCrmChecker
    {
        private readonly IReadOnlyCollection<DeliverablePaymentWithFsp> _deliverablePayments;
        private readonly IDictionary<string, List<CrmDeliverablePaymentData>> _crmPeriodValueDictionary;
        private readonly ICrmDeliverablePaymentRepository _crmDeliverablePaymentRepository;

        public DeliverablePaymentGroupToCrmChecker(
            IReadOnlyCollection<DeliverablePaymentWithFsp> deliverablePayments,
            IDictionary<string, List<CrmDeliverablePaymentData>> crmPeriodValueDictionary,
            ICrmDeliverablePaymentRepository crmDeliverablePaymentRepository)
        {
            _deliverablePayments = deliverablePayments;
            _crmPeriodValueDictionary = crmPeriodValueDictionary;
            _crmDeliverablePaymentRepository = crmDeliverablePaymentRepository;
        }

        public void Process(IList<PaymentValueDifferenceItem> differenceItems)
        {
            foreach (var payment in _deliverablePayments)
            {
                IEnumerable<CrmDeliverablePaymentData> crmPaymentValues = null;

                string key = CreateStringKeyForDeliverablePeriod(payment);
                if (_crmPeriodValueDictionary.ContainsKey(key))
                {
                    crmPaymentValues = _crmPeriodValueDictionary[key];
                }
                if (crmPaymentValues != null)
                {
                    int numPaymentValuesInCrm = crmPaymentValues.Count();
                    if (numPaymentValuesInCrm > 0)
                    {
                        CrmDeliverablePaymentData firstCrmPaymentValues = crmPaymentValues.First();
                        if (numPaymentValuesInCrm == 1)
                        {
                            ComparePaymentValuesAndLog(firstCrmPaymentValues, payment, differenceItems);
                        }
                        else if (numPaymentValuesInCrm > 1)
                        {
                            // there are duplicate rows so we need to log this
                            firstCrmPaymentValues.IsDupilcateRows = true;
                            PaymentValueDifferenceItem paymentValueDifferenceItem = new PaymentValueDifferenceItem(payment, firstCrmPaymentValues);
                            differenceItems.Add(paymentValueDifferenceItem);
                        }
                    }
                }
                else
                {
                    differenceItems.Add(new PaymentValueDifferenceItem(payment, null));
                }
            }
        }

        private static string CreateStringKeyForDeliverablePeriod(DeliverablePaymentWithFsp sqlPaymentValue)
        {
            StringBuilder stringBuilder = new StringBuilder();
            const string delimiter = "_";
            stringBuilder.Append(sqlPaymentValue.AllocationNumber);
            stringBuilder.Append(delimiter);
            stringBuilder.Append(sqlPaymentValue.VersionNumber);
            stringBuilder.Append(delimiter);
            stringBuilder.Append(sqlPaymentValue.DeliverableCode);
            stringBuilder.Append(delimiter);
            DateTime dt = DateTime.ParseExact(sqlPaymentValue.YearPeriod, "yyyyMM", new System.Globalization.CultureInfo("en-GB"));
            string periodDate = dt.ToString("MMM-yy");
            stringBuilder.Append(periodDate);

            return stringBuilder.ToString();
        }

        private static void ComparePaymentValuesAndLog(CrmDeliverablePaymentData crmPaymentValues, DeliverablePaymentWithFsp localStorePaymentValues, IList<PaymentValueDifferenceItem> differenceItems)
        {
            if (!IsCrmPaymentValuesEqualToSqlPaymentValues(crmPaymentValues, localStorePaymentValues))
            {
                differenceItems.Add(new PaymentValueDifferenceItem(localStorePaymentValues, crmPaymentValues));
            }
        }

        private static bool IsCrmPaymentValuesEqualToSqlPaymentValues(CrmDeliverablePaymentData crmPaymentValues, DeliverablePaymentWithFsp localStorePaymentValues)
        {
            return crmPaymentValues.PlannedValue == localStorePaymentValues.PlannedValue &&
                   crmPaymentValues.PlannedVolume == localStorePaymentValues.PlannedVolume &&
                   (crmPaymentValues.BalancingPaymentValue ?? 0) == localStorePaymentValues.BalancingPaymentAmount &&
                   crmPaymentValues.ActualValue == localStorePaymentValues.ActualValue &&
                   crmPaymentValues.ActualVolume == localStorePaymentValues.ActualVolume &&
                   (crmPaymentValues.CappingPaymentValue ?? 0) == (localStorePaymentValues.CappedPaymentAmount) &&
                   (crmPaymentValues.NetPaymentValue ?? 0) == localStorePaymentValues.NetPaymentAmount &&
                   (crmPaymentValues.ProfilePaymentValue ?? 0) == localStorePaymentValues.ProfilePaymentAmount &&
                   (crmPaymentValues.ReconciliationPaymentValue ?? 0) == (localStorePaymentValues.ReconciliationPaymentAmount);
        }

        private IReadOnlyCollection<CrmDeliverablePaymentData> GetPlannedAndActualValuesFromCrm(DeliverablePaymentWithFsp payment)
        {
            try
            {
                return _crmDeliverablePaymentRepository.GetByAllocationVersionDeliverableCodeAndVersion(
                    payment.AllocationNumber,
                    payment.VersionNumber,
                    payment.DeliverableCode,
                    payment.YearPeriod);
            }
            catch (Exception)
            {
                return new List<CrmDeliverablePaymentData>();
            }
        }
    }

}
