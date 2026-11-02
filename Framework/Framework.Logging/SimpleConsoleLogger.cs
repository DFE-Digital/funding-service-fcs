namespace SFA.FCT.Framework.Logging
{
    using System;
    using Interfaces;

    public class SimpleConsoleLogger : ILogger
    {
        public void LogVerbose(string format, params object[] args)
        {
            Console.Out.WriteLine(format, args);
        }

        public void LogVerbose(int id, string format, params object[] args)
        {
            Console.Out.WriteLine(format, args);
        }

        public void LogVerbose(Exception exception, string format, params object[] args)
        {
            Console.Out.WriteLine(format, args);
        }

        public bool IsVerboseEnabled()
        {
            return true;
        }

        public void LogInformation(string format, params object[] args)
        {
            Console.Out.WriteLine(format, args);
        }

        public void LogInformation(int id, string format, params object[] args)
        {
            Console.Out.WriteLine(format, args);
        }

        public void LogInformation(Exception exception, string format, params object[] args)
        {
            Console.Out.WriteLine(format, args);
        }

        public bool IsInformationEnabled()
        {
            return true;
        }

        public void LogWarning(string format, params object[] args)
        {
            Console.Out.WriteLine(format, args);
        }

        public void LogWarning(int id, string format, params object[] args)
        {
            Console.Out.WriteLine(format, args);
        }

        public void LogWarning(Exception exception, string format, params object[] args)
        {
            Console.Out.WriteLine(format, args);
        }

        public bool IsWarningEnabled()
        {
            return true;
        }

        public void LogError(int id, string format, params object[] args)
        {
            Console.Error.WriteLine(format, args);
        }

        public void LogError(int id, Exception exception, string format, params object[] args)
        {
            Console.Error.WriteLine(format, args);
        }

        public bool IsErrorEnabled()
        {
            return true;
        }

        public void LogCritical(int id, string format, params object[] args)
        {
            Console.Error.WriteLine(format, args);
        }

        public void LogCritical(int id, Exception exception, string format, params object[] args)
        {
            Console.Error.WriteLine(format, args);
        }

        public bool IsCriticalEnabled()
        {
            return true;
        }
    }
}
