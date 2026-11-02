namespace SFA.FCT.Contracts.AcceptanceTests.Infrastructure.Repositories
{
    using System.Data.SqlClient;
    using System.Linq;
    using PaymentGenerationDomain.Integration.DataStore;
    using PaymentGenerationDomain.Integration.DataStore.Model;
    using Extensions;

    public static class SubnominalAggregationRepository
    {
        public static bool IsRowPresentForAllocationAndPeriod(string allocationReference, string period)
        {
            using (var context = new PaymentGenerationDbContext())
            {
                return
                    context.SubnominalAggregations.Any(
                        sa => sa.AllocationNumber == allocationReference && sa.Period == period);
            }
        }

        public static SubnominalAggregation GetSubnominalAggregationKeyForKey(string allocationNumber, string period, string subnominalCode, string paymentType)
        {
            using (var context = new PaymentGenerationDbContext())
            {
                return context.SubnominalAggregations.Find(allocationNumber, period, subnominalCode, paymentType);
            }
        }

        public static void DeleteSubnominalAggregations(string allocationNumber)
        {
            using (var context = new PaymentGenerationDbContext())
            {
                context.SubnominalAggregations.RemoveWhere(sa =>
                sa.AllocationNumber == allocationNumber);
                context.SaveChanges();
            }
        }

        public static void DeleteSubnominalAggregationsForSubnominalCode(string subnominalCode)
        {
            using (var context = new PaymentGenerationDbContext())
            {
                context.Database.ExecuteSqlCommand(
                    $"Delete from PaymentGeneration.SubnominalAggregation where [SubnominalCode] = '{subnominalCode}'");

                context.SaveChanges();
            }
        }

        public static void DeleteSubnominalAggregationsForFsp(string fsp)
        {
            using (var context = new PaymentGenerationDbContext())
            {
                context.SubnominalAggregations.RemoveWhere(sa =>
                sa.FundingStreamPeriodCode == fsp);
                context.SaveChanges();

            }
        }

        public static void ChangeSubnominalAggregationSubnominalCode(string allocationNumber, string period, string subnomialCode, 
            string paymentType, string newSubnomialCode)
        {
            using (var context = new PaymentGenerationDbContext())
            {
                SqlParameter[] parameters = {
                new SqlParameter("@NewSubnominalCode", newSubnomialCode),
                new SqlParameter("@AllocationNumber", allocationNumber),
                new SqlParameter("@Period", period),
                new SqlParameter("@SubnominalCode", subnomialCode),
                new SqlParameter("@PaymentType", paymentType.ToUpper())};

                context.Database.ExecuteSqlCommand("dbo.sp_ChangeSubnominalAggregationSubnominalCode @NewSubnominalCode,@AllocationNumber,@Period,@SubnominalCode,@PaymentType", parameters);
            }
        }
    }
}
