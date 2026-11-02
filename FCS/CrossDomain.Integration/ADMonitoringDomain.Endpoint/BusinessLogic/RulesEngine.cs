namespace ADMonitoringDomain.Endpoint.BusinessLogic
{
    using System;
    using System.Collections.Generic;
    using System.Linq;
    using SFA.FCT.PaymentManagementDomain.PaymentSchedule.DataStore;
    using SFA.FCT.PaymentManagementDomain.PolicyCache.DataStore;
    using SFA.FCT.PaymentManagementDomain.PolicyCache.DataStore.Model;

    public class RulesEngine : IRulesEngine
    {
        public enum RuleName
        {
            NewContractAllocationApproved,
            AmendedContractAllocationApproved,
            ContractAllocationActualsReceived,
            ContractAllocationPaymentPosted
        }

        public enum EventName
        {
            AllocationActualsVerified,
            PaymentPosted,
            PaymentAggregated,
            PaymentCalculated
        }

        private readonly IDictionary<RuleName, IDictionary<EventName,Func<string, int, bool>>> _rulesDictionary = new Dictionary<RuleName, IDictionary<EventName, Func<string, int, bool>>>();
        private readonly IPaymentSchedulePolicyContext _paymentSchedulePolicyContext;
        private readonly IPaymentManagementPolicyContext _paymentManagementPolicyContext;

        public RulesEngine(IPaymentSchedulePolicyContext paymentSchedulePolicyContext, IPaymentManagementPolicyContext paymentManagementPolicyContext)
        {
            _paymentSchedulePolicyContext = paymentSchedulePolicyContext;
            _paymentManagementPolicyContext = paymentManagementPolicyContext;
            SetupRuleMappings();
        }

        public bool EvaluateRule(RuleName ruleName, EventName eventName, string allocationNumber, int contractVersionNumber)
        {
            if (_rulesDictionary.ContainsKey(ruleName) && _rulesDictionary[ruleName].ContainsKey(eventName))
            {
                return _rulesDictionary[ruleName][eventName](allocationNumber, contractVersionNumber);
            }

            throw new ArgumentException(string.Format("This ruleName {0} and eventName {1} is not supported", ruleName, eventName));            
        }

        private void SetupRuleMappings()
        {
            _rulesDictionary.Add(RuleName.ContractAllocationActualsReceived,
                new Dictionary<EventName, Func<string, int, bool>>
                {
                    {EventName.PaymentCalculated, EvaluateContractAllocationActualReceivedRuleForPaymentCalculated},
                    {EventName.PaymentAggregated, EvaluateContractAllocationActualReceivedRuleForPaymentAggregated},
                    {EventName.AllocationActualsVerified, EvaluateContractAllocationActualReceivedRuleForAllocationActualsVerified}
                }
            );
            _rulesDictionary.Add(RuleName.ContractAllocationPaymentPosted,
                new Dictionary<EventName, Func<string, int, bool>>
                {
                    {EventName.PaymentPosted, EvaluateContractAllocationPaymentPostedRuleForPaymentPosted}
        }
            );
        }

        private bool EvaluateContractAllocationActualReceivedRuleForPaymentCalculated(string allocationNumber, int contractVersionNumber)
        {
            IEnumerable<PaymentMethod> allowedPaymentMethods = new List<PaymentMethod> { PaymentMethod.NoPay, PaymentMethod.NoCalcAndNoPay };
            PaymentMethod? paymentMethod = GetPaymentMethod(allocationNumber, contractVersionNumber);

            return paymentMethod.HasValue && allowedPaymentMethods.Contains(paymentMethod.Value);
        }

        private bool EvaluateContractAllocationActualReceivedRuleForPaymentAggregated(string allocationNumber, int contractVersionNumber)
        {   
            return GetPaymentMethod(allocationNumber, contractVersionNumber) == PaymentMethod.PayOnActuals;
        }

        private bool EvaluateContractAllocationActualReceivedRuleForAllocationActualsVerified(string allocationNumber, int contractVersionNumber)
        {
            return GetPaymentMethod(allocationNumber, contractVersionNumber) == PaymentMethod.PayOnProfile;
        }

        private bool EvaluateContractAllocationPaymentPostedRuleForPaymentPosted(string allocationNumber, int contractVersionNumber)
        {
            var paymentMethod = GetPaymentMethod(allocationNumber, contractVersionNumber);
            return paymentMethod.HasValue && (paymentMethod == PaymentMethod.PayOnProfile || paymentMethod == PaymentMethod.PayOnActuals || paymentMethod == PaymentMethod.PayOnInstruction);
        }

        private PaymentMethod? GetPaymentMethod(string allocationNumber, int contractVersionNumber)
        {

            PaymentMethod? paymentMethod = null;
            var fundingStreamPeriod = _paymentSchedulePolicyContext.Allocations.SingleOrDefault(
                allocation =>
                    allocation.AllocationNumber == allocationNumber && allocation.VersionNumber == contractVersionNumber);
            if (fundingStreamPeriod != null)
            {
                string fundingStreamPeriodCode = fundingStreamPeriod.FundingStreamPeriodCode;
                paymentMethod = _paymentManagementPolicyContext.PolicyFundingStreamPeriods.Single(
                   fsp => fsp.FundingStreamPeriod == fundingStreamPeriodCode).PaymentMethod;
            }

            return paymentMethod;
        }
    }
}
