namespace XrmMigrator
{
    using System;

    public interface ILog
    {
        void Log(Exception e, string message);
        void Log(Exception e, string message, params object[] args);
        void Log(string message);
        void Log(string message, params object[] args);
    }
}
