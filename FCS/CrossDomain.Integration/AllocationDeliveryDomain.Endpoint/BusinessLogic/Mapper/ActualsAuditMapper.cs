namespace AllocationDeliveryDomain.Endpoint.BusinessLogic.Mapper
{
    using System;
    using System.Collections.Generic;
    using System.Linq;
    using SFA.FCT.AllocationDeliveryDomain.Common.BusinessLogic.Repository;
    using SFA.FCT.AllocationDeliveryDomain.Common.DataStore.Model;
    using SFA.FCT.AllocationDeliveryDomain.Common.Storage;
    using SFA.FCT.CrossDomain.Integration.Common;
    using SFA.FCT.CrossDomain.Integration.Entities.Data;

    public class ActualsAuditMapper : IActualsAuditMapper
    {
        private readonly IFundingStreamConfigurationStore _store;
        private int _collectionReturnPeriod;

        public ActualsAuditMapper(IFundingStreamConfigurationStore store, IDate dateProvider)
        {
            _store = store;

            _collectionReturnPeriod = Convert.ToInt32(dateProvider.GetCalculationDate().AddMonths(-1).ToString("yyyyMM"));
        }

        public IEnumerable<AllocationDeliverablePeriodActualAudit> Map(IEnumerable<EnrichedReportedActual> enrichedActuals, ConnectionInfo connectionInfo)
        {
            var periodDeliverables = new List<FundingStreamPeriodDeliverable>();
            var firstActual = enrichedActuals.FirstOrDefault();
            /// FundingStreamPeriodCode will be the same for all allocations in the message
            if (firstActual != null)
            {
                periodDeliverables = _store.GetFundingStreamPeriodDeliverables(firstActual.FundingStreamPeriodCode, connectionInfo).ToList();
            }

            var auditActuals = enrichedActuals.Select(e => e.ToAllocationDeliverablePeriodActualAudit()).ToList();
            auditActuals.ForEach(a => a.CollectionReturnPeriod = _collectionReturnPeriod);

            foreach (var allocationDeliverablePeriodActualAudit in auditActuals)
            {
                var fundingStreamPeriodDeliverable = periodDeliverables.FirstOrDefault(x => x.FundingStreamPeriodCode == allocationDeliverablePeriodActualAudit.FundingStreamPeriodCode &&
                                                                                                                       x.DeliverableCode == allocationDeliverablePeriodActualAudit.DeliverableCode);
                if (fundingStreamPeriodDeliverable != null)
                {
                    allocationDeliverablePeriodActualAudit.ParentDeliverableCode = fundingStreamPeriodDeliverable.ParentDeliverableCode;
                }
            }
            
            return auditActuals;
        }
    }
}
