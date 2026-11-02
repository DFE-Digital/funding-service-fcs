namespace SFA.FCT.Operations.Integrity.Services
{
    using System;
    using System.Collections.Generic;
    using System.Configuration;
    using System.Data.SqlClient;
    using System.Linq;
    using Dapper;
    using DTOs;
    using FCS.Worker.Common;
    using Framework.Logging.Interfaces;
    using Repositories;

    public class ChangeTrackerService : IChangeTrackerService
    {
        public const string PaasToCrmDeliverablePayment = "PAAS_TO_CRM_CHECK_DELIVERABLE_PAYMENT";
        private readonly IIntegrityCheckChangeTrackingRepository _integrityCheckChangeTrackingRepository;
        private readonly ILogger _logger;
        private readonly IFcsConfiguration _configuration;

        public ChangeTrackerService(
            IIntegrityCheckChangeTrackingRepository integrityCheckChangeTrackingRepository,
            ILogger logger, IFcsConfiguration configuration)
        {
            _integrityCheckChangeTrackingRepository = integrityCheckChangeTrackingRepository;
            _logger = logger;
            _configuration = configuration;
        }

        public ChangeTrackedDeliverablePayments GetDeliverablePaymentChanges(long? changeTrackingCurrentVersionOverride)
        {
            long startingCurrentVersion =
                changeTrackingCurrentVersionOverride ?? _integrityCheckChangeTrackingRepository.GetCurrentVersion(PaasToCrmDeliverablePayment);

            _logger.LogInformation(IntegrityLoggingIds.TrackingCurrentVersion, $"The tracking current version is: {startingCurrentVersion}");

            var rows = GetChangesSince(startingCurrentVersion);

            var currentVersion = rows.LastOrDefault()?.SYS_CHANGE_VERSION ?? startingCurrentVersion;

            var keys = rows.Select(r => new DeliverablePaymentKey(r.AllocationNumber, r.VersionNumber, r.DeliverableCode, int.Parse(r.Period), r.FundingStreamPeriodCode))
                .ToList();

            return new ChangeTrackedDeliverablePayments(keys, currentVersion);
        }

        private IReadOnlyCollection<dynamic> GetChangesSince(long currentVersion)
        {
            var connectionString = _configuration["ConnectionStrings:OperationsDbContext"];

            using (var connection = new SqlConnection(connectionString))
            {
                const string sqlQuery = @"SELECT SYS_CHANGE_VERSION,
                                                 dp.AllocationNumber,
                                                 dp.VersionNumber,
                                                 DeliverableCode,
                                                 Period,
												 a.FundingStreamPeriodCode
                                        FROM CHANGETABLE(CHANGES [PaymentSchedule].[DeliverablePayment], @currentVersion) dp, [PaymentSchedule].[Allocation] a
                                        where SYS_CHANGE_OPERATION IN ('I', 'U')
										and dp.AllocationNumber = a.AllocationNumber
										and dp.VersionNumber = a.VersionNumber
                                        order by SYS_CHANGE_VERSION";

                return connection.Query<dynamic>(
                    sqlQuery,
                    new {currentVersion},
                    commandTimeout:(int)TimeSpan.FromMinutes(30).TotalSeconds)
                    .ToList();
            }
        }
    }
}
