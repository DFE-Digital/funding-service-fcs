namespace Datafix.Tests.Automation.Releases.R75_28600
{
    public class UpdatePaymentTimetable9thDec : RunSqlFileIntoDb, IApplyDataFix
    {
        public string Release => "R75c";
        public int StoryNumber => 28600;
        public string Name => "Delay Apps census dates for payment period 09/12/2019 to 10/12/19";
        public int Order => 1;
        public void ApplyDataFix()
        {
            const string paymentTimetableSql = "Datafix.Tests.Resources.R75c.update_payment_timetable_r75c.sql";

            RunCodeFromFileIntoDb(paymentTimetableSql);
        }
    }
}
