namespace Datafix.Tests.Automation.Extensions
{
    using Operations.DataStore.Model;

    public static class ApplyDataFixExtensions
    {
        public static DataFixHistory ToDataFixHistory(this IApplyDataFix dataFix)
        {
            return new DataFixHistory(dataFix.Release, dataFix.StoryNumber, dataFix.Name);
        }
    }
}
