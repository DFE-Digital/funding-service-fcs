namespace FCT.Console.Config.Synchronizers.PaaS.Repositories
{
    using Dapper;
    using PaymentGenerationDomain.Integration.DataStore;

    public static class PaymentTimetableRepository 
    {
        public static void RemoveUnprocessedRows(PaymentGenerationDbContext context)
        {
            const string sql = "DELETE FROM [PaymentGeneration].[PaymentTimetable] WHERE Status <> 'Completed'";

            context.Database.Connection.Execute(sql);
        }
    }
}