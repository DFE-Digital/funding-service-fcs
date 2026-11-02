namespace Operations.Web.Repositories
{
    using System.Collections.Generic;
    using System.Configuration;
    using System.Data.SqlClient;
    using System.Linq;
    using System.Threading.Tasks;
    using Dapper;
    using Dtos;
    using Operations.Web.FundDataStore;
    using System.Data.Entity;

    public class ParkedFundingAllocationRepository : IParkedFundingAllocationRepository
    {
        public async Task<IReadOnlyCollection<ParkedFundingAllocationsSubStatusInfo>> GetSubStatusCounts()
        {

            using (var context = new FundingAllocationDbContext())
            {
                var closedCollections = await (from fa in context.FundingAllocations
                                               where fa.Status == "Parked"
                                               && fa.SubStatus != null
                                               select fa)
                              .GroupBy(fa => fa.SubStatus)
                              .Select(fa => new ParkedFundingAllocationsSubStatusInfo
                              {
                                  SubStatus = fa.FirstOrDefault().SubStatus,
                                  Count = fa.Count()
                              })
                              .ToListAsync();

                return closedCollections.ToList();
            }
        }

        public async Task<IReadOnlyCollection<AwaitingProviderInfo>> GetAwaitingProviderDetails()
        {
            string connectionString = ConfigurationManager
                .ConnectionStrings["ContractManagementDbContext"].ConnectionString;

            using (var connection = new SqlConnection(connectionString))
            {

                var closedCollections = await connection.QueryAsync<AwaitingProviderInfo>("sp_FA_GetAwaitingProviderDetails")
                    .ConfigureAwait(false);

                return closedCollections.ToList();
            }
        }

        public async Task<IReadOnlyCollection<AwaitingFundingLineInfo>> GetAwaitingFundingLineDetails()
        {

            using (var context = new FundingAllocationDbContext())
            {
                var closedCollections = await (from fa in context.FundingAllocations
                                               where fa.Status == "Parked"
                                               && fa.SubStatus == "AwaitingFundingLineConfig"
                                               select fa)
                              .GroupBy(fa => new { fa.AllocationFundingStream, fa.Period })
                              .Select(fa => new AwaitingFundingLineInfo
                              {
                                  CfsFundingStream = fa.FirstOrDefault().AllocationFundingStream
                                 ,
                                  CfsFundingPeriod = fa.FirstOrDefault().Period
                                 ,
                                  CountOfFAs = fa.Count()
                              }).OrderBy(o => new { o.CfsFundingPeriod, o.CfsFundingStream }).ToListAsync();

                return closedCollections;
            }

        }

        public async Task<IReadOnlyCollection<AwaitingFundingAllocationInfo>> GetAwaitingFundingAllocationDetails()
        {
            using (var context = new FundingAllocationDbContext())
            {
                var closedCollections = await (from fa in context.FundingAllocations
                                               where fa.Status == "Parked"
                                               && fa.SubStatus == "AwaitingFundingAllocationConfig"
                                               select fa)
                              .GroupBy(fa => new { fa.AllocationFundingStream, fa.Period })
                              .Select(fa => new AwaitingFundingAllocationInfo
                              {
                                  CfsFundingStream = fa.FirstOrDefault().AllocationFundingStream
                                 ,
                                  CfsFundingPeriod = fa.FirstOrDefault().Period
                                 ,
                                  CountOfFAs = fa.Count()
                              }).OrderBy(o => new { o.CfsFundingPeriod, o.CfsFundingStream }).ToListAsync();

                return closedCollections;
            }

        }
        public async Task<IReadOnlyCollection<AwaitingContractTypeInfo>> GetAwaitingContractTypeDetails()
        {
            string connectionString = ConfigurationManager
                .ConnectionStrings["ContractManagementDbContext"].ConnectionString;

            using (var connection = new SqlConnection(connectionString))
            {
                var closedCollections = await connection.QueryAsync<AwaitingContractTypeInfo>("sp_FA_GetAwaitingContractTypeDetails")
                     .ConfigureAwait(false);

                return closedCollections.ToList();
            }
        }

        public async Task<IReadOnlyCollection<ProviderTypeSubtypeInfo>> GetUnknownProviderTypeSubtypeDetails()
        {
            string connectionString = ConfigurationManager
                .ConnectionStrings["ContractManagementDbContext"].ConnectionString;

            using (var connection = new SqlConnection(connectionString))
            {
                var missingTypeSubTypes = await connection.QueryAsync<ProviderTypeSubtypeInfo>("sp_FA_GetUnknownProviderTypeSubtypeDetails")
                    .ConfigureAwait(false);

                return missingTypeSubTypes.ToList();
            }
        }
    }
}