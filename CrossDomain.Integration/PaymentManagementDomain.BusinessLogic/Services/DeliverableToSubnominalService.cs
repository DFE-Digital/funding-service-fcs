namespace SFA.FCT.PaymentManagementDomain.BusinessLogic.Services
{
    using System;
    using System.Collections.Concurrent;
    using System.Collections.Generic;
    using System.Linq;
    using AllocationDeliveryDomain.Common.DataStore;
    using AllocationDeliveryDomain.Common.DataStore.Model;
    using MoreLinq;
    using PolicyCache.DataStore;
    using PolicyCache.DataStore.Model;

    public class DeliverableToSubnominalService : IDeliverableToSubnominalService
    {
        private readonly IPaymentManagementPolicyContext _paymentManagementPolicyContext;
        private readonly IMonitoringDeliverablesDbContext _monitoringDeliverablesDbContext;
        private static readonly ConcurrentDictionary<string, IReadOnlyCollection<PolicyDeliverableToSubnominals>> FspPolicyDeliverableToSubnominals = new ConcurrentDictionary<string, IReadOnlyCollection<PolicyDeliverableToSubnominals>>();
        private static readonly ConcurrentDictionary<string, EsfAllocationData> AllocationEsfAllocationData = new ConcurrentDictionary<string, EsfAllocationData>();
        private static readonly ConcurrentBag<ESFRegionInvestmentPriority> ESFRegionInvestmentPriorities = new ConcurrentBag<ESFRegionInvestmentPriority>();

        private const string ESFFundingStreamPeriodCode = "ESF1420";

        public DeliverableToSubnominalService(IPaymentManagementPolicyContext paymentManagementPolicyContext,
            IMonitoringDeliverablesDbContext monitoringDeliverablesDbContext)
        {
            _paymentManagementPolicyContext = paymentManagementPolicyContext;
            _monitoringDeliverablesDbContext = monitoringDeliverablesDbContext;
        }

        /// <summary>
        /// This will get the subnominal codes for the data passed in. It will throw
        /// an argument exception if data is missing
        /// </summary>
        public SubnominalValue GetSubnominalValue(string fundingStreamPeriodCode,
                int deliverableCode, string contractAllocationNumber, string contractNumber)
        {
            if (IsEsfFundingStreamPeriod(fundingStreamPeriodCode))
            {
                return GetEsfSubnominalValue(
                    contractAllocationNumber,
                    contractNumber);
            }
            else
            {
                return GetNonEsfSubnominalValue(
                   fundingStreamPeriodCode,
                   deliverableCode);
            }
        }

        private bool IsEsfFundingStreamPeriod(string fundingStreamPeriodCode)
        {
            return fundingStreamPeriodCode == ESFFundingStreamPeriodCode;
        }

        private SubnominalValue GetNonEsfSubnominalValue(
            string fundingStreamPeriodCode,
            int deliverableCode)
        {
            IReadOnlyCollection<PolicyDeliverableToSubnominals> subnominals =
                GetPolicyDeliverableToSubnominalsForFsp(fundingStreamPeriodCode);

            IReadOnlyCollection<PolicyDeliverableToSubnominals> subnominalsForDeliverable = subnominals.Where(sub => sub.DeliverableCode == deliverableCode).ToList();

            return SubnominalValue.CreateNonEsf(
                reconciliation: subnominalsForDeliverable.SingleOrDefault(sub => sub.PaymentType == PaymentType.Reconciliation)?.SubnominalCode ?? 0,
                capping: subnominalsForDeliverable.SingleOrDefault(sub => sub.PaymentType == PaymentType.Capping)?.SubnominalCode ?? 0,
                profile: subnominalsForDeliverable.SingleOrDefault(sub => sub.PaymentType == PaymentType.Profile)?.SubnominalCode ?? 0);
        }

        private IReadOnlyCollection<PolicyDeliverableToSubnominals> GetPolicyDeliverableToSubnominalsForFsp(
            string fundingStreamPeriodCode)
        {
            return FspPolicyDeliverableToSubnominals.GetOrAdd(fundingStreamPeriodCode, s =>
            {
                return _paymentManagementPolicyContext.PolicyDeliverableToSubnominals.Where(
                    sub => sub.FundingStreamPeriod == fundingStreamPeriodCode).ToList();
            });
        }

        private SubnominalValue GetEsfSubnominalValue(string contractAllocationNumber, string contractNumber)
        {
            EsfAllocationData esfAllocationData = GetEsfAllocationData(contractNumber, contractAllocationNumber);

            ESFRegionInvestmentPriority policyFundingStreamPeriodSubnominal =
                GetESFRegionInvestmentPriorities()
                    .Single(sub => sub.InvestmentPriority == esfAllocationData.InvestmentPriorityNumber &&
                                   sub.RegionType == esfAllocationData.RegionTypeTrimmed);

            return SubnominalValue.CreateEsf(int.Parse(policyFundingStreamPeriodSubnominal.SubnominalCode));
        }

        private IEnumerable<ESFRegionInvestmentPriority> GetESFRegionInvestmentPriorities()
        {
            if (ESFRegionInvestmentPriorities.IsEmpty)
            {
                _paymentManagementPolicyContext.ESFRegionInvestmentPriorities.ForEach(ESFRegionInvestmentPriorities.Add);
            }

            return ESFRegionInvestmentPriorities;
        }

        private string CreateAllocationEsfAllocationDataKey(string contractAllocationNumber, string contractNumber)
        {
            return contractNumber + contractAllocationNumber;
        }

        private EsfAllocationData GetEsfAllocationData(string contractNumber, string contractAllocationNumber)
        {
            string key = CreateAllocationEsfAllocationDataKey(contractNumber, contractAllocationNumber);
            EsfAllocationData esfAllocationData = AllocationEsfAllocationData.GetOrAdd(key,
                new Func<string, EsfAllocationData>(
                    (k) =>
                        _monitoringDeliverablesDbContext.ESFAllocationData.SingleOrDefault(esf => esf.ContractNumber == contractNumber && esf.ContractAllocationNumber == contractAllocationNumber)));

            
            if (esfAllocationData == null)
            {
                throw new ArgumentException($"The ESFAllocationData table does not contain a row for contractNumber {contractNumber} + contractAllocationNumber {contractAllocationNumber}");
            }

            return esfAllocationData;
        }
    }
}
