namespace SFA.FCT.PaymentManagementDomain.PolicyCache.DataStore.Repositories
{
    using System.Collections.Generic;
    using Model;
    using SFA.FCT.CrossDomain.Integration.Entities.Data;

    public interface IPayCalcPolicyQueryRepository
    {
        PolicyFundingStreamPeriod GetFundingStreamPeriod(string fundingStreamPeriodCode, ConnectionInfo connectionInfo);

        PolicyFundingStreamPeriod GetFundingStreamPeriod(ConnectionInfo connectionInfo, string fundingStreamPeriodCode);

        IReadOnlyCollection<PolicyDeliverable> GetFundingStreamPeriodDeliverables(string fundingStreamPeriodCode, ConnectionInfo connectionInfo);

        IReadOnlyCollection<PolicyDeliverable> GetFundingStreamPeriodDeliverablesNonConnectionInfo(string fundingStreamPeriodCode);

        IReadOnlyCollection<CappingGroup> GetFundingStreamPeriodCappingGroups(string fundingStreamPeriodCode, ConnectionInfo connectionInfo);

        IReadOnlyCollection<PolicyFundingStreamCensusDate> GetFundingStreamPeriodCensusDates(string fundingStreamPeriodCode, ConnectionInfo connectionInfo);

        bool IsFspContractAllocationCappingWithChildProfileDeliverables(string fundingStreamPeriodCode, ConnectionInfo connectionInfo);

        IReadOnlyCollection<int> GetDeliverableCodesWherePlannedValueShouldNotBeUsedInCalc(string fundingStreamPeriodCode, ConnectionInfo connectionInfo);

        PolicySubnominal GetSubnominal(int subnominalCode, PaymentType paymentType, ConnectionInfo connectionInfo);
    }
}
