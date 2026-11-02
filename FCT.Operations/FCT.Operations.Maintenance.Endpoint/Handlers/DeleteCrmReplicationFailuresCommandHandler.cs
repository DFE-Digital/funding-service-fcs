namespace SFA.FCT.Operations.Maintenance.Endpoint.Handlers
{
    using System;
    using System.Data.SqlClient;
    using System.Threading.Tasks;
    using Common;
    using CrossDomain.Integration.Messages.Commands;
    using Framework.Logging.Interfaces;
    using NServiceBus;
    using Repositories;
    using FCS.Worker.Common;
    using ConnectionInfo = CrossDomain.Integration.Entities.Data.ConnectionInfo;

    public class DeleteCrmReplicationFailuresCommandHandler : IHandleMessages<DeleteCrmReplicationFailuresCommand>
    {
        private readonly ILogger _logger;
        private readonly ICrmReplicaRepository _crmReplicaRepository;
        private readonly ICrmReplicaRowDeleteRepository _crmReplicaRowDeleteRepository;
        private readonly IFcsConfiguration _configuration;

        public DeleteCrmReplicationFailuresCommandHandler(ILogger logger, ICrmReplicaRepository crmReplicaRepository, ICrmReplicaRowDeleteRepository crmReplicaRowDeleteRepository, IFcsConfiguration configuration)
        {
            _logger = logger;
            _crmReplicaRepository = crmReplicaRepository;
            _crmReplicaRowDeleteRepository = crmReplicaRowDeleteRepository;
            _configuration = configuration;
        }

        public async Task Handle(DeleteCrmReplicationFailuresCommand message, IMessageHandlerContext context)
        {
            _logger.LogInformation(LoggingEventId.DeleteCrmReplicationFailuresStart, "DeleteCrmReplicationFailuresCommand arrived");

            var contractReplicationFailures = await _crmReplicaRepository.GetContractReplicationFailures();

            var connectionString = _configuration["ConnectionStrings:CrmDatabaseConnectionString"];

            using (var connection = new SqlConnection(connectionString))
            {
                connection.Open();

                using (var transaction = connection.BeginTransaction())
                {
                    var connectionInfo = new ConnectionInfo(transaction, connection);

                    foreach (var c in contractReplicationFailures)
                    {
                        _logger.LogInformation(LoggingEventId.DeletingCrmReplicationFailure, $"Removing CRM replication 'Deletion Synchronization Failure' contract (and child records) for {c}");
                        await RemoveContractAndRelatedRecords(c.RecordId, connectionInfo).ConfigureAwait(continueOnCapturedContext: false); 
                    }

                    transaction.Commit();
                }
            }
            _logger.LogInformation(LoggingEventId.DeleteCrmReplicationFailuresFinish, "DeleteCrmReplicationFailuresCommand completed");
        }

        private async Task RemoveContractAndRelatedRecords(Guid recordId, ConnectionInfo connectionInfo)
        {
            await _crmReplicaRowDeleteRepository.DeleteContactDeliverablePeriodsForContractId(recordId, connectionInfo).ConfigureAwait(continueOnCapturedContext: false);
            await _crmReplicaRowDeleteRepository.DeleteContactDeliverablesForContractId(recordId, connectionInfo).ConfigureAwait(continueOnCapturedContext: false);
            await _crmReplicaRowDeleteRepository.DeleteContactAllocationsForContractId(recordId, connectionInfo).ConfigureAwait(continueOnCapturedContext: false);
            await _crmReplicaRowDeleteRepository.DeleteContactForContractId(recordId, connectionInfo).ConfigureAwait(continueOnCapturedContext: false);
        }
    }
}