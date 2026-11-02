namespace SFA.FCT.Framework.Logging
{
    using System;
    using System.Collections.Concurrent;
    using System.Configuration;
    using Interfaces;
    using Microsoft.WindowsAzure.Storage.Table;
    using NullObjects;
    using Polly;
    using SFA.FCT.Framework.Logging.Bespoke;

    [Serializable]
    public class LoggerFactory : ILoggerFactory
    {
        public const string DefaultSource = "WorkerRole";

        private ICloudEnvironment _cloudEnvironment = null;
        private string _storageConnectionString = null;
        private static Action<LogEntry> _createRowInAzure;

        public LoggerFactory()
        {
            //if (IsInAzureCloudService())
            //{
            //    _cloudEnvironment = new CloudEnvironment();
            //}
            //else
            //{
                _cloudEnvironment = new WebJobEnvironment();
                _createRowInAzure = CreateRowInAzure;
                //  }
        }

        public LoggerFactory(ICloudEnvironment cloudEnvironment)
        {
            _cloudEnvironment = cloudEnvironment;
        }

        public LoggerFactory(ICloudEnvironment cloudEnvironment, string storageConnectionString)
        {
            _cloudEnvironment = cloudEnvironment;
            _storageConnectionString = storageConnectionString;
        }

        public ILogger CreateLogger(string source)
        {
            if (_cloudEnvironment != null)
            {
                return CreateDefaultLogger(LogLevel.Verbose, _cloudEnvironment);
            }

            return new LoggerNullObject();
        }

        public ILogger CreateDefaultLogger(LogLevel logLevel = LogLevel.Verbose)
        {
            ConcurrentQueue<LogEntry> logEntries = new ConcurrentQueue<LogEntry>();
            QueueReader reader = new QueueReader(logEntries);
            BespokeLogWriter logWriter = new BespokeLogWriter(new CloudLogQueue(logEntries, _cloudEnvironment), logLevel);

            reader.StartDequeuingAndProcessing(CreateRowInAzure);

            return logWriter;
        }

        public ILogger CreateDefaultLogger(string storageConnectionString, ICloudEnvironment cloudEnvironment, Action<LogEntry> createRowInAzure)
        {
            _cloudEnvironment = cloudEnvironment;
            _storageConnectionString = storageConnectionString;
            _createRowInAzure = createRowInAzure;

            ConcurrentQueue<LogEntry> logEntries = new ConcurrentQueue<LogEntry>();
            QueueReader reader = new QueueReader(logEntries);
            BespokeLogWriter logWriter = new BespokeLogWriter(new CloudLogQueue(logEntries, _cloudEnvironment), LogLevel.Verbose);

            reader.StartDequeuingAndProcessing(createRowInAzure);

            return logWriter;
        }

        public ILogger CreateCoreLogger()
        {
            ConcurrentQueue<LogEntry> logEntries = new ConcurrentQueue<LogEntry>();
            QueueReader reader = new QueueReader(logEntries);
            BespokeLogWriter logWriter = new BespokeLogWriter(new CloudLogQueue(logEntries, _cloudEnvironment), LogLevel.Verbose);

            reader.StartDequeuingAndProcessing(_createRowInAzure);

            return logWriter;
        } 

        public ILogger CreateDefaultLogger(LogLevel logLevel, ICloudEnvironment cloudEnvironment)
        {
            ConcurrentQueue<LogEntry> logEntries = new ConcurrentQueue<LogEntry>();
            QueueReader reader = new QueueReader(logEntries);
            BespokeLogWriter logWriter = new BespokeLogWriter(new CloudLogQueue(logEntries, cloudEnvironment), logLevel);

            reader.StartDequeuingAndProcessing(CreateRowInAzure);

            return logWriter;
        }

        public ILogger CreateDefaultLogger(LogLevel logLevel, Func<ICloudEnvironment> getCloudEnvironment)
        {
            ConcurrentQueue<LogEntry> logEntries = new ConcurrentQueue<LogEntry>();
            QueueReader reader = new QueueReader(logEntries);
            BespokeLogWriter logWriter = new BespokeLogWriter(new CloudLogQueue(logEntries, getCloudEnvironment()), logLevel);

            reader.StartDequeuingAndProcessing(CreateRowInAzure);

            return logWriter;
        }

        protected  CloudTable GetCloudTable()
        {
            var azureStorageConnectionString = GetStorageConnectionString();

            var azureTable = AzureTableStore.GetTable(
                tableName: "WADLogsTable",
                connectionString: azureStorageConnectionString);

            return azureTable;
        }

        private  void CreateRowInAzure(LogEntry logEntry)
        {
            var azureTable = GetCloudTable();

            try
            {
                Policy.Handle<Exception>()
                    .WaitAndRetry(1, count => TimeSpan.FromSeconds(1))
                    .Execute(() => AzureTableStore.CreateRow(azureTable, logEntry));
            }
            catch (Exception)
            {
                // do nothing
            }
        }

        protected static bool IsInAzureCloudService()
        {
            //try
            //{
            //    return RoleEnvironment.IsAvailable;
            //}
            //catch (TypeInitializationException)
            //{
            //}

            return false;
        }

        private string GetStorageConnectionString()
        {
            if (string.IsNullOrEmpty(_storageConnectionString))
            {
                return ConfigurationManager.ConnectionStrings["StorageConnectionString"].ConnectionString;
            }

            return _storageConnectionString;
        }
    }
}
