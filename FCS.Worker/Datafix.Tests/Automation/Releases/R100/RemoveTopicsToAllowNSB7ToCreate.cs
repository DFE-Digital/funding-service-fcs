namespace Datafix.Tests.Automation.Releases.R100
{
    using System.Configuration;
    using System.Linq;
    using Microsoft.ServiceBus;

    public class RemoveTopicsToAllowNSB7ToCreate : IApplyDataFix
    {
        public string Release => "R100";
        public int StoryNumber => 31996;
        public string Name => "Move Cross Domain Integration to NServiceBus 7 (31996)";
        public int Order => 1;
        public void ApplyDataFix()
        {
            var namespaceManager = GetAsbNamespaceManager();

            var topics = namespaceManager.GetTopics().ToList();
            topics.ForEach(t =>
            {
                namespaceManager.DeleteTopic(t.Path);
            });
        }

        private static NamespaceManager GetAsbNamespaceManager()
        {
            return NamespaceManager.CreateFromConnectionString(ConfigurationManager.ConnectionStrings["NServiceBus/Transport"].ConnectionString);
        }
    }
}
