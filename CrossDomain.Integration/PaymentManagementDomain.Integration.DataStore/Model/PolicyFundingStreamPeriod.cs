using System.Collections.Generic;

namespace SFA.FCT.PaymentManagementDomain.PolicyCache.DataStore.Model
{
    using System;
    using System.ComponentModel.DataAnnotations;
    using System.ComponentModel.DataAnnotations.Schema;
    using System.Linq;

    public enum PaymentMethod
    {
        NoPay = 0,
        PayOnActuals = 1,
        PayOnProfile = 2,
        PayOnInstruction = 3,
        NoCalcAndNoPay = 4
    }

    public enum PaymentCappingPeriodType
    {
        FinancialYear = 0,
        AcademicYear = 1,
        ContractDuration = 2,
        AcademicAndFinancialYear = 3
    }

    public enum PaymentCappingLevelType
    {
        Group = 0,
        ContractAllocation = 1,
        DeliverableLine = 2
    }

    public class PolicyFundingStreamPeriod
    {
        private readonly IReadOnlyCollection<PaymentMethod> _calculationPaymentMethodsWhenApprovalArrives = new List<PaymentMethod>
        {
            PaymentMethod.PayOnActuals,
            PaymentMethod.PayOnProfile,
            PaymentMethod.NoPay
        };

        private readonly IReadOnlyCollection<PaymentMethod> _calculationPaymentMethodsWhenActualsArrive = new List<PaymentMethod>
        {
            PaymentMethod.PayOnActuals,
            PaymentMethod.NoPay
        };

        [Key, Column(Order = 0)]
        [Index("IX_FSPIndex", 1, IsUnique = true)]
        public string FundingStreamPeriod { get; set; }

        public PaymentMethod PaymentMethod { get; set; }

        public PaymentCappingLevelType? PaymentCappingLevel { get; set; }

        public PaymentCappingPeriodType? PaymentCappingPeriod { get; set; }

        public ICollection<CappingGroup> CappingGroups { get; set; }

        [Required, Column(Order = 1)]
        public bool ShouldCapPayments { get; set; }

        public DateTime? ActivityCloseDate { get; set; }

        public bool IsPrioritisedApportionment { get; set; }

        [MaxLength(100)]
        public string Name { get; set; }

        [MaxLength(100)]
        public string AgencyPayment { get; set; }

        public bool IsCalculationRequiredForApproval()
        {
            return _calculationPaymentMethodsWhenApprovalArrives.Contains(PaymentMethod);
        }

        public bool IsCalculationRequiredForActuals()
        {
            return _calculationPaymentMethodsWhenActualsArrive.Contains(PaymentMethod);
        }

        public bool IsActive(DateTime currentDate)
        {
            return !ActivityCloseDate.HasValue || currentDate.Date <= ActivityCloseDate.Value.Date;
        }
    }
}
