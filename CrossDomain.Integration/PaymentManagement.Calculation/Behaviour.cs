namespace PaymentManagement.Calculation
{
    using System;
    using System.Collections.Generic;
    using Dtos;
    using SFA.FCT.PaymentManagementDomain.PolicyCache.DataStore.Model;

    public class Behaviour
    {
        private readonly IReadOnlyCollection<CappingPeriod> _cappingPeriods;
        public Behaviour(Func<CalculationAllocationInput, CensusPeriodInfo, IReadOnlyCollection<CalculationResultLine>> calculateCappingAmount, IReadOnlyCollection<CappingPeriod> cappingPeriods, PaymentMethod paymentMethod)
        {
            CalculateCappingAmount = calculateCappingAmount;
            _cappingPeriods = cappingPeriods;
            PaymentMethod = paymentMethod;
        }

        public Func<CalculationAllocationInput, CensusPeriodInfo, IReadOnlyCollection<CalculationResultLine>> CalculateCappingAmount { get; }


        public Type GetTypeOfCappingClass => CalculateCappingAmount.Method.DeclaringType;

        public string Name => GetTypeOfCappingClass.Name;

        public IReadOnlyCollection<CappingPeriod> CappingPeriodsForOverDelivery => _cappingPeriods ?? new List<CappingPeriod>();

        public PaymentMethod PaymentMethod { get; }
    }
}
