namespace SFA.FCT.AllocationDeliveryDomain.Common.BusinessLogic.Repository
{
    using System.Collections.Generic;
    using CrossDomain.Integration.Entities.Data;
    using SFA.FCT.AllocationDeliveryDomain.Common.DataStore.Model;

    public interface IFundingStreamConfigurationStore
    {
        FundingStreamPeriod GetFundingStreamPeriod(string fundingStreamPeriodCode, ConnectionInfo connectionInfo);

        IEnumerable<FundingStreamPeriodDeliverable> GetFundingStreamPeriodDeliverables(string fundingStreamPeriodCode, ConnectionInfo connectionInfo);
    }
}
