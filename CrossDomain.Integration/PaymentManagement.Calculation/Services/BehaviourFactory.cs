namespace PaymentManagement.Calculation.Services
{
    using System;
    using System.Collections.Generic;
    using Behaviours;
    using Dtos;
    using Extensions;
    using Optional;
    using Repositories;
    using SFA.FCT.CrossDomain.Integration.Entities.Data;
    using SFA.FCT.PaymentManagementDomain.PolicyCache.DataStore.Model;

    public class BehaviourFactory : IBehaviourFactory
    {
        private static readonly IDictionary<BehaviourKey, Func<CalculationAllocationInput, CensusPeriodInfo, IReadOnlyCollection<CalculationResultLine>>> CappingCalculators 
            = new Dictionary<BehaviourKey, Func<CalculationAllocationInput, CensusPeriodInfo, IReadOnlyCollection<CalculationResultLine>>>
        {
            {
                new BehaviourKey(PaymentCappingPeriodType.ContractDuration, PaymentCappingLevelType.DeliverableLine),
                AllocationDurationDeliverableLineBehaviour.Calculate
            },
            {
                new BehaviourKey(PaymentCappingPeriodType.ContractDuration, PaymentCappingLevelType.ContractAllocation),
                AllocationDurationAllocationLevelBehaviour.Calculate
            },
            {
                new BehaviourKey(PaymentCappingPeriodType.FinancialYear, PaymentCappingLevelType.ContractAllocation),
                FinancialYearAllocationLevelBehaviour.Calculate
            },
            {
                new BehaviourKey(PaymentCappingPeriodType.FinancialYear, PaymentCappingLevelType.ContractAllocation, isPrioritisedApportionment:true),
                FinancialYearAllocationLevelWithPrioritisedApportionmentBehaviour.Calculate
            },
            {
                new BehaviourKey(PaymentCappingPeriodType.ContractDuration, PaymentCappingLevelType.Group, isPrioritisedApportionment:false),
                AllocationDurationDeliverableGroupBehaviour.Calculate
            },
            {
                new BehaviourKey(PaymentCappingPeriodType.ContractDuration, PaymentCappingLevelType.ContractAllocation, isPrioritisedApportionment:true),
                AllocationDurationAllocationLevelWithPrioritisedApportionmentBehaviour.Calculate
            },
            {
                new BehaviourKey(paymentCappingPeriodType:PaymentCappingPeriodType.FinancialYear, paymentCappingLevelType:PaymentCappingLevelType.Group, paymentMethod:PaymentMethod.PayOnActuals),
                FinancialYearDeliverableGroupBehaviour.Calculate
            },
            {
                new BehaviourKey(paymentCappingPeriodType:null, paymentCappingLevelType:null, paymentMethod:PaymentMethod.PayOnProfile),
                PayOnProfileBehaviour.Calculate
            },
            {
                new BehaviourKey(paymentCappingPeriodType:null, paymentCappingLevelType:null, paymentMethod:PaymentMethod.NoPay),
                PaidExternallyBehaviour.Calculate
            }
        };

        private readonly IPolicyFundingStreamPeriodRepository _fspRepository;

        public BehaviourFactory(IPolicyFundingStreamPeriodRepository fspRepository)
        {
            _fspRepository = fspRepository;
        }

        public Option<Behaviour> GetBehaviour(string fsp, Period currentPeriod, ConnectionInfo connectionInfo)
        {
            var config = _fspRepository.GetFspCalcConfigInfo(fsp, currentPeriod, connectionInfo);
            BehaviourKey behaviourKey = new BehaviourKey(config.GetPaymentCappingPeriodType(), config.PaymentCappingLevel, config.IsPrioritisedApportionment, config.PaymentMethod);

            var optionalCalculator = CappingCalculators.GetValueOrNull(behaviourKey)
                .NoneWhen(b => b == null);

            return optionalCalculator.Match(some: c =>
                {
                    return new Behaviour(c, config.CappingPeriods, config.PaymentMethod).Some();
                },
                none: () => new Option<Behaviour>());
        }

        private class BehaviourKey
        {
            private readonly int _paymentCappingPeriodValue = -1;
            private readonly int _paymentCappingLevelType = -1;

            public BehaviourKey(PaymentCappingPeriodType? paymentCappingPeriodType, PaymentCappingLevelType? paymentCappingLevelType, bool isPrioritisedApportionment = false, PaymentMethod paymentMethod = PaymentMethod.PayOnActuals)
            {
                PaymentCappingPeriodType = paymentCappingPeriodType;
                PaymentCappingLevelType = paymentCappingLevelType;
                IsPrioritisedApportionment = isPrioritisedApportionment;
                PaymentMethod = paymentMethod;

                _paymentCappingPeriodValue = paymentCappingPeriodType.HasValue ? (int)paymentCappingPeriodType : -1;
                _paymentCappingLevelType = paymentCappingLevelType.HasValue ? (int)paymentCappingLevelType : -1;
            }

            public PaymentCappingPeriodType? PaymentCappingPeriodType { get; }

            public PaymentCappingLevelType? PaymentCappingLevelType { get; }

            public bool IsPrioritisedApportionment { get; }

            public PaymentMethod PaymentMethod { get; }

            public override bool Equals(object obj)
            {
                if (obj is BehaviourKey other)
                {
                    return PaymentCappingLevelType == other.PaymentCappingLevelType &&
                           PaymentCappingPeriodType == other.PaymentCappingPeriodType &&
                           IsPrioritisedApportionment == other.IsPrioritisedApportionment &&
                           PaymentMethod == other.PaymentMethod;
                }

                return false;
            }

            public override int GetHashCode()
            {
                return _paymentCappingPeriodValue.GetHashCode() ^ _paymentCappingLevelType.GetHashCode() ^
                       IsPrioritisedApportionment.GetHashCode() ^ PaymentMethod.GetHashCode();
            }
        }
    }
}
