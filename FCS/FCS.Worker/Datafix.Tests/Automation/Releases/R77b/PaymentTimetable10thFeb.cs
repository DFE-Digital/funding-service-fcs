namespace Datafix.Tests.Automation.Releases.R77b
{
    public class PaymentTimetable10thFeb : RunSqlFileIntoDb, IApplyDataFix
    {
        public string Release => "R77b";
        public int StoryNumber => 28984;
        public string Name => "Delay Apprenticeships census end dates for R06";
        public int Order => 1;
        public void ApplyDataFix()
        {
            const string paymentTimetableSql = "Datafix.Tests.Resources.R77b.update_payment_timetable_r77b.sql";

            RunCodeFromFileIntoDb(paymentTimetableSql);
        }
    }
}
