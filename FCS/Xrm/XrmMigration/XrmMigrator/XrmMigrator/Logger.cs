namespace XrmMigrator
{
    using System;
    using System.Configuration;
    using System.IO;
    using System.Text;

    public class Logger : ILog
    {
        private readonly string _logFilePath;

        public Logger()
        {
            var logFilePath = ConfigurationManager.AppSettings["LogFilePath"];
            var defaultPath = Environment.CurrentDirectory;

            _logFilePath = !string.IsNullOrWhiteSpace(logFilePath) ? logFilePath : defaultPath;
            if (_logFilePath.Substring(_logFilePath.Length - 1) != @"\")
            {
                _logFilePath += @"\";
            }
        }

        public void Log(Exception e, string message)
        {
            Log(e, message, new object[] { });
        }

        public void Log(Exception e, string message, params object[] args)
        { 
            var logEntry = new StringBuilder();

            logEntry.Append(string.Format("{0:dd/MMM/yy HH:mm:ss}: ", DateTime.Now));

            logEntry.AppendLine(!string.IsNullOrEmpty(message)
                ? (args != null ? string.Format(message, args) : message)
                : "Tried to log something but there was no message.");

            if (e != null)
            {
                if (e.InnerException != null)
                {
                    logEntry.AppendLine(e.InnerException.Message);
                    logEntry.AppendLine(e.InnerException.StackTrace);
                }

                logEntry.AppendLine(e.Message);
                logEntry.AppendLine(e.StackTrace);
            }
            
            File.AppendAllText(_logFilePath + "XrmMigratorLog_ " + DateTime.Now.ToString("yyyy-MM-dd") + ".txt", logEntry.ToString());

            Console.WriteLine(logEntry);
        }

        public void Log(string message)
        {
            Log(null, message);
        }

        public void Log(string message, params object[] args)
        {
            Log(null, message, args);
        }
    }
}
