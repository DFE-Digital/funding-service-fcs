namespace Operations.Web.Infrastructure
{
    public static class LogInformation
    {
        private static int OpsWebLogInfoPartition = 2000;
        public static int InitiateDasEventPublication = OpsWebLogInfoPartition + 1;
        public static int InitiateDasEventMessageSent = OpsWebLogInfoPartition + 2;
        public static int InitiateDasEventNoAccess = OpsWebLogInfoPartition + 3;
    }
}