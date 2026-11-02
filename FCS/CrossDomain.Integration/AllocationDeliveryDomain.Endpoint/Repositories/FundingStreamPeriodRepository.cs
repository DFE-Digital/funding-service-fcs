namespace AllocationDeliveryDomain.Endpoint.Repositories
{
    using Optional;
    using SFA.FCT.AllocationDeliveryDomain.Common.DataStore.Model;
    using System.Collections.Concurrent;
    using System;
    using Dapper;
    using SFA.FCT.CrossDomain.Integration.Entities.Data;

    public class FundingStreamPeriodRepository : IFundingStreamPeriodRepository
    {
        private static readonly ConcurrentDictionary<string, Lazy<Option<FundingStreamPeriod>>> OptionalFundingStreamPeriods
            = new ConcurrentDictionary<string, Lazy<Option<FundingStreamPeriod>>>();

        public Option<FundingStreamPeriod> GetFundingStreamPeriod(string fundingStreamPeriodCode, ConnectionInfo connectionInfo)
        {
            var lazyGetFundingStreamPeriod = new Lazy<Option<FundingStreamPeriod>>(() =>  GetFromDb(fundingStreamPeriodCode, connectionInfo));

            lazyGetFundingStreamPeriod = OptionalFundingStreamPeriods.GetOrAdd(fundingStreamPeriodCode, lazyGetFundingStreamPeriod);

            return lazyGetFundingStreamPeriod.Value;
        }

        private Option<FundingStreamPeriod> GetFromDb(string fundingStreamPeriodCode, ConnectionInfo connectionInfo)
        {

            var fundingStreamPeriod = connectionInfo.Connection.QuerySingleOrDefault<FundingStreamPeriod>("dbo.sp_AllocDelDomain_GetFromDb @fundingStreamPeriodCode", new { fundingStreamPeriodCode }, transaction: connectionInfo.Transaction);

            return fundingStreamPeriod?.Some() ?? new Option<FundingStreamPeriod>();
        }
    }
}