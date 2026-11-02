namespace AllocationsEventsLoader.Loaders
{
    using System;
    using System.Collections.Concurrent;
    using System.Collections.Generic;
    using System.Configuration;
    using System.Linq;
    using System.Text;
    using Entities;
    using Helpers;
    using Microsoft.Xrm.Client;
    using Microsoft.Xrm.Client.Services;
    using MoreLinq;
    using SFA.FCT.ContractCreateDomain.Implementation;
    using SFA.FCT.ContractCreateDomain.Implementation.Persistence;
    using SFA.FCT.CrossDomain.Integration.Entities.ContractRequest;

    public class DeliverablePaymentGroupToCrmChecker
    {
        private readonly IList<DeliverablePaymentData> _deliverablePayments;
        private readonly IDictionary<string, IList<DeliverablePeriodsValueData>> _crmPeriodValueDictionary;
        private LookupManager _lookupManager;

        public DeliverablePaymentGroupToCrmChecker(IList<DeliverablePaymentData> deliverablePayments)
        {
            _deliverablePayments = deliverablePayments;
        }

        public DeliverablePaymentGroupToCrmChecker(IList<DeliverablePaymentData> deliverablePayments, IDictionary<string, IList<DeliverablePeriodsValueData>> crmPeriodValueDictionary)
        {
            _deliverablePayments = deliverablePayments;
            _crmPeriodValueDictionary = crmPeriodValueDictionary;
        }

        public void Process(BlockingCollection<PaymentValueDifferenceItem> differenceItems, bool deleteDuplicatesFromCrm = false)
        {
            int numSqlPaymentsProcessed = 0;
            int totalSqlPayments = _deliverablePayments.Count;

            CreateLookupManager();

            foreach (var payment in _deliverablePayments)
            {
                //Console.WriteLine("Processing item {0} of {1}", _cursor++, _deliverablePayments.Count);
                IEnumerable<DeliverablePeriodsValueData> crmPaymentValues = null;
     
                if (numSqlPaymentsProcessed%1000 == 0)
                {
                    Console.WriteLine("Num sql payments processed - {0} of {1}", numSqlPaymentsProcessed, totalSqlPayments);
                }

                if (_crmPeriodValueDictionary != null)
                {
                    string key = CreateStringKeyForDeliverablePeriod(payment);
                    if (_crmPeriodValueDictionary.ContainsKey(key))
                    {
                        crmPaymentValues = _crmPeriodValueDictionary[key];
                    }
                    else
                    {
                        Console.WriteLine("Key not found in Crm - {0}", key);
                    }
                }
                else
                {
                    crmPaymentValues = GetPlannedAndActualValuesFromCrm(payment);
                }
                if (crmPaymentValues != null)
                {
                    int numPaymentValuesInCrm = crmPaymentValues.Count();
                    if (numPaymentValuesInCrm > 0)
                    {
                        DeliverablePeriodsValueData firstCrmPaymentValues = crmPaymentValues.First();
                        if (numPaymentValuesInCrm == 1)
                        {
                            ComparePaymentValuesAndLog(firstCrmPaymentValues, payment, differenceItems);
                        }
                        else if (numPaymentValuesInCrm > 1)
                        {
                            // there are duplicate rows so we need to log this
                            firstCrmPaymentValues.IsDupilcateRows = true;
                            differenceItems.Add(new PaymentValueDifferenceItem(payment, firstCrmPaymentValues));
                            if (deleteDuplicatesFromCrm)
                            {
                                DeleteDuplicateDeliverablePeriods(crmPaymentValues, payment);
                            }
                        }
                    }
                }
                else
                {
                    Console.WriteLine("This payment is not in crm - Allocation Number - {0} of Version - {1} DeliverableCode - {2} Period = {3}", payment.AllocationNumber, payment.VersionNumber, payment.DeliverableCode, payment.Period);
                    differenceItems.Add(new PaymentValueDifferenceItem(payment, null));
                }
                numSqlPaymentsProcessed++;
            }
        }

        private string CreateStringKeyForDeliverablePeriod(DeliverablePaymentData sqlPaymentValue)
        {
            StringBuilder stringBuilder = new StringBuilder();
            const string delimiter = "_";
            stringBuilder.Append(sqlPaymentValue.AllocationNumber);
            stringBuilder.Append(delimiter);
            stringBuilder.Append(sqlPaymentValue.VersionNumber);
            stringBuilder.Append(delimiter);
            stringBuilder.Append(sqlPaymentValue.DeliverableCode);
            stringBuilder.Append(delimiter);
            DateTime dt = DateTime.ParseExact(sqlPaymentValue.Period, "yyyyMM", new System.Globalization.CultureInfo("en-GB"));
            string periodDate = dt.ToString("MMM-yy");
            stringBuilder.Append(periodDate);

            return stringBuilder.ToString();
        }

        private void DeleteDuplicateDeliverablePeriods(IEnumerable<DeliverablePeriodsValueData> crmPaymentValues, DeliverablePaymentData sqlPaymentValues)
        {
            IList<DeliverablePeriodsValueData> crmRowsThatAreEqualToSqlRows =
                crmPaymentValues.Where(crmPv => IsCrmPaymentValuesEqualToSqlPaymentValues(crmPv, sqlPaymentValues)).ToList();

            IList<DeliverablePeriodsValueData> crmRowsThatAreNotEqualToSqlRows =
                crmPaymentValues.Where(crmPv => !IsCrmPaymentValuesEqualToSqlPaymentValues(crmPv, sqlPaymentValues)).ToList();

            // first check to see is all the rows in Crm Match the rows in Sql
            if (crmRowsThatAreEqualToSqlRows.Count() == crmPaymentValues.Count())
            {
                // delete all apart from the latest
                DeleteAllButTheLatestFromCrm(crmRowsThatAreEqualToSqlRows);
            }
            else
            {
                // delete the items that are not equal if we have some that are equal
                if (crmRowsThatAreEqualToSqlRows.Any())
                {
                    crmRowsThatAreNotEqualToSqlRows.ForEach(crmPv => DeleteEntity(crmPv.EntityId));
                    DeleteAllButTheLatestFromCrm(crmRowsThatAreEqualToSqlRows);
                }
                else
                {
                    // we don't have any that are equal so just delete all but the latest
                    DeleteAllButTheLatestFromCrm(crmRowsThatAreNotEqualToSqlRows);
                }
            }
        }

        private void DeleteAllButTheLatestFromCrm(IList<DeliverablePeriodsValueData> crmPaymentValues)
        {
            if (crmPaymentValues.Count() > 1)
            {
                crmPaymentValues = crmPaymentValues.OrderByDescending(crmPv => crmPv.ModifiedOn).ToList();
                crmPaymentValues.RemoveAt(0);
                crmPaymentValues.ForEach(crmPv => DeleteEntity(crmPv.EntityId));
            }
        }

        private void DeleteEntity(Guid entityId)
        {
            CrmManager.DeleteEntity(CrmManager.ContractDeliverablePeriodEntityName, entityId);
        }

        private void ComparePaymentValuesAndLog(DeliverablePeriodsValueData crmPaymentValues, DeliverablePaymentData localStorePaymentValues, BlockingCollection<PaymentValueDifferenceItem> differenceItems)
        {
            if (!IsCrmPaymentValuesEqualToSqlPaymentValues(crmPaymentValues, localStorePaymentValues))
            {
                Console.WriteLine("We have an inconsistent value for Allocation: {0}, Version: {1}, DeliverableCode: {2} for Period:{3}.",
                    localStorePaymentValues.AllocationNumber, localStorePaymentValues.VersionNumber, localStorePaymentValues.DeliverableCode, localStorePaymentValues.Period);

                differenceItems.Add(new PaymentValueDifferenceItem(localStorePaymentValues, crmPaymentValues));
            }
        }

        private bool IsCrmPaymentValuesEqualToSqlPaymentValues(DeliverablePeriodsValueData crmPaymentValues,
            DeliverablePaymentData localStorePaymentValues)
        {
            return crmPaymentValues.PlannedValue == localStorePaymentValues.PlannedValue &&
                   (crmPaymentValues.BalancingPaymentValue ?? 0) == localStorePaymentValues.BalancingPaymentValue &&
                   crmPaymentValues.ActualValue == localStorePaymentValues.ActualValue &&
                   (crmPaymentValues.CappingPaymentValue ?? 0) == (localStorePaymentValues.CappingPaymentValue ?? 0) &&
                   (crmPaymentValues.NetPaymentValue ?? 0) == localStorePaymentValues.NetPaymentValue &&
                   (crmPaymentValues.ProfilePaymentValue ?? 0) == localStorePaymentValues.ProfilePaymentValue &&
                   (crmPaymentValues.ReconciliationPaymentValue ?? 0) == (localStorePaymentValues.ReconciliationPaymentValue ?? 0);
        }

        private IEnumerable<DeliverablePeriodsValueData> GetPlannedAndActualValuesFromCrm(DeliverablePaymentData payment)
        {
            try
            {
                return _lookupManager.GetPaymentScheduleDeliverablePaymentsValueList(payment.AllocationNumber,
                    payment.VersionNumber, payment.DeliverableCode.ToString(), payment.Period);
            }
            catch (Exception e)
            {
                Console.WriteLine(
                    "Error getting Deliverable Period from CRM: {0}, Version: {1}, DeliverableCode: {2} for Period:{3}.",
                    payment.AllocationNumber, payment.VersionNumber, payment.DeliverableCode, payment.Period);
                Console.WriteLine(e.Message);
                Console.WriteLine(e.StackTrace);
                return new List<DeliverablePeriodsValueData>();
            }
        }

        private void CreateLookupManager()
        {
            _lookupManager = new LookupManager
            {
                EnduringCacheManager = new EnduringCacheManager(),
                BatchCacheManager = new BatchCacheManager()
            };
            CrmConnection xrmConnection =
               CrmConnection.Parse(ConfigurationManager.ConnectionStrings["CrmConnectionString"].ConnectionString);
            _lookupManager.OrganizationService = new OrganizationService(xrmConnection);
        }
    }
}
