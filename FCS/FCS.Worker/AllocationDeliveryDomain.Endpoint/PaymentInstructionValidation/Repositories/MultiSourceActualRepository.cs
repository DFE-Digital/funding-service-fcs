namespace AllocationDeliveryDomain.Endpoint.PaymentInstructionValidation.Repositories
{
    using System;
    using System.Collections.Generic;
    using System.Linq;
    using System.Threading.Tasks;
    using AllocationDelivery.Messages.DTOs;
    using Endpoint.Repositories;
    using Services;
    using SFA.FCT.AllocationDeliveryDomain.Common.DataStore.Model;
    using SFA.FCT.AllocationDeliveryDomain.Common.Storage;
    using SFA.FCT.CrossDomain.Integration.Entities.Data;

    public class MultiSourceActualRepository : IMultiSourceActualRepository
    {
        private readonly IAzureRepository<ReportedActual> _reportedActualRepository;
        private readonly ISummarisedActualsQueryRepository _summarisedActualsRepository;

        public MultiSourceActualRepository(IAzureRepository<ReportedActual> reportedActualRepository, ISummarisedActualsQueryRepository summarisedActualsRepository)
        {
            _reportedActualRepository = reportedActualRepository;
            _summarisedActualsRepository = summarisedActualsRepository;
        }

        public async Task<IReadOnlyCollection<ReportedActual>> GetReportedActuals(string tableStoragePartitionKey, SummarisedActualOrgFspGroupKey sqlOrgFspGroupKey, ConnectionInfo connectionInfo)
        {
            if (tableStoragePartitionKey != null) 
            {
                return GetReportedActualsFromAzureTableStorage(tableStoragePartitionKey);
            }

            if (sqlOrgFspGroupKey != null)
            {
                return await GetReportedActualsFromAzureSql(sqlOrgFspGroupKey, connectionInfo);
            }

            throw new InvalidOperationException("Must provide Azure Table Storage key or Azure SQL key");
        }

        private IReadOnlyCollection<ReportedActual> GetReportedActualsFromAzureTableStorage(string partitionKey)
        {
            return _reportedActualRepository.GetRows(partitionKey)
                .ToList();
        }

        private async Task<IReadOnlyCollection<ReportedActual>> GetReportedActualsFromAzureSql(SummarisedActualOrgFspGroupKey groupKey, ConnectionInfo connectionInfo)
        {
            IReadOnlyCollection<SummarisedActual> summarisedActuals = await _summarisedActualsRepository.GetSummarisedActuals(groupKey, connectionInfo);

            return summarisedActuals
                .Select(SummarisedActualTransformer.ToReportedActual)
                .ToList();
        }
    }
}