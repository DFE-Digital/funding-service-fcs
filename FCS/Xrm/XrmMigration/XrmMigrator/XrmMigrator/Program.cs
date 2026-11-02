namespace XrmMigrator
{
    using System;
    using System.Collections.Generic;
    using System.Configuration;
    using System.Reactive.Linq;
    using System.Reactive.Subjects;
    using Dto;
    using Events;
    using Microsoft.Xrm.Client;
    using Microsoft.Xrm.Client.Services;
    using SFA.FCT.PaymentManagementDomain.PaymentSchedule.DataStore;
    using SFA.FCT.PaymentManagementDomain.PolicyCache.DataStore;
    using Xrm;

    public class Program
    {
        private static IOrganisationUpdater _orgUpdater;

        private static IDeliverableMigrator _deliverableMigrator;

        private static ISubnominalsReader _subnominalReader;

        private static int _recordsMigrated;
        private static int _recordsErrored;

        public static void Main(string[] args)
        {
            var xrmOrganisationService =
                new OrganizationService(
                    CrmConnection.Parse(ConfigurationManager.ConnectionStrings["CrmConnectionString"].ConnectionString));

            var logger = new Logger();

            var paramIndex = Array.IndexOf(args, "-migration");
            if (paramIndex > -1)
            {
                try
                {
                    var migration = args[paramIndex + 1];
                    switch (migration)
                    {
                        case "org":

                            logger.Log("Org migration started.");

                            _orgUpdater = new OrganisationUpdater { Logger = logger };
                            _orgUpdater.UpdateOrganisations();

                            break;
                        case "deliverable":
                            _recordsMigrated = 0;

                            logger.Log(null, "Deliverable migration started.");

                            Subject<DeliverableMigrationEvent> eventStreamDeliverable = CreateDeliverableMigrationEventStream(logger);

                            _deliverableMigrator = new DeliverableMigrator
                            {
                                OrgSvc = xrmOrganisationService
                            };

                            _deliverableMigrator.MigrateDeliverables(eventStreamDeliverable);

                            break;
                        case "subnominal":
                            _recordsMigrated = 0;
                            _recordsErrored = 0;
                            
                            logger.Log(null, "Deliverable Period Subnominal migration started.");

                            Subject<DeliverablePeriodMigrationEvent> eventStreamDeliverablePeriod = CreateDeliverablePeriodEventStream(logger);

                            _deliverableMigrator = new DeliverableMigrator
                            {
                                OrgSvc = xrmOrganisationService
                            };

                            using (var paymentManagementPolicyContext = new PaymentManagementPolicyContext())
                            using (var paymentSchedulePolicyContext = new PaymentSchedulePolicyContext())
                            {
                                _subnominalReader = new SubnominalsReader(paymentManagementPolicyContext,
                                    paymentSchedulePolicyContext);

                                IEnumerable<DeliverablePeriodSubnominal> subnominals = _subnominalReader.Read();

                                _deliverableMigrator.PopulateSubnominalCodes(eventStreamDeliverablePeriod,
                                    subnominals);
                            }

                            logger.Log("Deliverable Period Subnominal migration completed. Record(s) processed: {0}, Records Errored: {1}",
                                _recordsMigrated, _recordsErrored);

                            break;
                        default:
                            MigrationNotSpecified(logger);
                            break;
                    }
                }
                catch (IndexOutOfRangeException)
                {
                    MigrationNotSpecified(logger);
                }
            }
            else
            {
                MigrationNotSpecified(logger);
            }

            logger.Log(null, "Migration complete.");

            Environment.Exit(0);

        }

        private static Subject<DeliverableMigrationEvent> CreateDeliverableMigrationEventStream(ILog logger)
        {
            var eventStream = new Subject<DeliverableMigrationEvent>();

            eventStream.Subscribe(
                e =>
                {
                    logger.Log(null, "Record Updated: Allocation: {0}, Deliverable Code: {1}, Records Processed: {2}",
                        e.AllocationNumber, e.DeliverableCode, e.Processed);
                    _recordsMigrated++;
                },
                ex =>
                {
                    logger.Log(ex, "An Error Has Occurred: {0}", ex.Message);
                    Environment.Exit(1);
                });

            return eventStream;
        }

        private static Subject<DeliverablePeriodMigrationEvent> CreateDeliverablePeriodEventStream(ILog logger)
        {
            var eventStream = new Subject<DeliverablePeriodMigrationEvent>();

            eventStream.Where(e => e.Type == EventType.UpdatingRecord && e.Result == EventResult.Updated).Subscribe(
                e =>
                {
                    logger.Log("[{0}] Record Updated: Allocation: {1}, Subnominal Code: {2}, Subnominal Type: {3}, Period: {4}, Records Processed: {5}",
                        DateTime.Now,
                        e.AllocationNumber,
                        e.SubnominalCode,
                        e.SubnominalType,
                        e.Period,
                        e.Processed);
                    _recordsMigrated++;
                },
                ex =>
                {
                    logger.Log(ex, "An Error Has Occurred: {0}", ex.Message);
                    Environment.Exit(1);
                });

            eventStream.Where(e => e.Result == EventResult.Error || e.Result == EventResult.Warning).Subscribe(e =>
            {

                logger.Log("[{0}] Error or Warning Occurred: Allocation: {1}, Error: {2}",
                    DateTime.Now,
                    e.AllocationNumber,
                    e.Message);
                _recordsErrored++;
            });

            return eventStream;
        }


        private static void MigrationNotSpecified(ILog logger)
        {
            logger.Log(null, "Migration type not specified. Use \"-migration [org/deliverable/subnominal]\" to specify migration.");
            Environment.Exit(1);
        }
    }
}
