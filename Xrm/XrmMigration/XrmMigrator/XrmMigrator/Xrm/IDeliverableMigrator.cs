namespace XrmMigrator.Xrm
{
    using System;
    using System.Collections.Generic;
    using Dto;
    using Events;

    internal interface IDeliverableMigrator
    {
        void MigrateDeliverables(IObserver<DeliverableMigrationEvent> eventStream);

        void PopulateSubnominalCodes(IObserver<DeliverablePeriodMigrationEvent> eventStream, IEnumerable<DeliverablePeriodSubnominal> subnominals);
    }
}
