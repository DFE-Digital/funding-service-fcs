namespace Datafix.Tests.Automation.Releases.R76a
{
    public class PaymentTimetable19thDec : RunSqlFileIntoDb, IApplyDataFix
    {
        public string Release => "R76a";
        public int StoryNumber => 28699;
        public string Name => "Pull next 18/19 census dates forward for Apps C-I and PoA Procured AEB [19-DEC]";
        public int Order => 1;
        public void ApplyDataFix()
        {
            const string paymentTimetableSql = "Datafix.Tests.Resources.R76a.update_payment_timetable_r76a.sql";

            RunCodeFromFileIntoDb(paymentTimetableSql);
        }
    }
}
