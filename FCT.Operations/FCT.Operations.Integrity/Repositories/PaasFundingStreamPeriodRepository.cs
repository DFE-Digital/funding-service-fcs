namespace SFA.FCT.Operations.Integrity.Repositories
{
    using System;
    using System.Collections.Generic;
    using System.Data;
    using System.Linq;
    using AllocationDeliveryDomain.Common.BusinessLogic.Repository;
    using AllocationDeliveryDomain.Common.DataStore.Model;
    using CrossDomain.Integration.Entities.Data;
    using Dapper;

    public class PaasFundingStreamPeriodRepository : IPaasFundingStreamPeriodRepository, IFundingStreamConfigurationStore
    {
        private readonly IDbConnection _connection;
        public PaasFundingStreamPeriodRepository(IDbConnection connection)
        {
            _connection = connection;
        }

        public IReadOnlyCollection<string> GetFundingStreamPeriodCodesThatAreActive(DateTime dateTime)
        {
            return _connection.Query<string>("sp_Operation_GetFundingStreamPeriodCodesThatAreActive @date", param: new { dateTime.Date }).ToList();
        }

        public bool IsFundingStreamPeriodPayOnInstruction(string fspCode)
        {
            const int paymentMethodPayOnInstruction = 3;        

            int paymentMethod = _connection.QuerySingle<int>("sp_Operation_IsFundingStreamPeriodPayOnInstruction @fspCode", param: new { fspCode });

            return paymentMethod == paymentMethodPayOnInstruction;
        }

        public FundingStreamPeriod GetFundingStreamPeriod(string fundingStreamPeriodCode, ConnectionInfo connectionInfo)
        {
          return _connection.QuerySingle<FundingStreamPeriod>("sp_Operation_GetFundingStreamPeriod @fundingStreamPeriodCode", param: new { fundingStreamPeriodCode });
        }

        public IEnumerable<FundingStreamPeriodDeliverable> GetFundingStreamPeriodDeliverables(string fundingStreamPeriodCode, ConnectionInfo connectionInfo)
        {
            throw new NotImplementedException();
        }
    }
}
