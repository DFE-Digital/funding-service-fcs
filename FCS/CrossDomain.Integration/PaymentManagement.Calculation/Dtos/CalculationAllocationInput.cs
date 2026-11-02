namespace PaymentManagement.Calculation.Dtos
{
    using System.Collections.Generic;
    using System.Linq;
    using Extensions;
    using Newtonsoft.Json;
    using Optional.Collections;

    public class CalculationAllocationInput
    {
        private const int AllocationDurationPeriod = -1;
        private readonly Dictionary<int, decimal> _overDeliveryForPeriod = new Dictionary<int, decimal>();

        public CalculationAllocationInput(
            string allocationNumber,
            int versionNumber,
            string fundingStreamPeriodCode,
            List<CalculationDeliverableInput> deliverables,
            string ukprn,
            string orgId, string contractNumber,
            List<CappingGroup> cappingGroups)
        {
            AllocationNumber = allocationNumber;
            VersionNumber = versionNumber;
            FundingStreamPeriodCode = fundingStreamPeriodCode;
            Deliverables = deliverables;
            Ukprn = ukprn;
            OrgId = orgId;
            ContractNumber = contractNumber;
            CappingGroups = cappingGroups;
        }

        public string ContractNumber { get; }

        public string AllocationNumber { get; }

        public int VersionNumber { get; }

        public string FundingStreamPeriodCode { get; }

        public string Ukprn { get; }

        public string OrgId { get; }

        public List<CalculationDeliverableInput> Deliverables { get; }

        public List<CappingGroup> CappingGroups { get; }

        public bool IsNew() => VersionNumber == 1;

        public void SetOverDeliveryForPeriod(int financialPeriod, decimal overDelivery)
        {
            _overDeliveryForPeriod.AddOrUpdate(financialPeriod, overDelivery);
        }

        public void SetOverDelivery(decimal overDelivery)
        {
            SetOverDeliveryForPeriod(AllocationDurationPeriod, overDelivery);
        }

        public void SetOverDelivery(IReadOnlyCollection<CappingPeriod> cappingPeriods)
        {
            if (cappingPeriods.Count == 1) // contract duration
            {
                SetOverDelivery(cappingPeriods.First().OverDeliveryLimit);
            }
            else if (cappingPeriods.Count > 1)
            {
                var financialPeriods = GetFinancialPeriodsAscending().ToList();
                var orderedCappingPeriods = cappingPeriods.OrderBy(cp => cp.CappingPeriodNumber).ToList();
                orderedCappingPeriods.ForEach(cp =>
                {
                    var optionalFinancialPeriod = financialPeriods.GetItemAtIndexOrNone(cp.CappingPeriodNumber - 1);
                    optionalFinancialPeriod.MatchSome(fp =>
                    {
                        SetOverDeliveryForPeriod(fp, cp.OverDeliveryLimit);
                    });
                });
            }
        }

        public decimal GetOverDeliveryForFinancialPeriod(Period currentPeriod)
        {
            return _overDeliveryForPeriod.GetValueOrDefault(currentPeriod.GetTaxYear());
        }

        public decimal GetOverDelivery()
        {
            return _overDeliveryForPeriod.GetValueOrDefault(AllocationDurationPeriod);
        }

        public void MergePaymentValuesIncludingActualsOntoInput(IReadOnlyCollection<DeliverablePeriodPaymentInfo> paymentValues)
        {
            paymentValues.GroupBy(a => a.DeliverableCode)
                .ToList()
                .ForEach(paymentValueDPs =>
                {
                    var inputDeliverableOption = Deliverables
                        .SingleOrNone(d => d.DeliverableCode == paymentValueDPs.Key);

                    inputDeliverableOption.MatchSome(inputDeliverable =>
                    {
                        paymentValueDPs.ToList()
                            .ForEach(paymentValueDp =>
                            {
                                inputDeliverable.DeliverablePeriods
                                    .SingleOrNone(idp => idp.Period == paymentValueDp.Period)                                    
                                    .Match(
                                        some: idp =>
                                        {
                                            idp.ActualValue = paymentValueDp.ActualValue;
                                            idp.ActualVolume = paymentValueDp.ActualVolume;
                                            idp.NetPayment = paymentValueDp.NetPaymentAmount;
                                            idp.ReconciliationPayment = paymentValueDp.ReconciliationPaymentAmount;
                                            idp.CappedPayment = paymentValueDp.CappedPaymentAmount;
                                            idp.BalancingPayment = paymentValueDp.BalancingPaymentAmount;
                                            idp.ProfilePayment = paymentValueDp.ProfilePaymentAmount;
                                        },
                                        none: () =>
                                        {
                                            inputDeliverable.DeliverablePeriods.Add(new CalculationDeliverablePeriodInput(
                                                period:paymentValueDp.Period, 
                                                plannedValue: paymentValueDp.PlannedValue.GetValueOrDefault(),
                                                plannedVolume: paymentValueDp.PlannedVolume.GetValueOrDefault())
                                            {
                                                ActualValue = paymentValueDp.ActualValue,
                                                ActualVolume = paymentValueDp.ActualVolume,
                                                NetPayment = paymentValueDp.NetPaymentAmount,
                                                ReconciliationPayment = paymentValueDp.ReconciliationPaymentAmount,
                                                CappedPayment = paymentValueDp.CappedPaymentAmount,
                                                BalancingPayment = paymentValueDp.BalancingPaymentAmount,
                                                ProfilePayment = paymentValueDp.ProfilePaymentAmount
                                            });
                                        });
                            });
                    });
                });
        }
        
        public void MergePaymentValuesNotIncludingActualsOntoInput(IReadOnlyCollection<DeliverablePeriodPaymentInfo> currentVersionOfPaymentInfos, 
            IReadOnlyCollection<FspDeliverableInfo> fspDeliverableInfos)
        {
            var allowProfileFspDeliverableInfos = fspDeliverableInfos
                .Where(fdi => fdi.AllowProfile)
                .ToList();

            AddMissingDeliverablesWithPlannedValueToInput(currentVersionOfPaymentInfos, allowProfileFspDeliverableInfos);

            currentVersionOfPaymentInfos.GroupBy(a => a.DeliverableCode)
                .ToList()
                .ForEach(actualsDeliverablePeriods =>
                {
                    var inputDeliverableOption = Deliverables
                        .SingleOrNone(d => d.DeliverableCode == actualsDeliverablePeriods.Key);

                    inputDeliverableOption.MatchSome(inputDeliverable =>
                    {
                        actualsDeliverablePeriods.ToList()
                            .ForEach(actualDp =>
                            {
                                inputDeliverable.DeliverablePeriods.SingleOrNone(idp => idp.Period == actualDp.Period)
                                    .Match(some: idp =>
                                    {
                                        idp.PlannedValue = actualDp.PlannedValue;
                                        idp.PlannedVolume = actualDp.PlannedVolume;
                                        idp.NetPayment = actualDp.NetPaymentAmount;
                                        idp.ReconciliationPayment = actualDp.ReconciliationPaymentAmount;
                                        idp.CappedPayment = actualDp.CappedPaymentAmount;
                                    },
                                        none: () => inputDeliverable.DeliverablePeriods.Add(new CalculationDeliverablePeriodInput(
                                            period:actualDp.Period,
                                            plannedValue: actualDp.PlannedValue.GetValueOrDefault(), plannedVolume: actualDp.PlannedVolume.GetValueOrDefault())
                                        {
                                            ReconciliationPayment = actualDp.ReconciliationPaymentAmount,
                                            CappedPayment = actualDp.CappedPaymentAmount,
                                            NetPayment = actualDp.NetPaymentAmount
                                        }));
                            });
                    });
                });
        }

        public IReadOnlyCollection<PlannedValueAndActualsForFinancialPeriod> GetPlannedValueAndActualsTotals()
        {
            var taxYearsWithTheirProfilePeriods = Deliverables
                .Where(d => d.AllowProfile)
                .SelectMany(d => d.DeliverablePeriods)
                .ToLookup(dp => new Period(dp.Period).GetTaxYear());

            var taxYearsWithAllTheirPeriods = Deliverables
                .SelectMany(d => d.DeliverablePeriods)
                .ToLookup(dp => new Period(dp.Period).GetTaxYear());

            var taxYearTotals = taxYearsWithAllTheirPeriods.Select(taxYearGrp => new PlannedValueAndActualsForFinancialPeriod(
                    plannedValue: taxYearsWithTheirProfilePeriods[taxYearGrp.Key].Sum(g => g.PlannedValue.GetValueOrDefault()),
                    overrideLimitPercentage: GetOverDeliveryForFinancialPeriod(taxYearGrp.Key),
                    financialPeriod: taxYearGrp.Key,
                    actualsValue: taxYearGrp.Sum(g => g.ActualValue.GetValueOrDefault())))
                .ToList();

            return taxYearTotals;
        }

        private void AddMissingDeliverablesWithPlannedValueToInput(IReadOnlyCollection<DeliverablePeriodPaymentInfo> currentVersionOfPaymentInfos, List<FspDeliverableInfo> allowProfileFspDeliverableInfos)
        {
            var deliverableCodesWithPlannedValue = currentVersionOfPaymentInfos.Where(pi =>
                    !Deliverables.Select(d => d.DeliverableCode).Contains(pi.DeliverableCode) && pi.HasPlannedValueOrVolume)
                .Select(pi => pi.DeliverableCode).Distinct().ToList();

            deliverableCodesWithPlannedValue.ForEach(plannedValueDeliverableCode =>
            {
                var fspCappingGroupId =
                    GetFspCappingGroupId(allowProfileFspDeliverableInfos, plannedValueDeliverableCode);

                Deliverables.Add(new CalculationDeliverableInput(
                    plannedValueDeliverableCode,
                    new List<CalculationDeliverablePeriodInput>(),
                    GetAllowProfile(allowProfileFspDeliverableInfos, plannedValueDeliverableCode),
                    cappingApportionmentPriorityOrder:null,
                    fundingStreamPeriodCappingGroupId: fspCappingGroupId));
            });
        }

        private static int? GetFspCappingGroupId(List<FspDeliverableInfo> allowProfileFspDeliverableInfos,
            int deliverableCode)
        {
            return allowProfileFspDeliverableInfos
                .SingleOrDefault(profileDeliverableInfo =>
                    profileDeliverableInfo.DeliverableCode == deliverableCode)
                ?.FundingStreamPeriodCappingGroupId;
        }

        private static bool GetAllowProfile(List<FspDeliverableInfo> allowProfileFspDeliverableInfos, int deliverableCode)
        {
            return allowProfileFspDeliverableInfos.Select(apfdi => apfdi.DeliverableCode).ToList().Contains(deliverableCode);
        }

        private IReadOnlyCollection<int> GetFinancialPeriodsAscending()
        {
            return Deliverables
                .SelectMany(d => d.DeliverablePeriods.Select(dp => dp.Period))
                .Distinct()
                .Select(p => new Period(p).GetTaxYear())
                .Distinct()
                .OrderBy(p => p)
                .ToList();
        }

        public override string ToString()
        {
            return $"AllocationNumber: {AllocationNumber}, Version: {VersionNumber}";
        }
    }

    public class CalculationDeliverableInput
    {
        [JsonConstructor]
        public CalculationDeliverableInput(int deliverableCode, IList<CalculationDeliverablePeriodInput> deliverablePeriods, bool allowProfile, int? cappingApportionmentPriorityOrder, int? fundingStreamPeriodCappingGroupId, bool allowPayment = false)
        {
            DeliverableCode = deliverableCode;
            DeliverablePeriods = deliverablePeriods;
            AllowProfile = allowProfile;
            CappingApportionmentPriorityOrder = cappingApportionmentPriorityOrder;
            FundingStreamPeriodCappingGroupId = fundingStreamPeriodCappingGroupId;
            AllowPayment = allowPayment;
        }

        public CalculationDeliverableInput(int deliverableCode, IList<CalculationDeliverablePeriodInput> deliverablePeriods) :this(deliverableCode, deliverablePeriods, false, null,null)
        {
        }
        
        public int DeliverableCode { get; }

        public bool AllowProfile { get; }

        public bool AllowPayment { get; }

        public int? CappingApportionmentPriorityOrder { get; }

        public int? FundingStreamPeriodCappingGroupId { get; }

        public IList<CalculationDeliverablePeriodInput> DeliverablePeriods { get; }

        public decimal GetTotalActualsToDateForDeliverable(int currentPeriod)
        {
            return DeliverablePeriods.Where(dp => dp.Period <= currentPeriod)
                       .Sum(dp => dp.ActualValue) ?? 0;
        }

        public decimal GetTotalActualsToDateForDeliverableForFinancialYear(int currentPeriod, int financialYear)
        {
            return DeliverablePeriods.ToLookup(dp => new Period(dp.Period).GetTaxYear())[financialYear]
                       .Where(dp => dp.Period <= currentPeriod)
                       .Sum(dp => dp.ActualValue) ?? 0;
        }

        public decimal GetNetPaymentsBeforeThisMonth(int currentPeriod)
        {
            return DeliverablePeriods
                .Where(dp => dp.Period < currentPeriod)
                .Sum(dp => dp.NetPayment);
        }

        public IReadOnlyCollection<CalculationDeliverablePeriodInput> GetPeriodsForThisFinancialYear(Period currentPeriod)
        {
            return GetFinancialYearPeriods()[currentPeriod.GetTaxYear()].ToList();
        }

        public IReadOnlyCollection<CalculationDeliverablePeriodInput> GetPeriodsForPreviousFinancialYear(
            Period currentPeriod)
        {
            var financialYearPeriods = GetFinancialYearPeriods();

            var previousTaxYear = currentPeriod.GetPreviousTaxYear();

            return financialYearPeriods[previousTaxYear].ToList();
        }

        public IReadOnlyCollection<CalculationDeliverablePeriodInput> GetPeriodsForFinancialYear(
            Period currentPeriod)
        {
            var financialYearPeriods = GetFinancialYearPeriods();

            var taxYear = currentPeriod.GetTaxYear();

            return financialYearPeriods[taxYear].ToList();
        }

        public decimal? GetPlannedValue()
        {
            if (AllowProfile)
            {
                return DeliverablePeriods.Sum(dp => dp.PlannedValue);
            }

            return 0;
        }

        public decimal? GetPlannedValueBeforeThisMonth(int currentPeriod)
        {
            if (AllowProfile)
            {
                return DeliverablePeriods
                    .Where(dp => dp.Period < currentPeriod)
                    .Sum(dp => dp.PlannedValue);
            }

            return 0;
        }

        private ILookup<int, CalculationDeliverablePeriodInput> GetFinancialYearPeriods()
        {
            var financialPeriodsLookup = DeliverablePeriods.ToLookup(dp => new Period(dp.Period).GetTaxYear());

            return financialPeriodsLookup;
        }
    }

    public class CalculationDeliverablePeriodInput
    {
        public CalculationDeliverablePeriodInput()
        {
            
        }
        public CalculationDeliverablePeriodInput(int period, int actualVolume, decimal actualValue)
        {
            Period = period;
            ActualVolume = actualVolume;
            ActualValue = actualValue;
        }

        public CalculationDeliverablePeriodInput(int period, decimal plannedValue, int plannedVolume)
        {
            Period = period;
            PlannedValue = plannedValue;
            PlannedVolume = plannedVolume;
        }

        public int Period { get; set; }

        public int? ActualVolume { get; set; }

        public decimal? ActualValue { get; set; }

        public decimal? PlannedValue { get; set; }

        public int? PlannedVolume { get; set; }

        public decimal NetPayment { get; set; }

        public decimal? CappedPayment { get; set; }

        public decimal? ReconciliationPayment { get; set; }

        public int Month => Period % 100;

        public int Year => Period / 100;

        public decimal? ProfilePayment { get; set; }

        public decimal? BalancingPayment { get; set; }
    }
}
