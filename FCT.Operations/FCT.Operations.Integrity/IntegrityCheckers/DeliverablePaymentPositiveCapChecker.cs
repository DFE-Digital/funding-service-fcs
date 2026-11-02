namespace SFA.FCT.Operations.Integrity.IntegrityCheckers
{
    using System;
    using System.Collections.Generic;
    using System.Linq;
    using Services;
    using Repositories;
    using Utils;

    public class DeliverablePaymentPositiveCapChecker : IIntegrityChecker
    {
        private readonly PaasDeliverablePaymentLazyRepository _paasDeliverablePaymentLazyRepository;
  
        public DeliverablePaymentPositiveCapChecker(PaasDeliverablePaymentLazyRepository paasDeliverablePaymentLazyRepository)
        {
            _paasDeliverablePaymentLazyRepository = paasDeliverablePaymentLazyRepository;
        }

        public IntegrityCheckResult CheckValues()
        {
            string currentPeriod = DateTime.UtcNow.ToString("yyyyMM");
            string previousPeriod = DateTime.UtcNow.AddMonths(-1).ToString("yyyyMM");

            IReadOnlyCollection<CappingInfo> deliveryPaymentsWithPositiveCappingValue = GetDeliveryPaymentsWithPositiveCappingValue(currentPeriod, previousPeriod);

            return new IntegrityCheckResult(deliveryPaymentsWithPositiveCappingValue.Any(), 
                deliveryPaymentsWithPositiveCappingValue.Any() 
                    ? new CsvWriter<CappingInfo>().CreateCsv(deliveryPaymentsWithPositiveCappingValue) 
                    : null);
        }

        private IReadOnlyCollection<CappingInfo> GetDeliveryPaymentsWithPositiveCappingValue(string currentPeriod, string previousPeriod)
        {
            return
                _paasDeliverablePaymentLazyRepository.GetDeliverablePayments()
                    .Where(
                        dp => dp.CappedPaymentAmount > 0 && (dp.YearPeriod == currentPeriod || dp.YearPeriod == previousPeriod))
                    .Select(dp => new CappingInfo
                    {
                        AllocationNumber = dp.AllocationNumber,
                        CappedPaymentAmount = dp.CappedPaymentAmount,
                        DeliverableCode = dp.DeliverableCode,
                        Period = dp.Period,
                        VersionNumber = dp.VersionNumber
                    }).ToList();
        }

        private class CappingInfo
        {
            [Order(1)]
            public string AllocationNumber { get; set; }

            [Order(2)]
            public int VersionNumber { get; set; }

            [Order(3)]
            public int DeliverableCode { get; set; }

            [Order(4)]
            public string Period { get; set; }

            [Order(5)]
            public decimal? CappedPaymentAmount { get; set; }
        }
    }
}