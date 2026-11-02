namespace PaymentManagement.Calculation.Tests.Services
{
    using Calculation.Repositories;
    using Calculation.Services;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using SFA.FCT.PaymentManagementDomain.PolicyCache.DataStore;
    using System.Configuration;
    using System.Data.SqlClient;
    using System;
    using System.Collections.Generic;
    using System.Linq;
    using Dapper;
    using SFA.FCT.CrossDomain.Integration.Entities.Data;

    [TestClass]
    public class BehaviourFactoryTechnicalExplorationTests
    {
        [TestMethod, TestCategory("TechnicalExploration")]
        public void BehaviourFactory_GetBehaviour_CheckFactoryHasABehaviourForAllActiveFspsAcrossPeriods()
        {
            using (var context = new PaymentManagementPolicyContext())
            {
                var factory = new BehaviourFactory(new PolicyFundingStreamPeriodRepository());

                var periods = GetPeriods().ToList();
                var activeFsps = GetActiveFsps().ToList();

                var opaFspPeriods = new List<FspPeriod>();
                var behaviourFspPeriods = new List<FspPeriod>();

                activeFsps.ForEach(fsp =>
                {
                    periods.ForEach(period =>
                    {
                        var behaviour = factory.GetBehaviour(fsp, period, ConnectionInfo.CreateFrom(context.Database.Connection));
                        var fspPeriod = new FspPeriod(fsp, period);
                        behaviour.Match(
                            some: b => behaviourFspPeriods.Add(fspPeriod),
                            none: () => opaFspPeriods.Add(fspPeriod));
                    });
                });

                opaFspPeriods.ForEach(opa => Console.WriteLine("fsp%"  + opa.Fsp + "%period%" + opa.Period));

                // This results in the following FSPs not having an associated behaviour
                // They have pay methods that not do get calculated

                // 16-18NLAP-AS2019	PaymentMethod.NoCalcAndNoPay
                // ANLAP-AS2019		PaymentMethod.NoCalcAndNoPay
                // LEVY1799		PaymentMethod.PayOnInstruction
                // NONLEVY2019		PaymentMethod.PayOnInstruction
            }
        }

        private IReadOnlyCollection<string> GetActiveFsps()
        {
            var connectionString = ConfigurationManager.ConnectionStrings["PaymentManagementPolicyContext"].ConnectionString;

            // arrange
            using (var connection = new SqlConnection(connectionString))
            {
                return connection.Query<string>(@"SELECT [FundingStreamPeriod]
                                                    FROM [PolicyCache].[PolicyFundingStreamPeriod]
                                                    WHERE ActivityCloseDate IS NULL OR ActivityCloseDate > GETDATE()").ToList();
            }
        }

        private IReadOnlyCollection<int> GetPeriods()
        {
            return new List<int>
            {
                202005, 202006, 202007, 202008, 202009, 202010, 202011, 202012, 202201, 202202, 202203, 202204, 202205, 202206, 202207, 202208, 202209, 202210, 202211, 202212
            };
        }
    }

    public class FspPeriod
    {
        public FspPeriod(string fsp, int period)
        {
            Fsp = fsp;
            Period = period;
        }

        public string Fsp { get; }

        public int Period { get; }
    }
}