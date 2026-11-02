namespace Datafix.Tests.Automation
{
    public interface IApplyDataFix
    {
        string Release { get; }
        int StoryNumber { get; }
        string Name { get; }

        int Order { get; }

        void ApplyDataFix();
    }
}
