namespace AllocationDeliveryDomain.Endpoint.Repositories
{
    using System.Collections.Generic;
    using System.Linq;
    using AllocationDelivery.Messages.DTOs;
    using Services;
    using SFA.FCT.AllocationDeliveryDomain.Common.Storage;
    using SFA.FCT.CrossDomain.Integration.Entities.Data;

    public class MultiSourceActualRepository : IMultiSourceActualRepository
    {
        private readonly IAzureRepository<ReportedActual> _reportedActualRepository;
        private readonly ISummarisedActualRepository _summarisedActualRepository;

        public MultiSourceActualRepository(IAzureRepository<ReportedActual> reportedActualRepository, ISummarisedActualRepository summarisedActualRepository)
        {
            _reportedActualRepository = reportedActualRepository;
            _summarisedActualRepository = summarisedActualRepository;
        }

        public IReadOnlyCollection<ReportedActual> GetReportedActuals(string[] tableStoragePartitionKeys, SummarisedActualOrgFspGroupKey[] sqlOrgFspGroupKeys, ConnectionInfo connectionInfo)
        {
            // cater for nulls
            tableStoragePartitionKeys = tableStoragePartitionKeys ?? new string[] {};
            sqlOrgFspGroupKeys = sqlOrgFspGroupKeys ?? new SummarisedActualOrgFspGroupKey[] {};

            return Enumerable.Empty<ReportedActual>()
                .Concat(tableStoragePartitionKeys.SelectMany(GetReportedActualsFromAzureTableStorage))
                .Concat(sqlOrgFspGroupKeys.SelectMany(key => GetReportedActualsFromAzureSql(key, connectionInfo)))
                .ToList();
        }

        private IEnumerable<ReportedActual> GetReportedActualsFromAzureTableStorage(string partitionKey)
        {
            return _reportedActualRepository.GetRows(partitionKey);
        }

        private IEnumerable<ReportedActual> GetReportedActualsFromAzureSql(SummarisedActualOrgFspGroupKey groupKey, ConnectionInfo connectionInfo)
        {
            return
                _summarisedActualRepository.GetSummarisedActuals(groupKey, connectionInfo)
                .Select(SummarisedActualTransformer.ToReportedActual);
        }
    }
}