namespace SFA.FCT.PaymentManagementDomain.PolicyCache.DataStore
{
    using System;
    using System.Data;
    using System.Data.Entity;
    using SFA.FCT.PaymentManagementDomain.PolicyCache.DataStore.Model;

    /// <summary>
    /// Interface for the Payment Management Policy Entity DB Context
    /// </summary>
    public interface IPaymentManagementPolicyContext : IDisposable
    {
        IDbSet<PolicyDeliverable> PolicyDeliverables { get; set; }

        IDbSet<PolicyDeliverableToSubnominals> PolicyDeliverableToSubnominals { get; set; }

        IDbSet<PolicyFundingStreamCensusDate> PolicyFundingStreamCensusDates { get; set; }

        IDbSet<PolicyFundingStreamPeriod> PolicyFundingStreamPeriods { get; set; }

        IDbSet<PolicySubnominal> PolicySubnominals { get; set; }

        IDbSet<CappingGroup> CappingGroups { get; set; }

        IDbSet<ESFRegionInvestmentPriority> ESFRegionInvestmentPriorities { get; set; }

        IDbConnection GetConnection();

        /// <summary>
        /// commits changes to the persistance store
        /// </summary>
        /// <returns></returns>
        int SaveChanges();
    }
}
