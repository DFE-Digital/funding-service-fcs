namespace XrmMigrator
{
    using System.Collections.Generic;
    using System.Linq;
    using Dto;
    using SFA.FCT.PaymentManagementDomain.PaymentSchedule.DataStore;
    using SFA.FCT.PaymentManagementDomain.PolicyCache.DataStore;
    using SFA.FCT.PaymentManagementDomain.PolicyCache.DataStore.Model;
    using Xrm;

    public class SubnominalsReader : ISubnominalsReader
    {
        private readonly IPaymentManagementPolicyContext _paymentManagementPolicyContext;
        private readonly IPaymentSchedulePolicyContext _paymentSchedulePolicyContext;

        public SubnominalsReader(IPaymentManagementPolicyContext paymentManagementPolicyContext, PaymentSchedulePolicyContext paymentSchedulePolicyContext)
        {
            _paymentManagementPolicyContext = paymentManagementPolicyContext;
            _paymentSchedulePolicyContext = paymentSchedulePolicyContext;
        }

        public IEnumerable<DeliverablePeriodSubnominal> Read()
        {
            
            var allPolicyDeliverableToSubnominals = _paymentManagementPolicyContext.PolicyDeliverableToSubnominals.Where(x => x.PaymentType != PaymentType.Capping)
                .Select(x => new SubnominalDeliverable
                {
                    DeliverableCode = x.PolicyDeliverable.DeliverableCode,
                    SubnominalCode = x.PolicySubnominal.SubnominalCode,
                    PaymentType = x.PolicySubnominal.PaymentType,
                    FundingStreamPeriodCode = x.FundingStreamPeriod
                });

            var allDeliverablePayments = from payment in _paymentSchedulePolicyContext.DeliverablePayments
                join allocation in _paymentSchedulePolicyContext.Allocations on
                    new { payment.AllocationNumber, payment.VersionNumber }
                    equals
                    new { allocation.AllocationNumber, allocation.VersionNumber }
                where payment.NetPaymentAmount != 0
                select new DeliverablePayment
                {
                    Period = payment.Period,
                    AllocationNumber = payment.AllocationNumber,
                    FundingStreamPeriodCode = allocation.FundingStreamPeriodCode,
                    DeliverableCode = payment.DeliverableCode
                };

            return from p in allDeliverablePayments.ToList()
                join s in allPolicyDeliverableToSubnominals.ToList() on
                    new
                    {
                        p.FundingStreamPeriodCode,
                        p.DeliverableCode,
                        
                    }
                    equals
                    new
                    {
                        s.FundingStreamPeriodCode,
                        s.DeliverableCode
                    }
                select new DeliverablePeriodSubnominal
                {
                    AllocationNumber = p.AllocationNumber,
                    DeliverableCode = p.DeliverableCode.ToString(),
                    Period = p.Period,
                    SubnominalCode = s.SubnominalCode.ToString(),
                    SubnominalType = AsSubnominalType(s.PaymentType)
                };
        }

        private static SubnominalType AsSubnominalType(PaymentType item)
        {
            var result = SubnominalType.Capping;
            switch (item)
            {
                case PaymentType.Capping:
                    result = SubnominalType.Capping;
                    break;
                case PaymentType.Profile:
                    result = SubnominalType.Profile;
                    break;
                case PaymentType.Reconciliation:
                    result = SubnominalType.Reconcilation;
                    break;
            }
            return result;
        }

        private class DeliverablePayment
        {
            public string Period {get; set;}
            
            public string AllocationNumber {get; set;}

            public string FundingStreamPeriodCode { get; set; }

            public int DeliverableCode { get; set; }


        }

        private class SubnominalDeliverable
        {
            public int SubnominalCode { get; set; }

            public PaymentType PaymentType { get; set; }

            public string FundingStreamPeriodCode { get; set; }

            public int DeliverableCode { get; set; }

        }
    }
}
