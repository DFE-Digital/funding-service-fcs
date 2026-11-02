namespace SFA.FCT.Operations.Integrity.Repositories
{
    using System;
    using System.Collections.Generic;
    using System.Data;
    using System.IO;
    using System.Linq;
    using System.Reflection;
    using Dapper;
    using DTOs;
    using Framework.Logging.Interfaces;
    using Utils;

    public class PaasDeliverablePaymentLazyRepository : IPaasDeliverablePaymentLazyRepository
    {
        private const string SqlResourceName = @"SFA.FCT.Operations.Integrity.IntegrityCheckers.Sql.AnitaPaasExtract.sql";
        private const string SqlDeliverableResourceName = @"SFA.FCT.Operations.Integrity.IntegrityCheckers.Sql.GetDeliverablePaymentsForFsps.sql";
        private static readonly int CommandTimeoutFiveMins = (int)TimeSpan.FromMinutes(5).TotalSeconds;

        private readonly IDbConnection _dbConnection;
        private readonly ILogger _logger;
        private readonly Lazy<IReadOnlyCollection<DeliverablePaymentWithFsp>> _deliverablePaymentData;
        private readonly Lazy<ILookup<string, DeliverablePaymentWithFsp>> _deliverablePaymentsForFsp;
        private readonly Lazy<ILookup<AllocationVersion, DeliverablePaymentWithFsp>> _deliverablePaymentsForAllocation;

        public PaasDeliverablePaymentLazyRepository(IDbConnection connection, ILogger logger)
        {
            _logger = logger;
            _deliverablePaymentData = new Lazy<IReadOnlyCollection<DeliverablePaymentWithFsp>>(GetDeliverablePaymentsFromPaas);
            _deliverablePaymentsForFsp = new Lazy<ILookup<string, DeliverablePaymentWithFsp>>(() => GetDeliverablePayments().ToLookup(dp => dp.FundingStreamPeriodCode));
            _deliverablePaymentsForAllocation = new Lazy<ILookup<AllocationVersion, DeliverablePaymentWithFsp>>(() => GetDeliverablePayments().ToLookup(dp => new AllocationVersion(dp.AllocationNumber, dp.VersionNumber)));
            _dbConnection = connection;
        }

        public IReadOnlyCollection<DeliverablePaymentWithFsp> GetDeliverablePayments()
        {
            return _deliverablePaymentData.Value;
        }

        public IReadOnlyCollection<DeliverablePaymentWithFsp> GetDeliverablePaymentsNotPaidExternally()
        {
            const int paidExternallyPaymentMethod = 2;
            return _deliverablePaymentData.Value.Where(dp => dp.PaymentMethod != paidExternallyPaymentMethod).ToList();
        }

        public IReadOnlyCollection<DeliverablePaymentWithFsp> GetDeliverablePaymentsForFsp(string fsp)
        {
            return _deliverablePaymentsForFsp.Value[fsp].ToList();
        }

        public decimal SumActualValuesForAllocation(string allocationNumber, int versionNumber)
        {
            return _deliverablePaymentsForAllocation.Value[new AllocationVersion(allocationNumber, versionNumber)]
                .Sum(dp => dp.ActualValue);
        }

        public int SumActualVolumesForAllocation(string allocationNumber, int versionNumber)
        {
            return _deliverablePaymentsForAllocation.Value[new AllocationVersion(allocationNumber, versionNumber)]
                .Sum(dp => dp.ActualVolume);
        }

        public decimal SumActualValuesForPeriod(string allocationNumber, int versionNumber, string period)
        {
            return _deliverablePaymentsForAllocation.Value[new AllocationVersion(allocationNumber, versionNumber)]
                .Where(dp => dp.YearPeriod == period)
                .Sum(dp => dp.ActualValue);
        }

        public int SumActualVolumesForPeriod(string allocationNumber, int versionNumber, string period)
        {
            return _deliverablePaymentsForAllocation.Value[new AllocationVersion(allocationNumber, versionNumber)]
                .Where(dp => dp.YearPeriod == period)
                .Sum(dp => dp.ActualVolume);
        }

        public decimal SumReconcilationPaymentAmountsForPeriod(string allocationNumber, int versionNumber, string period)
        {
            return _deliverablePaymentsForAllocation.Value[new AllocationVersion(allocationNumber, versionNumber)]
                .Where(dp => dp.YearPeriod == period)
                .Sum(dp => dp.ReconciliationPaymentAmount);
        }

        public decimal SumNetPaymentAmountsForPeriod(string allocationNumber, int versionNumber, string period)
        {
            return _deliverablePaymentsForAllocation.Value[new AllocationVersion(allocationNumber, versionNumber)]
                .Where(dp => dp.YearPeriod == period)
                .Sum(dp => dp.NetPaymentAmount);
        }

        public IReadOnlyCollection<DeliverablePaymentWithFsp> GetDeliverablePaymentsForFsps(IReadOnlyCollection<string> fspCodes)
        {

            IReadOnlyCollection<DeliverablePaymentWithFsp> deliverablePayments = null;
            ActionRetrier.RetryWhenExceptionThrown(() =>
            {
                deliverablePayments = _dbConnection
                    .Query<DeliverablePaymentWithFsp>(sql: GetSqlScriptFromResource(SqlDeliverableResourceName), new { fspCodes }, commandTimeout: CommandTimeoutFiveMins).ToList();

            },
                numRetries: 5, numSecondsToWaitBetweenRetries: 10);

            return deliverablePayments;
        }

        private IReadOnlyCollection<DeliverablePaymentWithFsp> GetDeliverablePaymentsFromPaas()
        {
            IReadOnlyCollection<DeliverablePaymentWithFsp> deliverablePayments = null;
            ActionRetrier.RetryWhenExceptionThrown(() =>
            {
                _logger.LogInformation(IntegrityLoggingIds.StartingSqlQuery, $"Starting {SqlResourceName}");

                deliverablePayments = _dbConnection.Query<DeliverablePaymentWithFsp>(sql: GetSqlScriptFromResource(SqlResourceName), commandTimeout: CommandTimeoutFiveMins).ToList();

                _logger.LogInformation(IntegrityLoggingIds.FinishedSqlQuery, $"Finished {SqlResourceName}");
            },
                numRetries: 5, numSecondsToWaitBetweenRetries: 10);

            return deliverablePayments;
        }

        private static string GetSqlScriptFromResource(string sqlResourceName)
        {
            using (Stream stream = Assembly.GetExecutingAssembly().GetManifestResourceStream(sqlResourceName))
            using (StreamReader reader = new StreamReader(stream))
            {
                return reader.ReadToEnd();
            }
        }

        private class AllocationVersion
        {
            public AllocationVersion(string allocationNumber, int versionNumber)
            {
                AllocationNumber = allocationNumber;
                VersionNumber = versionNumber;
            }

            public string AllocationNumber { get; }

            public int VersionNumber { get; }

            private bool Equals(AllocationVersion other)
            {
                return string.Equals(AllocationNumber, other.AllocationNumber) && VersionNumber == other.VersionNumber;
            }

            public override bool Equals(object obj)
            {
                if (ReferenceEquals(null, obj)) return false;
                if (ReferenceEquals(this, obj)) return true;
                if (obj.GetType() != this.GetType()) return false;
                return Equals((AllocationVersion)obj);
            }

            public override int GetHashCode()
            {
                unchecked
                {
                    return (AllocationNumber.GetHashCode() * 397) ^ VersionNumber;
                }
            }
        }
    }
}
