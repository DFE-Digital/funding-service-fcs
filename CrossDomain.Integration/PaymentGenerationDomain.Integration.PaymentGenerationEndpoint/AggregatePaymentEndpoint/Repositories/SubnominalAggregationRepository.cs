namespace PaymentGenerationDomain.Integration.PaymentGenerationEndpoint.AggregatePaymentEndpoint.Repositories
{
    using System.Collections.Generic;
    using System.Data;
    using System.Data.SqlClient;
    using System.Linq;
    using DataStore;
    using DataStore.Model;
    using DTOs;
    using SFA.FCT.CrossDomain.Integration.Entities.Data;

    public class SubnominalAggregationRepository : ISubnominalAggregationRepository
    {
        public IReadOnlyCollection<SimpleSubnominalAggregation> GetSubnominalAggregations(
            string allocationNumber,
            string period,
            ConnectionInfo connectionInfo)
        {
            using (var context = new PaymentGenerationDbContext(connectionInfo))
            {
                return context.SubnominalAggregations.Where(sa => sa.AllocationNumber == allocationNumber
                                                                   && sa.Period == period)
                    .Select(sa => new { sa.AllocationNumber, sa.Period, sa.SubnominalCode, sa.PaymentType, sa.PostedFlag })
                    .AsEnumerable()
                    .Select(sa => new SimpleSubnominalAggregation(
                        allocationNumber: sa.AllocationNumber,
                        period: sa.Period,
                        subnominalCode: sa.SubnominalCode,
                        paymentType: sa.PaymentType,
                        isPosted: sa.PostedFlag))
                    .ToList();
            }
        }

        public void Update(SimpleSubnominalAggregation subnominalAggregation, ConnectionInfo connectionInfo)
        {
            SqlParameter[] parameters =
            {
                new SqlParameter("@allocationNumber", subnominalAggregation.AllocationNumber),
                new SqlParameter("@period", subnominalAggregation.Period),
                new SqlParameter("@subnominalCode", subnominalAggregation.SubnominalCode),
                new SqlParameter("@paymentType", subnominalAggregation.PaymentType),
                new SqlParameter("@aggregatedValue", SqlDbType.Decimal)
                {
                    Value = subnominalAggregation.AggregatedValue
                },
                new SqlParameter("@version", SqlDbType.Int)
                {
                    Value = subnominalAggregation.VersionNumber
                }
            };

            using (var context = new PaymentGenerationDbContext(connectionInfo))
            {
                context.Database.ExecuteSqlCommand(
                    @" update [PaymentGeneration].[SubnominalAggregation] set AggregatedValue = @aggregatedValue,
                        AllocationVersionNumber = @version
                        where [AllocationNumber] = @allocationNumber
                        and [Period] = @period
                        and [SubnominalCode] = @subnominalCode
                        and [PaymentType] = @paymentType", parameters);
            }
        }

        public void Insert(SubnominalAggregation subnominalAggregation, ConnectionInfo connectionInfo)
        {
            using (var context = new PaymentGenerationDbContext(connectionInfo))
            {
                context.SubnominalAggregations.Add(subnominalAggregation);

                context.SaveChanges();
            }
        }
    }
}
