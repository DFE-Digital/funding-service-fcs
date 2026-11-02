namespace SFA.FCT.Framework.Logging.Interfaces
{
    using System;

    /// <summary>
    /// Supports logging.
    /// </summary>
    public interface ILogger
    {
        /// <summary>
        /// Logs a verbose message.
        /// </summary>
        /// <param name="format">The format of the message.</param>
        /// <param name="args">The arguments for the format string.</param>
        void LogVerbose(string format, params object[] args);

        void LogVerbose(int id, string format, params object[] args);

        /// <summary>
        /// Logs a verbose exception.
        /// </summary>
        /// <param name="exception">The exception to be logged.</param>
        /// <param name="format">The format of an additional message to be logged with the exception details.</param>
        /// <param name="args">The arguments for the format string.</param>
        void LogVerbose(Exception exception, string format, params object[] args);

        /// <summary>
        /// Returns a value indicating whether verbose logging is enabled.
        /// </summary>
        /// <returns>A value indicating whether verbose logging is enabled.</returns>
        bool IsVerboseEnabled();

        /// <summary>
        /// Logs an informational message.
        /// </summary>
        /// <param name="format">The format of the message.</param>
        /// <param name="args">The arguments for the format string.</param>
        void LogInformation(string format, params object[] args);

        void LogInformation(int id, string format, params object[] args);

        /// <summary>
        /// Logs an informational exception.
        /// </summary>
        /// <param name="exception">The exception to be logged.</param>
        /// <param name="format">The format of an additional message to be logged with the exception details.</param>
        /// <param name="args">The arguments for the format string.</param>
        void LogInformation(Exception exception, string format, params object[] args);

        /// <summary>
        /// Returns a value indicating whether information logging is enabled.
        /// </summary>
        /// <returns>A value indicating whether information logging is enabled.</returns>
        bool IsInformationEnabled();

        /// <summary>
        /// Logs a warning message.
        /// </summary>
        /// <param name="format">The format of the message.</param>
        /// <param name="args">The arguments for the format string.</param>
        void LogWarning(string format, params object[] args);

        void LogWarning(int id, string format, params object[] args);

        /// <summary>
        /// Logs a warning exception.
        /// </summary>
        /// <param name="exception">The exception to be logged.</param>
        /// <param name="format">The format of an additional message to be logged with the exception details.</param>
        /// <param name="args">The arguments for the format string.</param>
        void LogWarning(Exception exception, string format, params object[] args);

        /// <summary>
        /// Returns a value indicating whether warning logging is enabled.
        /// </summary>
        /// <returns>A value indicating whether warning logging is enabled.</returns>
        bool IsWarningEnabled();

        /// <summary>
        /// Logs an error message.
        /// </summary>
        /// <param name="id">An identifier unique to the source which identifies this error message.</param>
        /// <param name="format">The format of the message.</param>
        /// <param name="args">The arguments for the format string.</param>
        void LogError(int id, string format, params object[] args);

        /// <summary>
        /// Logs an error exception.
        /// </summary>
        /// <param name="id">An identifier unique to the source which identifies this error message.</param>
        /// <param name="exception">The exception to be logged.</param>
        /// <param name="format">The format of an additional message to be logged with the exception details.</param>
        /// <param name="args">The arguments for the format string.</param>
        void LogError(int id, Exception exception, string format, params object[] args);

        /// <summary>
        /// Returns a value indicating whether error logging is enabled.
        /// </summary>
        /// <returns>A value indicating whether error logging is enabled.</returns>
        bool IsErrorEnabled();

        /// <summary>
        /// Logs a critical message.
        /// </summary>
        /// <param name="id">An identifier unique to the source which identifies this error message.</param>
        /// <param name="format">The format of the message.</param>
        /// <param name="args">The arguments for the format string.</param>
        void LogCritical(int id, string format, params object[] args);

        /// <summary>
        /// Logs a critical exception.
        /// </summary>
        /// <param name="id">An identifier unique to the source which identifies this error message.</param>
        /// <param name="exception">The exception to be logged.</param>
        /// <param name="format">The format of an additional message to be logged with the exception details.</param>
        /// <param name="args">The arguments for the format string.</param>
        void LogCritical(int id, Exception exception, string format, params object[] args);

        /// <summary>
        /// Returns a value indicating whether critical logging is enabled.
        /// </summary>
        /// <returns>A value indicating whether critical logging is enabled.</returns>
        bool IsCriticalEnabled();
    }
}
