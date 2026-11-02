namespace FCTCrmConfig.ConfigPackage
{
    public class DeploymentEvent
    {
        public enum OperationType
        {
            RecordCreate,
            RecordUpdate,
            RecordDeactivate,
            SettingsUpdate,
            ConfigFileLoad
        }

        public enum OperationState 
        {
            Started,
            InProgress,
            Completed
        }

        public enum LogLevel
        {
            Verbose,
            Info,
            Warning,
            Error
        }

        public OperationState State { get; set; }

        public OperationType Type { get; set; }

        public LogLevel Level { get; set; }

        public string Message { get; set; }
    }
}
