namespace SFA.FCT.Framework.Logging
{
    using System;
    using System.Diagnostics;
    using System.Diagnostics.Contracts;
    using System.Globalization;
    using Interfaces;

    /// <summary>
    /// Performs logging.
    /// </summary>
    public class Logger : ILogger
    {
        /// <summary>
        /// The trace source to be used for logging.
        /// </summary>
        private readonly TraceSource _traceSource;

        /// <summary>
        /// Initializes a new instance of the <see cref="Logger"/> class.
        /// </summary>
        /// <param name="traceSource">The source to be used.</param>
        public Logger(TraceSource traceSource)
        {
            _traceSource = traceSource;
        }

        /// <summary>
        /// Logs a verbose message.
        /// </summary>
        /// <param name="format">The format of the message.</param>
        /// <param name="args">The arguments for the format string.</param>
        public void LogVerbose(string format, params object[] args)
        {
            Contract.Requires(Trace.CorrelationManager.ActivityId != Guid.Empty, "An activity must have been started");
            LogVerbose(1, format, args);
        }

        public void LogVerbose(int id, string format, params object[] args)
        {
            Contract.Requires(Trace.CorrelationManager.ActivityId != Guid.Empty, "An activity must have been started");
            TraceEvent(TraceEventType.Verbose, id, format, args);
        }

        /// <summary>
        /// Logs a verbose exception.
        /// </summary>
        /// <param name="exception">The exception to be logged.</param>
        /// <param name="format">The format of an additional message to be logged with the exception details.</param>
        /// <param name="args">The arguments for the format string.</param>
        public void LogVerbose(Exception exception, string format, params object[] args)
        {
            Contract.Requires(Trace.CorrelationManager.ActivityId != Guid.Empty, "An activity must have been started");
            LogException(TraceEventType.Verbose, 1, exception, format, args);
        }

        /// <summary>
        /// Returns a value indicating whether verbose logging is enabled.
        /// </summary>
        /// <returns>A value indicating whether verbose logging is enabled.</returns>
        public bool IsVerboseEnabled()
        {
            return _traceSource.Switch.ShouldTrace(TraceEventType.Verbose);
        }

        /// <summary>
        /// Logs an informational message.
        /// </summary>
        /// <param name="format">The format of the message.</param>
        /// <param name="args">The arguments for the format string.</param>
        public void LogInformation(string format, params object[] args)
        {
            Contract.Requires(Trace.CorrelationManager.ActivityId != Guid.Empty, "An activity must have been started");
            LogInformation(1, format, args);
        }

        public void LogInformation(int id, string format, params object[] args)
        {
            Contract.Requires(Trace.CorrelationManager.ActivityId != Guid.Empty, "An activity must have been started");
            TraceEvent(TraceEventType.Information, id, format, args);
        }

        /// <summary>
        /// Logs an informational exception.
        /// </summary>
        /// <param name="exception">The exception to be logged.</param>
        /// <param name="format">The format of an additional message to be logged with the exception details.</param>
        /// <param name="args">The arguments for the format string.</param>
        public void LogInformation(Exception exception, string format, params object[] args)
        {
            Contract.Requires(Trace.CorrelationManager.ActivityId != Guid.Empty, "An activity must have been started");
            LogException(TraceEventType.Information, 1, exception, format, args);
        }

        /// <summary>
        /// Returns a value indicating whether information logging is enabled.
        /// </summary>
        /// <returns>A value indicating whether information logging is enabled.</returns>
        public bool IsInformationEnabled()
        {
            return _traceSource.Switch.ShouldTrace(TraceEventType.Information);
        }

        /// <summary>
        /// Logs a warning message.
        /// </summary>
        /// <param name="format">The format of the message.</param>
        /// <param name="args">The arguments for the format string.</param>
        public void LogWarning(string format, params object[] args)
        {
            Contract.Requires(Trace.CorrelationManager.ActivityId != Guid.Empty, "An activity must have been started");
            LogWarning(1, format, args);
        }

        public void LogWarning(int id, string format, params object[] args)
        {
            Contract.Requires(Trace.CorrelationManager.ActivityId != Guid.Empty, "An activity must have been started");
            TraceEvent(TraceEventType.Warning, id, format, args);
        }

        /// <summary>
        /// Logs a warning exception.
        /// </summary>
        /// <param name="exception">The exception to be logged.</param>
        /// <param name="format">The format of an additional message to be logged with the exception details.</param>
        /// <param name="args">The arguments for the format string.</param>
        public void LogWarning(Exception exception, string format, params object[] args)
        {
            Contract.Requires(Trace.CorrelationManager.ActivityId != Guid.Empty, "An activity must have been started");
            LogException(TraceEventType.Warning, 1, exception, format, args);
        }

        /// <summary>
        /// Returns a value indicating whether warning logging is enabled.
        /// </summary>
        /// <returns>A value indicating whether warning logging is enabled.</returns>
        public bool IsWarningEnabled()
        {
            return _traceSource.Switch.ShouldTrace(TraceEventType.Warning);
        }

        /// <summary>
        /// Logs an error message.
        /// </summary>
        /// <param name="id">An identifier unique to the source which identifies this error message.</param>
        /// <param name="format">The format of the message.</param>
        /// <param name="args">The arguments for the format string.</param>
        public void LogError(int id, string format, params object[] args)
        {
            Contract.Requires(Trace.CorrelationManager.ActivityId != Guid.Empty, "An activity must have been started");
            TraceEvent(TraceEventType.Error, id, format, args);
        }

        /// <summary>
        /// Logs an error exception.
        /// </summary>
        /// <param name="id">An identifier unique to the source which identifies this error message.</param>
        /// <param name="exception">The exception to be logged.</param>
        /// <param name="format">The format of an additional message to be logged with the exception details.</param>
        /// <param name="args">The arguments for the format string.</param>
        public void LogError(int id, Exception exception, string format, params object[] args)
        {
            Contract.Requires(Trace.CorrelationManager.ActivityId != Guid.Empty, "An activity must have been started");
            LogException(TraceEventType.Error, id, exception, format, args);
        }

        /// <summary>
        /// Returns a value indicating whether error logging is enabled.
        /// </summary>
        /// <returns>A value indicating whether error logging is enabled.</returns>
        public bool IsErrorEnabled()
        {
            return _traceSource.Switch.ShouldTrace(TraceEventType.Error);
        }

        /// <summary>
        /// Logs a critical message.
        /// </summary>
        /// <param name="id">An identifier unique to the source which identifies this error message.</param>
        /// <param name="format">The format of the message.</param>
        /// <param name="args">The arguments for the format string.</param>
        public void LogCritical(int id, string format, params object[] args)
        {
            Contract.Requires(Trace.CorrelationManager.ActivityId != Guid.Empty, "An activity must have been started");
            TraceEvent(TraceEventType.Error, id, format, args);
        }

        /// <summary>
        /// Logs a critical exception.
        /// </summary>
        /// <param name="id">An identifier unique to the source which identifies this error message.</param>
        /// <param name="exception">The exception to be logged.</param>
        /// <param name="format">The format of an additional message to be logged with the exception details.</param>
        /// <param name="args">The arguments for the format string.</param>
        public void LogCritical(int id, Exception exception, string format, params object[] args)
        {
            Contract.Requires(Trace.CorrelationManager.ActivityId != Guid.Empty, "An activity must have been started");
            LogException(TraceEventType.Error, id, exception, format, args);
        }

        /// <summary>
        /// Returns a value indicating whether critical logging is enabled.
        /// </summary>
        /// <returns>A value indicating whether critical logging is enabled.</returns>
        public bool IsCriticalEnabled()
        {
            return _traceSource.Switch.ShouldTrace(TraceEventType.Critical);
        }

        /// <summary>
        /// Formats a message.
        /// </summary>
        /// <param name="format">The format for the message.</param>
        /// <param name="args">The arguments for the format string.</param>
        /// <returns>The formatted message.</returns>
        private static string Format(string format, params object[] args)
        {
            return string.Format(CultureInfo.InvariantCulture, format, args);
        }

        /// <summary>
        /// Logs an exception.
        /// </summary>
        /// <param name="traceEventType">The event type to use to log the exception.</param>
        /// <param name="id">An identifier unique to the source which identifies this error message.</param>
        /// <param name="exception">The exception to be logged.</param>
        /// <param name="format">The format of an additional message to be logged with the exception details.</param>
        /// <param name="args">The arguments for the format string.</param>
        private void LogException(TraceEventType traceEventType, int id, Exception exception, string format, object[] args)
        {
            TraceEvent(traceEventType, id, "Exception. {0}. Details: {1}", Format(format, args), exception);
        }

        private void TraceEvent(TraceEventType traceEventType, int id, string format, params object[] args)
        {
            var timestamp = DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss.fff");

            _traceSource.TraceEvent(traceEventType, id, timestamp + " : " + format, args);
        }
    }
}
