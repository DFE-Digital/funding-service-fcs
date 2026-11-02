namespace FctServices.Deds
{
    using System.Configuration;

    public class EnvironmentContext : IEnvironmentContext
    {
        public string StorageTableSuffix
        {
            get { return ConfigurationManager.AppSettings["StorageTableSuffix"]; }
        }
    }
}