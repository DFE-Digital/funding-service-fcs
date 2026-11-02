namespace AllocationsEventsLoader.Loaders
{
    using System.Collections.Generic;
    using Helpers;
    using System;
    using System.Configuration;
    using Microsoft.Xrm.Client;
    using Microsoft.Xrm.Client.Services;
    using SFA.FCT.ContractCreateDomain.Implementation;
    using SFA.FCT.ContractCreateDomain.Implementation.Persistence;
    using SFA.FCT.PaymentManagementDomain.PaymentSchedule.DataStore;

    public class DeliverablePaymentProcessor
    {
        private readonly IList<DeliverablePaymentData> _deliverablePayments;
        private LookupManager _lookupManager;
        private int _cursor = 1;

        public DeliverablePaymentProcessor(IList<DeliverablePaymentData> deliverablePayments)
        {
            _deliverablePayments = deliverablePayments;
        }

        public void Process()
        {
            CreateLookupManager();
            foreach (var payment in _deliverablePayments)
            {
                Console.WriteLine("Processing item {0} of {1}", _cursor++, _deliverablePayments.Count);
                var updatedPayment = GetPlannedAndActualValues(payment);

                Console.WriteLine("Updating DeliverablePayment table for Allocation: {0}, Version: {1}, DeliverableCode: {2} for Period:{3}.",
                    payment.AllocationNumber, payment.VersionNumber, payment.DeliverableCode, payment.Period);
                UpdateDeliverablePayments(updatedPayment);
            }
        }

        private DeliverablePaymentData GetPlannedAndActualValues(DeliverablePaymentData payment)
        {
            var paymentData = _lookupManager.GetPaymentScheduleDeliverablePaymentsValues(payment.AllocationNumber,
                payment.VersionNumber, payment.DeliverableCode.ToString(), payment.Period);
            payment.PlannedValue = paymentData.PlannedValue;
            payment.ActualValue = paymentData.ActualValue;
            return payment;
        }

        private void UpdateDeliverablePayments(DeliverablePaymentData payment)
        {
            using (var context = new PaymentSchedulePolicyContext())
            {
                var deliverablePayment = context.DeliverablePayments.Find(
                payment.AllocationNumber,
                     payment.VersionNumber,
                     payment.DeliverableCode,
                     payment.Period);
                if (deliverablePayment != null)
                {
                    deliverablePayment.PlannedValue = payment.PlannedValue;
                    deliverablePayment.ActualValue = payment.ActualValue;
                    context.SaveChanges();
                    Console.WriteLine("Updated");
                }
                else
                {
                    Console.WriteLine("No record found in DeliverablePayment table for Allocation: {0}, Version: {1}, DeliverableCode: {2} for Period:{3} ...moving on.",
                        payment.AllocationNumber, payment.VersionNumber, payment.DeliverableCode, payment.Period);
                }
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
