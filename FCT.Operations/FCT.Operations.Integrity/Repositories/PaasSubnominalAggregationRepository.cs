namespace SFA.FCT.Operations.Integrity.Repositories
{
    using System;
    using System.Collections.Concurrent;
    using System.Collections.Generic;
    using System.Data;
    using System.Linq;
    using System.Security.Cryptography;
    using System.Text;
    using Dapper;
    using DTOs;
    using Utils;

    public class PaasSubnominalAggregationRepository : IPaasSubnominalAggregationRepository
    {
        private readonly ConcurrentDictionary<Guid, Lazy<IReadOnlyCollection<SubnominalAggregationInfo>>> _cache;
        private readonly IDbConnection _connection;

        public PaasSubnominalAggregationRepository(IDbConnection connection)
        {
            _connection = connection;
            _cache = new ConcurrentDictionary<Guid, Lazy<IReadOnlyCollection<SubnominalAggregationInfo>>>();
        }

        public IReadOnlyCollection<SubnominalAggregationInfo> GetSubnominalAggregations(IReadOnlyCollection<string> fspCodes)
        {
            Lazy<IReadOnlyCollection<SubnominalAggregationInfo>> lazy = _cache.GetOrAdd(
                GenerateGuid(fspCodes),
                _ => new Lazy<IReadOnlyCollection<SubnominalAggregationInfo>>(() => GetData(fspCodes)));

            return lazy.Value;
        }

        public IReadOnlyCollection<SubnominalAggregationInfo> GetSubnominalAggregationsForOpenContracts(IReadOnlyCollection<string> fspCodes)
        {
            return GetSubnominalAggregations(fspCodes)
                .Where(sa => !sa.IsInactiveContract)
                .ToList();
        }

        public Guid GenerateGuid(IReadOnlyCollection<string> fspCodes)
        {
            string input = string.Join("_", fspCodes.OrderBy(s => s));

            using (MD5 md5 = MD5.Create())
            {
                byte[] hash = md5.ComputeHash(Encoding.Default.GetBytes(input));
                return new Guid(hash);
            }
        }

        private IReadOnlyCollection<SubnominalAggregationInfo> GetData(IReadOnlyCollection<string> fspCodes)
        {
            var param = new DynamicParameters();
            param.Add("fspCodes", getFspCodesTable(fspCodes).AsTableValuedParameter("FspCodesUDT"));
            return FunctionRetrier.RetryWhenExceptionThrown(() => _connection.Query<SubnominalAggregationInfo>("sp_Operations_GetData", param, commandType: CommandType.StoredProcedure, commandTimeout: 180)
                .ToList(), 10);
        }

        private static DataTable getFspCodesTable(IReadOnlyCollection<string> fspCodes)
        {
            DataTable fspDT = new DataTable();
            fspDT.Columns.Add("FspCodes");
            foreach (var fsp in fspCodes)
            {
                fspDT.Rows.Add(fsp);
            }
            return fspDT;
        }
    }
}
