namespace PaymentManagement.Calculation.Repositories
{
    using System;
    using System.Collections.Concurrent;
    using System.Collections.Generic;
    using System.Data.Entity;
    using System.Linq;
    using Dapper;
    using Dtos;
    using SFA.FCT.CrossDomain.Integration.Entities.Data;
    using SFA.FCT.PaymentManagementDomain.PolicyCache.DataStore;
    using SFA.FCT.PaymentManagementDomain.PolicyCache.DataStore.Model;
    using CappingGroup = Dtos.CappingGroup;

    public class PolicyFundingStreamPeriodRepository : IPolicyFundingStreamPeriodRepository
    {
       
        private static readonly ConcurrentDictionary<FspPeriod, Lazy<FspCalcConfigInfo>> CachedFspCalcConfigInfos
            = new ConcurrentDictionary<FspPeriod, Lazy<FspCalcConfigInfo>>();

        private static readonly ConcurrentDictionary<string, Lazy<PolicyFundingStreamPeriod>> CachedFsps
            = new ConcurrentDictionary<string, Lazy<PolicyFundingStreamPeriod>>();

        private static readonly ConcurrentDictionary<string, Lazy<IReadOnlyCollection<FspDeliverableInfo>>> CachedFspDeliverableInfos
            = new ConcurrentDictionary<string, Lazy<IReadOnlyCollection<FspDeliverableInfo>>>();

        private static readonly ConcurrentDictionary<string, Lazy<IReadOnlyCollection<CappingGroup>>> CachedCappingGroups
            = new ConcurrentDictionary<string, Lazy<IReadOnlyCollection<CappingGroup>>>();

        public FspCalcConfigInfo GetFspCalcConfigInfo(string fundingStreamPeriodCode, Period currentPeriod, ConnectionInfo connectionInfo)
        {
            var lazyFspCalcConfigInfo = new Lazy<FspCalcConfigInfo>(() => GetFspCalcConfigInfoFromDb(fundingStreamPeriodCode, currentPeriod, connectionInfo));

            lazyFspCalcConfigInfo = CachedFspCalcConfigInfos.GetOrAdd(new FspPeriod(fundingStreamPeriodCode, currentPeriod), lazyFspCalcConfigInfo);

            return lazyFspCalcConfigInfo.Value;
        }

        public PaymentMethod GetPaymentMethod(string fundingStreamPeriodCode, ConnectionInfo connectionInfo)
        {
            var lazyFsp = new Lazy<PolicyFundingStreamPeriod>(() => GetFundingStreamPeriodFromDb(fundingStreamPeriodCode, connectionInfo));

            lazyFsp = CachedFsps.GetOrAdd(fundingStreamPeriodCode, lazyFsp);

            return lazyFsp.Value.PaymentMethod;
        }

        public IReadOnlyCollection<FspDeliverableInfo> GetFspDeliverableInfos(string fundingStreamPeriodCode, ConnectionInfo connectionInfo)
        {
            var lazyFspDeliverableInfos = new Lazy<IReadOnlyCollection<FspDeliverableInfo>>(() => GetFspDeliverableInfosFromDb(fundingStreamPeriodCode, connectionInfo));

            return CachedFspDeliverableInfos.GetOrAdd(fundingStreamPeriodCode, lazyFspDeliverableInfos).Value;
        }

        public IReadOnlyCollection<CappingGroup> GetCappingGroups(string fundingStreamPeriodCode, ConnectionInfo connectionInfo)
        {
            var lazyCappingGroups = new Lazy<IReadOnlyCollection<CappingGroup>>(() => GetCappingGroupsFDromDb(fundingStreamPeriodCode, connectionInfo));

            return CachedCappingGroups.GetOrAdd(fundingStreamPeriodCode, lazyCappingGroups).Value;
        }

        public IReadOnlyCollection<CappingGroup> GetCappingGroupsFDromDb(string fundingStreamPeriodCode, ConnectionInfo connectionInfo)
        {
            using (var context = new PaymentManagementPolicyContext())
            {
                var cappingGroups = context.CappingGroups
                              .Where(cg => cg.FundingStreamPeriod == fundingStreamPeriodCode)
                              .Select(r => new
                              {
                                  r.FundingStreamPeriodCappingGroupId,
                                  r.AllowUnderDeliveryToBeReUsed,
                                  r.AllowOverDeliveryToBeOffset
                              }).AsEnumerable()
                              .Select(r => new CappingGroup(r.FundingStreamPeriodCappingGroupId
                              , r.AllowUnderDeliveryToBeReUsed
                              , r.AllowOverDeliveryToBeOffset)).ToList();
                              
                return cappingGroups;

            }
       
        }

        public IReadOnlyCollection<FspDeliverableInfo> GetFspDeliverableInfosFromDb(string fundingStreamPeriodCode, ConnectionInfo connectionInfo)
        {
            using (var context = new PaymentManagementPolicyContext())
            {
                var fspDeliverableInfo = context.PolicyDeliverables
                              .Where(cg => cg.FundingStreamPeriod == fundingStreamPeriodCode)
                              .Select(r => new
                              {
                                  r.DeliverableCode,
                                  r.AllowProfile,
                                  r.CappingApportionmentPriorityOrder,
                                  r.FundingStreamPeriodCappingGroupId,
                                 AllowPayment= r.IsPayable
                              }).AsEnumerable()
                              .Select(r => new FspDeliverableInfo(r.DeliverableCode,
                                  r.AllowProfile,
                                  r.CappingApportionmentPriorityOrder,
                                  r.FundingStreamPeriodCappingGroupId,
                                  r.AllowPayment)).ToList();

               return fspDeliverableInfo;
            }


            
        }

        private PolicyFundingStreamPeriod GetFundingStreamPeriodFromDb(string fundingStreamPeriodCode, ConnectionInfo connectionInfo)
        {
            using (var context = new PaymentManagementPolicyContext(connectionInfo))
            {
                return context.PolicyFundingStreamPeriods
                    .AsNoTracking()
                    .Single(fsp => fsp.FundingStreamPeriod == fundingStreamPeriodCode);
            }
        }

        public FspCalcConfigInfo GetFspCalcConfigInfoFromDb(string fundingStreamPeriodCode, Period currentPeriod, ConnectionInfo connectionInfo)
        {
          var rows = connectionInfo.Connection.Query<dynamic>("dbo.sp_PaymentManagement_GetFspCalcConfigInfoFromDb @fundingStreamPeriodCode,@month,@year",
                new {fundingStreamPeriodCode,month=currentPeriod?.Month, year=currentPeriod?.Year}, transaction:connectionInfo.Transaction);

            var grps = rows.GroupBy(r => new
                {
                    r.PaymentMethod, r.PaymentCappingPeriod, r.PaymentCappingLevel, r.IsPrioritisedApportionment,
                    r.OverrideCappingPeriod, r.CalcPolicyVersion
                });

               return grps.Select(grp => new FspCalcConfigInfo(
                    paymentMethod: (PaymentMethod) grp.Key.PaymentMethod,
                    paymentCappingPeriod: (PaymentCappingPeriodType?) grp.Key.PaymentCappingPeriod,
                    paymentCappingLevel: (PaymentCappingLevelType?) grp.Key.PaymentCappingLevel,
                    isPrioritisedApportionment: grp.Key.IsPrioritisedApportionment,
                    overrideCappingPeriod: (PaymentCappingPeriodType?) grp.Key.OverrideCappingPeriod ,
                    calcPolicyVersion: grp.Key.CalcPolicyVersion,
                    cappingPeriods: grp.Where(cp => cp.CappingPeriod != null)
                        .Select(cp => new CappingPeriod(cp.CappingPeriod, cp.OverDeliveryLimit))
                        .ToList()
                )).Single();
        }

        private class FspPeriod
        {
            public FspPeriod(string fundingStreamPeriodCode, Period period)
            {
                FundingStreamPeriodCode = fundingStreamPeriodCode;
                Period = period;
            }

            public string FundingStreamPeriodCode { get; }

            public Period Period { get; }

            public override bool Equals(object obj)
            {
                if (obj is FspPeriod other)
                {
                    return other.FundingStreamPeriodCode == FundingStreamPeriodCode && other.Period == Period;
                }

                return false;
            }

            public override int GetHashCode()
            {
                if (Period != null)
                {
                    return FundingStreamPeriodCode.GetHashCode() ^ Period.GetHashCode();
                }

                return FundingStreamPeriodCode.GetHashCode();
            }
        }
    }
}