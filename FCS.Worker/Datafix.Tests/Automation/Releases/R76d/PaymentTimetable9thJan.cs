namespace Datafix.Tests.Automation.Releases.R76d
{
    public class PaymentTimetable9thJan : RunSqlFileIntoDb, IApplyDataFix
    {
        public string Release => "R76d";
        public int StoryNumber => 28768;
        public string Name => "Delay Apprenticeships census end dates for R05";
        public int Order => 1;
        public void ApplyDataFix()
        {
            const string paymentTimetableSql = "Datafix.Tests.Resources.R76d.update_payment_timetable_r76d.sql";

            RunCodeFromFileIntoDb(paymentTimetableSql);
        }
    }
}
