namespace PaymentManagement.Calculation.Repositories
{
    using System.Collections.Generic;
    using Dtos;
    using SFA.FCT.CrossDomain.Integration.Entities.Data;
    using SFA.FCT.PaymentManagementDomain.PolicyCache.DataStore.Model;
    using CappingGroup = Dtos.CappingGroup;

    public interface IPolicyFundingStreamPeriodRepository
    {
        FspCalcConfigInfo GetFspCalcConfigInfo(string fundingStreamPeriodCode, Period currentPeriod, ConnectionInfo connectionInfo);

        PaymentMethod GetPaymentMethod(string fundingStreamPeriodCode, ConnectionInfo connectionInfo);

        IReadOnlyCollection<FspDeliverableInfo> GetFspDeliverableInfos(string fundingStreamPeriodCode, ConnectionInfo connectionInfo);

        IReadOnlyCollection<CappingGroup> GetCappingGroups(string fundingStreamPeriodCode, ConnectionInfo connectionInfo);
    }
}