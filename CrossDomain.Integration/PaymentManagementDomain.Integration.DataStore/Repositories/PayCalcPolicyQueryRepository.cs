namespace SFA.FCT.PaymentManagementDomain.PolicyCache.DataStore.Repositories
{
    using System.Collections.Generic;
    using System.Linq;
    using Model;
    using SFA.FCT.CrossDomain.Integration.Entities.Data;

    public class PayCalcPolicyQueryRepository : IPayCalcPolicyQueryRepository
    {
        private readonly IEntityCache<string, PolicyFundingStreamPeriod> _fundingStreamPeriods;
        private readonly IEntityCache<string, IReadOnlyCollection<PolicyDeliverable>> _fundingStreamPeriodDeliverables;
        private readonly IEntityCache<string, IReadOnlyCollection<CappingGroup>> _fundingStreamPeriodCappingGroups;

        public PayCalcPolicyQueryRepository(
            IEntityCache<string, PolicyFundingStreamPeriod> fundingStreamPeriods,
            IEntityCache<string, IReadOnlyCollection<PolicyDeliverable>> fundingStreamPeriodDeliverables,
            IEntityCache<string, IReadOnlyCollection<CappingGroup>> fundingStreamPeriodCappingGroups)
        {
            _fundingStreamPeriods = fundingStreamPeriods;
            _fundingStreamPeriodDeliverables = fundingStreamPeriodDeliverables;
            _fundingStreamPeriodCappingGroups = fundingStreamPeriodCappingGroups;
        }

        public PolicyFundingStreamPeriod GetFundingStreamPeriod(string fundingStreamPeriodCode, ConnectionInfo connectionInfo)
        {
            using (var context = new PaymentManagementPolicyContext(connectionInfo))
            {
                return _fundingStreamPeriods.GetOrAdd(fundingStreamPeriodCode, key => context.PolicyFundingStreamPeriods.Find(key));
            }
        }

        public PolicyFundingStreamPeriod GetFundingStreamPeriod(ConnectionInfo connectionInfo, string fundingStreamPeriodCode)
        {
            return _fundingStreamPeriods.GetOrAdd(fundingStreamPeriodCode, key =>
            {
                using (var context = new PaymentManagementPolicyContext(connectionInfo))
                {
                    return context.PolicyFundingStreamPeriods.Find(key);
                }
            });
        }

        public IReadOnlyCollection<PolicyDeliverable> GetFundingStreamPeriodDeliverables(string fundingStreamPeriodCode, ConnectionInfo connectionInfo)
        {
            return _fundingStreamPeriodDeliverables.GetOrAdd(fundingStreamPeriodCode, key =>
            {
                using (var context = new PaymentManagementPolicyContext(connectionInfo))
                {
                    return context.PolicyDeliverables
                        .Where(pd => pd.FundingStreamPeriod == key)
                        .ToList()
                        .AsReadOnly();
                }
            });
        }

        public IReadOnlyCollection<PolicyDeliverable> GetFundingStreamPeriodDeliverablesNonConnectionInfo(string fundingStreamPeriodCode)
        {
            return _fundingStreamPeriodDeliverables.GetOrAdd(fundingStreamPeriodCode, key =>
            {
                using (var context = new PaymentManagementPolicyContext()) // avoid ConnectionInfo in this method to avoid many changes to callers of SupplyDocumentGenerationRequest
                {
                    return context.PolicyDeliverables
                        .Where(pd => pd.FundingStreamPeriod == key)
                        .ToList()
                        .AsReadOnly();
                }
            });
        }

        public IReadOnlyCollection<CappingGroup> GetFundingStreamPeriodCappingGroups(string fundingStreamPeriodCode, ConnectionInfo connectionInfo)
        {
            return _fundingStreamPeriodCappingGroups.GetOrAdd(fundingStreamPeriodCode, key =>
            {
                using (var context = new PaymentManagementPolicyContext(connectionInfo))
                {
                    return context.CappingGroups
                        .Where(cg => cg.FundingStreamPeriod == key)
                        .ToList()
                        .AsReadOnly();
                }
            });
        }

        public IReadOnlyCollection<PolicyFundingStreamCensusDate> GetFundingStreamPeriodCensusDates(string fundingStreamPeriodCode, ConnectionInfo connectionInfo)
        {
            using (var context = new PaymentManagementPolicyContext(connectionInfo))
            {
                // explicitly do not cache census dates to allow emergency changes to underlying database at month-end
                return context.PolicyFundingStreamCensusDates
                    .Where(cd => cd.FundingStreamPeriod == fundingStreamPeriodCode)
                    .ToList()
                    .AsReadOnly();
            }
        }

        public bool IsFspContractAllocationCappingWithChildProfileDeliverables(string fundingStreamPeriodCode, ConnectionInfo connectionInfo)
        {
            PolicyFundingStreamPeriod fsp = GetFundingStreamPeriod(fundingStreamPeriodCode, connectionInfo);

            if (fsp.PaymentCappingLevel == PaymentCappingLevelType.ContractAllocation)
            {
                var policyDeliverables = GetFundingStreamPeriodDeliverables(fundingStreamPeriodCode, connectionInfo);

                return policyDeliverables.Any(pd => pd.ParentDeliverableCode.HasValue && pd.AllowProfile);
            }

            return false;
        }

        public IReadOnlyCollection<int> GetDeliverableCodesWherePlannedValueShouldNotBeUsedInCalc(string fundingStreamPeriodCode, ConnectionInfo connectionInfo)
        {
            PolicyFundingStreamPeriod fsp = GetFundingStreamPeriod(fundingStreamPeriodCode, connectionInfo);

            if (fsp.PaymentCappingLevel == PaymentCappingLevelType.ContractAllocation)
            {
                var policyDeliverables = GetFundingStreamPeriodDeliverables(fundingStreamPeriodCode, connectionInfo);

                return policyDeliverables.Where(pd => pd.ParentDeliverableCode.HasValue && pd.AllowProfile).Select(pd => pd.ParentDeliverableCode.Value)
                    .Distinct()
                    .ToList();
            }

            return Enumerable.Empty<int>().ToList();
        }

        public PolicySubnominal GetSubnominal(int subnominalCode, PaymentType paymentType, ConnectionInfo connectionInfo)
        {
            using (var context = new PaymentManagementPolicyContext(connectionInfo))
            {
                return context.PolicySubnominals.Find(subnominalCode, paymentType);
            }
        }

        public static PayCalcPolicyQueryRepository CreateInstance()
        {
            return new PayCalcPolicyQueryRepository(
                new EntityCache<string, PolicyFundingStreamPeriod>(),
                new EntityCache<string, IReadOnlyCollection<PolicyDeliverable>>(),
                new EntityCache<string, IReadOnlyCollection<CappingGroup>>());
        }
    }
}